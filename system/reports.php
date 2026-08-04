<?php
require_once '../includes/header.php';
require_once '../includes/auth.php';
require_once '../includes/functions.php';
requireAdmin();

if (isset($_GET['download'])) {
    $report_type = $_GET['download'];
    $start_date = $_GET['start_date'] ?? date('Y-m-01');
    $end_date = $_GET['end_date'] ?? date('Y-m-t');
    
    if ($report_type === 'sales') {
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="sales_report_'.$start_date.'_to_'.$end_date.'.csv"');
        $output = fopen('php://output', 'w');
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
            $margin = $row['total_sales'] > 0 ? ($row['total_profit']/$row['total_sales'])*100 : 0;
            fputcsv($output, [
                $row['sale_date'], $row['username'], $row['num_sales'],
                number_format($row['total_sales'],2), number_format($row['total_cost'],2),
                number_format($row['total_profit'],2), number_format($margin,2).'%'
            ]);
        }
        fclose($output);
        exit();
    } elseif ($report_type === 'products') {
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="product_report_'.$start_date.'_to_'.$end_date.'.csv"');
        $output = fopen('php://output', 'w');
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
            $margin = $row['total_sales'] > 0 ? ($row['total_profit']/$row['total_sales'])*100 : 0;
            fputcsv($output, [
                $row['name'], $row['total_quantity'],
                number_format($row['total_sales'],2), number_format($row['total_cost'],2),
                number_format($row['total_profit'],2), number_format($margin,2).'%'
            ]);
        }
        fclose($output);
        exit();
    }
}

$start_date = $_GET['start_date'] ?? date('Y-m-01');
$end_date = $_GET['end_date'] ?? date('Y-m-t');

$sales_report = $db->query("
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

$product_report = $db->query("
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

$expiry_report = $db->query("
    SELECT name, batch_number, quantity, expiry_date
    FROM products_pharm
    WHERE expiry_date BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 60 DAY)
    ORDER BY expiry_date ASC
");

$low_stock_report = $db->query("
    SELECT name, batch_number, quantity, minimum_stock_level
    FROM products_pharm
    WHERE quantity <= minimum_stock_level
    ORDER BY quantity ASC
");
?>

<div class="card mb-4">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5>Reports</h5>
        <div class="btn-group">
<a href="download_report.php?download=sales&start_date=<?= $start_date ?>&end_date=<?= $end_date ?>" class="btn btn-success">
    <i class="fas fa-download"></i> Download Sales Report
</a>
<a href="download_report.php?download=products&start_date=<?= $start_date ?>&end_date=<?= $end_date ?>" class="btn btn-success ms-2">
    <i class="fas fa-download"></i> Download Product Report
</a>

        </div>
    </div>
    <div class="card-body">
        <form class="row mb-4">
            <div class="col-md-4">
                <label class="form-label">Start Date</label>
                <input type="date" class="form-control" name="start_date" value="<?= $start_date ?>">
            </div>
            <div class="col-md-4">
                <label class="form-label">End Date</label>
                <input type="date" class="form-control" name="end_date" value="<?= $end_date ?>">
            </div>
            <div class="col-md-4 d-flex align-items-end">
                <button type="submit" class="btn btn-primary">Filter</button>
                <a href="reports.php" class="btn btn-secondary ms-2">Reset</a>
            </div>
        </form>
        
        <ul class="nav nav-tabs" id="reportTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="sales-tab" data-bs-toggle="tab" data-bs-target="#sales" type="button" role="tab">Sales Report</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="products-tab" data-bs-toggle="tab" data-bs-target="#products" type="button" role="tab">Product Sales</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="expiry-tab" data-bs-toggle="tab" data-bs-target="#expiry" type="button" role="tab">Expiry Report</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="stock-tab" data-bs-toggle="tab" data-bs-target="#stock" type="button" role="tab">Low Stock</button>
            </li>
        </ul>
        
        <div class="tab-content p-3 border border-top-0 rounded-bottom">
            <div class="tab-pane fade show active" id="sales" role="tabpanel" aria-labelledby="sales-tab">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Pharmacist</th>
                                <th>Sales Count</th>
                                <th>Total Sales</th>
                                <th>Total Cost</th>
                                <th>Profit</th>
                                <th>Margin</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($sales_report as $report): 
                                $margin = $report['total_sales'] > 0 ? ($report['total_profit']/$report['total_sales'])*100 : 0;
                                $profit_class = $report['total_profit'] >= 0 ? 'text-success' : 'text-danger';
                            ?>
                            <tr>
                                <td><?= date('d/m/Y', strtotime($report['sale_date'])) ?></td>
                                <td><?= $report['username'] ?></td>
                                <td><?= $report['num_sales'] ?></td>
                                <td><?= number_format($report['total_sales'],2) ?></td>
                                <td><?= number_format($report['total_cost'],2) ?></td>
                                <td class="<?= $profit_class ?>"><?= number_format($report['total_profit'],2) ?></td>
                                <td class="<?= $profit_class ?>"><?= number_format($margin,2) ?>%</td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <div class="tab-pane fade" id="products" role="tabpanel" aria-labelledby="products-tab">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Quantity</th>
                                <th>Total Sales</th>
                                <th>Total Cost</th>
                                <th>Profit</th>
                                <th>Margin</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($product_report as $report): 
                                $margin = $report['total_sales'] > 0 ? ($report['total_profit']/$report['total_sales'])*100 : 0;
                                $profit_class = $report['total_profit'] >= 0 ? 'text-success' : 'text-danger';
                            ?>
                            <tr>
                                <td><?= $report['name'] ?></td>
                                <td><?= $report['total_quantity'] ?></td>
                                <td><?= number_format($report['total_sales'],2) ?></td>
                                <td><?= number_format($report['total_cost'],2) ?></td>
                                <td class="<?= $profit_class ?>"><?= number_format($report['total_profit'],2) ?></td>
                                <td class="<?= $profit_class ?>"><?= number_format($margin,2) ?>%</td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <div class="tab-pane fade" id="expiry" role="tabpanel" aria-labelledby="expiry-tab">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Batch</th>
                                <th>Quantity</th>
                                <th>Expiry Date</th>
                                <th>Days Left</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($expiry_report as $product): ?>
                            <tr>
                                <td><?= $product['name'] ?></td>
                                <td><?= $product['batch_number'] ?></td>
                                <td><?= $product['quantity'] ?></td>
                                <td><?= date('d/m/Y', strtotime($product['expiry_date'])) ?></td>
                                <td><?= days_remaining($product['expiry_date']) ?></td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <div class="tab-pane fade" id="stock" role="tabpanel" aria-labelledby="stock-tab">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Batch</th>
                                <th>Current Stock</th>
                                <th>Minimum Level</th>
                                <th>Difference</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($low_stock_report as $product): ?>
                            <tr>
                                <td><?= $product['name'] ?></td>
                                <td><?= $product['batch_number'] ?></td>
                                <td><?= $product['quantity'] ?></td>
                                <td><?= $product['minimum_stock_level'] ?></td>
                                <td><?= $product['quantity'] - $product['minimum_stock_level'] ?></td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<?php include '../includes/footer.php'; ?>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

