<?php
ob_start();
require_once '../includes/header.php';
require_once '../classes/Pharmacy.php';

requireAdmin();

$pharmacy = new Pharmacy($db);
$product = null;
$batches = [];
$generated_barcode = date('YmdHis') . rand(100, 999);

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['start_invoice'])) {
    $_SESSION['invoice_number'] = $_POST['invoice_number'];
    $_SESSION['supplier_name'] = $_POST['supplier_name'];
    $_SESSION['supplier_contact'] = $_POST['supplier_contact'];
    $_SESSION['supplier_address'] = $_POST['supplier_address'];
    $_SESSION['invoice_status'] = $_POST['invoice_status'];
    $_SESSION['invoice_date'] = $_POST['invoice_date'] ?: date('Y-m-d');
    $_SESSION['invoice_total'] = 0;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['clear_invoice'])) {
    unset(
        $_SESSION['invoice_number'],
        $_SESSION['supplier_name'],
        $_SESSION['supplier_contact'],
        $_SESSION['supplier_address'],
        $_SESSION['invoice_total'],
        $_SESSION['invoice_status'],
        $_SESSION['invoice_date']
    );
    header('Location: update_stock.php');
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['search'])) {
    $name = trim($_GET['search']);
    $product = $pharmacy->findProductByName($name);

    if ($product) {
        $batches = $db->fetchAll('SELECT * FROM product_batches_pharm WHERE product_id = ? ORDER BY archived_at DESC', [$product['id']]);
    } else {
        $_SESSION['error'] = 'Product not found.';
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['update_stock'])) {
    $product_id = (int) $_POST['product_id'];
    $current = $db->fetchOne('SELECT * FROM products_pharm WHERE id = ?', [$product_id]);

    if (!$current) {
        $_SESSION['error'] = 'Product not found.';
        header('Location: update_stock.php');
        exit();
    }
    $invoice_id = null;
    if (isset($_SESSION['invoice_number'])) {
        $invoice_number = $_SESSION['invoice_number'];
        $supplier_name = $_SESSION['supplier_name'];
        $supplier_contact = $_SESSION['supplier_contact'];
        $supplier_address = $_SESSION['supplier_address'];
        $invoice_status = $_SESSION['invoice_status'];
        $invoice_date = $_SESSION['invoice_date'];

        $invoice = $db->fetchOne('SELECT id FROM invoices_pharm WHERE invoice_number = ?', [$invoice_number]);

        if (!$invoice) {
            $db->execute('INSERT INTO invoices_pharm (invoice_number, supplier_name, supplier_contact, supplier_address, invoice_status, invoice_date)
                      VALUES (?, ?, ?, ?, ?, ?)', [
                $invoice_number,
                $supplier_name,
                $supplier_contact,
                $supplier_address,
                $invoice_status,
                $invoice_date
            ]);
            $conn = $db->getConnection();
            $invoice_id = $conn->insert_id;

        } else {
            $invoice_id = $invoice['id'];
        }
    }


    $db->execute('INSERT INTO product_batches_pharm 
(product_id, batch_number, buying_price, selling_price, expiry_date, barcode, quantity, unit_type, archived_at, invoice_id) 
VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?)', [
        $current['id'],
        $current['batch_number'],
        $current['buying_price'],
        $current['selling_price'],
        $current['expiry_date'],
        $current['barcode'],
        $current['quantity'],
        $current['unit_type'],
        $invoice_id
    ]);

    $total_quantity = $current['quantity'] + (int) $_POST['quantity'];

    $db->execute('UPDATE products_pharm 
    SET batch_number = ?, buying_price = ?, selling_price = ?, expiry_date = ?, barcode = ?, quantity = ?, unit_type = ? 
    WHERE id = ?', [
        $_POST['batch_number'],
        (float) $_POST['buying_price'],
        (float) $_POST['selling_price'],
        $_POST['expiry_date'],
        $_POST['barcode'],
        $total_quantity,
        $_POST['unit_type'],
        $product_id
    ]);
    $quantityB = (int) $_POST['quantity'];

    if (isset($_SESSION['invoice_total'])) {
        $_SESSION['invoice_total'] += $quantityB * (float) $_POST['buying_price'];
    }



    $_SESSION['message'] = 'Stock updated and previous batch archived successfully.';
    header('Location: update_stock.php?search=' . urlencode($current['name']));
    exit();
}
ob_end_flush();
?>

<div class="container-fluid px-4 mt-4">

    <?php if (!empty($_SESSION['message'])): ?>
        <div class="alert alert-success"><?php echo $_SESSION['message'];
        unset($_SESSION['message']); ?></div>
    <?php endif; ?>

    <?php if (!empty($_SESSION['error'])): ?>
        <div class="alert alert-danger"><?php echo $_SESSION['error'];
        unset($_SESSION['error']); ?></div>
    <?php endif; ?>

    <?php if (!isset($_SESSION['invoice_number'])): ?>
        <form method="POST" class="mb-4 border p-3">
            <h5>Start New Invoice Entry</h5>
            <div class="row g-3">
                <div class="col-md-6 col-lg-4 mb-3">

                    <label>Invoice Number</label>
                    <input type="text" name="invoice_number" class="form-control" required>
                </div>
                <div class="col-md-3 mb-3">
                    <label>Supplier Name</label>
                    <input type="text" name="supplier_name" class="form-control" required>
                </div>
                <div class="col-md-3 mb-3">
                    <label>Supplier Contact</label>
                    <input type="text" name="supplier_contact" class="form-control" required>
                </div>
                <div class="col-md-3 mb-3">
                    <label>Supplier Address</label>
                    <input type="text" name="supplier_address" class="form-control" required>
                </div>
                <div class="col-md-3 mb-3">
                    <label>Invoice Status</label>
                    <select name="invoice_status" class="form-select" required>
                        <option value="Paid">Paid</option>
                        <option value="Pending">Pending</option>
                    </select>
                </div>
                <div class="col-md-3 mb-3">
                    <label>Invoice Date</label>
                    <input type="date" name="invoice_date" class="form-control" value="<?php echo date('Y-m-d'); ?>">
                </div>
            </div>
            <button type="submit" name="start_invoice" class="btn btn-success">Start Invoice</button>
        </form>
    <?php else: ?>
        <div class="alert alert-info d-flex flex-wrap align-items-center gap-2">
            <strong>Invoice:</strong> <?= $_SESSION['invoice_number'] ?> |
            <strong>Supplier:</strong> <?= $_SESSION['supplier_name'] ?> |
            <strong>Contact:</strong> <?= $_SESSION['supplier_contact'] ?> |
            <strong>Address:</strong> <?= $_SESSION['supplier_address'] ?> |
            <strong>Status:</strong> <?= $_SESSION['invoice_status'] ?> |
            <strong>Date:</strong> <?= $_SESSION['invoice_date'] ?> |
            <strong>Total:</strong> UGX <?= number_format($_SESSION['invoice_total'], 2) ?>
            <form method="POST" class="d-inline float-end">
                <button type="submit" name="clear_invoice" class="btn btn-sm btn-danger">End Invoice</button>
            </form>
        </div>
    <?php endif; ?>

    <div class="mb-4 position-relative">
        <label class="form-label">Search Product</label>
        <input type="text" id="liveSearch" class="form-control" placeholder="Type product name...">
        <div id="liveSuggestions" class="list-group position-absolute w-100" style="z-index: 1000;"></div>
    </div>

    <?php if ($product): ?>
        <form method="POST">
            <input type="hidden" name="product_id" value="<?= $product['id'] ?>">

            <div class="row g-3">
                <div class="col-md-6 col-lg-4 mb-3">
                    <label>Product Name</label>
                    <input type="text" class="form-control" value="<?= htmlspecialchars($product['name']) ?>" disabled>
                </div>

                <div class="col-md-6 col-lg-4 mb-3">
                    <label>New Batch Number</label>
                    <input type="text" name="batch_number" class="form-control" required>
                </div>

                <div class="col-md-6 col-lg-4 mb-3">
                    <label>New Buying Price</label>
                    <input type="number" name="buying_price" class="form-control" step="1"
                        value="<?= htmlspecialchars($product['buying_price']) ?>" required>
                </div>

                <div class="col-md-6 col-lg-4 mb-3">
                    <label>New Selling Price</label>
                    <input type="number" name="selling_price" class="form-control" step="1"
                        value="<?= htmlspecialchars($product['selling_price']) ?>" required>
                </div>

                <div class="col-md-6 col-lg-4 mb-3">
                    <label>New Expiry Date</label>
                    <input type="date" name="expiry_date" class="form-control" required>
                </div>

                <div class="col-md-6 col-lg-4 mb-3">
                    <label>New Barcode</label>
                    <input type="text" name="barcode" class="form-control" value="<?= $generated_barcode ?>" readonly>
                </div>

                <div class="col-md-6 col-lg-4 mb-3">
                    <label>New Unit Type</label>
                    <select name="unit_type" class="form-select" required>
                        <!-- <option value="">-- Select Unit Type --</option> -->
                        <?php
                        $unit_types = ['strp' => 'Strip', 'pkt' => 'Packet', 'inj' => 'Injection', 'tab' => 'Tablet', 'cap' => 'Capsule', 'dos' => 'Dose', 'pce' => 'Piece', 'btl' => 'Bottle', 'syp' => 'Syrup', 'scht' => 'Sachet'];
                        foreach ($unit_types as $code => $label):
                            $selected = ($product['unit_type'] === $code) ? 'selected' : '';
                            echo "<option value=\"$code\" $selected>$label</option>";
                        endforeach;
                        ?>
                    </select>

                </div>

                <div class="col-md-6 col-lg-4 mb-3">
                    <label>New Quantity</label>
                    <input type="number" name="quantity" class="form-control" required>
                </div>
            </div>

            <button type="submit" name="update_stock" class="btn btn-success">Update Stock</button>
        </form>
    <?php endif; ?>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function () {
        $('#liveSearch').on('keyup', function () {
            let query = $(this).val();
            if (query.length >= 2) {
                $.ajax({
                    url: 'live_search.php',
                    method: 'GET',
                    data: { query: query },
                    success: function (data) {
                        let resultBox = $('#searchResults');
                        resultBox.empty();
                        if (data.length > 0) {
                            data.forEach(product => {
                                resultBox.append(`<a href="update_stock.php?search=${encodeURIComponent(product.name)}" class="list-group-item list-group-item-action">${product.name}</a>`);
                            });
                        } else {
                            resultBox.html('<div class="text-muted">No matches found</div>');
                        }
                    }
                });
            } else {
                $('#searchResults').empty();
            }
        });
    });
</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const input = document.getElementById("liveSearch");
        const suggestions = document.getElementById("liveSuggestions");

        input.addEventListener("input", function () {
            const query = this.value.trim();

            if (query.length < 2) {
                suggestions.innerHTML = '';
                return;
            }

            fetch(`../system/product_lookup.php?query=${encodeURIComponent(query)}`)
                .then(response => response.json())
                .then(data => {
                    suggestions.innerHTML = '';
                    data.forEach(product => {
                        const item = document.createElement("button");
                        item.className = "list-group-item list-group-item-action";
                        item.textContent = product.name;
                        item.addEventListener("click", function () {
                            window.location.href = `update_stock.php?search=${encodeURIComponent(product.name)}`;
                        });
                        suggestions.appendChild(item);
                    });
                });
        });

        // Hide suggestions on click outside
        document.addEventListener("click", function (e) {
            if (!suggestions.contains(e.target) && e.target !== input) {
                suggestions.innerHTML = '';
            }
        });
    });
</script>

<?php require_once '../includes/footer.php'; ?>