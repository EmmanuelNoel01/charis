<?php
require_once '../includes/auth.php';
require_once '../includes/functions.php';
require_once '../includes/db.php';

if (!isset($_GET['download'])) {
    http_response_code(400);
    exit('Missing download type.');
}

$report_type = $_GET['download'];
$start_date = $_GET['start_date'] ?? date('Y-m-01');
$end_date = $_GET['end_date'] ?? date('Y-m-t');

if (ob_get_level()) {
    ob_end_clean();
}
header('Content-Type: text/csv');
header('Content-Disposition: attachment; filename="' . $report_type . '_report_' . $start_date . '_to_' . $end_date . '.csv"');
header('Pragma: no-cache');
header('Expires: 0');

$output = fopen('php://output', 'w');

if ($report_type === 'sales') {
    fputcsv($output, ['Date', 'Pharmacist', 'Sales Count', 'Total Sales', 'Total Cost', 'Profit', 'Margin']);
    $report = $db->query("
        SELECT DATE(s.date) as sale_date, COUNT(*) as num_sales, 
               SUM(si.total) as total_sales, SUM(si.quantity*p.buying_price) as total_cost,
               SUM(si.total-(si.quantity*p.buying_price)) as total_profit, u.username
        FROM sales_pharm s
        JOIN sale_items_pharm si ON s.id=si.sale_id
        JOIN products_pharm p ON si.product_id=p.id
        JOIN users_pharm u ON s.user_id=u.id
        WHERE DATE(s.date) BETWEEN ? AND ?
        GROUP BY DATE(s.date), u.username
        ORDER BY sale_date DESC
    ", [$start_date, $end_date]);

    foreach ($report as $row) {
        $margin = $row['total_sales'] > 0 ? ($row['total_profit'] / $row['total_sales']) * 100 : 0;
        fputcsv($output, [
            $row['sale_date'],
            $row['username'],
            $row['num_sales'],
            number_format($row['total_sales'], 2),
            number_format($row['total_cost'], 2),
            number_format($row['total_profit'], 2),
            number_format($margin, 2) . '%'
        ]);
    }

} elseif ($report_type === 'products') {
    fputcsv($output, ['Product', 'Quantity', 'Total Sales', 'Total Cost', 'Profit', 'Margin']);
    $report = $db->query("
        SELECT p.name, SUM(si.quantity) as total_quantity, SUM(si.total) as total_sales,
               SUM(si.quantity*p.buying_price) as total_cost,
               SUM(si.total-(si.quantity*p.buying_price)) as total_profit
        FROM sale_items_pharm si
        JOIN products_pharm p ON si.product_id=p.id
        JOIN sales_pharm s ON si.sale_id=s.id
        WHERE DATE(s.date) BETWEEN ? AND ?
        GROUP BY p.name
        ORDER BY total_profit DESC
    ", [$start_date, $end_date]);

    foreach ($report as $row) {
        $margin = $row['total_sales'] > 0 ? ($row['total_profit'] / $row['total_sales']) * 100 : 0;
        fputcsv($output, [
            $row['name'],
            $row['total_quantity'],
            number_format($row['total_sales'], 2),
            number_format($row['total_cost'], 2),
            number_format($row['total_profit'], 2),
            number_format($margin, 2) . '%'
        ]);
    }

} else {
    http_response_code(400);
    exit('Invalid report type.');
}

fclose($output);
exit();
