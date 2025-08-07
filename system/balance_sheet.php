<?php
require_once '../includes/header.php';
require_once '../includes/db.php';
requireAdmin();

$start_date = $_GET['start_date'] ?? '';
$end_date = $_GET['end_date'] ?? '';

if ($start_date == '' || $end_date == '') {
    $start_date = date('Y-m-01');
    $end_date = date('Y-m-t');
}

$income_sql = "SELECT SUM(total_amount) AS total_income FROM sales_pharm WHERE DATE(date) BETWEEN ? AND ?";
$income_data = $db->fetchOne($income_sql, [$start_date, $end_date]);
$total_income = $income_data['total_income'] ?? 0;

$expense_sql = "SELECT SUM(amount) AS total_expense FROM expenditures_pharm WHERE expense_date BETWEEN ? AND ?";
$expense_data = $db->fetchOne($expense_sql, [$start_date, $end_date]);
$total_expense = $expense_data['total_expense'] ?? 0;

$net_balance = $total_income - $total_expense;
?>

<div class="container mt-4">
    <h2>Balance Sheet</h2>

    <form method="GET" class="row g-3 mb-4">
        <div class="col-md-4">
            <label>Start Date</label>
            <input type="date" name="start_date" class="form-control" value="<?= $start_date ?>">
        </div>
        <div class="col-md-4">
            <label>End Date</label>
            <input type="date" name="end_date" class="form-control" value="<?= $end_date ?>">
        </div>
        <div class="col-md-4 d-flex align-items-end">
            <button class="btn btn-primary" type="submit">Filter</button>
        </div>
    </form>

    <div class="card border-success mb-3">
        <div class="card-header bg-success text-white">Summary for <?= $start_date ?> to <?= $end_date ?></div>
        <div class="card-body">
            <h5 class="card-title">Income: <span class="text-success">UGX <?= number_format($total_income, 2) ?></span></h5>
            <h5 class="card-title">Expenditure: <span class="text-danger">UGX <?= number_format($total_expense, 2) ?></span></h5>
            <h5 class="card-title">Net Balance: 
                <span class="<?= $net_balance >= 0 ? 'text-success' : 'text-danger' ?>">
                    UGX <?= number_format($net_balance, 2) ?>
                </span>
            </h5>
        </div>
    </div>

    <div class="row mt-4">
        <div class="col-md-6">
            <h5>Income Breakdown</h5>
            <table class="table table-bordered">
                <thead>
                    <tr><th>Date</th><th>Customer</th><th>Amount</th></tr>
                </thead>
                <tbody>
                <?php
                $sales = $db->fetchAll("SELECT date, customer_name, total_amount FROM sales_pharm WHERE DATE(date) BETWEEN ? AND ? ORDER BY date DESC", [$start_date, $end_date]);
                foreach ($sales as $s):
                ?>
                    <tr>
                        <td><?= substr($s['date'], 0, 10) ?></td>
                        <td><?= htmlspecialchars($s['customer_name'] ?? 'N/A') ?></td>
                        <td>UGX <?= number_format($s['total_amount'], 2) ?></td>
                    </tr>
                <?php endforeach; ?>
                </tbody>
            </table>
        </div>

        <div class="col-md-6">
            <h5>Expenditure Breakdown</h5>
            <table class="table table-bordered">
                <thead>
                    <tr><th>Date</th><th>Title</th><th>Amount</th></tr>
                </thead>
                <tbody>
                <?php
                $expenses = $db->fetchAll("SELECT expense_date, title, amount FROM expenditures_pharm WHERE expense_date BETWEEN ? AND ? ORDER BY expense_date DESC", [$start_date, $end_date]);
                foreach ($expenses as $e):
                ?>
                    <tr>
                        <td><?= $e['expense_date'] ?></td>
                        <td><?= htmlspecialchars($e['title']) ?></td>
                        <td>UGX <?= number_format($e['amount'], 2) ?></td>
                    </tr>
                <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<?php require_once '../includes/footer.php'; ?>
