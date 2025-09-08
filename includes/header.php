<?php
require_once 'auth.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>RUKAKANT SYSTEM</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="../assets/css/style.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <style>
    body,
    html {
      margin: 0;
      padding: 0;
      height: 100%;
    }
    .wrapper {
      display: flex;
      min-height: 100vh;
      width: 100%;
    }
    .sidebar {
      background-color: #116aef;
      color: white;
      min-width: 250px;
      max-width: 280px;
      flex-shrink: 0;
    }
    .sidebar .nav-link {
      color: #fff;
      padding: 10px 15px;
      border-radius: 5px;
      transition: background-color 0.2s ease, color 0.2s ease, transform 0.1s;
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 8px;
      text-decoration: none;
    }
    /* Hover */
    .sidebar .nav-link:hover {
      background-color: #f0f0f0;
      color: #000;
      transform: scale(1.02);
      text-decoration: none;
    }
    /* Active (selected) */
    .sidebar .nav-link.active-link {
      background-color: #f0f0f0;
      color: #000;
      font-weight: bold;
      text-decoration: none;
    }
    .content {
      flex-grow: 1;
      padding: 20px;
      width: 100%;
    }
  </style>
</head>
<body>
  <?php if ($auth->isLoggedIn()): ?>
    <div class="wrapper">
      <!-- Sidebar -->
      <nav class="sidebar d-flex flex-column p-3">
        <a href="index.php" class="navbar-brand text-white mb-4 fs-4">RUKAKANT</a>
        <hr class="text-white" />
        <ul class="nav nav-pills flex-column mb-auto">
          <li>
            <a
              href="/pharmacy_system/system/index.php"
              class="nav-link <?= basename($_SERVER['PHP_SELF']) == 'index.php' ? 'active-link' : '' ?>"
              ><i class="fa-solid fa-gauge"></i> Dashboard</a
            >
          </li>
          <li>
            <a
              href="/pharmacy_system/system/sales.php"
              class="nav-link <?= basename($_SERVER['PHP_SELF']) == 'sales.php' ? 'active-link' : '' ?>"
              ><i class="fa-solid fa-cart-shopping"></i> Sales</a
            >
          </li>
          <li>
            <a
              href="/pharmacy_system/system/products.php"
              class="nav-link <?= basename($_SERVER['PHP_SELF']) == 'products.php' ? 'active-link' : '' ?>"
              ><i class="fa-solid fa-box"></i> Products</a
            >
          </li>
          <li>
            <a
              href="/pharmacy_system/system/update_stock.php"
              class="nav-link <?= basename($_SERVER['PHP_SELF']) == 'update_stock.php' ? 'active-link' : '' ?>"
              ><i class="fa-solid fa-arrow-up-right-from-square"></i> Update Stock</a
            >
          </li>
            <li>
              <a
                href="/pharmacy_system/system/expenditures.php"
                class="nav-link <?= basename($_SERVER['PHP_SELF']) == 'expenditures.php' ? 'active-link' : '' ?>"
                ><i class="fa-solid fa-file-invoice-dollar"></i> Expenditure</a
              >
            </li>
          <?php if ($auth->isAdmin()): ?>
          <li>
            <a
              href="/pharmacy_system/system/view_invoice.php"
              class="nav-link <?= basename($_SERVER['PHP_SELF']) == 'view_invoice.php' ? 'active-link' : '' ?>"
              ><i class="fa-solid fa-receipt"></i>Products On Invoice</a
            >
          </li>
            <li>
              <a
                href="/pharmacy_system/system/admin.php"
                class="nav-link <?= basename($_SERVER['PHP_SELF']) == 'admin.php' ? 'active-link' : '' ?>"
                ><i class="fa-solid fa-user-shield"></i> Admin Role</a
              >
            </li>
            <li>
              <a
                href="/pharmacy_system/system/reports.php"
                class="nav-link <?= basename($_SERVER['PHP_SELF']) == 'reports.php' ? 'active-link' : '' ?>"
                ><i class="fa-solid fa-chart-line"></i> Reports</a
              >
            </li>
          <?php endif; ?>
        </ul>
        <hr class="text-white" />
        <div class="dropdown">
          <a
            href="#"
            class="d-flex align-items-center text-white text-decoration-none dropdown-toggle"
            id="navbarDropdown"
            data-bs-toggle="dropdown"
            aria-expanded="false"
            style="color: inherit;"
          >
            <i class="fa-solid fa-user"></i><div> <p>&nbsp;</p></div>
            <?= htmlspecialchars($_SESSION['full_name'] ?? $_SESSION['username']) ?>
            (<?= ucfirst($_SESSION['role']) ?>)
          </a>          
              <div class="mx-3 my-2 d-grid">
                <a href="../logout.php" class="btn btn-danger">Logout</a>
              </div>
        </div>
      </nav>       
      <div class="content">
        <?php if (isset($_SESSION['message'])): ?>
          <div class="alert alert-info alert-dismissible fade show">
            <?= $_SESSION['message'] ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          </div>
          <?php unset($_SESSION['message']); ?>
        <?php endif; ?>
  <?php else: ?>
  <?php endif; ?>
