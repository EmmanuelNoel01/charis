<?php
require_once '../fpdf/fpdf.php';

class PDF extends FPDF
{
    public static function generateInvoice($sale_id, $db)
    {
        $conn = $db->getConnection();

        // Fetch sale info
        $stmt = $conn->prepare('
            SELECT s.*, u.username 
            FROM sales_pharm s
            JOIN users_pharm u ON s.user_id = u.id
            WHERE s.id = ?
        ');
        $stmt->bind_param('i', $sale_id);
        $stmt->execute();
        $sale = $stmt->get_result()->fetch_assoc();

        if (!$sale) {
            throw new Exception('Sale not found');
        }

        // Fetch sale items
        $stmt = $conn->prepare('
            SELECT si.*, p.name 
            FROM sale_items_pharm si
            JOIN products_pharm p ON si.product_id = p.id
            WHERE si.sale_id = ?
        ');
        $stmt->bind_param('i', $sale_id);
        $stmt->execute();
        $items = $stmt->get_result();

        // Fetch pharmacy details from DB
        $pharmacy = $db->fetchOne("SELECT * FROM pharmacy_details LIMIT 1");

        $pharmacy_name = $pharmacy['name'] ?? 'N/A';
        $pharmacy_address = $pharmacy['address'] ?? 'N/A';
        $pharmacy_phone = $pharmacy['phone'] ?? 'N/A';
        $pharmacy_email = $pharmacy['email'] ?? 'N/A';

        // Create PDF
        $pdf = new FPDF();
        $pdf->AddPage();

        // Title
        $pdf->SetFont('Arial', 'B', 14);
        $pdf->Cell(0, 10, 'RECEIPT', 0, 1, 'C');

        // Pharmacy & Invoice Details
        $pdf->SetFont('Arial', '', 10);
        $pdf->Cell(100, 6, $pharmacy_name, 0, 0);
        $pdf->Cell(90, 6, 'Receipt #: ' . $sale['invoice_number'], 0, 1, 'R');

        $pdf->Cell(100, 6, $pharmacy_address, 0, 0);
        $pdf->Cell(90, 6, 'Date: ' . date('d/m/Y H:i', strtotime($sale['date'])), 0, 1, 'R');

        $pdf->Cell(100, 6, 'Phone: ' . $pharmacy_phone, 0, 0);
        $pdf->Cell(90, 6, 'Pharmacist: ' . $sale['username'], 0, 1, 'R');

        $pdf->Cell(100, 6, 'Email: ' . $pharmacy_email, 0, 1);

        $pdf->Ln(8);
        $pdf->SetFont('Arial', 'B', 12);
        $pdf->Cell(0, 6, 'Customer', 0, 1);
        $pdf->SetFont('Arial', '', 11);
        $pdf->Cell(0, 6, $sale['customer_name'], 0, 1);

        $pdf->Ln(8);

        // Table Headers
        $pdf->SetFont('Arial', 'B', 11);
        $pdf->SetFillColor(230, 230, 230);
        $pdf->Cell(10, 8, '#', 1, 0, 'C', true);
        $pdf->Cell(80, 8, 'Product', 1, 0, 'L', true);
        $pdf->Cell(25, 8, 'Qty', 1, 0, 'C', true);
        $pdf->Cell(35, 8, 'Unit Price', 1, 0, 'R', true);
        $pdf->Cell(40, 8, 'Total', 1, 1, 'R', true);

        // Table Content
        $pdf->SetFont('Arial', '', 11);
        $index = 1;
        while ($item = $items->fetch_assoc()) {
            $pdf->Cell(10, 8, $index++, 1, 0, 'C');
            $pdf->Cell(80, 8, $item['name'], 1);
            $pdf->Cell(25, 8, $item['quantity'], 1, 0, 'C');
            $pdf->Cell(35, 8, number_format($item['price'], 2), 1, 0, 'R');
            $pdf->Cell(40, 8, number_format($item['total'], 2), 1, 1, 'R');
        }

        // Totals
        $pdf->Ln(4);
        $pdf->Cell(150, 8, 'Subtotal:', 0, 0, 'R');
        $pdf->Cell(35, 8, number_format($sale['total_amount'], 2), 0, 1, 'R');

        $pdf->Cell(150, 8, 'Tax (0%):', 0, 0, 'R');
        $pdf->Cell(35, 8, '0.00', 0, 1, 'R');

        $pdf->Cell(150, 8, 'Discount (0%):', 0, 0, 'R');
        $pdf->Cell(35, 8, '0.00', 0, 1, 'R');

        $pdf->SetFont('Arial', 'B', 12);
        $pdf->Cell(150, 8, 'Total:', 0, 0, 'R');
        $pdf->Cell(35, 8, number_format($sale['total_amount'], 2), 0, 1, 'R');

        $pdf->Ln(12);
        $pdf->SetFont('Arial', '', 11);
        $pdf->Cell(0, 6, 'Payment Method: ' . ucfirst(str_replace('_', ' ', $sale['payment_method'])), 0, 1);
        $pdf->Ln(3);
        $pdf->Cell(0, 6, 'Thank you for your business!', 0, 1);

        if (ob_get_length()) {
            ob_end_clean();
        }

        // Save PDF to file
        $filePath = "../invoices/invoice_$sale_id.pdf";
        $pdf->Output('F', $filePath);
    }
}
