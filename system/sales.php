<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

ob_start();
require_once '../includes/header.php';
require_once '../includes/functions.php';
requireLogin();

// ---- pagination + filter for Recent Sales ----
$limit  = 5;
$page   = isset($_GET['page']) && is_numeric($_GET['page']) ? (int) $_GET['page'] : 1;
$offset = ($page - 1) * $limit;

$start_date = $_GET['start_date'] ?? '';
$end_date   = $_GET['end_date']   ?? '';

$date_filter = '';
$params = [];
if (!empty($start_date) && !empty($end_date)) {
    $date_filter = "WHERE DATE(s.date) BETWEEN ? AND ?";
    $params[] = $start_date;
    $params[] = $end_date;
}

if (!empty($date_filter)) {
    $stmt = $db->prepare("SELECT COUNT(*) AS total FROM sales_pharm s $date_filter");
    $stmt->bind_param('ss', ...$params);
    $stmt->execute();
    $total_row = $stmt->get_result()->fetch_assoc();
    $stmt->close();
} else {
    $total_row = $db->rawQuery("SELECT COUNT(*) AS total FROM sales_pharm")->fetch_assoc();
}
$total_rows  = $total_row['total'];
$total_pages = ceil($total_rows / $limit);

$query = "
    SELECT s.*, u.username
    FROM sales_pharm s
    JOIN users_pharm u ON s.user_id = u.id
";
if (!empty($date_filter)) $query .= " $date_filter ";
$query .= " ORDER BY s.date DESC LIMIT $limit OFFSET $offset";

if (!empty($date_filter)) {
    $stmt = $db->prepare($query);
    $stmt->bind_param('ss', ...$params);
    $stmt->execute();
    $recent_sales = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    $stmt->close();
} else {
    $recent_sales = $db->fetchAll($query);
}
?>

<div class="container-fluid d-flex justify-content-center">
    <div class="row w-100 justify-content-center">
        <div class="col-12">

            <div class="card mb-4">
                <div class="card-header">
                    <h5>New Sale</h5>
                </div>
                <div class="card-body">

                    <form id="saleForm" method="POST" action="invoice.php">

                        <!-- Customer (search registered customers, or type any walk-in name) -->
                        <div class="mb-3 position-relative">
                            <label class="form-label">Customer</label>
                            <input type="hidden" name="customer_id" id="customerId" value="">
                            <input type="text" class="form-control" id="customerSearch"
                                   name="customer_name"
                                   placeholder="Type a name or phone, or leave blank for walk-in..."
                                   autocomplete="off">
                            <div id="customerSuggestions" class="list-group position-absolute w-100"
                                 style="z-index: 1000; display: none;"></div>
                            <small class="text-muted">
                                Type to search registered customers, click a suggestion to attach them,
                                or just type any name for a walk-in. Manage records on the
                                <a href="customers.php" target="_blank">Customers</a> page.
                            </small>
                        </div>

                        <!-- Product search -->
                        <div class="mb-3 position-relative">
                            <label class="form-label">Search Product</label>
                            <input type="text" id="productSearch" class="form-control"
                                   placeholder="Type product name..." autocomplete="off">
                            <div id="suggestions" class="list-group position-absolute w-100"
                                 style="z-index: 1000; display: none;"></div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-striped w-100">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Batch</th>
                                        <th>Price</th>
                                        <th>Quantity</th>
                                        <th>Total</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody id="saleItems"></tbody>
                                <tfoot>
                                    <tr>
                                        <th colspan="4">Total</th>
                                        <th id="saleTotal">0</th>
                                        <th></th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Payment Method</label>
                            <select class="form-select" id="paymentMethod" name="payment_method" required>
                                <option value="cash">Cash</option>
                                <option value="card">Card</option>
                                <option value="mobile_money">Mobile Money</option>
                            </select>
                        </div>

                        <div class="mb-3" id="transactionIdField" style="display: none;">
                            <label class="form-label">Transaction ID</label>
                            <input type="text" class="form-control" name="transaction_id"
                                   placeholder="Enter mobile money transaction ID">
                        </div>

                        <button type="submit" name="invoice" class="btn btn-success w-100">Process Sale</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<hr>

<div class="card-header">
    <h5>Recent Sales</h5>
</div>
<div class="container-fluid d-flex justify-content-center">
    <div class="row w-100 justify-content-center">
        <div class="col-12">
            <div class="card">
                <div class="card-body">

                    <form method="GET" class="row g-2 mb-3">
                        <div class="col-4">
                            <input type="date" name="start_date" value="<?= htmlspecialchars($start_date) ?>"
                                   class="form-control" required>
                        </div>
                        <div class="col-4">
                            <input type="date" name="end_date" value="<?= htmlspecialchars($end_date) ?>"
                                   class="form-control" required>
                        </div>
                        <div class="col-3">
                            <button type="submit" class="btn btn-success w-100 h-100">Filter</button>
                        </div>
                    </form>

                    <div class="table-responsive">
                        <table class="table table-striped w-100">
                            <thead>
                                <tr>
                                    <th>Invoice #</th>
                                    <th>Date</th>
                                    <th>Customer</th>
                                    <th>Amount</th>
                                    <th>Payment Method</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($recent_sales as $sale): ?>
                                    <tr>
                                        <td><?= $sale['invoice_number'] ?></td>
                                        <!-- Date rendered ENTIRELY in PHP so it is correct online or offline -->
                                        <td><?= date('d/m/Y H:i', strtotime($sale['date'])) ?></td>
                                        <td><?= htmlspecialchars($sale['customer_name'] ?? '') ?></td>
                                        <td><?= number_format($sale['total_amount']) ?></td>
                                        <td>
                                            <?= ucfirst(str_replace('_', ' ', $sale['payment_method'])) ?>
                                            <?php if (!empty($sale['transaction_id'])): ?>
                                                <br><small>Transaction ID: <?= $sale['transaction_id'] ?></small>
                                            <?php endif; ?>
                                        </td>
                                        <td>
                                            <a href="closed_invoice.php?id=<?= $sale['id'] ?>" class="btn btn-sm btn-info">View</a>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>

                    <?php if ($total_pages > 1): ?>
                        <nav>
                            <ul class="pagination justify-content-center mt-3">
                                <?php if ($page > 1): ?>
                                    <li class="page-item">
                                        <a class="page-link"
                                            href="?page=<?= $page - 1 ?>&start_date=<?= $start_date ?>&end_date=<?= $end_date ?>">Previous</a>
                                    </li>
                                <?php endif; ?>
                                <?php
                                $range = ($total_pages > 1000) ? 0 : (($total_pages > 100) ? 1 : 2);
                                $start = max(1, $page - $range);
                                $end   = min($total_pages, $page + $range);
                                if ($start > 1) {
                                    echo '<li class="page-item"><a class="page-link" href="?page=1&start_date=' . $start_date . '&end_date=' . $end_date . '">1</a></li>';
                                    if ($start > 2) echo '<li class="page-item disabled"><span class="page-link">...</span></li>';
                                }
                                for ($i = $start; $i <= $end; $i++) {
                                    $active = ($i == $page) ? 'active' : '';
                                    echo '<li class="page-item ' . $active . '"><a class="page-link" href="?page=' . $i . '&start_date=' . $start_date . '&end_date=' . $end_date . '">' . $i . '</a></li>';
                                }
                                if ($end < $total_pages) {
                                    if ($end < $total_pages - 1) echo '<li class="page-item disabled"><span class="page-link">...</span></li>';
                                    echo '<li class="page-item"><a class="page-link" href="?page=' . $total_pages . '&start_date=' . $start_date . '&end_date=' . $end_date . '">' . $total_pages . '</a></li>';
                                }
                                ?>
                                <?php if ($page < $total_pages): ?>
                                    <li class="page-item">
                                        <a class="page-link"
                                            href="?page=<?= $page + 1 ?>&start_date=<?= $start_date ?>&end_date=<?= $end_date ?>">Next</a>
                                    </li>
                                <?php endif; ?>
                            </ul>
                        </nav>
                    <?php endif; ?>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
/* ========== global scroll fix: stop wheel from changing focused number inputs ========== */
document.addEventListener('wheel', function (e) {
    if (document.activeElement && document.activeElement.type === 'number') {
        document.activeElement.blur();
    }
}, { passive: true });

/* ========== customer search-as-you-type ========== */
(function () {
    const customerSearch      = document.getElementById('customerSearch');
    const customerSuggestions = document.getElementById('customerSuggestions');
    const customerIdField     = document.getElementById('customerId');
    if (!customerSearch) return;

    customerSearch.addEventListener('input', function () {
        const q = this.value.trim();
        // typing a new name clears any previously chosen id
        customerIdField.value = '';
        if (q.length < 1) {
            customerSuggestions.style.display = 'none';
            customerSuggestions.innerHTML = '';
            return;
        }

        fetch(`ajax_search_customers.php?query=${encodeURIComponent(q)}`)
            .then(r => r.json())
            .then(data => {
                customerSuggestions.innerHTML = '';
                if (!Array.isArray(data) || data.length === 0) {
                    customerSuggestions.style.display = 'none';
                    return;
                }
                customerSuggestions.style.display = 'block';
                data.forEach(c => {
                    const btn = document.createElement('button');
                    btn.type = 'button';
                    btn.className = 'list-group-item list-group-item-action';
                    btn.textContent = `${c.name}${c.contact ? ' — ' + c.contact : ''}${c.address ? ' (' + c.address + ')' : ''}`;
                    btn.addEventListener('click', () => {
                        customerSearch.value = c.name;
                        customerIdField.value = c.id;
                        customerSuggestions.style.display = 'none';
                    });
                    customerSuggestions.appendChild(btn);
                });
            })
            .catch(() => { customerSuggestions.style.display = 'none'; });
    });

    document.addEventListener('click', function (e) {
        if (!customerSearch.contains(e.target) && !customerSuggestions.contains(e.target)) {
            customerSuggestions.style.display = 'none';
        }
    });
})();

/* ========== product search + sale items cart ========== */
(function () {
    const productSearch      = document.getElementById('productSearch');
    if (!productSearch) return;

    const suggestions        = document.getElementById('suggestions');
    const saleItems          = document.getElementById('saleItems');
    const saleTotal          = document.getElementById('saleTotal');
    const paymentMethod      = document.getElementById('paymentMethod');
    const transactionIdField = document.getElementById('transactionIdField');

    let total = 0;
    let items = [];

    if (paymentMethod) {
        paymentMethod.addEventListener('change', function () {
            if (this.value === 'mobile_money') {
                transactionIdField.style.display = 'block';
                transactionIdField.querySelector('input').setAttribute('required', 'required');
            } else {
                transactionIdField.style.display = 'none';
                transactionIdField.querySelector('input').removeAttribute('required');
            }
        });
    }

    productSearch.addEventListener('input', function () {
        const query = this.value;
        if (query.length < 2) {
            suggestions.style.display = 'none';
            suggestions.innerHTML = '';
            return;
        }
        fetch(`product_search.php?query=${encodeURIComponent(query)}`)
            .then(res => res.json())
            .then(data => {
                suggestions.innerHTML = '';
                if (!Array.isArray(data) || data.length === 0) {
                    suggestions.style.display = 'none';
                    return;
                }
                suggestions.style.display = 'block';
                data.forEach(product => {
                    const item = document.createElement('button');
                    item.type = 'button';
                    item.className = 'list-group-item list-group-item-action';
                    const batchLabel = product.batch_number ? ` [Batch ${product.batch_number}]` : '';
                    const expLabel   = product.expiry_date   ? ` exp ${product.expiry_date}` : '';
                    item.textContent = `${product.name}${batchLabel} — UGX ${product.selling_price} — Stock: ${product.quantity}${expLabel}`;
                    item.addEventListener('click', () => {
                        const existing = items.find(i => i.id === product.id);
                        if (existing) {
                            if (existing.quantity >= product.quantity) {
                                alert('Cannot add more than available stock for this batch');
                                return;
                            }
                            existing.quantity++;
                            existing.total = existing.quantity * existing.price;
                        } else {
                            items.push({
                                id:           product.id,
                                name:         product.name,
                                batch_number: product.batch_number || '',
                                price:        parseFloat(product.selling_price),
                                quantity:     1,
                                total:        parseFloat(product.selling_price),
                                stock:        parseFloat(product.quantity)
                            });
                        }
                        updateSaleItems();
                        productSearch.value = '';
                        suggestions.style.display = 'none';
                        suggestions.innerHTML = '';
                    });
                    suggestions.appendChild(item);
                });
            })
            .catch(err => {
                console.error('Error:', err);
                suggestions.style.display = 'none';
            });
    });

    document.addEventListener('click', function (e) {
        if (!productSearch.contains(e.target) && !suggestions.contains(e.target)) {
            suggestions.style.display = 'none';
        }
    });

    function updateSaleItems() {
        saleItems.innerHTML = '';
        total = 0;
        items.forEach((item, index) => {
            total += item.total;
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${item.name}</td>
                <td><small>${item.batch_number || ''}</small></td>
                <td>
                    <input type="number" name="products[${index}][price]"
                           value="${item.price.toFixed(2)}" min="0" step="0.01"
                           class="form-control form-control-sm price-input"
                           data-index="${index}" onwheel="this.blur()">
                </td>
                <td>
                    <input type="number" name="products[${index}][quantity]"
                           value="${item.quantity}" min="0.1" step="0.1"
                           class="form-control form-control-sm quantity-input"
                           data-index="${index}" onwheel="this.blur()">
                    <input type="hidden" name="products[${index}][id]" value="${item.id}">
                </td>
                <td>
                    <input type="number" name="products[${index}][total]"
                           value="${item.total.toFixed(2)}" min="0" step="0.01"
                           class="form-control form-control-sm total-input"
                           data-index="${index}" onwheel="this.blur()">
                </td>
                <td>
                    <button type="button" class="btn btn-sm btn-danger remove-item" data-index="${index}">Remove</button>
                </td>
            `;
            saleItems.appendChild(row);
        });
        saleTotal.textContent = total.toFixed(2);

        document.querySelectorAll('.price-input').forEach(input => {
            input.addEventListener('change', function () {
                const idx = parseInt(this.dataset.index);
                const v   = parseFloat(this.value);
                if (isNaN(v) || v < 0) { alert('Please enter a valid price'); this.value = items[idx].price.toFixed(2); return; }
                items[idx].price = v;
                items[idx].total = items[idx].quantity * items[idx].price;
                updateSaleItems();
            });
        });
        document.querySelectorAll('.quantity-input').forEach(input => {
            input.addEventListener('change', function () {
                const idx = parseInt(this.dataset.index);
                const v   = parseFloat(this.value);
                if (isNaN(v) || v <= 0) { alert('Quantity must be greater than 0'); this.value = items[idx].quantity; return; }
                items[idx].quantity = v;
                items[idx].total    = items[idx].quantity * items[idx].price;
                updateSaleItems();
            });
        });
        document.querySelectorAll('.total-input').forEach(input => {
            input.addEventListener('change', function () {
                const idx = parseInt(this.dataset.index);
                const v   = parseFloat(this.value);
                if (isNaN(v) || v < 0) { alert('Please enter a valid total amount'); this.value = items[idx].total.toFixed(2); return; }
                if (items[idx].quantity > 0) {
                    items[idx].price = v / items[idx].quantity;
                    items[idx].total = v;
                    updateSaleItems();
                } else {
                    alert('Quantity must be greater than 0 to calculate unit price');
                    this.value = items[idx].total.toFixed(2);
                }
            });
        });
        document.querySelectorAll('.remove-item').forEach(button => {
            button.addEventListener('click', function () {
                const idx = parseInt(this.dataset.index);
                items.splice(idx, 1);
                updateSaleItems();
            });
        });
    }
})();
</script>

<?php include '../includes/footer.php'; ?>