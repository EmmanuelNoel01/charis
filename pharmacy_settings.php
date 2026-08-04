<?php
require_once 'includes/header.php';
require_once 'includes/functions.php';
requireAdmin();

$success = '';
$error = '';

$existing = $db->fetchOne("SELECT * FROM pharmacy_details LIMIT 1");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = trim($_POST['name']);
    $address = trim($_POST['address']);
    $phone = trim($_POST['phone']);
    $email = trim($_POST['email']);

    if ($existing) {
        $sql = "UPDATE pharmacy_details SET name = ?, address = ?, phone = ?, email = ? WHERE id = ?";
        $updated = $db->execute($sql, [$name, $address, $phone, $email, $existing['id']]);
        $success = "Pharmacy details updated successfully.";
    } else {
        $inserted = $db->insert("pharmacy_details", [
            'name' => $name,
            'address' => $address,
            'phone' => $phone,
            'email' => $email
        ]);
        $success = "Pharmacy details saved successfully.";
    }

    $existing = $db->fetchOne("SELECT * FROM pharmacy_details LIMIT 1");
}
?>

<div class="container mt-4">
    <div class="card">
        <div class="card-header">
            <h5>Pharmacy Information Settings</h5>
        </div>
        <div class="card-body">
            <?php if ($success): ?>
                <div class="alert alert-success"><?= $success ?></div>
            <?php endif; ?>

            <form method="POST" action="">
                <div class="mb-3">
                    <label class="form-label">Pharmacy Name</label>
                    <input type="text" name="name" class="form-control" required value="<?= htmlspecialchars($existing['name'] ?? '') ?>">
                </div>

                <div class="mb-3">
                    <label class="form-label">Address</label>
                    <textarea name="address" class="form-control" required><?= htmlspecialchars($existing['address'] ?? '') ?></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Phone</label>
                    <input type="text" name="phone" class="form-control" value="<?= htmlspecialchars($existing['phone'] ?? '') ?>">
                </div>

                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" value="<?= htmlspecialchars($existing['email'] ?? '') ?>">
                </div>

                <button type="submit" class="btn btn-primary">Save Settings</button>
            </form>
        </div>
    </div>
</div>

<?php require_once 'includes/footer.php'; ?>
