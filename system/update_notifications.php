<?php
require_once 'includes/database.php'; // Your database connection
require_once 'classes/Pharmacy.php'; // Your Pharmacy class

function generateDrugNotifications($db) {
    // Clear old notifications (older than 7 days)
    $db->execute("DELETE FROM drug_notifications WHERE created_at < DATE_SUB(NOW(), INTERVAL 7 DAY)");
    
    // Expiring drugs notifications
    $expiring_drugs = $db->query("
        SELECT name, batch_number, expiry_date, 
               DATEDIFF(expiry_date, CURDATE()) as days_until_expiry
        FROM products_pharm 
        WHERE expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
        AND quantity > 0
    ");
    
    foreach ($expiring_drugs as $drug) {
        $days_left = $drug['days_until_expiry'];
        $priority = $days_left <= 7 ? 'high' : ($days_left <= 15 ? 'medium' : 'low');
        
        // Check if notification already exists for this drug
        $existing = $db->query("
            SELECT id FROM drug_notifications 
            WHERE drug_name = ? AND batch_number = ? AND notification_type = 'expiry' AND is_read = FALSE
        ", [$drug['name'], $drug['batch_number']]);
        
        if (empty($existing)) {
            $db->execute("
                INSERT INTO drug_notifications (title, message, drug_name, batch_number, expiry_date, days_left, notification_type, priority)
                VALUES (?, ?, ?, ?, ?, ?, 'expiry', ?)
            ", [
                "Drug Expiring in {$days_left} days",
                "{$drug['name']} (Batch: {$drug['batch_number']}) will expire on " . date('d/m/Y', strtotime($drug['expiry_date'])),
                $drug['name'],
                $drug['batch_number'],
                $drug['expiry_date'],
                $days_left,
                $priority
            ]);
        }
    }
    
    // Low stock notifications
    $low_stock_drugs = $db->query("
        SELECT name, batch_number, quantity, minimum_stock_level
        FROM products_pharm 
        WHERE quantity > 0 AND quantity <= minimum_stock_level
    ");
    
    foreach ($low_stock_drugs as $drug) {
        $stock_percentage = round(($drug['quantity'] / $drug['minimum_stock_level']) * 100);
        $priority = $stock_percentage <= 10 ? 'high' : ($stock_percentage <= 30 ? 'medium' : 'low');
        
        // Check if notification already exists
        $existing = $db->query("
            SELECT id FROM drug_notifications 
            WHERE drug_name = ? AND batch_number = ? AND notification_type = 'low_stock' AND is_read = FALSE
        ", [$drug['name'], $drug['batch_number']]);
        
        if (empty($existing)) {
            $db->execute("
                INSERT INTO drug_notifications (title, message, drug_name, batch_number, current_stock, minimum_required, notification_type, priority)
                VALUES (?, ?, ?, ?, ?, ?, 'low_stock', ?)
            ", [
                "Low Stock Alert - {$stock_percentage}%",
                "{$drug['name']} (Batch: {$drug['batch_number']}) has only {$drug['quantity']} units left",
                $drug['name'],
                $drug['batch_number'],
                $drug['quantity'],
                $drug['minimum_stock_level'],
                $priority
            ]);
        }
    }
    
    return ['expiring' => count($expiring_drugs), 'low_stock' => count($low_stock_drugs)];
}

// Generate notifications
$result = generateDrugNotifications($db);
echo "Notifications updated: " . ($result['expiring'] + $result['low_stock']) . " total alerts";
?>