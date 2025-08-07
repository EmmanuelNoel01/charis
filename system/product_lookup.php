<?php
require_once '../includes/db.php';
require_once '../classes/Pharmacy.php';

header('Content-Type: application/json');

if (!isset($_GET['query'])) {
    echo json_encode([]);
    exit;
}

$query = trim($_GET['query']);
if (strlen($query) < 2) {
    echo json_encode([]);
    exit;
}

$pharmacy = new Pharmacy($db);
$results = $db->fetchAll("SELECT id, name FROM products_pharm WHERE name LIKE ? LIMIT 10", ["%$query%"]);

echo json_encode($results);
