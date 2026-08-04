<?php
require_once '../includes/auth.php';
requireLogin();
header('Content-Type: application/json');

$query = trim($_GET['query'] ?? '');

if ($query === '' || strlen($query) < 1) {
    echo json_encode([]);
    exit;
}

$rows = $db->fetchAll(
    "SELECT id, name, contact, address
     FROM customers_pharm
     WHERE name LIKE CONCAT('%', ?, '%') OR contact LIKE CONCAT('%', ?, '%')
     ORDER BY name ASC
     LIMIT 10",
    [$query, $query]
);

echo json_encode($rows);
