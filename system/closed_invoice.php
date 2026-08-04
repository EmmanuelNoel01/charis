<?php
ob_start();
require_once '../includes/header.php';
require_once '../includes/functions.php';
require_once '../classes/PDF.php';
requireLogin();

$dbConn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['invoice'])) {
    $customer_name = $_POST['customer_name'] ?? 'Walk-in Customer';
    $payment_method = $_POST['payment_method'] ?? 'cash';
    $transaction_id = $_POST['transaction_id'] ?? '';
    $products = $_POST['products'] ?? [];

    if (empty($products)) {
        die("No products selected.");
    }

    $db->beginTransaction();

    try {
        $user_id = $_SESSION['user_id'];
        $invoice_number = 'INV' . time();
        $date = date('Y-m-d H:i:s');
        $total_amount = 0;

        foreach ($products as $prod) {
            $price = isset($prod['price']) ? (float) $prod['price'] : 0;
            $quantity = (float) $prod['quantity'];
            $total_amount += $price * $quantity;
        }

        // Prepare sale data with transaction_id
        $sale_data = [
            "user_id" => $user_id,
            "customer_name" => $customer_name,
            "invoice_number" => $invoice_number,
            "payment_method" => $payment_method,
            "total_amount" => $total_amount,
            "date" => $date
        ];

        // Add transaction_id only if it's not empty
        if (!empty($transaction_id)) {
            $sale_data["transaction_id"] = $transaction_id;
        }

        $sale_id = $db->insert("sales_pharm", $sale_data);

        foreach ($products as $prod) {
            $product_id = (int) $prod['id'];
            $quantity = (float) $prod['quantity'];
            $price = isset($prod['price']) ? (float) $prod['price'] : 0;
            $total = $price * $quantity;

            $db->insert("sale_items_pharm", [
                "sale_id" => $sale_id,
                "product_id" => $product_id,
                "quantity" => $quantity,
                "price" => $price,
                "total" => $total
            ]);

            // Get current quantity from the database
            $dBQuantity = $db->query("SELECT name, quantity FROM products_pharm WHERE id = ?", [$product_id])[0] ?? null;
            $productName = $dBQuantity['name'] ?? 'Unknown Product';
            $availableQty = $dBQuantity['quantity'] ?? 0;

            if (!$dBQuantity || $dBQuantity['quantity'] < $quantity) {
                // Redirect if insufficient stocknewpage.php
                echo "<script>
                    alert('You don\\'t have enough in stock for {$productName}. You have {$availableQty} left and you are trying to sell {$quantity}.');
                    window.history.back();
                </script>";
                exit();
            }
            else {
                // Update quantity
                $db->rawQuery("UPDATE products_pharm SET quantity = quantity - $quantity WHERE id = $product_id");
            }


        }

        $db->commit();

        header("Location: invoice.php?id=$sale_id");
        exit();
    } catch (Exception $e) {
        $db->rollback();
        die("Sale processing failed: " . $e->getMessage());
    }
    
}

if (!isset($_GET['id'])) {
    header("Location: sales.php");
    exit();
}

$sale_id = (int) $_GET['id'];
$sale = $db->query("
    SELECT s.*, u.username 
    FROM sales_pharm s
    JOIN users_pharm u ON s.user_id = u.id
    WHERE s.id = ?
", [$sale_id])[0] ?? null;

if (!$sale) {
    header("Location: sales.php");
    exit();
}

$sale_items = $db->query("
    SELECT si.*, p.name 
    FROM sale_items_pharm si
    JOIN products_pharm p ON si.product_id = p.id
    WHERE si.sale_id = ?
", [$sale_id]);

// Load pharmacy details safely
$pharmacy = $db->fetchOne("SELECT * FROM pharmacy_details LIMIT 1");

if (isset($_GET['download'])) {
    PDF::generateInvoice($sale_id, $db);
    $filePath = "../invoices/invoice_$sale_id.pdf";

    if (file_exists($filePath)) {
        header('Content-Type: application/pdf');
        header('Content-Disposition: inline; filename="invoice_' . $sale_id . '.pdf"');
        header('Content-Length: ' . filesize($filePath));
        readfile($filePath);
        exit;
    } else {
        die("Invoice file not found.");
    }
}
ob_end_flush();
?>

<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5>Invoice: <?= htmlspecialchars($sale['invoice_number']) ?></h5>
        <div>
            <a href="invoice.php?id=<?= $sale_id ?>&download=1" target="_blank" id="downloadInvoiceBtn"
                class="btn btn-primary">Download PDF</a>
            <?php if (isset($_SESSION['role']) && $_SESSION['role'] === 'admin'): ?>
                <a href="edit_invoice.php?id=<?= $sale_id ?>" class="btn btn-warning">Edit Invoice</a>
            <?php endif; ?>

            <a href="sales.php" class="btn btn-secondary">Back to Sales</a>
        </div>
    </div>
    <div class="card-body">
        <div class="row mb-4">
            <div class="col-md-6">
                <p>
                    <?= $pharmacy['name'] ?? 'Pharmacy Name Not Set' ?><br>
                    <?= nl2br($pharmacy['address'] ?? 'Address Not Set') ?><br>
                    Phone: <?= $pharmacy['phone'] ?? 'N/A' ?><br>
                    Email: <?= $pharmacy['email'] ?? 'N/A' ?>
                </p>
            </div>
            <div class="col-md-6 text-end">
                <p>
                    Invoice:  <?= htmlspecialchars($sale['invoice_number']) ?><br>
                    Date: <?= date('d/m/Y H:i', strtotime($sale['date'])) ?><br>
                    Pharmacist: <?= htmlspecialchars($sale['username']) ?>
                </p>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-md-12">
                <h6>Customer</h6>
                <p><?= htmlspecialchars($sale['customer_name']) ?></p>
            </div>
        </div>

        <div class="table-responsive mb-4">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th>Unit Price</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($sale_items as $index => $item): ?>
                        <tr>
                            <td><?= $index + 1 ?></td>
                            <td><?= htmlspecialchars($item['name']) ?></td>
                            <td><?= $item['quantity'] ?></td>
                            <td><?= number_format($item['price'], 2) ?></td>
                            <td><?= number_format($item['total'], 2) ?></td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
                <tfoot>
                    <tr>
                        <th colspan="4" class="text-end">Subtotal:</th>
                        <th><?= number_format($sale['total_amount'], 2) ?></th>
                    </tr>
                    <tr>
                        <th colspan="4" class="text-end">Tax (0%):</th>
                        <th>0.00</th>
                    </tr>
                    <tr>
                        <th colspan="4" class="text-end">Discount (0%):</th>
                        <th>0.00</th>
                    </tr>
                    <tr>
                        <th colspan="4" class="text-end">Total:</th>
                        <th>UGX <?= number_format($sale['total_amount']) ?></th>
                    </tr>
                </tfoot>
            </table>
        </div>

        <div class="row">
            <div class="col-md-12">
                <p>Payment Method: <?= ucfirst(str_replace('_', ' ', $sale['payment_method'])) ?></p>
                <?php if (!empty($sale['transaction_id'])): ?>
                    <p>Transaction ID: <?= htmlspecialchars($sale['transaction_id']) ?></p>
                <?php endif; ?>
                <p>Thank you for your business!</p>
            </div>
        </div>
    </div>
</div>

<?php require_once '../includes/footer.php'; ?>

<script>
    document.getElementById('downloadInvoiceBtn').addEventListener('click', () => {
        setTimeout(() => {
            window.location.href = 'sales.php';
        }, 2000);
    });
</script>