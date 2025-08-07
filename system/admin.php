<?php
require_once '../includes/db.php';
require_once '../includes/auth.php';

requireAdmin();

if (isset($_GET['delete'])) {
    $delete_id = (int)$_GET['delete'];
    $sql = "DELETE FROM users_pharm WHERE id = ?";
    if ($db->execute($sql, [$delete_id])) {
        $_SESSION['message'] = "User deleted successfully!";
    } else {
        $_SESSION['error'] = "Failed to delete user.";
    }
    header("Location: admin.php");
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['create_user'])) {
    $username = $_POST['username'];
    $encrypted_password = $auth->encrypt($_POST['password']); 
    $role = $_POST['role'];
    $full_name = $_POST['full_name'];
    $email = $_POST['email'];
    $phone = $_POST['phone'];

    $user_data = [
        'username' => $username,
        'password' => $encrypted_password,
        'role' => $role,
        'full_name' => $full_name,
        'email' => $email,
        'phone' => $phone,
        'created_at' => date('Y-m-d H:i:s')
    ];

    $insert_result = $db->insert('users_pharm', $user_data);

    if (is_numeric($insert_result)) {
        $_SESSION['message'] = "User created successfully!";
    } else {
        if (str_contains($insert_result, 'Duplicate entry')) {
            if (str_contains($insert_result, 'email')) {
                $_SESSION['error'] = "Email already exists. Please use a different email.";
            } elseif (str_contains($insert_result, 'username')) {
                $_SESSION['error'] = "Username already exists. Please choose another.";
            } else {
                $_SESSION['error'] = "Duplicate entry error.";
            }
        } else {
            $_SESSION['error'] = "Failed to create user: " . $insert_result;
        }
    }

    header("Location: admin.php");
    exit();
}


if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['edit_user'])) {
    $user_id = (int)$_POST['user_id'];
    $username = $_POST['username'];
    $role = $_POST['role'];
    $full_name = $_POST['full_name'];
    $email = $_POST['email'];
    $phone = $_POST['phone'];

    if (!empty($_POST['password'])) {
        $encrypted_password = $auth->encrypt($_POST['password']); 
        $sql = "UPDATE users_pharm SET username = ?, role = ?, full_name = ?, email = ?, phone = ?, password = ? WHERE id = ?";
        $params = [$username, $role, $full_name, $email, $phone, $encrypted_password, $user_id];
    } else {
        $sql = "UPDATE users_pharm SET username = ?, role = ?, full_name = ?, email = ?, phone = ? WHERE id = ?";
        $params = [$username, $role, $full_name, $email, $phone, $user_id];
    }

    if ($db->execute($sql, $params)) {
        $_SESSION['message'] = "User updated successfully!";
    } else {
        $_SESSION['error'] = "Failed to update user.";
    }

    header("Location: admin.php");
    exit();
}

$users = $db->query("SELECT * FROM users_pharm ORDER BY created_at DESC");
ob_end_flush();
?>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" />
<title>User Management</title>
</head>
<body>
<?php require_once '../includes/header.php'; ?>
<div class="container-fluid mt-4">

    <?php if (!empty($_SESSION['message'])): ?>
        <div class="alert alert-success"><?= $_SESSION['message']; unset($_SESSION['message']); ?></div>
    <?php endif; ?>
    <?php if (!empty($_SESSION['error'])): ?>
        <div class="alert alert-danger"><?= $_SESSION['error']; unset($_SESSION['error']); ?></div>
    <?php endif; ?>

    <div class="card mb-4">
        <div class="card-header"><h5>User Management</h5></div>
        <div class="card-body">
            <button class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#createUserModal">Create New User</button>

            <div class="table-responsive">
                <table class="table table-striped align-middle">
                    <thead>
                        <tr>
                            <th>Username</th>
                            <th>Full Name</th>
                            <th>Role</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Last Login</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php foreach ($users as $user): ?>
                        <tr>
                            <td><?= htmlspecialchars($user['username']) ?></td>
                            <td><?= htmlspecialchars($user['full_name']) ?></td>
                            <td><?= ucfirst($user['role']) ?></td>
                            <td><?= htmlspecialchars($user['email']) ?></td>
                            <td><?= htmlspecialchars($user['phone']) ?></td>
                            <td><?= $user['last_login'] ? date('d/m/Y H:i', strtotime($user['last_login'])) : 'Never' ?></td>
                            <td class="d-flex gap-2">
                                <button 
                                    class="btn btn-sm btn-warning edit-btn flex-fill"
                                    data-id="<?= $user['id'] ?>"
                                    data-username="<?= htmlspecialchars($user['username'], ENT_QUOTES) ?>"
                                    data-full_name="<?= htmlspecialchars($user['full_name'], ENT_QUOTES) ?>"
                                    data-role="<?= $user['role'] ?>"
                                    data-email="<?= htmlspecialchars($user['email'], ENT_QUOTES) ?>"
                                    data-phone="<?= htmlspecialchars($user['phone'], ENT_QUOTES) ?>"
                                    data-bs-toggle="modal" data-bs-target="#editUserModal"
                                >Edit</button>
                                <a href="admin.php?delete=<?= $user['id'] ?>" class="btn btn-sm btn-danger flex-fill" onclick="return confirm('Are you sure?')">Delete</a>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>

<div class="modal fade" id="createUserModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form method="POST" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Create New User</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">                
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <input type="text" class="form-control" name="username" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <input type="password" class="form-control" name="password" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Role</label>
                    <select class="form-select" name="role" required>
                        <option value="admin">Admin</option>
                        <option value="pharmacist">Pharmacist</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Full Name</label>
                    <input type="text" class="form-control" name="full_name" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" name="email" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Phone</label>
                    <input type="text" class="form-control" name="phone" />
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="submit" name="create_user" class="btn btn-primary">Create User</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="editUserModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form method="POST" class="modal-content">
            <input type="hidden" name="user_id" id="editUserId" />
            <div class="modal-header">
                <h5 class="modal-title">Edit User</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">                
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <input type="text" class="form-control" name="username" id="editUsername" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Password <small>(Leave blank to keep current password)</small></label>
                    <input type="password" class="form-control" name="password" id="editPassword" autocomplete="new-password" />
                </div>
                <div class="mb-3">
                    <label class="form-label">Role</label>
                    <select class="form-select" name="role" id="editRole" required>
                        <option value="admin">Admin</option>
                        <option value="pharmacist">Pharmacist</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Full Name</label>
                    <input type="text" class="form-control" name="full_name" id="editFullName" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" name="email" id="editEmail" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Phone</label>
                    <input type="text" class="form-control" name="phone" id="editPhone" />
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="submit" name="edit_user" class="btn btn-primary">Update User</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.min.js"></script>
<script>
document.querySelectorAll('.edit-btn').forEach(button => {
    button.addEventListener('click', function() {
        document.getElementById('editUserId').value = this.getAttribute('data-id');
        document.getElementById('editUsername').value = this.getAttribute('data-username');
        document.getElementById('editFullName').value = this.getAttribute('data-full_name');
        document.getElementById('editRole').value = this.getAttribute('data-role');
        document.getElementById('editEmail').value = this.getAttribute('data-email');
        document.getElementById('editPhone').value = this.getAttribute('data-phone');
        document.getElementById('editPassword').value = '';
    });
});
</script>

<?php if (!empty($_SESSION['error']) && isset($_POST['create_user'])): ?>
<script>
    const createModal = new bootstrap.Modal(document.getElementById('createUserModal'));
    createModal.show();
</script>
<?php endif; ?>

</body>
</html>
