<?php
ob_start();
require_once '../includes/header.php';
require_once '../classes/Pharmacy.php';

requireAdmin();

$pharmacy = new Pharmacy($db);

// Handle form submissions
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['add_product'])) {
        try {
            $product_id = $pharmacy->addProduct([
                'name' => $_POST['name'],
                'description' => $_POST['description'],
                'batch_number' => $_POST['batch_number'],
                'quantity' => (int) $_POST['quantity'],
                'buying_price' => (float) $_POST['buying_price'],
                'selling_price' => (float) $_POST['selling_price'],
                'expiry_date' => $_POST['expiry_date'],
                'minimum_stock_level' => (int) $_POST['minimum_stock_level'],
                'barcode' => $_POST['barcode'] ?? null,
                'unit_type' => $_POST['unit_type']
            ]);

            $_SESSION['message'] = 'Product added successfully!';
            header("Location: products.php?action=view&id=$product_id");
            exit();
        } catch (Exception $e) {
            $error = $e->getMessage();
        }
    } elseif (isset($_POST['update_product'])) {
        try {
            $product_id = (int) $_POST['product_id'];
            $pharmacy->updateProduct($product_id, [
                'name' => $_POST['name'],
                'description' => $_POST['description'],
                'batch_number' => $_POST['batch_number'],
                'quantity' => (int) $_POST['quantity'],
                'buying_price' => (float) $_POST['buying_price'],
                'selling_price' => (float) $_POST['selling_price'],
                'expiry_date' => $_POST['expiry_date'],
                'minimum_stock_level' => (int) $_POST['minimum_stock_level'],
                'barcode' => $_POST['barcode'] ?? null,
                'unit_type' => $_POST['unit_type']
            ]);

            $_SESSION['message'] = 'Product updated successfully!';
            header("Location: products.php?action=view&id=$product_id");
            exit();
        } catch (Exception $e) {
            $error = $e->getMessage();
        }
    } elseif (isset($_FILES['csv_file'])) {
        try {
            $file = $_FILES['csv_file']['tmp_name'];
            $result = $pharmacy->importProductsFromCSV($file);
            $_SESSION['message'] = sprintf(
                'CSV import completed: %d products imported, %d failed',
                $result['success'],
                $result['errors']
            );
            header('Location: products.php');
            exit();
        } catch (Exception $e) {
            $error = $e->getMessage();
        }
    } elseif (isset($_POST['delete_all_products'])) {
        // Bulk delete all products and related data
        try {
            $db->beginTransaction();

            $db->execute('DELETE FROM stock_movements_pharm');
            $db->execute('DELETE FROM sale_items_pharm');
            $db->execute('DELETE FROM procurement_items_pharm');
            $db->execute('DELETE FROM credit_note_items_pharm');
            $db->execute('DELETE FROM products_pharm');

            $db->commit();
            $_SESSION['message'] = 'All products and related data deleted successfully!';
        } catch (Exception $e) {
            $db->rollback();
            $_SESSION['error'] = 'Bulk delete failed: ' . $e->getMessage();
        }
        header('Location: products.php');
        exit();
    }
}

$action = $_GET['action'] ?? '';
$product_id = (int) ($_GET['id'] ?? 0);

if ($action === 'delete' && $product_id) {
    try {
        $db->beginTransaction();

        $db->execute('DELETE FROM stock_movements_pharm WHERE product_id = ?', [$product_id]);

        $db->execute('DELETE FROM sale_items_pharm WHERE product_id = ?', [$product_id]);

        $db->execute('DELETE FROM procurement_items_pharm WHERE product_id = ?', [$product_id]);

        $db->execute('DELETE FROM credit_note_items_pharm WHERE product_id = ?', [$product_id]);

        $db->execute('DELETE FROM products_pharm WHERE id = ?', [$product_id]);

        $db->commit();
        $_SESSION['message'] = 'Product and related data deleted successfully!';
    } catch (Exception $e) {
        $db->rollback();
        $_SESSION['error'] = 'Delete failed: ' . $e->getMessage();
    }

    header('Location: products.php');
    exit();
}

$product = null;
if (in_array($action, ['view', 'edit']) && $product_id) {
    $product = $pharmacy->getProduct($product_id);
    if (!$product) {
        header('Location: products.php');
        exit();
    }
}

$limit = 10;
$page = isset($_GET['page']) ? (int) $_GET['page'] : 1;
$page = max($page, 1);
$offset = ($page - 1) * $limit;

$total_all = $pharmacy->countAllProducts($_GET['search'] ?? '');
$total_expiring = $pharmacy->countExpiringProducts();
$total_low = $pharmacy->countLowStockProducts();

$total_pages_all = ceil($total_all / $limit);
$total_pages_expiring = ceil($total_expiring / $limit);
$total_pages_low = ceil($total_low / $limit);

$search = $_GET['search'] ?? '';
$products = $pharmacy->getProducts($search, $limit, $offset);
$expiring_soon = $pharmacy->getExpiringProducts($limit, $offset);
$low_stock = $pharmacy->getLowStockProducts($limit, $offset);

function renderPagination($current_page, $total_pages, $tab = '')
{
    $output = '<nav><ul class="pagination">';
    for ($i = 1; $i <= $total_pages; $i++) {
        $active = $i === $current_page ? ' active' : '';
        $url = '?page=' . $i;
        if ($tab)
            $url .= '#' . $tab;
        $output .= "<li class='page-item$active'><a class='page-link' href='$url'>$i</a></li>";
    }
    $output .= '</ul></nav>';
    return $output;
}

// $search = $_GET['search'] ?? '';
// $products = $pharmacy->getProducts($search);
// $expiring_soon = $pharmacy->getExpiringProducts();
// $low_stock = $pharmacy->getLowStockProducts();
ob_end_flush();
?>
<div class="card mb-4">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5>Product Management</h5>
        <div>
            <button class="btn btn-danger me-2"
                onclick="if(confirm('Are you sure you want to delete ALL products and all related data? This action cannot be undone.')) { document.getElementById('deleteAllForm').submit(); }">
                <i class="fas fa-trash"></i> Delete All Products
            </button>

            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#importModal">
                <i class="fas fa-file-import"></i> Import CSV
            </button>
            <a href="?action=add" class="btn btn-success">
                <i class="fas fa-plus"></i> Add Product
            </a>
        </div>
    </div>

    <form id="deleteAllForm" method="POST" style="display:none;">
        <input type="hidden" name="delete_all_products" value="1">
    </form>

    <div class="card-body">
        <?php if (isset($error)): ?>
            <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
        <?php endif; ?>

        <?php if (!empty($_SESSION['message'])): ?>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <?= htmlspecialchars($_SESSION['message']) ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <?php unset($_SESSION['message']); ?>
        <?php endif; ?>

        <?php if (!empty($_SESSION['error'])): ?>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <?= htmlspecialchars($_SESSION['error']) ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <?php unset($_SESSION['error']); ?>
        <?php endif; ?>

        <form class="mb-3">
            <div class="input-group">
                <input type="text" class="form-control" name="search" placeholder="Search products..."
                    value="<?= htmlspecialchars($search) ?>">
                <button class="btn btn-outline-secondary" type="submit">
                    <i class="fas fa-search"></i> Search
                </button>
            </div>
        </form>

        <ul class="nav nav-tabs" id="productTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="all-tab" data-bs-toggle="tab" data-bs-target="#all" type="button">
                    All Products
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="expiring-tab" data-bs-toggle="tab" data-bs-target="#expiring"
                    type="button">
                    Expiring Soon
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="low-tab" data-bs-toggle="tab" data-bs-target="#low" type="button">
                    Low Stock
                </button>
            </li>
        </ul>

        <div class="tab-content p-3 border border-top-0 rounded-bottom">
            <div class="tab-pane fade show active" id="all" role="tabpanel">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Batch</th>
                                <th>Quantity</th>
                                <th>Buying Price</th>
                                <th>Selling Price</th>
                                <th>Expiry Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($products as $p): ?>
                                <tr class="<?= $p['quantity'] <= $p['minimum_stock_level'] ? 'table-warning' : '' ?>
                                <?= (strtotime($p['expiry_date']) - time()) < (30 * 86400) ? 'table-danger' : '' ?>">
                                    <td><?= htmlspecialchars($p['name']) ?></td>
                                    <td><?= htmlspecialchars($p['batch_number']) ?></td>
                                    <td><?= $p['quantity'] ?></td>
                                    <td><?= number_format($p['buying_price'], 2) ?></td>
                                    <td><?= number_format($p['selling_price'], 2) ?></td>
                                    <td><?= date('d/m/Y', strtotime($p['expiry_date'])) ?></td>
                                    <td>
                                        <a href="?action=view&id=<?= $p['id'] ?>" class="btn btn-sm btn-info" title="View">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="?action=edit&id=<?= $p['id'] ?>" class="btn btn-sm btn-warning"
                                            title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="?action=delete&id=<?= $p['id'] ?>" class="btn btn-sm btn-danger"
                                            onclick="return confirm('Are you sure you want to delete this product and all related data?')"
                                            title="Delete">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                    <?= renderPagination($page, $total_pages_all, 'all') ?>
                </div>
            </div>

            <div class="tab-pane fade" id="expiring" role="tabpanel">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Batch</th>
                                <th>Quantity</th>
                                <th>Expiry Date</th>
                                <th>Days Left</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($expiring_soon as $p): ?>
                                <tr>
                                    <td><?= htmlspecialchars($p['name']) ?></td>
                                    <td><?= htmlspecialchars($p['batch_number']) ?></td>
                                    <td><?= $p['quantity'] ?></td>
                                    <td><?= date('d/m/Y', strtotime($p['expiry_date'])) ?></td>
                                    <td><?= floor((strtotime($p['expiry_date']) - time()) / 86400) ?></td>
                                    <td>
                                        <a href="?action=view&id=<?= $p['id'] ?>" class="btn btn-sm btn-info" title="View">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                    <?= renderPagination($page, $total_pages_expiring, 'expiring') ?>
                </div>
            </div>

            <div class="tab-pane fade" id="low" role="tabpanel">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Batch</th>
                                <th>Current Stock</th>
                                <th>Minimum Level</th>
                                <th>Difference</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($low_stock as $p): ?>
                                <tr>
                                    <td><?= htmlspecialchars($p['name']) ?></td>
                                    <td><?= htmlspecialchars($p['batch_number']) ?></td>
                                    <td><?= $p['quantity'] ?></td>
                                    <td><?= $p['minimum_stock_level'] ?></td>
                                    <td><?= $p['quantity'] - $p['minimum_stock_level'] ?></td>
                                    <td>
                                        <a href="?action=view&id=<?= $p['id'] ?>" class="btn btn-sm btn-info" title="View">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="?action=edit&id=<?= $p['id'] ?>" class="btn btn-sm btn-warning"
                                            title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                    <?= renderPagination($page, $total_pages_low, 'low') ?>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Import CSV Modal -->
<div class="modal fade" id="importModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Import Products from CSV
                    <div class="form-text"
                        style="color: red; font-weight: bold; text-transform: uppercase; margin-bottom: 5px;">
                        Ensure the dates are correct
                    </div>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="POST" enctype="multipart/form-data">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">CSV File</label>
                        <input type="file" class="form-control" name="csv_file" accept=".csv" required>

                        <div class="form-text">
                            CSV format: Name,Description,Batch Number,Quantity,Buying Price,Selling Price,Expiry Date
                            (YYYY-MM-DD),Minimum Stock Level,Barcode, Unit Type
                        </div>

                    </div>
                    <div class="mb-3">
                        <a href="sample_products.csv" class="btn btn-sm btn-outline-secondary">
                            <i class="fas fa-download"></i> Download Sample CSV
                        </a>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Import</button>
                </div>
            </form>
        </div>
    </div>
</div>

<?php if ($action === 'add' || $action === 'edit'): ?>
    <?php
    $editing = ($action === 'edit');
    $p = $editing ? $product : [
        'name' => '',
        'description' => '',
        'batch_number' => '',
        'quantity' => 0,
        'buying_price' => 0,
        'selling_price' => 0,
        'expiry_date' => date('d-m-y'),
        'minimum_stock_level' => 10,
        'barcode' => '',
        'unit_type' => '',
    ];
    ?>
    <div class="card mt-4">
        <div class="card-header">
            <h5><?= $editing ? 'Edit Product' : 'Add New Product' ?></h5>
        </div>
        <div class="card-body">
            <form method="POST">
                <?php if ($editing): ?>
                    <input type="hidden" name="product_id" value="<?= $p['id'] ?>">
                <?php endif; ?>

                <div class="mb-3">
                    <label class="form-label">Name</label>
                    <input required type="text" name="name" class="form-control"
                        value="<?= htmlspecialchars($p['name']) ?>">
                </div>

                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control"><?= htmlspecialchars($p['description']) ?></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Batch Number</label>
                    <input required type="text" name="batch_number" class="form-control"
                        value="<?= htmlspecialchars($p['batch_number']) ?>">
                </div>

                <div class="mb-3">
                    <label class="form-label">Quantity</label>
                    <input required type="number" min="0" name="quantity" class="form-control"
                        value="<?= htmlspecialchars($p['quantity']) ?>">
                </div>

                <div class="mb-3">
                    <label class="form-label">Buying Price</label>
                    <input required type="number" min="0" step="0.01" name="buying_price" class="form-control"
                        value="<?= htmlspecialchars($p['buying_price']) ?>">
                </div>

                <div class="mb-3">
                    <label class="form-label">Selling Price</label>
                    <input required type="number" min="0" step="0.01" name="selling_price" class="form-control"
                        value="<?= htmlspecialchars($p['selling_price']) ?>">
                </div>

                <div class="mb-3">
                    <label class="form-label">Expiry Date</label>
                    <input required type="date" name="expiry_date" class="form-control"
                        value="<?= htmlspecialchars($p['expiry_date']) ?>">
                </div>

                <div class="mb-3">
                    <label class="form-label">Minimum Stock Level</label>
                    <input required type="number" min="0" name="minimum_stock_level" class="form-control"
                        value="<?= htmlspecialchars($p['minimum_stock_level']) ?>">
                </div>

                <div class="mb-3">
                    <label class="form-label">Barcode</label>
                    <input type="text" name="barcode" class="form-control" value="<?= htmlspecialchars($p['barcode']) ?>">
                </div>
                <div class="mb-3">
                    <label class="form-label">Unit Type</label>
                    <select name="unit_type" class="form-select" required>
                        <option value="">-- Select Unit Type --</option>
                        <option value="strp" <?= $p['unit_type'] === 'strp' ? 'selected' : '' ?>>Strip</option>
                        <option value="pkt" <?= $p['unit_type'] === 'pkt' ? 'selected' : '' ?>>Packet</option>
                        <option value="inj" <?= $p['unit_type'] === 'inj' ? 'selected' : '' ?>>Injection</option>
                        <option value="tab" <?= $p['unit_type'] === 'tab' ? 'selected' : '' ?>>Tablet</option>
                        <option value="cap" <?= $p['unit_type'] === 'cap' ? 'selected' : '' ?>>Capsule</option>
                        <option value="dos" <?= $p['unit_type'] === 'dos' ? 'selected' : '' ?>>Dose</option>
                        <option value="pce" <?= $p['unit_type'] === 'pce' ? 'selected' : '' ?>>Piece</option>
                        <option value="btl" <?= $p['unit_type'] === 'btl' ? 'selected' : '' ?>>Bottle</option>
                        <option value="syp" <?= $p['unit_type'] === 'syp' ? 'selected' : '' ?>>Syrup</option>
                        <option value="scht" <?= $p['unit_type'] === 'scht' ? 'selected' : '' ?>>Sachet</option>
                    </select>
                </div>

                <button type="submit" name="<?= $editing ? 'update_product' : 'add_product' ?>" class="btn btn-primary">
                    <?= $editing ? 'Update' : 'Add' ?> Product
                </button>
                <a href="products.php" class="btn btn-secondary">Cancel</a>
            </form>
        </div>
    </div>
<?php endif; ?>

<?php
require_once '../includes/footer.php';
?>