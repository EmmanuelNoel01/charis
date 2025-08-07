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

<div class="row">
    <div class="col-md-7">
        <div class="card mb-4">
            <div class="card-header">
                <h5>New Sale</h5>
            </div>
            <div class="card-body">
                <form id="saleForm" method="POST" action="invoice.php">
                    <div class="mb-3">
                        <label class="form-label">Customer Name</label>
                        <input type="text" class="form-control" name="customer_name" placeholder="Type customer name..."
                            required>
                    </div>

                    <div class="mb-3 position-relative">
                        <label class="form-label">Search Product</label>
                        <input type="text" id="productSearch" class="form-control" placeholder="Type product name...">
                        <div id="suggestions" class="list-group position-absolute w-100" style="z-index: 1000;"></div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-striped">
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
                                    <th id="saleTotal">0.00</th>
                                    <th></th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Payment Method</label>
                        <select class="form-select" name="payment_method" required>
                            <option value="cash">Cash</option>
                            <option value="card">Card</option>
                            <option value="mobile_money">Mobile Money</option>
                        </select>
                    </div>

                    <button type="submit" name="invoice" class="btn btn-success w-100">Process Sale</button>
                </form>
            </div>
        </div>
    </div>

    <div class="col-md-5">
        <div class="card">
            <div class="card-header">
                <h5>Recent Sales</h5>
            </div>
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
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Invoice #</th>
                                <th>Date</th>
                                <th>Amount</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($recent_sales as $sale): ?>
                                <tr>
                                    <td><?= $sale['invoice_number'] ?></td>
                                    <td><?= date('d/m/Y H:i', strtotime($sale['date'])) ?></td>
                                    <td><?= number_format($sale['total_amount'], 2) ?></td>
                                    <td>
                                        <a href="invoice.php?id=<?= $sale['id'] ?>" class="btn btn-sm btn-info">View</a>
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

                            <?php for ($i = 1; $i <= $total_pages; $i++): ?>
                                <li class="page-item <?= ($page == $i) ? 'active' : '' ?>">
                                    <a class="page-link"
                                        href="?page=<?= $i ?>&start_date=<?= $start_date ?>&end_date=<?= $end_date ?>"><?= $i ?></a>
                                </li>
                            <?php endfor; ?>

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


<script>
    const productSearch = document.getElementById('productSearch');
    const suggestions = document.getElementById('suggestions');
    const saleItems = document.getElementById('saleItems');
    const saleTotal = document.getElementById('saleTotal');
    let total = 0;
    let items = [];

    productSearch.addEventListener('input', function () {
        const query = this.value;
        if (query.length < 2) {
            suggestions.innerHTML = '';
            return;
        }

        fetch(`../system/product_search.php?query=${encodeURIComponent(query)}`)
            .then(res => res.json())
            .then(data => {
                suggestions.innerHTML = '';
                data.forEach(product => {
                    const item = document.createElement('button');
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
                        suggestions.innerHTML = '';
                    });

                    suggestions.appendChild(item);
                });
            });
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
                       value="${item.price.toFixed(2)}" min="0" step="1"
                       class="form-control form-control-sm price-input"
                       data-index="${index}">
            </td>
            <td>
                <input type="number" name="products[${index}][quantity]" 
       value="${item.quantity}" min="0.1" step="0.1" class="form-control form-control-sm quantity-input"
       data-index="${index}">

                <input type="hidden" name="products[${index}][id]" value="${item.id}">
            </td>
            <td>${item.total.toFixed(2)}</td>
            <td>
                <button type="button" class="btn btn-sm btn-danger remove-item" data-index="${index}">Remove</button>
            </td>
        `;
            saleItems.appendChild(row);
        });

        saleTotal.textContent = total.toFixed(2);
        document.querySelectorAll('.price-input').forEach(input => {
            input.addEventListener('change', function () {
                const index = parseFloat(this.dataset.index);
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
        document.querySelectorAll('.quantity-input').forEach(input => {
            input.addEventListener('change', function () {
                const index = parseFloat(this.dataset.index);
                let newQty = parseFloat(this.value);
                if (isNaN(newQty) || newQty <= 0) {
                    alert('Quantity must be at least 1');
                    this.value = items[index].quantity;
                    return;
                }
                items[index].quantity = newQty;
                items[index].total = items[index].quantity * items[index].price;
                updateSaleItems();
            });
        });
        document.querySelectorAll('.remove-item').forEach(button => {
            button.addEventListener('click', function () {
                const index = parseFloat(this.dataset.index);
                items.splice(index, 1);
                updateSaleItems();
            });
        });
    }
</script>

<?php include '../includes/footer.php'; ?>