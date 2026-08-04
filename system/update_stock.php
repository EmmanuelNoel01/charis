<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Load only PHP — NOT header.php — so redirects work regardless of output buffering.
require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../includes/functions.php';
require_once __DIR__ . '/../classes/Pharmacy.php';

requireAdmin();
$pharmacy = new Pharmacy($db);

$user_id = (int) ($_SESSION['user_id'] ?? 0);
if ($user_id <= 0) {
    header('Location: ' . base_url('login.php'));
    exit();
}

// ----------------------------------------------------------------------------
// 2-hour auto-cleanup for stale "open" drafts. Runs once per page hit.
// ----------------------------------------------------------------------------
$db->execute(
    "DELETE FROM procurement_drafts_pharm
     WHERE status = 'open' AND updated_at < (NOW() - INTERVAL 2 HOUR)"
);

// ----------------------------------------------------------------------------
// Helpers
// ----------------------------------------------------------------------------
function get_open_draft($db, $user_id) {
    return $db->fetchOne(
        "SELECT * FROM procurement_drafts_pharm WHERE user_id = ? AND status = 'open' ORDER BY id DESC LIMIT 1",
        [$user_id]
    );
}
function get_draft_items($db, $draft_id) {
    return $db->fetchAll(
        "SELECT * FROM procurement_draft_items_pharm WHERE draft_id = ? ORDER BY id ASC",
        [$draft_id]
    );
}
function get_draft_total($db, $draft_id) {
    $row = $db->fetchOne(
        "SELECT COALESCE(SUM(subtotal), 0) AS t FROM procurement_draft_items_pharm WHERE draft_id = ?",
        [$draft_id]
    );
    return (float) ($row['t'] ?? 0);
}

// ----------------------------------------------------------------------------
// POST handlers — all run BEFORE any HTML output.
// ----------------------------------------------------------------------------

// START INVOICE
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['start_invoice'])) {
    $db->execute(
        "UPDATE procurement_drafts_pharm SET status = 'cancelled' WHERE user_id = ? AND status = 'open'",
        [$user_id]
    );
    $db->insert('procurement_drafts_pharm', [
        'user_id'           => $user_id,
        'invoice_number'    => trim($_POST['invoice_number']),
        'supplier_name'     => trim($_POST['supplier_name']),
        'supplier_contact'  => trim($_POST['supplier_contact']),
        'supplier_address'  => trim($_POST['supplier_address']),
        'invoice_status'    => trim($_POST['invoice_status']),
        'invoice_date'      => $_POST['invoice_date'] ?: date('Y-m-d'),
        'status'            => 'open'
    ]);
    header('Location: update_stock.php');
    exit();
}

// END INVOICE
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['clear_invoice'])) {
    $db->execute(
        "DELETE FROM procurement_drafts_pharm WHERE user_id = ? AND status = 'open'",
        [$user_id]
    );
    header('Location: update_stock.php');
    exit();
}

// ADD ITEM
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['add_to_invoice'])) {
    $draft = get_open_draft($db, $user_id);
    if (!$draft) {
        $_SESSION['error'] = 'No invoice is currently open. Start an invoice first.';
        header('Location: update_stock.php');
        exit();
    }
    $product_id = (int) $_POST['product_id'];
    $current = $db->fetchOne('SELECT * FROM products_pharm WHERE id = ?', [$product_id]);
    if (!$current) {
        $_SESSION['error'] = 'Product not found.';
        header('Location: update_stock.php');
        exit();
    }
    $qty   = (float) $_POST['quantity'];
    $price = round((float) $_POST['buying_price'], 2);
    $sub   = round($qty * $price, 2);

    $db->insert('procurement_draft_items_pharm', [
        'draft_id'      => $draft['id'],
        'product_id'    => $product_id,
        'product_name'  => $current['name'],
        'batch_number'  => $_POST['batch_number'],
        'buying_price'  => $price,
        'selling_price' => round((float) $_POST['selling_price'], 2),
        'expiry_date'   => $_POST['expiry_date'],
        'barcode'       => $_POST['barcode'],
        'quantity'      => $qty,
        'unit_type'     => $_POST['unit_type'],
        'subtotal'      => $sub
    ]);

    // Touch draft to reset the 2-hour timer
    $db->execute("UPDATE procurement_drafts_pharm SET updated_at = NOW() WHERE id = ?", [$draft['id']]);

    $_SESSION['message'] = 'Product added. Running total: UGX ' . number_format(get_draft_total($db, $draft['id']), 2);
    header('Location: update_stock.php?search=' . urlencode($current['name']));
    exit();
}

// REMOVE ITEM
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['remove_item'])) {
    $item_id = (int) ($_POST['item_id'] ?? 0);
    $draft = get_open_draft($db, $user_id);
    if ($draft && $item_id > 0) {
        $row = $db->fetchOne(
            "SELECT product_name FROM procurement_draft_items_pharm WHERE id = ? AND draft_id = ?",
            [$item_id, $draft['id']]
        );
        $db->execute(
            "DELETE FROM procurement_draft_items_pharm WHERE id = ? AND draft_id = ?",
            [$item_id, $draft['id']]
        );
        if ($row) {
            $_SESSION['message'] = 'Removed "' . htmlspecialchars($row['product_name'])
                . '". Running total: UGX ' . number_format(get_draft_total($db, $draft['id']), 2);
        }
    }
    header('Location: update_stock.php');
    exit();
}

// FINALIZE — commits items to stock, marks draft finalized, panel disappears
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['finalize_invoice'])) {
    $draft = get_open_draft($db, $user_id);
    if (!$draft) {
        $_SESSION['error'] = 'No invoice to finalize.';
        header('Location: update_stock.php');
        exit();
    }
    $items = get_draft_items($db, $draft['id']);
    if (empty($items)) {
        $_SESSION['error'] = 'Cannot finalize an empty invoice. Add at least one product first.';
        header('Location: update_stock.php');
        exit();
    }

    $invoice_number = $draft['invoice_number'];
    $db->beginTransaction();
    try {
        $existing = $db->fetchOne('SELECT id FROM invoices_pharm WHERE invoice_number = ?', [$invoice_number]);
        if (!$existing) {
            $total_amount = 0.0;
            foreach ($items as $it) $total_amount += (float)$it['subtotal'];
            $db->execute(
                'INSERT INTO invoices_pharm (invoice_number, supplier_name, supplier_contact, supplier_address, invoice_status, invoice_date, total_amount)
                 VALUES (?, ?, ?, ?, ?, ?, ?)',
                [$invoice_number, $draft['supplier_name'], $draft['supplier_contact'], $draft['supplier_address'],
                 $draft['invoice_status'], $draft['invoice_date'], $total_amount]
            );
            $invoice_id = $db->getConnection()->insert_id;
        } else {
            $invoice_id = $existing['id'];
        }

        foreach ($items as $item) {
            $current = $db->fetchOne('SELECT * FROM products_pharm WHERE id = ?', [$item['product_id']]);
            if (!$current) {
                throw new Exception("Product id {$item['product_id']} not found while finalizing invoice.");
            }

            // === Per request: when a NEW batch is procured for a product that
            // still has leftover stock, archive the leftover as an ACTIVE batch
            // (is_active = 1, sellable). On the sales side, FEFO will sell from
            // this leftover FIRST until it hits zero, THEN start eating into
            // the new batch on the live row.
            //
            // We always write an audit row so view_invoice.php can find the
            // procurement record. If the outgoing live row had quantity > 0,
            // we additionally mark THAT carry-over row is_active=1 so it's
            // sellable. Then the live row is overwritten with the new batch.

            $carryover_qty = (float) $current['quantity'];

            if ($carryover_qty > 0
                && (string)$current['batch_number'] !== (string)$item['batch_number']) {
                // Different batch number — carry the old batch into the active archive.
                $db->execute(
                    'INSERT INTO product_batches_pharm
                        (product_id, batch_number, buying_price, selling_price, expiry_date,
                         barcode, quantity, unit_type, archived_at, invoice_id, invoice_number,
                         name, is_active)
                     VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?, ?, ?, 1)',
                    [
                        $current['id'],
                        $current['batch_number'],
                        round((float)$current['buying_price'], 2),
                        (float)$current['selling_price'],
                        $current['expiry_date'],
                        $current['barcode'],
                        $carryover_qty,
                        $current['unit_type'],
                        $invoice_id,
                        $invoice_number,
                        $current['name']
                    ]
                );
                // The new live row will hold ONLY the new batch's quantity.
                $new_live_qty = (float)$item['quantity'];
            } else {
                // Same batch number, OR no leftover. Just stack on the live row.
                $new_live_qty = $carryover_qty + (float)$item['quantity'];
            }

            // Audit row for the new batch arrival (history; not sellable directly).
            $db->execute(
                'INSERT INTO product_batches_pharm
                    (product_id, batch_number, buying_price, selling_price, expiry_date, barcode,
                     quantity, unit_type, archived_at, invoice_id, invoice_number, name, is_active)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?, ?, ?, 0)',
                [
                    $current['id'],
                    $item['batch_number'],
                    round((float)$item['buying_price'], 2),
                    (float)$item['selling_price'],
                    $item['expiry_date'],
                    $item['barcode'],
                    (float)$item['quantity'],
                    $item['unit_type'],
                    $invoice_id,
                    $invoice_number,
                    $current['name']
                ]
            );

            $db->execute(
                'UPDATE products_pharm
                 SET batch_number = ?, buying_price = ?, selling_price = ?, expiry_date = ?,
                     barcode = ?, quantity = ?, unit_type = ?, invoice_number = ?
                 WHERE id = ?',
                [
                    $item['batch_number'],
                    round((float)$item['buying_price'], 2),
                    (float)$item['selling_price'],
                    $item['expiry_date'],
                    $item['barcode'],
                    $new_live_qty,
                    $item['unit_type'],
                    $invoice_number,
                    $item['product_id']
                ]
            );
        }

        // Mark draft finalized and clear its items — this is what makes the panel disappear.
        $db->execute("UPDATE procurement_drafts_pharm SET status = 'finalized' WHERE id = ?", [$draft['id']]);
        $db->execute("DELETE FROM procurement_draft_items_pharm WHERE draft_id = ?", [$draft['id']]);

        $db->commit();
        $_SESSION['message'] = 'Invoice ' . htmlspecialchars($invoice_number) . ' finalized. Stock updated successfully.';
    } catch (Exception $e) {
        $db->rollback();
        $_SESSION['error'] = 'Could not finalize invoice: ' . $e->getMessage();
    }
    header('Location: update_stock.php');
    exit();
}

// EDIT single product (existing behaviour, simplified)
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['edit_product'])) {
    try {
        $pid = (int) $_POST['product_id'];
        $db->execute(
            "UPDATE products_pharm SET buying_price = ?, selling_price = ?, quantity = ? WHERE id = ?",
            [
                round((float)$_POST['buying_price'], 2),
                round((float)$_POST['selling_price'], 2),
                (float)$_POST['quantity'],
                $pid
            ]
        );
        $_SESSION['message'] = 'Product updated.';
    } catch (Exception $e) {
        $_SESSION['error'] = 'Update failed: ' . $e->getMessage();
    }
    header('Location: update_stock.php');
    exit();
}

// ----------------------------------------------------------------------------
// Page data for rendering
// ----------------------------------------------------------------------------
$draft       = get_open_draft($db, $user_id);
$draft_items = $draft ? get_draft_items($db, $draft['id']) : [];
$draft_total = $draft ? get_draft_total($db, $draft['id']) : 0.0;

$product   = null;
$batches   = [];
$generated_barcode = date('YmdHis') . rand(100, 999);
$search = trim($_GET['search'] ?? '');
if ($search !== '') {
    $product = $db->fetchOne("SELECT * FROM products_pharm WHERE name = ? OR barcode = ? LIMIT 1", [$search, $search]);
    if ($product) {
        $batches = $db->fetchAll(
            "SELECT * FROM product_batches_pharm WHERE product_id = ? ORDER BY archived_at DESC LIMIT 10",
            [$product['id']]
        );
    }
}

require_once __DIR__ . '/../includes/header.php';
?>

<div class="container-fluid px-4 mt-4">

    <?php if (!empty($_SESSION['message'])): ?>
        <div class="alert alert-success"><?= $_SESSION['message']; unset($_SESSION['message']); ?></div>
    <?php endif; ?>
    <?php if (!empty($_SESSION['error'])): ?>
        <div class="alert alert-danger"><?= $_SESSION['error']; unset($_SESSION['error']); ?></div>
    <?php endif; ?>

    <?php if (!$draft): ?>
        <!-- ============== NO OPEN DRAFT: Start Invoice form ============== -->
        <div class="card mb-4">
            <div class="card-header"><h5>Start a new procurement invoice</h5></div>
            <div class="card-body">
                <form method="POST" class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Invoice Number *</label>
                        <input type="text" name="invoice_number" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Invoice Date</label>
                        <input type="date" name="invoice_date" class="form-control" value="<?= date('Y-m-d') ?>">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Supplier Name *</label>
                        <input type="text" name="supplier_name" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Supplier Contact</label>
                        <input type="text" name="supplier_contact" class="form-control">
                    </div>
                    <div class="col-md-8">
                        <label class="form-label">Supplier Address</label>
                        <input type="text" name="supplier_address" class="form-control">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Status</label>
                        <select name="invoice_status" class="form-select">
                            <option value="paid">Paid</option>
                            <option value="unpaid">Unpaid</option>
                            <option value="partial">Partial</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <button type="submit" name="start_invoice" class="btn btn-primary">Start Invoice</button>
                    </div>
                </form>
            </div>
        </div>

    <?php else: ?>
        <!-- ============== OPEN DRAFT: Sticky panel + Add-product form + items table ============== -->
        <div class="alert alert-info d-flex flex-wrap align-items-center gap-2 sticky-top"
             style="top: 0; z-index: 1020;">
            <strong>Invoice:</strong> <?= htmlspecialchars($draft['invoice_number']) ?> |
            <strong>Supplier:</strong> <?= htmlspecialchars($draft['supplier_name']) ?> |
            <strong>Contact:</strong> <?= htmlspecialchars($draft['supplier_contact']) ?> |
            <strong>Address:</strong> <?= htmlspecialchars($draft['supplier_address']) ?> |
            <strong>Status:</strong> <?= htmlspecialchars($draft['invoice_status']) ?> |
            <strong>Date:</strong> <?= htmlspecialchars($draft['invoice_date']) ?> |
            <strong>Total:</strong> UGX <?= number_format($draft_total, 2) ?>
            <form method="POST" class="ms-auto">
                <button type="submit" name="clear_invoice" class="btn btn-sm btn-danger"
                        onclick="return confirm('End the current procurement invoice?');">End Invoice</button>
            </form>
        </div>

        <!-- Search products -->
        <div class="card mb-4">
            <div class="card-header"><h5>Add product to invoice</h5></div>
            <div class="card-body">
                <!-- search-as-you-type: GET form still works as fallback if JS is off -->
                <form method="GET" class="row g-2 mb-3" id="updateStockSearchForm">
                    <div class="col-md-10 position-relative">
                        <input type="text" name="search" id="usSearchInput"
                               class="form-control"
                               placeholder="Type to search product by name..."
                               value="<?= htmlspecialchars($search) ?>"
                               autocomplete="off" autofocus>
                        <div id="usSuggestions" class="list-group position-absolute w-100"
                             style="z-index: 1000; display: none; max-height: 320px; overflow-y: auto;"></div>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-success w-100">Find</button>
                    </div>
                </form>

                <?php if ($search && !$product): ?>
                    <div class="alert alert-warning">No product matched "<?= htmlspecialchars($search) ?>".</div>
                <?php endif; ?>

                <?php if ($product): ?>
                    <form method="POST" class="row g-3">
                        <input type="hidden" name="product_id" value="<?= $product['id'] ?>">

                        <div class="col-md-12">
                            <strong><?= htmlspecialchars($product['name']) ?></strong>
                            <small class="text-muted">(current stock: <?= $product['quantity'] ?>, last buying price: <?= number_format((float)$product['buying_price'], 2) ?>)</small>
                        </div>

                        <div class="col-md-6 col-lg-4">
                            <label>Batch Number</label>
                            <input type="text" name="batch_number" class="form-control" required>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <label>Expiry Date</label>
                            <input type="date" name="expiry_date" class="form-control" required>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <label>Barcode</label>
                            <input type="text" name="barcode" class="form-control"
                                   value="<?= $product['barcode'] ?: $generated_barcode ?>">
                        </div>

                        <div class="col-md-6 col-lg-4">
                            <label>New Quantity</label>
                            <input type="number" name="quantity" id="qtyInput" class="form-control" step="any" required onwheel="this.blur()">
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <label>Total Amount Paid (UGX)</label>
                            <input type="number" id="totalAmountInput" class="form-control" step="any" onwheel="this.blur()"
                                   placeholder="Buying price auto-calculates">
                            <small class="text-muted">Buying price = Total &divide; Quantity (2 decimal places)</small>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <label>Buying Price</label>
                            <input type="number" name="buying_price" id="buyingPriceInput" class="form-control" step="0.01"
                                   value="<?= htmlspecialchars($product['buying_price']) ?>" required onwheel="this.blur()">
                        </div>

                        <div class="col-md-6 col-lg-4">
                            <label>Selling Price</label>
                            <input type="number" name="selling_price" class="form-control" step="0.01"
                                   value="<?= htmlspecialchars($product['selling_price']) ?>" required onwheel="this.blur()">
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <label>Unit Type</label>
                            <select name="unit_type" class="form-select">
                                <?php foreach (['tab' => 'Tablet', 'cap' => 'Capsule', 'dos' => 'Dose', 'pce' => 'Piece', 'btl' => 'Bottle', 'syp' => 'Syrup', 'scht' => 'Sachet'] as $k => $v): ?>
                                    <option value="<?= $k ?>" <?= ($product['unit_type'] ?? '') === $k ? 'selected' : '' ?>><?= $v ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>

                        <div class="col-12">
                            <button type="submit" name="add_to_invoice" class="btn btn-primary">Add to Invoice</button>
                        </div>
                    </form>
                <?php endif; ?>
            </div>
        </div>

        <!-- Items already on this draft -->
        <?php if (!empty($draft_items)): ?>
            <div class="card mb-4">
                <div class="card-header"><h5>Items on this invoice</h5></div>
                <div class="card-body table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Batch</th>
                                <th>Qty</th>
                                <th>Buying Price</th>
                                <th>Subtotal</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($draft_items as $it): ?>
                                <tr>
                                    <td><?= htmlspecialchars($it['product_name']) ?></td>
                                    <td><?= htmlspecialchars($it['batch_number']) ?></td>
                                    <td><?= $it['quantity'] ?></td>
                                    <td>UGX <?= number_format((float)$it['buying_price'], 2) ?></td>
                                    <td>UGX <?= number_format((float)$it['subtotal'], 2) ?></td>
                                    <td>
                                        <form method="POST" class="d-inline">
                                            <input type="hidden" name="item_id" value="<?= $it['id'] ?>">
                                            <button type="submit" name="remove_item" class="btn btn-sm btn-danger">Remove</button>
                                        </form>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                        <tfoot>
                            <tr>
                                <th colspan="4" class="text-end">Running Total</th>
                                <th colspan="2">UGX <?= number_format($draft_total, 2) ?></th>
                            </tr>
                        </tfoot>
                    </table>

                    <form method="POST" class="mt-3">
                        <button type="submit" name="finalize_invoice" class="btn btn-success btn-lg w-100"
                                onclick="return confirm('Finalize this invoice and update stock?');">
                            Finalize Invoice
                        </button>
                    </form>
                </div>
            </div>
        <?php endif; ?>

    <?php endif; ?>
</div>

<script>
// Global: block mouse-wheel from changing focused number inputs
document.addEventListener('wheel', function (e) {
    if (document.activeElement && document.activeElement.type === 'number') {
        document.activeElement.blur();
    }
}, { passive: true });

// Auto-calc buying price = Total / Quantity (2 dp)
(function () {
    const qty   = document.getElementById('qtyInput');
    const total = document.getElementById('totalAmountInput');
    const bp    = document.getElementById('buyingPriceInput');
    if (!qty || !total || !bp) return;

    function recalc() {
        const q = parseFloat(qty.value);
        const t = parseFloat(total.value);
        if (!isNaN(q) && q > 0 && !isNaN(t) && t >= 0) {
            bp.value = (Math.round((t / q) * 100) / 100).toFixed(2);
        }
    }
    qty.addEventListener('input', recalc);
    total.addEventListener('input', recalc);
})();

/* ========== search-as-you-type for the product search ========== */
(function () {
    const input  = document.getElementById('usSearchInput');
    const list   = document.getElementById('usSuggestions');
    const form   = document.getElementById('updateStockSearchForm');
    if (!input || !list || !form) return;

    let timer = null;

    input.addEventListener('input', function () {
        const q = this.value.trim();
        if (timer) clearTimeout(timer);
        if (q.length < 1) {
            list.style.display = 'none';
            list.innerHTML = '';
            return;
        }
        // small debounce so we don't hit the server on every keystroke
        timer = setTimeout(() => fetchSuggestions(q), 150);
    });

    function fetchSuggestions(q) {
        fetch('product_search.php?include_zero=1&query=' + encodeURIComponent(q))
            .then(r => r.json())
            .then(data => {
                list.innerHTML = '';
                if (!Array.isArray(data) || data.length === 0) {
                    list.style.display = 'none';
                    return;
                }
                list.style.display = 'block';
                data.forEach(p => {
                    const btn = document.createElement('button');
                    btn.type = 'button';
                    btn.className = 'list-group-item list-group-item-action';
                    const exp = p.expiry_date ? ' · exp ' + p.expiry_date : '';
                    const batch = p.batch_number ? ' [Batch ' + p.batch_number + ']' : '';
                    btn.textContent = `${p.name}${batch} — Stock: ${p.quantity}${exp}`;
                    btn.addEventListener('click', () => {
                        // Reuse the existing server-side product loader by submitting the
                        // GET form with the picked name. update_stock.php?search=<name>
                        // resolves the product row, shows the Add-to-Invoice form, and
                        // pre-fills the buying/selling/unit fields.
                        input.value = p.name;
                        list.style.display = 'none';
                        form.submit();
                    });
                    list.appendChild(btn);
                });
            })
            .catch(() => { list.style.display = 'none'; });
    }

    // Click outside to close the dropdown
    document.addEventListener('click', function (e) {
        if (!input.contains(e.target) && !list.contains(e.target)) {
            list.style.display = 'none';
        }
    });

    // Allow Enter on the input to submit the form (it already does, but
    // make sure the suggestion list is hidden first)
    input.addEventListener('keydown', function (e) {
        if (e.key === 'Enter') {
            list.style.display = 'none';
        }
    });
})();
</script>

<?php include __DIR__ . '/../includes/footer.php'; ?>