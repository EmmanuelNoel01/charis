<?php
require_once '../includes/header.php';
require_once '../includes/functions.php';
require_once '../includes/auth.php';
require_once '../classes/Pharmacy.php';

checkExpiringProducts($db);
checkLowStockProducts($db);

$notifications = $db->query("
    SELECT * FROM notifications_pharm 
    WHERE user_id = ? OR user_id = 0 
    ORDER BY created_at DESC 
    LIMIT 5
", [$_SESSION['user_id']]);

$recent_sales = $db->query("
    SELECT * FROM sales_pharm 
    ORDER BY date DESC 
    LIMIT 5
");

$product_count = $db->query("SELECT COUNT(*) as count FROM products_pharm")[0]['count'];
$today_sales = $db->query("SELECT SUM(total_amount) as total FROM sales_pharm WHERE DATE(date) = CURDATE()")[0]['total'] ?? 0;
$low_stock = $db->query("SELECT COUNT(*) as count FROM products_pharm WHERE quantity <= minimum_stock_level")[0]['count'];
$expiring = $db->query("SELECT COUNT(*) as count FROM products_pharm WHERE expiry_date BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 30 DAY)")[0]['count'];

$pharmacy = new Pharmacy($db);
// Call this function periodically (maybe in a cron job or when accessing dashboard)


// Then fetch notifications for display
$notifications = $db->query("
    SELECT * FROM drug_notifications 
    WHERE is_read = FALSE 
    ORDER BY 
        FIELD(priority, 'high', 'medium', 'low'),
        created_at DESC
    LIMIT 20
");



// Get notifications for the dashboard
$expiring_notifications = $pharmacy->getExpiringDrugsNotifications($db, 30);
$low_stock_notifications = $pharmacy->getLowStockNotifications($db);

// Combine all notifications
$all_notifications = array_merge($expiring_notifications, $low_stock_notifications);

// Sort notifications by priority (high first)
usort($all_notifications, function ($a, $b) {
    $priority_order = ['high' => 3, 'medium' => 2, 'low' => 1];
    return $priority_order[$b['priority']] - $priority_order[$a['priority']];
});

// Generate notifications (with check to avoid running too frequently)
$lastNotificationUpdate = $_SESSION['last_notification_update'] ?? 0;
if (time() - $lastNotificationUpdate > 300) { // Update every 5 minutes
    $pharmacy->generateDrugNotifications();
    $_SESSION['last_notification_update'] = time();
}

// Get unread notifications
$notifications = $db->query("
    SELECT * FROM drug_notifications 
    WHERE is_read = FALSE 
    ORDER BY 
        FIELD(priority, 'high', 'medium', 'low'),
        created_at DESC
    LIMIT 10
");

// Count by priority
$high_priority = $db->query("SELECT COUNT(*) as count FROM drug_notifications WHERE is_read = FALSE AND priority = 'high'")[0]['count'];
$medium_priority = $db->query("SELECT COUNT(*) as count FROM drug_notifications WHERE is_read = FALSE AND priority = 'medium'")[0]['count'];
$low_priority = $db->query("SELECT COUNT(*) as count FROM drug_notifications WHERE is_read = FALSE AND priority = 'low'")[0]['count'];
?>

<div id="loading-wrapper">
    <div class='spin-wrapper'>
        <div class='spin'>
            <div class='inner'></div>
        </div>
        <div class='spin'>
            <div class='inner'></div>
        </div>
        <div class='spin'>
            <div class='inner'></div>
        </div>
        <div class='spin'>
            <div class='inner'></div>
        </div>
        <div class='spin'>
            <div class='inner'></div>
        </div>
        <div class='spin'>
            <div class='inner'></div>
        </div>
    </div>
</div>

<div class="app-body">

    <div class="row gx-3">
        <div class="col-xxl-12 col-sm-12">
            <div class="card mb-3 bg-2">
                <div class="card-body">
                    <div class="py-4 px-3 text-white">
                        <h6 id="greeting"></h6>
                        <h2>
                            <?= htmlspecialchars($_SESSION['full_name'] ?? $_SESSION['username']) ?>
                        </h2>
                        <h5>This is Our Inventory Summary</h5>
                        <div class="mt-4 d-flex gap-3">
                            <div class="d-flex align-items-center">
                                <div class="icon-box lg bg-arctic rounded-3 me-3">
                                    <i class="ri-surgical-mask-line fs-4"></i>
                                </div>
                                <div class="d-flex flex-column">
                                    <h2 class="m-0 lh-1"><?= $product_count ?></h2>
                                    <p class="m-0">Total Products</p>
                                </div>
                            </div>
                            <div class="d-flex align-items-center">
                                <div class="icon-box lg bg-lime rounded-3 me-3">
                                    <i class="ri-store-3-line fs-4"></i>
                                </div>
                                <div class="d-flex flex-column">
                                    <h2 class="m-0 lh-1"><?= $low_stock ?></h2>
                                    <p class="m-0">Low Stock</p>
                                </div>
                            </div>
                            <div class="d-flex align-items-center">
                                <div class="icon-box lg bg-peach rounded-3 me-3">
                                    <i class="ri-walk-line fs-4"></i>
                                </div>
                                <div class="d-flex flex-column">
                                    <h2 class="m-0 lh-1"><?= $expiring ?></h2>
                                    <p class="m-0">Expiring Soon</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row gx-3">
        <div class="col-xl-3 col-sm-6 col-12">
            <div class="card mb-3">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="p-2 border border-primary rounded-circle me-3">
                            <div class="icon-box md bg-primary-subtle rounded-5">
                                <i class="ri-clipboard-line fs-4 text-primary"></i>
                            </div>
                        </div>
                        <div class="d-flex flex-column">
                            <p class="m-0">Balance Sheet</p>
                        </div>
                    </div>
                    <div class="d-flex align-items-end justify-content-between mt-1">
                        <a class="text-primary" href="/pharmacy_system/system/balance_sheet.php">
                            <span>View</span>
                            <i class="ri-arrow-right-line ms-1"></i>
                        </a>
                        <div class="text-end">
                            <p class="mb-0 text-primary">
                            <div></div>
                            </p>
                            <span class="badge bg-primary-subtle text-primary small">
                                <div></div>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-sm-6 col-12">
            <div class="card mb-3">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="p-2 border border-warning rounded-circle me-3">
                            <div class="icon-box md bg-warning-subtle rounded-5">
                                <i class="ri-money-dollar-circle-line fs-4 text-warning"></i>
                            </div>
                        </div>
                        <div class="d-flex flex-column">
                            <!-- <h2 class="lh-1">UGX. <?= number_format($today_sales) ?></h2> -->
                            <p class="m-0">Today's Sales</p>
                        </div>
                    </div>
                    <div class="d-flex align-items-end justify-content-between mt-1">
                        <a class="text-warning" href="/pharmacy_system/system/sales.php">
                            <span>View All</span>
                            <i class="ri-arrow-right-line ms-1"></i>
                        </a>
                        <div class="text-end">
                            <p class="mb-0 text-warning">
                            <div> </div>
                            </p>
                            <span class="badge bg-warning-subtle text-warning small">
                                <div> </div>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6">
            <div class="card mb-4">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0">Recent Sales</h5>
                </div>
                <div class="card-body">
                    <?php if (count($recent_sales)): ?>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>Invoice </th>
                                        <th>Date</th>
                                            <th>Amount</th>
                                            <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($recent_sales as $sale): ?>
                                        <tr>
                                            <td><?= htmlspecialchars($sale['invoice_number']) ?></td>
                                            <td><?= date('d/m/Y H:i', strtotime($sale['date'])) ?></td>

                                                <td><?= number_format($sale['total_amount']) ?></td>
                                                <td>
                                                    <a href="closed_invoice.php?id=<?= $sale['id'] ?>"
                                                        class="btn btn-sm btn-outline-info">View</a>
                                                </td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>
                    <?php else: ?>
                        <p class="text-muted">No recent sales available.</p>
                    <?php endif; ?>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card mb-4">
                <div class="card-header bg-secondary text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Drug Alerts</h5>
                    <?php if (count($notifications) > 0): ?>
                        <span class="badge bg-danger"><?= count($notifications) ?></span>
                    <?php endif; ?>
                </div>
                <div class="card-body p-0">
                    <?php if (count($notifications)): ?>
                        <div class="list-group list-group-flush">
                            <?php foreach ($notifications as $notification): ?>
                                <div class="list-group-item <?=
                                    $notification['priority'] === 'high' ? 'list-group-item-danger' :
                                    ($notification['priority'] === 'medium' ? 'list-group-item-warning' : 'list-group-item-info')
                                    ?>">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="flex-grow-1">
                                            <h6 class="mb-1">
                                                <?php if ($notification['priority'] === 'high'): ?>
                                                    <i class="fas fa-exclamation-triangle text-danger"></i>
                                                <?php elseif ($notification['priority'] === 'medium'): ?>
                                                    <i class="fas fa-exclamation-circle text-warning"></i>
                                                <?php else: ?>
                                                    <i class="fas fa-info-circle text-info"></i>
                                                <?php endif; ?>
                                                <?= htmlspecialchars($notification['title']) ?>
                                            </h6>
                                            <p class="mb-1 small"><?= htmlspecialchars($notification['message']) ?></p>

                                            <?php if ($notification['notification_type'] === 'expiry' && $notification['days_left']): ?>
                                                <div class="mt-2">
                                                    <small class="text-muted">
                                                        <strong>Days until expiry:</strong>
                                                        <span
                                                            class="<?= $notification['days_left'] <= 7 ? 'text-danger fw-bold' : 'text-warning' ?>">
                                                            <?= $notification['days_left'] ?> days
                                                        </span>
                                                    </small>
                                                </div>
                                            <?php endif; ?>

                                            <?php if ($notification['notification_type'] === 'low_stock' && $notification['current_stock']): ?>
                                                <div class="mt-2">
                                                    <small class="text-muted">
                                                        <strong>Stock level:</strong>
                                                        <span
                                                            class="<?= $notification['current_stock'] <= ($notification['minimum_required'] * 0.1) ? 'text-danger fw-bold' : 'text-warning' ?>">
                                                            <?= $notification['current_stock'] ?>/<?= $notification['minimum_required'] ?>
                                                        </span>
                                                    </small>
                                                </div>
                                            <?php endif; ?>
                                        </div>
                                        <div class="ms-2">
                                            <a href="products.php?tab=<?= $notification['notification_type'] === 'expiry' ? 'expiring' : 'low' ?>"
                                                class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <button class="btn btn-sm btn-outline-secondary mark-read"
                                                data-id="<?= $notification['id'] ?>">
                                                <i class="fas fa-check"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    <?php else: ?>
                        <div class="text-center p-4">
                            <i class="fas fa-check-circle text-success fa-2x mb-2"></i>
                            <p class="text-muted mb-0">All drugs are properly stocked</p>
                            <p class="text-muted small">No expiring or low stock alerts</p>
                        </div>
                    <?php endif; ?>
                </div>
                <?php if (count($notifications) > 0): ?>
                    <div class="card-footer bg-light">
                        <div class="row text-center">
                            <div class="col-4">
                                <span class="badge bg-danger"><?= $high_priority ?></span>
                                <small class="text-muted d-block">Critical</small>
                            </div>
                            <div class="col-4">
                                <span class="badge bg-warning"><?= $medium_priority ?></span>
                                <small class="text-muted d-block">Warning</small>
                            </div>
                            <div class="col-4">
                                <span class="badge bg-info"><?= $low_priority ?></span>
                                <small class="text-muted d-block">Info</small>
                            </div>
                        </div>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>
</div>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="Marketplace for Bootstrap Admin Dashboards">
<meta property="og:title" content="Admin Templates - Dashboard Templates">
<meta property="og:description" content="Marketplace for Bootstrap Admin Dashboards">
<meta property="og:type" content="Website">
<link rel="shortcut icon" href="assets/images/favicon.svg">

<link rel="stylesheet" href="assets/fonts/remix/remixicon.css">
<link rel="stylesheet" href="assets/css/main.min.css">

<link rel="stylesheet" href="assets/vendor/overlay-scroll/OverlayScrollbars.min.css">
<script>
    document.addEventListener("DOMContentLoaded", function () {
        setTimeout(function () {
            const loader = document.getElementById('loading-wrapper');
            if (loader) {
                loader.classList.add('hide');
                setTimeout(() => loader.style.display = 'none', 500);
            }
        }, 1000);

    });

    document.addEventListener("DOMContentLoaded", function () {
        const greetingElement = document.getElementById("greeting");
        const now = new Date();
        const hour = now.getHours();

        let greeting;

        if (hour >= 0 && hour < 12) {
            greeting = "Good Morning";
        } else if (hour >= 12 && hour < 17) {
            greeting = "Good Afternoon";
        } else {
            greeting = "Good Evening";
        }
        greetingElement.textContent = greeting + ",";
    });
</script>
<style>
    #loading-wrapper {
        opacity: 1;
        transition: opacity 0.5s ease;
    }

    #loading-wrapper.hide {
        opacity: 0;
        pointer-events: none;
    }
</style>

<script>
    // Add JavaScript to mark notifications as read
    document.querySelectorAll('.mark-read').forEach(button => {
        button.addEventListener('click', function () {
            const notificationId = this.getAttribute('data-id');
            fetch('mark_notification_read.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'id=' + notificationId
            }).then(response => {
                if (response.ok) {
                    this.closest('.list-group-item').remove();
                }
            });
        });
    });
</script>