<?php
function generateInvoiceNumber() {
    return 'INV-' . date('Ymd') . '-' . strtoupper(substr(uniqid(), -6));
}

function days_remaining($expiry_date) {
    $now = new DateTime();
    $expiry = new DateTime($expiry_date);
    $interval = $now->diff($expiry);
    return $interval->format('%r%a');
}

function time_elapsed_string($datetime, $full = false) {
    $now = new DateTime;
    $ago = new DateTime($datetime);
    $diff = $now->diff($ago);

    $string = array(
        'y' => 'year',
        'm' => 'month',
        'd' => 'day',
        'h' => 'hour',
        'i' => 'minute',
        's' => 'second',
    );
    
    foreach ($string as $k => &$v) {
        if ($diff->$k) {
            $v = $diff->$k . ' ' . $v . ($diff->$k > 1 ? 's' : '');
        } else {
            unset($string[$k]);
        }
    }

    if (!$full) $string = array_slice($string, 0, 1);
    return $string ? implode(', ', $string) . ' ago' : 'just now';
}

function checkExpiringProducts($db) {
    $threshold_date = date('Y-m-d', strtotime('+30 days'));
    $expiring_products = $db->query("
        SELECT * FROM products_pharm 
        WHERE expiry_date BETWEEN NOW() AND ?
        AND quantity > 0
    ", [$threshold_date]);
    
    foreach ($expiring_products as $product) {
        $exists = $db->query("
            SELECT COUNT(*) FROM notifications_pharm 
            WHERE type = 'expiry' 
            AND related_id = ? 
            AND is_read = 0
        ", [$product['id']]);
        
        if (!$exists[0]['COUNT(*)']) {
            $notification = [
                'user_id' => 1, 
                'title' => 'Product Expiring Soon',
                'message' => $product['name'] . ' (Batch: ' . $product['batch_number'] . ') expires on ' . $product['expiry_date'],
                'type' => 'expiry',
                'related_id' => $product['id'],
                'created_at' => date('Y-m-d H:i:s')
            ];
            $db->insert('notifications_pharm', $notification);
        }
    }
}

function checkLowStockProducts($db) {
    $low_stock_products = $db->query("
        SELECT * FROM products_pharm 
        WHERE quantity <= minimum_stock_level
        AND quantity > 0
    ");
    
    foreach ($low_stock_products as $product) {
        $exists = $db->query("
            SELECT COUNT(*) FROM notifications_pharm 
            WHERE type = 'low_stock' 
            AND related_id = ? 
            AND is_read = 0
        ", [$product['id']]);
        
        if (!$exists[0]['COUNT(*)']) {
            $notification = [
                'user_id' => 1, // Admin
                'title' => 'Low Stock Alert',
                'message' => $product['name'] . ' is running low. Current stock: ' . $product['quantity'],
                'type' => 'low_stock',
                'related_id' => $product['id'],
                'created_at' => date('Y-m-d H:i:s')
            ];
            $db->insert('notifications_pharm', $notification);
        }
    }
}

function sendNotification($db, $user_id, $title, $message, $type, $related_id = null) {
    $notification = [
        'user_id' => $user_id,
        'title' => $title,
        'message' => $message,
        'type' => $type,
        'related_id' => $related_id,
        'created_at' => date('Y-m-d H:i:s')
    ];
    return $db->insert('notifications_pharm', $notification);
}
// function requireAdmin() {
//     if (session_status() === PHP_SESSION_NONE) {
//         session_start();
//     }
    
//     if (!isset($_SESSION['user']) || $_SESSION['user']['role'] !== 'admin') {
//         header('Location: ../login.php');
//         exit();
//     }
// }
?>
