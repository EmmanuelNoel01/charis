<?php
require_once '../includes/header.php';
require_once '../includes/functions.php';
requireLogin();

$limit = 5;
$page = isset($_GET['page']) && is_numeric($_GET['page']) ? (int) $_GET['page'] : 1;
$offset = ($page - 1) * $limit;

$start_date = isset($_GET['start_date']) ? $_GET['start_date'] : '';
$end_date = isset($_GET['end_date']) ? $_GET['end_date'] : '';
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
    $result = $stmt->get_result();
    $total_row = $result->fetch_assoc();
    $stmt->close();
} else {
    $total_result = $db->rawQuery("SELECT COUNT(*) AS total FROM sales_pharm");
    $total_row = $total_result->fetch_assoc();
}
$total_rows = $total_row['total'];
$total_pages = ceil($total_rows / $limit);

$query = "
    SELECT s.*, u.username 
    FROM sales_pharm s
    JOIN users_pharm u ON s.user_id = u.id
    ";

if (!empty($date_filter)) {
    $query .= "$date_filter ";
}

$query .= "ORDER BY s.date DESC LIMIT $limit OFFSET $offset";

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
                        <div class="mb-3">
                            <label class="form-label">Customer Name</label>
                            <input type="text" class="form-control" name="customer_name"
                                placeholder="Type customer name..." required>
                        </div>

                        <div class="mb-3 position-relative">
                            <label class="form-label">Search Product</label>
                            <input type="text" id="productSearch" class="form-control"
                                placeholder="Type product name...">
                            <div id="suggestions" class="list-group position-absolute w-100" style="z-index: 1000; display: none;">
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-striped w-100">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Price</th>
                                        <th>Quantity</th>
                                        <th>Total</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody id="saleItems"></tbody>
                                <tfoot>
                                    <tr>
                                        <th colspan="3">Total</th>
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
                                    <th>Amount</th>
                                    <th>Payment Method</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($recent_sales as $sale): ?>
                                    <tr>
                                        <td><?= $sale['invoice_number'] ?></td>
                                        <td><?= date('d/m/Y H:i', strtotime($sale['date'])) ?></td>
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
                                $end = min($total_pages, $page + $range);

                                if ($start > 1) {
                                    echo '<li class="page-item"><a class="page-link" href="?page=1&start_date=' . $start_date . '&end_date=' . $end_date . '">1</a></li>';
                                    if ($start > 2) {
                                        echo '<li class="page-item disabled"><span class="page-link">...</span></li>';
                                    }
                                }

                                for ($i = $start; $i <= $end; $i++) {
                                    $active = ($i == $page) ? 'active' : '';
                                    echo '<li class="page-item ' . $active . '">
                          <a class="page-link" href="?page=' . $i . '&start_date=' . $start_date . '&end_date=' . $end_date . '">' . $i . '</a>
                      </li>';
                                }

                                if ($end < $total_pages) {
                                    if ($end < $total_pages - 1) {
                                        echo '<li class="page-item disabled"><span class="page-link">...</span></li>';
                                    }
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
    const productSearch = document.getElementById('productSearch');
    const suggestions = document.getElementById('suggestions');
    const saleItems = document.getElementById('saleItems');
    const saleTotal = document.getElementById('saleTotal');
    const paymentMethod = document.getElementById('paymentMethod');
    const transactionIdField = document.getElementById('transactionIdField');
    let total = 0;
    let items = [];

    // Show/hide transaction ID field based on payment method
    paymentMethod.addEventListener('change', function() {
        if (this.value === 'mobile_money') {
            transactionIdField.style.display = 'block';
            // Make transaction ID required when mobile money is selected
            transactionIdField.querySelector('input').setAttribute('required', 'required');
        } else {
            transactionIdField.style.display = 'none';
            // Remove required attribute for other payment methods
            transactionIdField.querySelector('input').removeAttribute('required');
        }
    });

    productSearch.addEventListener('input', function () {
        const query = this.value;
        if (query.length < 2) {
            suggestions.style.display = 'none';
            suggestions.innerHTML = '';
            return;
        }

        fetch(`../system/product_search.php?query=${encodeURIComponent(query)}`)
            .then(res => res.json())
            .then(data => {
                suggestions.innerHTML = '';
                if (data.length > 0) {
                    suggestions.style.display = 'block';
                    data.forEach(product => {
                        const item = document.createElement('button');
                        item.type = 'button';
                        item.className = 'list-group-item list-group-item-action';
                        item.textContent = `${product.name} - UGX ${product.selling_price} - Stock: ${product.quantity}`;
                        item.dataset.id = product.id;
                        item.dataset.name = product.name;
                        item.dataset.price = product.selling_price;
                        item.dataset.stock = product.quantity;

                        item.addEventListener('click', () => {
                            const existing = items.find(i => i.id === product.id);
                            if (existing) {
                                if (existing.quantity >= product.quantity) {
                                    alert('Cannot add more than available stock');
                                    return;
                                }
                                existing.quantity++;
                                existing.total = existing.quantity * existing.price;
                            } else {
                                items.push({
                                    id: product.id,
                                    name: product.name,
                                    price: parseFloat(product.selling_price),
                                    quantity: 1,
                                    total: parseFloat(product.selling_price)
                                });
                            }
                            updateSaleItems();
                            productSearch.value = '';
                            suggestions.style.display = 'none';
                            suggestions.innerHTML = '';
                        });

                        suggestions.appendChild(item);
                    });
                } else {
                    suggestions.style.display = 'none';
                }
            })
            .catch(err => {
                console.error('Error:', err);
                suggestions.style.display = 'none';
            });
    });

    // Hide suggestions when clicking outside
    document.addEventListener('click', function(e) {
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
                <td>
                    <input type="number" name="products[${index}][price]" 
                           value="${item.price.toFixed(2)}" min="0" step="0.01"
                           class="form-control form-control-sm price-input"
                           data-index="${index}">
                </td>
                <td>
                    <input type="number" name="products[${index}][quantity]" 
                           value="${item.quantity}" min="0.1" step="0.1" 
                           class="form-control form-control-sm quantity-input"
                           data-index="${index}">
                    <input type="hidden" name="products[${index}][id]" value="${item.id}">
                </td>
                <td>
                    <input type="number" name="products[${index}][total]" 
                           value="${item.total.toFixed(2)}" min="0" step="0.01"
                           class="form-control form-control-sm total-input"
                           data-index="${index}">
                </td>
                <td>
                    <button type="button" class="btn btn-sm btn-danger remove-item" data-index="${index}">Remove</button>
                </td>
            `;
            saleItems.appendChild(row);
        });

        saleTotal.textContent = total.toFixed(2);
        
        // Add event listeners for price inputs
        document.querySelectorAll('.price-input').forEach(input => {
            input.addEventListener('change', function () {
                const index = parseInt(this.dataset.index);
                let newPrice = parseFloat(this.value);
                if (isNaN(newPrice) || newPrice < 0) {
                    alert('Please enter a valid price');
                    this.value = items[index].price.toFixed(2);
                    return;
                }
                items[index].price = newPrice;
                items[index].total = items[index].quantity * items[index].price;
                updateSaleItems();
            });
        });
        
        // Add event listeners for quantity inputs
        document.querySelectorAll('.quantity-input').forEach(input => {
            input.addEventListener('change', function () {
                const index = parseInt(this.dataset.index);
                let newQty = parseFloat(this.value);
                if (isNaN(newQty) || newQty <= 0) {
                    alert('Quantity must be greater than 0');
                    this.value = items[index].quantity;
                    return;
                }
                items[index].quantity = newQty;
                items[index].total = items[index].quantity * items[index].price;
                updateSaleItems();
            });
        });
        
        // Add event listeners for total inputs
        document.querySelectorAll('.total-input').forEach(input => {
            input.addEventListener('change', function () {
                const index = parseInt(this.dataset.index);
                let newTotal = parseFloat(this.value);
                if (isNaN(newTotal) || newTotal < 0) {
                    alert('Please enter a valid total amount');
                    this.value = items[index].total.toFixed(2);
                    return;
                }
                
                // Calculate unit price based on total and quantity
                if (items[index].quantity > 0) {
                    items[index].price = newTotal / items[index].quantity;
                    items[index].total = newTotal;
                    updateSaleItems();
                } else {
                    alert('Quantity must be greater than 0 to calculate unit price');
                    this.value = items[index].total.toFixed(2);
                }
            });
        });
        
        // Add event listeners for remove buttons
        document.querySelectorAll('.remove-item').forEach(button => {
            button.addEventListener('click', function () {
                const index = parseInt(this.dataset.index);
                items.splice(index, 1);
                updateSaleItems();
            });
        });
    }
</script>

<?php include '../includes/footer.php'; ?>