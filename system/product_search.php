<?php
require_once '../includes/db.php';
header('Content-Type: application/json');

$query = $_GET['query'] ?? '';
// On sales.php the cashier shouldn't see out-of-stock products.
// On update_stock.php (restocking) we DO want to see them.
// Pass ?include_zero=1 from the restocking page.
$include_zero = isset($_GET['include_zero']) && $_GET['include_zero'] === '1';

if ($query) {
    // Available = live products_pharm row + sum of active archived batches.
    // We expose the earliest expiry (FEFO) so the cashier sees what'll sell first.
    $rows = $db->query("
        SELECT
            p.id,
            p.name,
            p.batch_number,
            p.selling_price,
            p.unit_type,
            (p.quantity + COALESCE((
                SELECT SUM(b.quantity)
                FROM product_batches_pharm b
                WHERE b.product_id = p.id AND b.is_active = 1 AND b.quantity > 0
            ), 0)) AS quantity,
            LEAST(
                IFNULL(p.expiry_date, '9999-12-31'),
                IFNULL((
                    SELECT MIN(b.expiry_date)
                    FROM product_batches_pharm b
                    WHERE b.product_id = p.id AND b.is_active = 1 AND b.quantity > 0
                ), '9999-12-31')
            ) AS expiry_date
        FROM products_pharm p
        WHERE p.name LIKE CONCAT('%', ?, '%')
        " . ($include_zero ? "" : "HAVING quantity > 0") . "
        ORDER BY p.name ASC, expiry_date ASC
        LIMIT 25
    ", [$query]);

    echo json_encode($rows);
} else {
    echo json_encode([]);
}