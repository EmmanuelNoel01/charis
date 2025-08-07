<?php
require_once '../includes/header.php';
require_once '../includes/db.php';


$dbConn = $db->getConnection();
$user_id = $_SESSION['user_id'] ?? 1;

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['add_expenditure'])) {
    $title = $_POST['title'];
    $description = $_POST['description'];
    $amount = $_POST['amount'];
    $expense_date = $_POST['expense_date'];
    $category = $_POST['category'];

    $stmt = $dbConn->prepare("INSERT INTO expenditures_pharm (user_id, title, description, amount, expense_date, category) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("issdss", $user_id, $title, $description, $amount, $expense_date, $category);
    $stmt->execute();
}

$page = $_GET['page'] ?? 1;
$limit = 10;
$offset = ($page - 1) * $limit;

$filter_category = $_GET['filter_category'] ?? '';
$start_date = $_GET['start_date'] ?? '';
$end_date = $_GET['end_date'] ?? '';

$filter_sql = "WHERE 1=1";
$filter_params = [];

if ($filter_category != '') {
    $filter_sql .= " AND category = ?";
    $filter_params[] = $filter_category;
}
if ($start_date != '') {
    $filter_sql .= " AND expense_date >= ?";
    $filter_params[] = $start_date;
}
if ($end_date != '') {
    $filter_sql .= " AND expense_date <= ?";
    $filter_params[] = $end_date;
}

$count_query = $db->fetchOne("SELECT COUNT(*) as total FROM expenditures_pharm $filter_sql", $filter_params);
$total_result = $count_query['total'];
$total_pages = ceil($total_result / $limit);

$filter_sql .= " ORDER BY expense_date DESC LIMIT ? OFFSET ?";
$filter_params[] = $limit;
$filter_params[] = $offset;

$expenses = $db->fetchAll("SELECT e.*, u.full_name FROM expenditures_pharm e JOIN users_pharm u ON e.user_id = u.id $filter_sql", $filter_params);

$weekly = $db->fetchOne("SELECT SUM(amount) AS total FROM expenditures_pharm WHERE YEARWEEK(expense_date, 1) = YEARWEEK(NOW(), 1)");
$monthly = $db->fetchOne("SELECT SUM(amount) AS total FROM expenditures_pharm WHERE MONTH(expense_date) = MONTH(NOW()) AND YEAR(expense_date) = YEAR(NOW())");
?>

<div class="container-fluid mt-4">
    <div class="alert alert-info d-flex justify-content-between flex-wrap">
        <div><strong>This Week:</strong> UGX <?= number_format($weekly['total'] ?? 0, 2) ?></div>
        <div><strong>This Month:</strong> UGX <?= number_format($monthly['total'] ?? 0, 2) ?></div>
    </div>
    <form method="POST" class="row g-3 mb-4 border rounded p-3 bg-light d-flex flex-wrap">
        <h5 class="w-100">Add New Expenditure</h5>
        <div class="col-md-4">
            <label class="form-label">Title</label>
            <input type="text" name="title" class="form-control" required>
        </div>
        <div class="col-md-4">
            <label class="form-label">Amount (UGX)</label>
            <input type="number" step="1" name="amount" class="form-control" required>
        </div>
        <div class="col-md-4">
            <label class="form-label">Date</label>
            <input type="date" name="expense_date" class="form-control" value="<?= date('Y-m-d') ?>" required>
        </div>
        <div class="col-md-4">
            <label class="form-label">Category</label>
            <select name="category" class="form-select" required>
                <option value="Fuel">Fuel</option>
                <option value="Supplies">Supplies</option>
                <option value="Transport">Transport</option>
                <option value="Salary">Salary</option>
                <option value="Maintenance">Maintenance</option>
                <option value="Other">Other</option>
            </select>
        </div>
        <div class="col-md-8">
            <label class="form-label">Description</label>
            <textarea name="description" class="form-control" rows="2"></textarea>
        </div>
        <div class="col-12 d-flex justify-content-start">
            <button type="submit" name="add_expenditure" class="btn btn-primary">Add Expenditure</button>
        </div>
    </form>

  
    <form method="GET" class="row g-3 mb-3 d-flex flex-wrap">
        <h5 class="w-100">Filter Expenditures</h5>
        <div class="col-md-3">
            <label>Category</label>
            <select name="filter_category" class="form-select">
                <option value="">All</option>
                <?php
                $categories = ['Fuel', 'Supplies', 'Transport', 'Salary', 'Maintenance', 'Other'];
                foreach ($categories as $cat) {
                    echo "<option value='$cat'" . ($filter_category == $cat ? ' selected' : '') . ">$cat</option>";
                }
                ?>
            </select>
        </div>
        <div class="col-md-3">
            <label>Start Date</label>
            <input type="date" name="start_date" class="form-control" value="<?= htmlspecialchars($start_date) ?>">
        </div>
        <div class="col-md-3">
            <label>End Date</label>
            <input type="date" name="end_date" class="form-control" value="<?= htmlspecialchars($end_date) ?>">
        </div>
        <div class="col-md-3 d-flex align-items-end">
            <button class="btn btn-secondary w-100" type="submit">Apply Filter</button>
        </div>
    </form>


    <h5>Expenditure Records</h5>
    <div class="table-responsive">
        <table class="table table-bordered table-hover">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Title</th>
                    <th>Category</th>
                    <th>Amount (UGX)</th>
                    <th>Description</th>
                    <th>Entered By</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($expenses as $exp): ?>
                    <tr>
                        <td><?= htmlspecialchars($exp['expense_date']) ?></td>
                        <td><?= htmlspecialchars($exp['title']) ?></td>
                        <td><?= htmlspecialchars($exp['category']) ?></td>
                        <td><?= number_format($exp['amount'], 2) ?></td>
                        <td><?= htmlspecialchars($exp['description']) ?></td>
                        <td><?= htmlspecialchars($exp['full_name']) ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>


    <nav>
        <ul class="pagination">
            <?php for ($i = 1; $i <= $total_pages; $i++): ?>
                <li class="page-item <?= ($i == $page) ? 'active' : '' ?>">
                    <a class="page-link" href="?page=<?= $i ?>&filter_category=<?= urlencode($filter_category) ?>&start_date=<?= $start_date ?>&end_date=<?= $end_date ?>"><?= $i ?></a>
                </li>
            <?php endfor; ?>
        </ul>
    </nav>
</div>

<?php require_once '../includes/footer.php'; ?>
