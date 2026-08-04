<?php
require_once __DIR__ . '/../includes/db.php';

class Pharmacy
{
    private $db;

    public function __construct($db)
    {
        $this->db = $db;
    }

    // Product Management

    public function addProduct($data)
    {
        return $this->db->insert('products_pharm', [
            'name' => $data['name'],
            'description' => $data['description'],
            'batch_number' => $data['batch_number'],
            'quantity' => $data['quantity'],
            'buying_price' => $data['buying_price'],
            'selling_price' => $data['selling_price'],
            'expiry_date' => $data['expiry_date'],
            'minimum_stock_level' => $data['minimum_stock_level'],
            'barcode' => $data['barcode'],
            'unit_type' => $data['unit_type']
        ]);
    }



    public function updateProduct($id, $data)
    {
        $sql = 'UPDATE products_pharm SET name = ?, description = ?, batch_number = ?, quantity = ?, buying_price = ?, selling_price = ?, expiry_date = ?, minimum_stock_level = ?, barcode = ?, unit_type = ?
            WHERE id = ?';
        $this->db->execute($sql, [
            $data['name'],
            $data['description'],
            $data['batch_number'],
            $data['quantity'],
            $data['buying_price'],
            $data['selling_price'],
            $data['expiry_date'],
            $data['minimum_stock_level'],
            $data['barcode'],
            $data['unit_type'],
            $id
        ]);
    }

    public function getProduct($id)
    {
        return $this->db->getById('products', $id);
    }

    public function getProducts($search = '', $limit = 10, $offset = 0)
    {
        $where = '';
        $params = [];

        if (!empty($search)) {
            $where = 'WHERE (name LIKE ? OR batch_number LIKE ? OR barcode = ?)';
            $params = ["%$search%", "%$search%", $search];
        }

        $params[] = (string) $limit;
        $params[] = (string) $offset;

        $sql = "
        SELECT * FROM products_pharm 
        $where 
        ORDER BY name 
        LIMIT ? OFFSET ?
    ";

        return $this->db->query($sql, $params);
    }

    // public function getExpiringProducts($days = 30, $limit = 10, $offset = 0)
    // {
    //     return $this->db->query('
    //         SELECT * FROM products_pharm 
    //         WHERE expiry_date BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL ? DAY)
    //         ORDER BY expiry_date ASC
    //     ', [$days]);
    // }

    // public function getLowStockProducts($limit = 10, $offset = 0)
    // {
    //     return $this->db->query('
    //         SELECT * FROM products_pharm 
    //         WHERE quantity <= minimum_stock_level
    //         ORDER BY quantity ASC
    //     ');
    // }
    public function recordStockMovement($data)
    {
        $required = ['product_id', 'quantity', 'movement_type'];
        foreach ($required as $field) {
            if (!isset($data[$field])) {
                throw new Exception("Missing required field: $field");
            }
        }

        $defaults = [
            'date' => date('Y-m-d H:i:s'),
            'notes' => '',
            'user_id' => $_SESSION['user_id'] ?? null
        ];

        $data = array_merge($defaults, $data);
        return $this->db->insert('stock_movements', $data);
    }

    public function getStockMovements($product_id)
    {
        return $this->db->query('
            SELECT sm.*, u.username 
            FROM stock_movements_pharm sm
            LEFT JOIN users_pharm u ON sm.user_id = u.id
            WHERE sm.product_id = ?
            ORDER BY sm.date DESC
        ', [$product_id]);
    }

    public function createSale($sale_data, $items)
    {
        // Validate items
        if (empty($items)) {
            throw new Exception('No items in sale');
        }

        // Calculate totals
        $total_amount = 0;
        foreach ($items as $item) {
            $product = $this->getProduct($item['product_id']);
            if (!$product || $product['quantity'] < $item['quantity']) {
                throw new Exception('Invalid product or insufficient stock');
            }
            $total_amount += $item['quantity'] * $product['selling_price'];
        }

        // Create sale record
        $defaults = [
            'invoice_number' => $this->generateInvoiceNumber(),
            'date' => date('Y-m-d H:i:s'),
            'net_amount' => $total_amount,
            'discount' => 0,
            'tax' => 0
        ];

        $sale_data = array_merge($defaults, $sale_data);
        $sale_data['total_amount'] = $total_amount;

        $sale_id = $this->db->insert('sales', $sale_data);

        // Add sale items and update stock
        foreach ($items as $item) {
            $product = $this->getProduct($item['product_id']);

            $sale_item = [
                'sale_id' => $sale_id,
                'product_id' => $item['product_id'],
                'quantity' => $item['quantity'],
                'price' => $product['selling_price'],
                'total' => $item['quantity'] * $product['selling_price']
            ];

            $this->db->insert('sale_items', $sale_item);

            // Update product quantity
            $this->db->execute('
                UPDATE products_pharm 
                SET quantity = quantity - ? 
                WHERE id = ?
            ', [$item['quantity'], $item['product_id']]);

            // Record stock movement
            $this->recordStockMovement([
                'product_id' => $item['product_id'],
                'quantity' => -$item['quantity'],
                'movement_type' => 'sale',
                'notes' => 'Sold to ' . ($sale_data['customer_name'] ?? 'Customer')
            ]);
        }

        return $sale_id;
    }

    public function getSale($id)
    {
        $sale = $this->db->query('
            SELECT s.*, u.username 
            FROM sales_pharm s
            JOIN users_pharm u ON s.user_id = u.id
            WHERE s.id = ?
        ', [$id]);

        if (empty($sale))
            return null;

        $sale = $sale[0];
        $sale['items'] = $this->db->query('
            SELECT si.*, p.name 
            FROM sale_items_pharm si
            JOIN products_pharm p ON si.product_id = p.id
            WHERE si.sale_id = ?
        ', [$id]);

        return $sale;
    }

    public function getSales($limit = 100)
    {
        $sales = $this->db->query('
            SELECT s.*, u.username 
            FROM sales_pharm s
            JOIN users_pharm u ON s.user_id = u.id
            ORDER BY s.date DESC
            LIMIT ?
        ', [$limit]);

        return $sales;
    }

    // Reporting
    public function getSalesReport($start_date, $end_date)
    {
        return $this->db->query('
            SELECT DATE(s.date) as sale_date, 
                   COUNT(*) as num_sales, 
                   SUM(s.total_amount) as total_amount,
                   u.username
            FROM sales_pharm s
            JOIN users_pharm u ON s.user_id = u.id
            WHERE DATE(s.date) BETWEEN ? AND ?
            GROUP BY DATE(s.date), u.username
            ORDER BY sale_date DESC
        ', [$start_date, $end_date]);
    }

    public function getProductSalesReport($start_date, $end_date)
    {
        return $this->db->query('
            SELECT p.name, 
                   SUM(si.quantity) as total_quantity, 
                   SUM(si.total) as total_amount
            FROM sale_items_pharm si
            JOIN products_pharm p ON si.product_id = p.id
            JOIN sales_pharm s ON si.sale_id = s.id
            WHERE DATE(s.date) BETWEEN ? AND ?
            GROUP BY p.name
            ORDER BY total_quantity DESC
        ', [$start_date, $end_date]);
    }

    // Utility Methods
    private function generateInvoiceNumber()
    {
        return 'INV-' . date('Ymd') . '-' . strtoupper(substr(uniqid(), -6));
    }

    public function importProductsFromCSV($file_path)
    {
        if (($handle = fopen($file_path, 'r')) !== FALSE) {
            // Skip header row
            fgetcsv($handle);

            $success_count = 0;

            while (($data = fgetcsv($handle, 1000, ',')) !== FALSE) {
                $rawDate = trim($data[6]);
                $expiryDate = null;

                if (!empty($rawDate)) {
                    $dateObj = DateTime::createFromFormat('Y-m-d', $rawDate);

                    if (!$dateObj) {
                        $dateObj = DateTime::createFromFormat('d/m/Y', $rawDate);
                    }
                    $dateErrors = DateTime::getLastErrors();
                    if (!$dateObj || $dateErrors['warning_count'] > 0 || $dateErrors['error_count'] > 0) {
                        fclose($handle); 
                        throw new Exception("Invalid date format in CSV: '$rawDate'. Import aborted.");
                    }

                    $expiryDate = $dateObj->format('Y-m-d');
                }

                $product = [
                    'name' => $data[0],
                    'description' => $data[1],
                    'batch_number' => $data[2],
                    'quantity' => (int) $data[3],
                    'buying_price' => (float) str_replace(',', '', $data[4]),
                    'selling_price' => (float) str_replace(',', '', $data[5]),
                    'expiry_date' => $expiryDate,
                    'minimum_stock_level' => isset($data[7]) ? (int) $data[7] : 10,
                    'barcode' => $data[8] ?? null,
                    'unit_type' => $data[9] ?? 'pce',
                    'category_id' => null,
                    'supplier_id' => null
                ];

                $this->addProduct($product);
                $success_count++;
            }

            fclose($handle);

            return [
                'success' => $success_count,
                'errors' => 0
            ];
        }

        throw new Exception('Failed to open CSV file');
    }








    // public function importProductsFromCSV($file_path)
// {
//     if (($handle = fopen($file_path, 'r')) !== FALSE) {
//         // Skip header row
//         fgetcsv($handle);

    //         $success_count = 0;
//         $error_count = 0;

    //         while (($data = fgetcsv($handle, 1000, ',')) !== FALSE) {
//             try {
//                 $rawDate = trim($data[6]);
//                 $expiryDate = null;

    //                 if (!empty($rawDate)) {
//                     // Try parsing in Y-m-d format (2028-05-01)
//                     $dateObj = DateTime::createFromFormat('Y-m-d', $rawDate);

    //                     // If that fails, try d/m/Y format (like 31/11/2026 in your data)
//                     if (!$dateObj) {
//                         $dateObj = DateTime::createFromFormat('d/m/Y', $rawDate);
//                     }

    //                     if ($dateObj) {
//                         $expiryDate = $dateObj->format('Y-m-d');
//                     } else {
//                         throw new Exception("Invalid date format: $rawDate");
//                     }
//                 }

    //                 $product = [
//                     'name' => $data[0],
//                     'description' => $data[1],
//                     'batch_number' => $data[2],
//                     'quantity' => (int) $data[3],
//                     'buying_price' => (float) str_replace(',', '', $data[4]),
//                     'selling_price' => (float) str_replace(',', '', $data[5]),
//                     'expiry_date' => $expiryDate,
//                     'minimum_stock_level' => isset($data[7]) ? (int) $data[7] : 10,
//                     'barcode' => $data[8] ?? null,
//                     'unit_type' => $data[9] ?? 'pce',
//                     'category_id' => null,
//                     'supplier_id' => null
//                 ];

    //                 $this->addProduct($product);
//                 $success_count++;
//             } catch (Exception $e) {
//                 $error_count++;
//                 error_log("Import error: " . $e->getMessage());
//             }
//         }
//         fclose($handle);

    //         return [
//             'success' => $success_count,
//             'errors' => $error_count
//         ];
//     }

    //     throw new Exception('Failed to open CSV file');
// }

    // Notifications
    public function checkExpiringProducts($days = 30)
    {
        $products = $this->getExpiringProducts($days);
        $notifications = [];

        foreach ($products as $product) {
            $exists = $this->db->query("
                SELECT COUNT(*) FROM notifications_pharm 
                WHERE type = 'expiry' 
                AND related_id = ? 
                AND is_read = 0
            ", [$product['id']]);

            if (!$exists[0]['COUNT(*)']) {
                $notifications[] = $this->createNotification([
                    'user_id' => 1,  // Admin
                    'title' => 'Product Expiring Soon',
                    'message' => $product['name'] . ' (Batch: ' . $product['batch_number'] . ') expires on ' . $product['expiry_date'],
                    'type' => 'expiry',
                    'related_id' => $product['id']
                ]);
            }
        }

        return $notifications;
    }

    public function checkLowStockProducts()
    {
        $products = $this->getLowStockProducts();
        $notifications = [];

        foreach ($products as $product) {
            $exists = $this->db->query("
                SELECT COUNT(*) FROM notifications_pharm 
                WHERE type = 'low_stock' 
                AND related_id = ? 
                AND is_read = 0
            ", [$product['id']]);

            if (!$exists[0]['COUNT(*)']) {
                $notifications[] = $this->createNotification([
                    'user_id' => 1,  // Admin
                    'title' => 'Low Stock Alert',
                    'message' => $product['name'] . ' is running low. Current stock: ' . $product['quantity'],
                    'type' => 'low_stock',
                    'related_id' => $product['id']
                ]);
            }
        }

        return $notifications;
    }

    public function createNotification($data)
    {
        $defaults = [
            'created_at' => date('Y-m-d H:i:s'),
            'is_read' => 0
        ];

        $data = array_merge($defaults, $data);
        return $this->db->insert('notifications', $data);
    }

    public function getNotifications($user_id, $limit = 5)
    {
        return $this->db->query('
            SELECT * FROM notifications_pharm 
            WHERE user_id = ? OR user_id = 0 
            ORDER BY created_at DESC 
            LIMIT ?
        ', [$user_id, $limit]);
    }

    public function updateProductStock($product_id, $data)
    {
        $this->db->beginTransaction();

        try {
            // 1) Increase quantity, update batch_number, buying_price, selling_price, expiry_date, barcode
            $sql = 'UPDATE products_pharm SET 
                batch_number = ?, 
                quantity = quantity + ?, 
                buying_price = ?, 
                selling_price = ?, 
                expiry_date = ?, 
                barcode = ?,
                updated_at = NOW()
            WHERE id = ?';
            $params = [
                $data['batch_number'],
                $data['quantity'],
                $data['buying_price'],
                $data['selling_price'],
                $data['expiry_date'],
                $data['barcode'],
                $product_id
            ];
            $this->db->execute($sql, $params);

            // 2) Insert stock movement record
            $this->db->execute("INSERT INTO stock_movements_pharm 
            (product_id, quantity, movement_type, date, user_id, notes) 
            VALUES (?, ?, 'purchase', NOW(), ?, ?)",
                [$product_id, $data['quantity'], $_SESSION['user_id'], 'Stock update via stock page']
            );

            $this->db->commit();
        } catch (Exception $e) {
            $this->db->rollback();
            throw $e;
        }
    }

    public function searchProductsByName($name)
    {
        $name = "%$name%";
        $sql = 'SELECT * FROM products_pharm WHERE name LIKE ?';
        return $this->db->query($sql, [$name]);
    }

    public function addProductBatch($product_id, $batchData)
    {
        $conn = $this->db;

        $conn->beginTransaction();
        try {
            // 1. Insert into procurement_pharm if needed (or use dummy procurement_id)
            $procurement_id = null;
            $stmt = $conn->query('INSERT INTO procurement_pharm (supplier_id, invoice_number, invoice_date, payment_status, total_amount, created_by) VALUES (?, ?, ?, ?, ?, ?)', [
                1,
                'AUTO-GENERATED',
                date('Y-m-d'),
                'paid',
                $batchData['buying_price'] * $batchData['quantity'],
                $batchData['created_by']
            ]);
            $procurement_id = $conn->rawQuery('SELECT LAST_INSERT_ID()')->fetch_row()[0];

            // 2. Insert batch into procurement_items_pharm
            $batchInsertId = $conn->insert('procurement_items', [
                'procurement_id' => $procurement_id,
                'product_id' => $product_id,
                'quantity' => $batchData['quantity'],
                'unit' => 'pce',
                'buying_price' => $batchData['buying_price'],
                'selling_price' => $batchData['selling_price'],
                'expiry_date' => $batchData['expiry_date'],
                'batch_number' => $batchData['batch_number']
            ]);

            // 3. Log in stock movements
            $conn->execute("INSERT INTO stock_movements_pharm (product_id, quantity, movement_type, date, user_id, notes, batch_id)
            VALUES (?, ?, 'purchase', NOW(), ?, ?, ?)", [
                $product_id,
                $batchData['quantity'],
                $batchData['created_by'],
                'Batch added manually',
                $batchInsertId
            ]);

            $conn->commit();
        } catch (Exception $e) {
            $conn->rollback();
            throw new Exception('Failed to add batch: ' . $e->getMessage());
        }
    }

    /**
     * Total stock for a product across the live products_pharm row plus
     * every product_batches_pharm row marked is_active. This is the
     * "real" available quantity the cashier can sell.
     */
    public function getTotalProductQuantity($product_id)
    {
        $live = $this->db->fetchOne(
            "SELECT COALESCE(quantity, 0) AS q FROM products_pharm WHERE id = ?",
            [$product_id]
        );
        $arch = $this->db->fetchOne(
            "SELECT COALESCE(SUM(quantity), 0) AS q
             FROM product_batches_pharm
             WHERE product_id = ? AND is_active = 1 AND quantity > 0",
            [$product_id]
        );
        return (float)($live['q'] ?? 0) + (float)($arch['q'] ?? 0);
    }

    /**
     * Deduct `$quantity` from a product using FEFO across active batches
     * first (earliest expiry first), then the live products_pharm row.
     *
     * Throws Exception with a clear message if total stock is insufficient.
     * Must be called inside a transaction by the caller.
     *
     * Returns true on success.
     */
    public function deductStockFEFO($product_id, $quantity)
    {
        $quantity = (float) $quantity;
        if ($quantity <= 0) {
            throw new Exception('Quantity to deduct must be greater than zero.');
        }

        $product = $this->db->fetchOne("SELECT id, name, quantity FROM products_pharm WHERE id = ?", [$product_id]);
        if (!$product) {
            throw new Exception("Product id $product_id not found.");
        }

        // Hard reject if there isn't enough total stock anywhere.
        $available = $this->getTotalProductQuantity($product_id);
        if ($quantity > $available) {
            throw new Exception(
                sprintf('Only %s available for %s — cannot sell %s.',
                    rtrim(rtrim(number_format($available, 2), '0'), '.'),
                    $product['name'],
                    rtrim(rtrim(number_format($quantity, 2), '0'), '.')
                )
            );
        }

        $remaining = $quantity;

        // 1) Walk active archived batches FEFO (earliest expiry first).
        //    NULL expiry sorts last so dated batches sell before "unknown" expiry.
        $batches = $this->db->fetchAll(
            "SELECT id, quantity, expiry_date
             FROM product_batches_pharm
             WHERE product_id = ? AND is_active = 1 AND quantity > 0
             ORDER BY (expiry_date IS NULL), expiry_date ASC, archived_at ASC, id ASC",
            [$product_id]
        );
        foreach ($batches as $b) {
            if ($remaining <= 0) break;
            $take = min((float)$b['quantity'], $remaining);
            $new_qty = (float)$b['quantity'] - $take;
            // Deactivate when exhausted; the row stays for audit.
            $this->db->execute(
                "UPDATE product_batches_pharm
                 SET quantity = ?, is_active = CASE WHEN ? <= 0 THEN 0 ELSE 1 END
                 WHERE id = ?",
                [$new_qty, $new_qty, $b['id']]
            );
            $remaining -= $take;
        }

        // 2) Any remainder comes from the live row.
        if ($remaining > 0) {
            $take = min((float)$product['quantity'], $remaining);
            $this->db->execute(
                "UPDATE products_pharm SET quantity = quantity - ? WHERE id = ? AND quantity >= ?",
                [$take, $product_id, $take]
            );
            $remaining -= $take;
        }

        // Sanity check — should be zero if we calculated available correctly
        // and the CHECK constraints didn't reject anything.
        if ($remaining > 0.0001) {
            throw new Exception('Stock deduction failed: remainder ' . $remaining
                . ' could not be allocated. Stock state may be inconsistent.');
        }

        return true;
    }

    public function findProductByName($name)
    {
        $sql = 'SELECT * FROM products_pharm WHERE name LIKE ? ORDER BY id DESC LIMIT 1';
        return $this->db->fetchOne($sql, ['%' . $name . '%']);
    }

    public function countAllProducts($search = '')
    {
        if ($search) {
            $result = $this->db->query("SELECT COUNT(*) as total FROM products_pharm WHERE name LIKE ?", ["%$search%"]);
        } else {
            $result = $this->db->query("SELECT COUNT(*) as total FROM products_pharm");
        }

        return $result[0]['total'] ?? 0;
    }

    public function getExpiringProducts($search = '', $limit = 10, $offset = 0, $days = 30)
{
    $sql = '
        SELECT * FROM products_pharm 
        WHERE expiry_date BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL ? DAY)
    ';
    $params = [$days];

    if (!empty($search)) {
        $sql .= ' AND (name LIKE ? OR batch_number LIKE ? OR barcode LIKE ?)';
        $searchTerm = "%$search%";
        $params[] = $searchTerm;
        $params[] = $searchTerm;
        $params[] = $searchTerm;
    }

    $sql .= ' ORDER BY expiry_date ASC';

    if ($limit) {
        $sql .= ' LIMIT ? OFFSET ?';
        $params[] = $limit;
        $params[] = $offset;
    }

    return $this->db->query($sql, $params);
}

public function getLowStockProducts($search = '', $limit = 10, $offset = 0)
{
    $sql = '
        SELECT * FROM products_pharm 
        WHERE quantity <= minimum_stock_level
    ';
    $params = [];

    if (!empty($search)) {
        $sql .= ' AND (name LIKE ? OR batch_number LIKE ? OR barcode LIKE ?)';
        $searchTerm = "%$search%";
        $params[] = $searchTerm;
        $params[] = $searchTerm;
        $params[] = $searchTerm;
    }

    $sql .= ' ORDER BY quantity ASC';

    if ($limit) {
        $sql .= ' LIMIT ? OFFSET ?';
        $params[] = $limit;
        $params[] = $offset;
    }

    return $this->db->query($sql, $params);
}

public function countExpiringProducts($search = '')
{
    $threshold_date = date('Y-m-d', strtotime('+30 days'));
    $sql = "SELECT COUNT(*) as total FROM products_pharm WHERE expiry_date <= ?";
    $params = [$threshold_date];

    if (!empty($search)) {
        $sql .= ' AND (name LIKE ? OR batch_number LIKE ? OR barcode LIKE ?)';
        $searchTerm = "%$search%";
        $params[] = $searchTerm;
        $params[] = $searchTerm;
        $params[] = $searchTerm;
    }

    $result = $this->db->query($sql, $params);
    return $result[0]['total'] ?? 0;
}

public function countLowStockProducts($search = '')
{
    $sql = "SELECT COUNT(*) as total FROM products_pharm WHERE quantity <= minimum_stock_level";
    $params = [];

    if (!empty($search)) {
        $sql .= ' AND (name LIKE ? OR batch_number LIKE ? OR barcode LIKE ?)';
        $searchTerm = "%$search%";
        $params[] = $searchTerm;
        $params[] = $searchTerm;
        $params[] = $searchTerm;
    }

    $result = $this->db->query($sql, $params);
    return $result[0]['total'] ?? 0;
}


// Add this function to your Pharmacy class or in the dashboard file
public function getExpiringDrugsNotifications($db, $days_threshold = 30) {
    $sql = "
        SELECT name, batch_number, expiry_date, 
               DATEDIFF(expiry_date, CURDATE()) as days_until_expiry
        FROM products_pharm 
        WHERE expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL ? DAY)
        AND quantity > 0
        ORDER BY expiry_date ASC
    ";
    
    $expiring_drugs = $db->query($sql, [$days_threshold]);
    $notifications = [];
    
    foreach ($expiring_drugs as $drug) {
        $days_left = $drug['days_until_expiry'];
        
        if ($days_left <= 7) {
            $priority = 'high';
            $title = "URGENT: Drug Expiring Soon";
        } elseif ($days_left <= 15) {
            $priority = 'medium';
            $title = "Drug Expiring Soon";
        } else {
            $priority = 'low';
            $title = "Drug Nearing Expiry";
        }
        
        $notifications[] = [
            'title' => $title,
            'message' => "{$drug['name']} (Batch: {$drug['batch_number']}) expires in {$days_left} days on " . date('d/m/Y', strtotime($drug['expiry_date'])),
            'priority' => $priority,
            'days_left' => $days_left,
            'drug_name' => $drug['name'],
            'batch_number' => $drug['batch_number'],
            'expiry_date' => $drug['expiry_date']
        ];
    }
    
    return $notifications;
}

// Also add low stock notifications
public function getLowStockNotifications($db, $threshold_percentage = 20) {
    $sql = "
        SELECT name, batch_number, quantity, minimum_stock_level,
               ROUND((quantity / minimum_stock_level) * 100) as stock_percentage
        FROM products_pharm 
        WHERE quantity > 0 AND quantity <= minimum_stock_level
        ORDER BY quantity ASC
    ";
    
    $low_stock_drugs = $db->query($sql);
    $notifications = [];
    
    foreach ($low_stock_drugs as $drug) {
        $stock_percentage = $drug['stock_percentage'];
        
        if ($stock_percentage <= 10) {
            $priority = 'high';
            $title = "CRITICAL: Very Low Stock";
        } elseif ($stock_percentage <= 30) {
            $priority = 'medium';
            $title = "Low Stock Alert";
        } else {
            $priority = 'low';
            $title = "Stock Running Low";
        }
        
        $needed = $drug['minimum_stock_level'] - $drug['quantity'];
        $notifications[] = [
            'title' => $title,
            'message' => "{$drug['name']} (Batch: {$drug['batch_number']}) has only {$drug['quantity']} units left. Minimum required: {$drug['minimum_stock_level']}",
            'priority' => $priority,
            'stock_percentage' => $stock_percentage,
            'drug_name' => $drug['name'],
            'current_stock' => $drug['quantity'],
            'minimum_required' => $drug['minimum_stock_level'],
            'needed' => $needed
        ];
    }
    
    return $notifications;
}


// Add this method to your Pharmacy class
public function generateDrugNotifications() {
    // Clear old notifications (older than 7 days)
    $this->db->execute("DELETE FROM drug_notifications WHERE created_at < DATE_SUB(NOW(), INTERVAL 7 DAY)");
    
    // Expiring drugs notifications
    $expiring_drugs = $this->db->query("
        SELECT name, batch_number, expiry_date, 
               DATEDIFF(expiry_date, CURDATE()) as days_until_expiry
        FROM products_pharm 
        WHERE expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
        AND quantity > 0
    ");
    
    foreach ($expiring_drugs as $drug) {
        $days_left = $drug['days_until_expiry'];
        $priority = $days_left <= 7 ? 'high' : ($days_left <= 15 ? 'medium' : 'low');
        
        $this->db->execute("
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
    
    // Low stock notifications
    $low_stock_drugs = $this->db->query("
        SELECT name, batch_number, quantity, minimum_stock_level
        FROM products_pharm 
        WHERE quantity > 0 AND quantity <= minimum_stock_level
    ");
    
    foreach ($low_stock_drugs as $drug) {
        $stock_percentage = round(($drug['quantity'] / $drug['minimum_stock_level']) * 100);
        $priority = $stock_percentage <= 10 ? 'high' : ($stock_percentage <= 30 ? 'medium' : 'low');
        
        $this->db->execute("
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
    
    return true;
}

// Also add a method to get notifications
public function getDrugNotifications($limit = 20) {
    return $this->db->query("
        SELECT * FROM drug_notifications 
        WHERE is_read = FALSE 
        ORDER BY 
            FIELD(priority, 'high', 'medium', 'low'),
            created_at DESC
        LIMIT ?
    ", [$limit]);
}








































    // public function countExpiringProducts()
    // {
    //     $threshold_date = date('Y-m-d', strtotime('+30 days'));
    //     $result = $this->db->query("SELECT COUNT(*) as total FROM products_pharm WHERE expiry_date <= ?", [$threshold_date]);
    //     return $result[0]['total'] ?? 0;
    // }
    // public function countLowStockProducts()
    // {
    //     $result = $this->db->query("SELECT COUNT(*) as total FROM products_pharm WHERE quantity <= minimum_stock_level");
    //     return $result[0]['total'] ?? 0;
    // }


}