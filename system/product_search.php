
<?php
require_once '../includes/db.php'; 
$query = $_GET['query'] ?? '';

if ($query) {
    $stmt = $db->query("
        SELECT id, name, selling_price, quantity 
        FROM products_pharm 
        WHERE name LIKE CONCAT('%', ?, '%') AND quantity > 0
        LIMIT 10
    ", [$query]);

    echo json_encode($stmt);
} else {
    echo json_encode([]);
}
?>
