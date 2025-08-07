<?php
ob_start();
require_once '../includes/header.php';
require_once '../includes/functions.php';
requireLogin();

$sale_id = (int)($_GET['id'] ?? 0);
$sale = $db->fetchOne("SELECT * FROM sales_pharm WHERE id = ?", [$sale_id]);

if (!$sale) {
    die("Invalid sale ID.");
}

$sale_items = $db->query("
    SELECT si.*, p.name 
    FROM sale_items_pharm si
    JOIN products_pharm p ON si.product_id = p.id
    WHERE si.sale_id = ?
", [$sale_id]);

$products = $db->query("SELECT id, name, selling_price, quantity FROM products_pharm");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $customer_name = $_POST['customer_name'] ?? 'Walk-in Customer';
    $payment_method = $_POST['payment_method'] ?? 'cash';
    $updated_products = $_POST['products'] ?? [];

    $db->beginTransaction();
    try {
        foreach ($sale_items as $item) {
            $stmt = $db->prepare("UPDATE products_pharm SET quantity = quantity + ? WHERE id = ?");
            $stmt->bind_param("di", $item['quantity'], $item['product_id']);
            $stmt->execute();
            $stmt->close();
        }

        $stmt = $db->prepare("DELETE FROM sale_items_pharm WHERE sale_id = ?");
        $stmt->bind_param("i", $sale_id);
        $stmt->execute();
        $stmt->close();

        $total_amount = 0;
        foreach ($updated_products as $prod) {
            $product_id = (int)($prod['id'] ?? 0);
            $quantity = (float)($prod['quantity'] ?? 0);

            if ($product_id <= 0) {
                throw new Exception("Invalid product selected.");
            }

            $result = $db->fetchOne("SELECT selling_price FROM products_pharm WHERE id = ?", [$product_id]);
            $price = $result['selling_price'] ?? 0;
            $total = $price * $quantity;
            $total_amount += $total;

            // Insert new sale item
            $db->insert("sale_items_pharm", [
                "sale_id" => $sale_id,
                "product_id" => $product_id,
                "quantity" => $quantity,
                "price" => $price,
                "total" => $total
            ]);

            $stmt = $db->prepare("UPDATE products_pharm SET quantity = quantity - ? WHERE id = ?");
            $stmt->bind_param("di", $quantity, $product_id);
            $stmt->execute();
            $stmt->close();
        }

        $stmt = $db->prepare("UPDATE sales_pharm SET customer_name = ?, payment_method = ?, total_amount = ? WHERE id = ?");
        $stmt->bind_param("ssdi", $customer_name, $payment_method, $total_amount, $sale_id);
        $stmt->execute();
        $stmt->close();

        $db->commit();
        header("Location: invoice.php?id=$sale_id");
        exit();
    } catch (Exception $e) {
        $db->rollback();
        die("Invoice update failed: " . $e->getMessage());
    }
}

ob_end_flush();
?>
<div class="card">
    <div class="card-header">
        <h5>Edit Invoice #<?= htmlspecialchars($sale['invoice_number']) ?></h5>
    </div>
    <div class="card-body">
        <form method="POST">
            <div class="mb-3">
                <label>Customer Name</label>
                <input type="text" name="customer_name" value="<?= htmlspecialchars($sale['customer_name']) ?>" class="form-control" disabled>
            </div>

            <div class="mb-3">
                <label>Payment Method</label>
                <select name="payment_method" class="form-control" disabled>
                    <option value="cash" <?= $sale['payment_method'] === 'cash' ? 'selected' : '' ?>>Cash</option>
                    <option value="mobile_money" <?= $sale['payment_method'] === 'mobile_money' ? 'selected' : '' ?>>Mobile Money</option>
                    <option value="insurance" <?= $sale['payment_method'] === 'insurance' ? 'selected' : '' ?>>Insurance</option>
                </select>
            </div>

            <h6>Products</h6>
            <div id="productList">
                <?php foreach ($sale_items as $index => $item): ?>
                <div class="row mb-2 product-row">
                    <div class="col-md-6 dropdown">
                        <input type="text" class="form-control product-input" value="<?= htmlspecialchars($item['name']) ?>" placeholder="Select a product" readonly>
                        <input type="hidden" name="products[<?= $index ?>][id]" value="<?= $item['product_id'] ?>">
                        <div class="dropdown-content" id="dropdown-<?= $index ?>">
                            <?php foreach ($products as $p): ?>
                                <div class="product-option" data-id="<?= $p['id'] ?>" data-name="<?= $p['name'] ?>">
                                    <?= $p['name'] ?>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <input type="number" name="products[<?= $index ?>][quantity]" class="form-control" value="<?= $item['quantity'] ?>" min="0.1" step="0.1" required>
                    </div>
                    <div class="col-md-2">
                        <button type="button" class="btn btn-danger remove-row">X</button>
                    </div>
                </div>
                <?php endforeach; ?>
            </div>

            <button type="button" class="btn btn-sm btn-info" id="addProduct">Add Another Product</button>
            <br><br>
            <button type="submit" class="btn btn-primary">Update Invoice</button>
            <a href="invoice.php?id=<?= $sale_id ?>" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
</div>

<script>
let counter = <?= count($sale_items) ?>;
const products = <?= json_encode($products) ?>;

document.getElementById('addProduct').addEventListener('click', () => {
    const row = document.createElement('div');
    row.className = 'row mb-2 product-row';

    let options = '';
    for (const p of products) {
        options += `<div class="product-option" data-id="${p.id}" data-name="${p.name}">${p.name}</div>`;
    }

    row.innerHTML = `
        <div class="col-md-6 dropdown">
            <input type="text" class="form-control product-input" placeholder="Select a product" readonly>
            <input type="hidden" name="products[${counter}][id]" value="">
            <div class="dropdown-content" id="dropdown-${counter}">
                ${options}
            </div>
        </div>
        <div class="col-md-4">
            <input type="number" name="products[${counter}][quantity]" class="form-control" min="0.1" step="0.1" required>
        </div>
        <div class="col-md-2">
            <button type="button" class="btn btn-danger remove-row">X</button>
        </div>
    `;
    document.getElementById('productList').appendChild(row);
    counter++;
});

document.addEventListener('focus', (e) => {
    if (e.target.classList.contains('product-input')) {
        const dropdown = e.target.closest('.dropdown').querySelector('.dropdown-content');
        dropdown.classList.add('show');
    }
}, true);

document.addEventListener('click', (e) => {
    if (!e.target.matches('.product-input')) {
        document.querySelectorAll('.dropdown-content').forEach(dd => dd.classList.remove('show'));
    }
});

document.addEventListener('click', (e) => {
    if (e.target.classList.contains('product-option')) {
        const dropdown = e.target.closest('.dropdown');
        const input = dropdown.querySelector('.product-input');
        const hiddenInput = dropdown.querySelector('input[type="hidden"]');

        input.value = e.target.dataset.name;
        hiddenInput.value = e.target.dataset.id;

        dropdown.querySelector('.dropdown-content').classList.remove('show');
    }
});

document.addEventListener('click', function(e) {
    if (e.target && e.target.classList.contains('remove-row')) {
        e.target.closest('.product-row').remove();
    }
});
</script>

<style>
    .dropdown {
        position: relative;
        display: inline-block;
    }
    .dropdown-content {
        display: none;
        position: absolute;
        background-color: white;
        border: 1px solid #ccc;
        max-height: 200px;
        overflow-y: auto;
        z-index: 1;
        width: 100%;
    }
    .dropdown-content div {
        padding: 8px;
        cursor: pointer;
    }
    .dropdown-content div:hover {
        background-color: #f1f1f1;
    }
    .show {
        display: block;
    }
</style>

<?php require_once '../includes/footer.php'; ?>
