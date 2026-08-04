<?php
// IMPORTANT: handle POST (and redirects) BEFORE any HTML is sent.
// Header.php starts the page output, so the redirect must happen first.
require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../includes/functions.php';
requireLogin();

$edit_customer = null;
$error = '';

// CREATE / UPDATE
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['save_customer'])) {
    $id      = isset($_POST['id']) && $_POST['id'] !== '' ? (int) $_POST['id'] : null;
    $name    = trim($_POST['name'] ?? '');
    $contact = trim($_POST['contact'] ?? '');
    $address = trim($_POST['address'] ?? '');
    $remarks = trim($_POST['remarks'] ?? '');

    if ($name === '') {
        $error = 'Customer name is required.';
    } else {
        try {
            if ($id) {
                $db->execute(
                    "UPDATE customers_pharm SET name = ?, contact = ?, address = ?, remarks = ? WHERE id = ?",
                    [$name, $contact, $address, $remarks, $id]
                );
                $_SESSION['message'] = "Customer \"" . htmlspecialchars($name) . "\" was updated successfully.";
            } else {
                $db->insert('customers_pharm', [
                    'name' => $name,
                    'contact' => $contact,
                    'address' => $address,
                    'remarks' => $remarks
                ]);
                $_SESSION['message'] = "Customer \"" . htmlspecialchars($name) . "\" was registered successfully.";
            }
            header("Location: customers.php");
            exit();
        } catch (Exception $e) {
            $error = "Save failed: " . $e->getMessage();
        }
    }
}

// DELETE
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['delete_customer'])) {
    $id = (int) $_POST['id'];
    $db->execute("DELETE FROM customers_pharm WHERE id = ?", [$id]);
    $_SESSION['message'] = "Customer removed.";
    header("Location: customers.php");
    exit();
}

// From here on the page renders — include the layout header now.
require_once __DIR__ . '/../includes/header.php';

// LOAD ONE FOR EDIT
if (isset($_GET['edit'])) {
    $edit_customer = $db->fetchOne(
        "SELECT * FROM customers_pharm WHERE id = ?",
        [(int) $_GET['edit']]
    );
}

// LIST WITH SEARCH + PAGINATION
$search = trim($_GET['search'] ?? '');
$limit  = 15;
$page   = max(1, (int)($_GET['page'] ?? 1));
$offset = ($page - 1) * $limit;

if ($search !== '') {
    $total = (int) ($db->fetchOne(
        "SELECT COUNT(*) AS c FROM customers_pharm WHERE name LIKE CONCAT('%', ?, '%') OR contact LIKE CONCAT('%', ?, '%')",
        [$search, $search]
    )['c'] ?? 0);
    $customers = $db->fetchAll(
        "SELECT * FROM customers_pharm
         WHERE name LIKE CONCAT('%', ?, '%') OR contact LIKE CONCAT('%', ?, '%')
         ORDER BY name ASC LIMIT $limit OFFSET $offset",
        [$search, $search]
    );
} else {
    $total = (int) ($db->fetchOne("SELECT COUNT(*) AS c FROM customers_pharm")['c'] ?? 0);
    $customers = $db->fetchAll(
        "SELECT * FROM customers_pharm ORDER BY name ASC LIMIT $limit OFFSET $offset"
    );
}
$total_pages = max(1, (int) ceil($total / $limit));
?>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <div class="card mb-4">
                <div class="card-header">
                    <h5><?= $edit_customer ? 'Edit Customer' : 'Add Customer' ?></h5>
                </div>
                <div class="card-body">
                    <?php if ($error): ?>
                        <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
                    <?php endif; ?>
                    <form method="POST">
                        <input type="hidden" name="id" value="<?= $edit_customer['id'] ?? '' ?>">
                        <div class="mb-2">
                            <label class="form-label">Name *</label>
                            <input type="text" class="form-control" name="name"
                                   value="<?= htmlspecialchars($edit_customer['name'] ?? '') ?>" required>
                        </div>
                        <div class="mb-2">
                            <label class="form-label">Contact (phone)</label>
                            <input type="text" class="form-control" name="contact"
                                   value="<?= htmlspecialchars($edit_customer['contact'] ?? '') ?>">
                        </div>
                        <div class="mb-2">
                            <label class="form-label">Address</label>
                            <input type="text" class="form-control" name="address"
                                   value="<?= htmlspecialchars($edit_customer['address'] ?? '') ?>">
                        </div>
                        <div class="mb-2">
                            <label class="form-label">Remarks</label>
                            <textarea class="form-control" name="remarks" rows="3"><?= htmlspecialchars($edit_customer['remarks'] ?? '') ?></textarea>
                        </div>
                        <button type="submit" name="save_customer" class="btn btn-primary w-100">
                            <?= $edit_customer ? 'Update Customer' : 'Add Customer' ?>
                        </button>
                        <?php if ($edit_customer): ?>
                            <a href="customers.php" class="btn btn-secondary w-100 mt-2">Cancel</a>
                        <?php endif; ?>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<?php require_once '../includes/footer.php'; ?>
