<?php
require_once 'includes/auth.php';

if ($auth->isLoggedIn()) {
    header("Location: index.php");
    exit();
}

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';

    if ($auth->login($username, $password)) {
        // Redirect based on role
        if ($auth->isAdmin()) {
            header("Location: system/index.php");
        } else {
            header("Location: system/index.php");
        }
        exit();
    } else {
        $error = "Invalid username or password";
    }
}
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>LogIn</title>

    <!-- Meta -->
    <meta name="description" content="Marketplace for Bootstrap Admin Dashboards">
    <meta property="og:title" content="Admin Templates - Dashboard Templates">
    <meta property="og:description" content="Marketplace for Bootstrap Admin Dashboards">
    <meta property="og:type" content="Website">
    <!-- <link rel="shortcut icon" href="assets/images/favicon.svg"> -->

    <link rel="stylesheet" href="assets/fonts/remix/remixicon.css">
    <link rel="stylesheet" href="assets/css/main.min.css">

</head>

<body class="login-bg">

    <div class="container">
        <div class="auth-wrapper">
            <form method="POST">
                <div class="auth-box">
                    <a href="index.html" class="auth-logo mb-4">
                        <img src="assets/images/logo-dark.svg" alt="Bootstrap Gallery">
                    </a>
                    <?php if (isset($_SESSION['error'])): ?>
                        <div class="alert alert-danger"><?= $_SESSION['error'] ?></div>
                        <?php unset($_SESSION['error']); ?>
                    <?php endif; ?>

                    <?php if ($error): ?>
                        <div class="alert alert-danger"><?= $error ?></div>
                    <?php endif; ?>
                    <?php if (isset($_GET['timeout'])): ?>
                        <div class="alert alert-warning">You have been inactive for long. Please log in again.</div>
                    <?php endif; ?>
                    <div class="mb-3">
                        <label class="form-label" for="username" class="form-label">Username <span
                                class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="username" name="username" required autofocus>
                    </div>
                    <div class="mb-2">
                        <label class="form-label" for="password" class="form-label">Password <span
                                class="text-danger">*</span></label>
                        <div class="input-group">
                            <input type="password" class="form-control" id="password" name="password" required>
                            <button type="button" class="btn btn-outline-secondary" id="togglePassword">
                                <i class="ri-eye-line text-primary"></i></button>
                        </div>
                    </div>
                    <div class="mb-3 d-grid gap-2">
                        <button type="submit" class="btn btn-primary">Login</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</body>
<script>
    const togglePassword = document.querySelector('#togglePassword');
    const password = document.querySelector('#password');

    togglePassword.addEventListener('click', function (e) {
        // toggle the type attribute
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        // toggle the eye slash icon. nnnnnnnnn
        this.querySelector('i').classList.toggle('ri-eye-line');
        this.querySelector('i').classList.toggle('ri-eye-off-line');
    });

</script>
</html>