<?php
require_once '../includes/header.php';
require_once '../classes/Pharmacy.php';

requireAdmin();

$pharmacy = new Pharmacy($db);
$products = [];
$invoice_number = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['search_invoice'])) {
    $invoice_number = trim($_POST['invoice_number']);
    if ($invoice_number !== '') {
        // Pull from the audit/batches table. Every finalize on update_stock.php
        // archives a batch row here keyed by invoice_number, so this list is
        // never overwritten by a later re-stocking of the same product.
        $products = $db->fetchAll(
            "SELECT
                COALESCE(NULLIF(pb.name, ''), p.name) AS name,
                pb.batch_number,
                pb.buying_price,
                pb.selling_price,
                pb.expiry_date,
                pb.quantity,
                pb.unit_type,
                pb.barcode,
                pb.archived_at
             FROM product_batches_pharm pb
             LEFT JOIN products_pharm p ON p.id = pb.product_id
             WHERE pb.invoice_number = ?
             ORDER BY name ASC",
            [$invoice_number]
        );

        // Fallback: older receipts saved before this update may still only be
        // findable on the live products table.
        if (!$products) {
            $products = $db->fetchAll(
                'SELECT name, batch_number, buying_price, selling_price, expiry_date, quantity, unit_type, barcode
                 FROM products_pharm WHERE invoice_number = ? ORDER BY name ASC',
                [$invoice_number]
            );
        }

        if (!$products) {
            $_SESSION['error'] = "No products found for invoice number: $invoice_number";
        }
    }
}
?>

<div class="container mt-5">
    <div class="row mb-4">
        <div class="col-md-12">
            <div class="card shadow-sm">
                <div class="card-body">
                    <!-- <h4 class="card-title mb-3">Search Products by Invoice</h4> -->
                    
                    <?php if (!empty($_SESSION['error'])): ?>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <?= $_SESSION['error']; unset($_SESSION['error']); ?>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <?php endif; ?>

                    <form method="POST" class="row g-3">
                        <div class="col-md-6">
                            <input type="text" name="invoice_number" class="form-control form-control-lg" 
                                   placeholder="Enter Invoice Number..." 
                                   value="<?= htmlspecialchars($invoice_number) ?>" required>
                        </div>
                        <div class="col-md-3">
                            <button type="submit" name="search_invoice" class="btn btn-primary btn-lg w-100">
                                <i class="bi bi-search"></i> Search
                            </button>
                        </div>
                        <div class="col-md-3">
                            <a href="view_invoice.php" class="btn btn-secondary btn-lg w-100">
                                <i class="bi bi-arrow-repeat"></i> Reset
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <?php if ($products): ?>
        <div class="row">
            <div class="col-md-12">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <span>Products in Invoice: <strong><?= htmlspecialchars($invoice_number) ?></strong></span>
                        <span class="badge bg-light text-dark fs-6"><?= count($products) ?> Items</span>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <!-- <th>#</th> -->
                                        <th>Product Name</th>
                                        <th>Batch Number</th>
                                        <th>Buying Price</th>
                                        <th>Selling Price</th>
                                        <th>Expiry Date</th>
                                        <th>Quantity</th>
                                        <!-- <th>Unit Type</th> -->
                                        <!-- <th>Barcode</th> -->
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($products as $index => $product): ?>
                                        <tr>
                                            <!-- <td><?= $index + 1 ?></td> -->
                                            <td><?= htmlspecialchars($product['name']) ?></td>
                                            <td><?= htmlspecialchars($product['batch_number']) ?></td>
                                            <td>UGX <?= number_format($product['buying_price']) ?></td>
                                            <td>UGX <?= number_format($product['selling_price']) ?></td>
                                            <td><?= htmlspecialchars($product['expiry_date']) ?></td>
                                            <td><?= htmlspecialchars($product['quantity']) ?></td>
                                            <!-- <td>
                                                <span class="badge bg-secondary">
                                                    <?= htmlspecialchars(strtoupper($product['unit_type'])) ?>
                                                </span>
                                            </td> -->
                                            <!-- <td><?= htmlspecialchars($product['barcode']) ?></td> -->
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!-- <div class="card-footer text-muted">
                        Search completed at <?= date('d-m-Y H:i:s') ?>
                    </div> -->
                </div>
            </div>
        </div>
    <?php elseif ($invoice_number): ?>
        <div class="alert alert-info text-center">
            No products found for invoice number <strong><?= htmlspecialchars($invoice_number) ?></strong>.
        </div>
    <?php endif; ?>
</div>

<!-- Bootstrap Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<?php require_once '../includes/footer.php'; ?>
