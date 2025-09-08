-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 08, 2025 at 04:52 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hospital_management`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `account_id` int(11) NOT NULL,
  `account_name` varchar(100) NOT NULL,
  `account_type` enum('Asset','Liability','Equity','Revenue','Expense') NOT NULL,
  `account_code` varchar(20) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `ap_aging`
-- (See below for the actual view)
--
CREATE TABLE `ap_aging` (
`bill_id` int(11)
,`vendor_id` int(11)
,`vendor_name` varchar(100)
,`total_amount` decimal(10,2)
,`amount_paid` decimal(10,2)
,`balance` decimal(11,2)
,`due_date` date
,`aging_bucket` varchar(12)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ar_aging`
-- (See below for the actual view)
--
CREATE TABLE `ar_aging` (
`invoice_id` int(11)
,`visit_id` int(11)
,`patient_id` int(11)
,`patient_name` varchar(101)
,`total_amount` decimal(10,2)
,`amount_paid` decimal(10,2)
,`balance` decimal(11,2)
,`due_date` date
,`aging_bucket` varchar(12)
);

-- --------------------------------------------------------

--
-- Table structure for table `beds`
--

CREATE TABLE `beds` (
  `bed_id` int(11) NOT NULL,
  `ward_id` int(11) NOT NULL,
  `bed_number` varchar(20) NOT NULL,
  `status` enum('Available','Occupied','Maintenance') DEFAULT 'Available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `beds`
--

INSERT INTO `beds` (`bed_id`, `ward_id`, `bed_number`, `status`) VALUES
(1, 1, '7', 'Occupied'),
(2, 2, '5', 'Available'),
(3, 3, '1', 'Available'),
(4, 3, '2', 'Available'),
(5, 3, '3', 'Available'),
(6, 3, '4', 'Available'),
(7, 3, '5', 'Available'),
(8, 3, '6', 'Available'),
(9, 3, '7', 'Available'),
(10, 3, '8', 'Available'),
(11, 3, '9', 'Available'),
(12, 3, '10', 'Available'),
(13, 4, '1', 'Available');

-- --------------------------------------------------------

--
-- Table structure for table `bills`
--

CREATE TABLE `bills` (
  `bill_id` int(11) NOT NULL,
  `vendor_id` int(11) NOT NULL,
  `bill_date` date NOT NULL,
  `due_date` date NOT NULL,
  `bill_number` varchar(50) NOT NULL,
  `reference_number` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `amount_paid` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('Pending','Partially Paid','Paid','Cancelled') DEFAULT 'Pending',
  `term_id` int(11) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bill_items`
--

CREATE TABLE `bill_items` (
  `item_id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `description` text NOT NULL,
  `quantity` decimal(10,2) NOT NULL DEFAULT 1.00,
  `unit_price` decimal(10,2) NOT NULL,
  `amount` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bill_payments`
--

CREATE TABLE `bill_payments` (
  `payment_id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` date NOT NULL,
  `payment_method` enum('Cash','Check','Bank Transfer') NOT NULL,
  `reference_number` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cashbook`
--

CREATE TABLE `cashbook` (
  `transaction_id` int(11) NOT NULL,
  `transaction_date` date NOT NULL,
  `reference_number` varchar(20) NOT NULL,
  `description` text DEFAULT NULL,
  `account_id` int(11) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `transaction_type` enum('Receipt','Payment') NOT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories_pharm`
--

CREATE TABLE `categories_pharm` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `credit_notes_pharm`
--

CREATE TABLE `credit_notes_pharm` (
  `id` int(11) NOT NULL,
  `sale_id` int(11) NOT NULL,
  `issued_by` int(11) NOT NULL,
  `reason` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `credit_note_items_pharm`
--

CREATE TABLE `credit_note_items_pharm` (
  `id` int(11) NOT NULL,
  `credit_note_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `reason` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `diagnosis`
--

CREATE TABLE `diagnosis` (
  `id` int(11) NOT NULL,
  `diagnosis_code` varchar(20) NOT NULL,
  `diagnosis_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `diagnosis`
--

INSERT INTO `diagnosis` (`id`, `diagnosis_code`, `diagnosis_name`) VALUES
(1, 'A00', 'Cholera'),
(2, 'B20', 'HIV disease'),
(3, 'E11', 'Type 2 diabetes mellitus'),
(4, 'J45', 'Asthma');

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `doctor_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `specialization` varchar(100) NOT NULL,
  `specialization_fee` decimal(10,2) NOT NULL DEFAULT 0.00,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`doctor_id`, `first_name`, `last_name`, `specialization`, `specialization_fee`, `phone`, `email`, `created_at`) VALUES
(1, 'John', 'Doe', 'Cardiology', 50000.00, '+256712345678', 'john.doe@example.com', '2025-05-17 22:02:40');

-- --------------------------------------------------------

--
-- Table structure for table `doctor_notes`
--

CREATE TABLE `doctor_notes` (
  `note_id` int(11) NOT NULL,
  `visit_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `complaints` text DEFAULT NULL,
  `diagnosis` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctor_notes`
--

INSERT INTO `doctor_notes` (`note_id`, `visit_id`, `doctor_id`, `complaints`, `diagnosis`, `notes`, `created_at`) VALUES
(1, 4, 1, 'test', 'malaria', 'test notes', '2025-06-04 12:08:51'),
(2, 5, 1, 'test complaints', 'pain', 'just', '2025-06-05 16:57:40'),
(3, 7, 1, 'test', 'malaria', 'test notes', '2025-06-06 10:17:19'),
(4, 8, 1, 'test', 'test', 'test', '2025-06-13 05:45:06'),
(5, 10, 1, 'NA', 'NA', 'NA', '2025-06-24 18:09:51'),
(6, 13, 1, 'krfgmbpkgr', 'ikpefnb', 'kdnokbnr', '2025-07-09 11:45:56');

-- --------------------------------------------------------

--
-- Table structure for table `expenditures_pharm`
--

CREATE TABLE `expenditures_pharm` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `expense_date` date NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `category` varchar(50) NOT NULL DEFAULT 'General'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `financial_periods`
--

CREATE TABLE `financial_periods` (
  `period_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `is_closed` tinyint(1) NOT NULL DEFAULT 0,
  `closed_at` timestamp NULL DEFAULT NULL,
  `closed_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inpatient_admissions`
--

CREATE TABLE `inpatient_admissions` (
  `admission_id` int(11) NOT NULL,
  `visit_id` int(11) NOT NULL,
  `bed_id` int(11) NOT NULL,
  `admission_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `discharge_date` timestamp NULL DEFAULT NULL,
  `status` enum('Admitted','Discharged','Transferred') DEFAULT 'Admitted',
  `notes` text DEFAULT NULL,
  `diagnosis` text DEFAULT NULL,
  `treatment_plan` text DEFAULT NULL,
  `procedures` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inpatient_admissions`
--

INSERT INTO `inpatient_admissions` (`admission_id`, `visit_id`, `bed_id`, `admission_date`, `discharge_date`, `status`, `notes`, `diagnosis`, `treatment_plan`, `procedures`) VALUES
(1, 8, 1, '2025-06-14 19:34:08', NULL, 'Admitted', '', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `inpatient_medications`
--

CREATE TABLE `inpatient_medications` (
  `id` int(11) NOT NULL,
  `admission_id` int(11) NOT NULL,
  `medication_id` int(11) NOT NULL,
  `dosage` varchar(100) NOT NULL,
  `frequency` varchar(100) NOT NULL,
  `duration` varchar(100) NOT NULL,
  `notes` text DEFAULT NULL,
  `prescribed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `prescribed_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inpatient_procedures`
--

CREATE TABLE `inpatient_procedures` (
  `inpatient_procedure_id` int(11) NOT NULL,
  `admission_id` int(11) NOT NULL,
  `procedure_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `procedure_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL,
  `status` enum('Planned','Completed','Cancelled') DEFAULT 'Planned'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_claims`
--

CREATE TABLE `insurance_claims` (
  `claim_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `insurance_id` int(11) NOT NULL,
  `policy_id` int(11) NOT NULL,
  `visit_id` int(11) DEFAULT NULL,
  `admission_id` int(11) DEFAULT NULL,
  `claim_number` varchar(50) NOT NULL,
  `claim_date` date NOT NULL,
  `submitted_date` date DEFAULT NULL,
  `processed_date` date DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `amount_approved` decimal(10,2) DEFAULT NULL,
  `status` enum('Draft','Submitted','Processing','Approved','Partially Approved','Rejected','Paid') DEFAULT 'Draft',
  `rejection_reason` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_claim_items`
--

CREATE TABLE `insurance_claim_items` (
  `claim_item_id` int(11) NOT NULL,
  `claim_id` int(11) NOT NULL,
  `service_type` enum('Consultation','Lab','Radiology','Medication','Procedure','Room','Other') NOT NULL,
  `service_id` int(11) DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `unit_price` decimal(10,2) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `amount_approved` decimal(10,2) DEFAULT NULL,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `rejection_reason` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_companies`
--

CREATE TABLE `insurance_companies` (
  `insurance_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `insurance_companies`
--

INSERT INTO `insurance_companies` (`insurance_id`, `name`, `contact_person`, `address`, `phone`, `email`, `created_at`) VALUES
(1, 'Sanlam', 'RUTAHIGWA EMMANUEL NOEL', 'William Street', '+256783222564', 'rutahigwaemmanuelnoel@gmail.com', '2025-06-19 20:23:44'),
(2, 'prudential', 'CENTENARY RURAL DEVELOPMENT BANK', 'William Street', '+256783222564', 'rutahigwaemmanuelnoel@gmail.com', '2025-06-19 20:27:39'),
(3, 'UAP', 'NOEL', 'William Street', '0734840691', 'example@gmail.com', '2025-07-09 11:38:24');

-- --------------------------------------------------------

--
-- Table structure for table `insurance_lab_pricing`
--

CREATE TABLE `insurance_lab_pricing` (
  `pricing_id` int(11) NOT NULL,
  `insurance_id` int(11) NOT NULL,
  `test_id` int(11) NOT NULL,
  `negotiated_price` decimal(10,2) NOT NULL,
  `effective_date` date NOT NULL,
  `expiry_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_medication_pricing`
--

CREATE TABLE `insurance_medication_pricing` (
  `pricing_id` int(11) NOT NULL,
  `insurance_id` int(11) NOT NULL,
  `medication_id` int(11) NOT NULL,
  `negotiated_price` decimal(10,2) NOT NULL,
  `effective_date` date NOT NULL,
  `expiry_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_negotiated_rates`
--

CREATE TABLE `insurance_negotiated_rates` (
  `rate_id` int(11) NOT NULL,
  `insurance_id` int(11) NOT NULL,
  `service_type` enum('Consultation','Lab','Radiology','Medication') NOT NULL,
  `service_id` int(11) NOT NULL,
  `negotiated_rate` decimal(10,2) NOT NULL,
  `effective_date` date NOT NULL,
  `expiry_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `insurance_negotiated_rates`
--

INSERT INTO `insurance_negotiated_rates` (`rate_id`, `insurance_id`, `service_type`, `service_id`, `negotiated_rate`, `effective_date`, `expiry_date`) VALUES
(1, 2, 'Lab', 1, 5.00, '2025-06-19', '2026-12-19'),
(2, 3, 'Medication', 2, 500.00, '2025-07-09', '2026-07-09');

-- --------------------------------------------------------

--
-- Table structure for table `insurance_payments`
--

CREATE TABLE `insurance_payments` (
  `payment_id` int(11) NOT NULL,
  `claim_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` date NOT NULL,
  `payment_method` enum('Check','Bank Transfer','Credit Card') NOT NULL,
  `reference_number` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_policies`
--

CREATE TABLE `insurance_policies` (
  `policy_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `insurance_id` int(11) NOT NULL,
  `policy_number` varchar(50) NOT NULL,
  `coverage_start` date NOT NULL,
  `coverage_end` date NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `insurance_policies`
--

INSERT INTO `insurance_policies` (`policy_id`, `patient_id`, `insurance_id`, `policy_number`, `coverage_start`, `coverage_end`, `is_active`, `created_at`) VALUES
(1, 5, 1, '3121755-17', '2024-12-12', '2026-12-12', 1, '2025-06-19 21:11:22'),
(2, 6, 1, '3121755-00', '2025-01-01', '2026-01-01', 1, '2025-06-27 18:13:41'),
(3, 7, 1, '3121755-00', '2025-03-12', '2070-03-12', 1, '2025-07-09 07:35:30'),
(4, 8, 3, '3121755-00', '2024-12-12', '2026-12-12', 1, '2025-07-09 11:42:35');

-- --------------------------------------------------------

--
-- Table structure for table `insurance_procedure_pricing`
--

CREATE TABLE `insurance_procedure_pricing` (
  `pricing_id` int(11) NOT NULL,
  `insurance_id` int(11) NOT NULL,
  `procedure_name` varchar(100) NOT NULL,
  `negotiated_price` decimal(10,2) NOT NULL,
  `description` text DEFAULT NULL,
  `effective_date` date NOT NULL,
  `expiry_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_radiology_pricing`
--

CREATE TABLE `insurance_radiology_pricing` (
  `pricing_id` int(11) NOT NULL,
  `insurance_id` int(11) NOT NULL,
  `radiology_id` int(11) NOT NULL,
  `negotiated_price` decimal(10,2) NOT NULL,
  `effective_date` date NOT NULL,
  `expiry_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `invoice_id` int(11) NOT NULL,
  `visit_id` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `amount_paid` decimal(10,2) NOT NULL DEFAULT 0.00,
  `payment_status` enum('Pending','Paid','Partially Paid') DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `billing_type` enum('Cash','Insurance') DEFAULT 'Cash',
  `insurance_id` int(11) DEFAULT NULL,
  `insurance_claim_number` varchar(50) DEFAULT NULL,
  `claim_id` int(11) DEFAULT NULL,
  `payment_type` enum('Cash','Insurance') DEFAULT 'Cash',
  `term_id` int(11) DEFAULT NULL,
  `due_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `invoices`
--

INSERT INTO `invoices` (`invoice_id`, `visit_id`, `total_amount`, `amount_paid`, `payment_status`, `created_at`, `billing_type`, `insurance_id`, `insurance_claim_number`, `claim_id`, `payment_type`, `term_id`, `due_date`) VALUES
(4, 4, 455450.00, 455450.00, 'Paid', '2025-06-05 11:38:27', 'Cash', NULL, NULL, NULL, 'Cash', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `invoices_pharm`
--

CREATE TABLE `invoices_pharm` (
  `id` int(11) NOT NULL,
  `invoice_number` varchar(100) NOT NULL,
  `supplier_name` varchar(255) DEFAULT NULL,
  `supplier_contact` varchar(100) DEFAULT NULL,
  `invoice_status` enum('Paid','Pending') DEFAULT 'Pending',
  `invoice_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `supplier_address` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `invoices_pharm`
--

INSERT INTO `invoices_pharm` (`id`, `invoice_number`, `supplier_name`, `supplier_contact`, `invoice_status`, `invoice_date`, `created_at`, `supplier_address`) VALUES
(1, 'INV-250716-001', 'AMKA', '0778848512', 'Pending', '2025-07-24', '2025-07-24 04:44:22', 'NSAMBYA'),
(2, '00165099', 'AMKA', '0778848512', 'Paid', '2025-07-23', '2025-07-24 04:50:12', 'NSAMBYA'),
(3, 'INV-250716-744000', 'AMKA', '0778848512', 'Paid', '2025-07-20', '2025-07-27 16:32:48', 'NSAMBYA'),
(4, 'INV-250716-74090', 'AMKA', '0778848512', 'Paid', '2025-08-01', '2025-08-01 17:45:15', 'NSAMBYA'),
(5, 'INV-250716-7', 'AMKA', '07788485', 'Paid', '2025-08-01', '2025-08-01 17:47:09', 'kajjansi'),
(6, '0016500', 'AMKA', '0778848512', 'Paid', '2025-08-01', '2025-08-01 17:49:34', 'kajjansi'),
(7, '00165109', 'AMKA', '0778848512', 'Paid', '2025-08-01', '2025-08-01 17:58:40', 'NSAMBYA'),
(8, 'INV-250716-744', 'AMKA', '0778848512', 'Paid', '2025-08-16', '2025-08-16 10:51:18', 'NSAMBYA'),
(9, 'INV-250716-745', 'AMKA', '0778848512', 'Paid', '2025-08-16', '2025-08-16 10:56:50', 'NSAMBYA');

-- --------------------------------------------------------

--
-- Table structure for table `invoice_payments`
--

CREATE TABLE `invoice_payments` (
  `payment_id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` date NOT NULL,
  `payment_method` enum('Cash','Check','Credit Card','Bank Transfer','Mobile Money') NOT NULL,
  `reference_number` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `invoice_payments`
--

INSERT INTO `invoice_payments` (`payment_id`, `invoice_id`, `amount`, `payment_date`, `payment_method`, `reference_number`, `notes`, `created_by`, `created_at`) VALUES
(1, 4, 70000.00, '2025-06-23', 'Cash', '', '', 2, '2025-06-23 16:49:02'),
(2, 4, 385450.00, '2025-06-23', 'Cash', '', '', 2, '2025-06-23 16:49:38');

-- --------------------------------------------------------

--
-- Table structure for table `journal_entries`
--

CREATE TABLE `journal_entries` (
  `entry_id` int(11) NOT NULL,
  `transaction_date` date NOT NULL,
  `reference_number` varchar(20) NOT NULL,
  `description` text DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `journal_items`
--

CREATE TABLE `journal_items` (
  `item_id` int(11) NOT NULL,
  `entry_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `debit_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `credit_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lab_orders`
--

CREATE TABLE `lab_orders` (
  `order_id` int(11) NOT NULL,
  `visit_id` int(11) NOT NULL,
  `admission_id` int(11) DEFAULT NULL,
  `doctor_id` int(11) NOT NULL,
  `test_id` int(11) NOT NULL,
  `order_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('Pending','Completed','Cancelled') DEFAULT 'Pending',
  `results` text DEFAULT NULL,
  `result_date` timestamp NULL DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `file_attachment` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lab_orders`
--

INSERT INTO `lab_orders` (`order_id`, `visit_id`, `admission_id`, `doctor_id`, `test_id`, `order_date`, `status`, `results`, `result_date`, `notes`, `file_attachment`) VALUES
(1, 4, NULL, 1, 1, '2025-06-05 08:36:31', 'Completed', 'malaria positvie', '2025-06-05 09:42:21', 'malaria', NULL),
(2, 4, NULL, 1, 4, '2025-06-05 09:11:44', 'Completed', 'hiv positive', '2025-06-05 09:42:33', 'hiv', NULL),
(3, 4, NULL, 1, 4, '2025-06-05 09:12:45', 'Completed', 'negative', '2025-06-05 09:42:54', 'hiv testing', NULL),
(4, 5, NULL, 1, 1, '2025-06-05 16:57:52', 'Completed', '+ve', '2025-06-05 17:11:25', 'malaria', NULL),
(5, 7, NULL, 1, 1, '2025-06-06 10:17:42', 'Completed', 'test results', '2025-06-06 10:19:21', 'check for malaria', NULL),
(6, 8, NULL, 1, 1, '2025-06-13 05:45:20', 'Completed', 'resutlsf', '2025-06-14 21:23:06', '', NULL),
(7, 8, NULL, 1, 1, '2025-06-14 21:44:40', 'Completed', 'd', '2025-06-14 21:45:49', '', NULL),
(8, 10, NULL, 1, 1, '2025-06-24 18:10:04', 'Completed', 'ihbuh', '2025-06-24 18:20:43', '', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `lab_tests`
--

CREATE TABLE `lab_tests` (
  `test_id` int(11) NOT NULL,
  `test_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `cost` decimal(10,2) NOT NULL,
  `normal_range` varchar(255) DEFAULT NULL,
  `sample_type` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lab_tests`
--

INSERT INTO `lab_tests` (`test_id`, `test_name`, `description`, `cost`, `normal_range`, `sample_type`) VALUES
(1, 'Complete Blood Count', 'Measures overall health and detects disorders like anemia or infection.', 25000.00, NULL, NULL),
(2, 'Liver Function Test', 'Checks the health of your liver by measuring levels of proteins and enzymes.', 30000.00, NULL, NULL),
(3, 'Malaria Test', 'Detects the presence of malaria parasites in the blood.', 10000.00, NULL, NULL),
(4, 'HIV Test', 'Detects antibodies to HIV infection.', 15000.00, NULL, NULL),
(5, 'COVID-19 PCR Test', 'Detects the genetic material of the virus using a lab technique called PCR.', 20000.00, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `medications`
--

CREATE TABLE `medications` (
  `medication_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `cost_per_unit` decimal(10,2) NOT NULL,
  `stock_quantity` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `medications`
--

INSERT INTO `medications` (`medication_id`, `name`, `description`, `cost_per_unit`, `stock_quantity`) VALUES
(1, 'panadol', '', 400.00, 60),
(2, 'PARACETAMOL', 'N/A', 500.00, 13),
(3, 'philip', '', 900.00, 80);

-- --------------------------------------------------------

--
-- Table structure for table `medication_batches`
--

CREATE TABLE `medication_batches` (
  `batch_id` int(11) NOT NULL,
  `medication_id` int(11) NOT NULL,
  `batch_number` varchar(50) NOT NULL,
  `manufacture_date` date NOT NULL,
  `expiry_date` date NOT NULL,
  `quantity_received` int(11) NOT NULL,
  `quantity_remaining` int(11) NOT NULL,
  `unit_cost` decimal(10,2) NOT NULL,
  `supplier` varchar(100) DEFAULT NULL,
  `received_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medication_usage`
--

CREATE TABLE `medication_usage` (
  `usage_id` int(11) NOT NULL,
  `prescription_id` int(11) NOT NULL,
  `batch_id` int(11) NOT NULL,
  `quantity_used` int(11) NOT NULL,
  `used_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `used_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications_pharm`
--

CREATE TABLE `notifications_pharm` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(4) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `type` enum('expiry','low_stock','system') NOT NULL,
  `related_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications_pharm`
--

INSERT INTO `notifications_pharm` (`id`, `user_id`, `title`, `message`, `is_read`, `created_at`, `type`, `related_id`) VALUES
(6, 1, 'Low Stock Alert', 'philip is running low. Current stock: 1', 0, '2025-07-15 20:05:14', 'low_stock', 915),
(7, 1, 'Low Stock Alert', '5ML SYRINGES is running low. Current stock: 10', 0, '2025-07-16 07:26:13', 'low_stock', 527),
(8, 1, 'Low Stock Alert', 'FRAMOL 500MG is running low. Current stock: 10', 0, '2025-07-17 07:20:29', 'low_stock', 916),
(9, 1, 'Product Expiring Soon', 'Amoxicillin 250mg (Batch: NOEL-24902-TESTSEST) expires on 2025-09-11', 0, '2025-08-16 13:32:52', 'expiry', 1387),
(10, 1, 'Product Expiring Soon', 'Antiseptic Cream 30g (Batch: BATCH006) expires on 2025-09-30', 0, '2025-09-08 16:11:36', 'expiry', 1390);

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `patient_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `date_of_birth` date NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `address` text DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `insurance_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`patient_id`, `first_name`, `last_name`, `date_of_birth`, `gender`, `address`, `phone`, `email`, `insurance_id`, `created_at`) VALUES
(1, 'EMMANUEL NOEL', 'RUTAHIGWA', '2002-06-04', 'Male', 'William Street', '+256783222564', 'rutahigwaemmanuelnoel@gmail.com', NULL, '2025-05-17 22:00:51'),
(2, 'CENTENARY', 'BANK', '2007-06-07', 'Male', 'William Street', '+256778485512', 'rutahigwaemmanuelnoel@gmail.com', NULL, '2025-05-21 03:51:04'),
(3, 'EMMANUEL NOEL', 'RUTAHIGWA', '2007-02-02', 'Male', 'William Street', '+256783222564', 'rutahigwaemmanuelnoel@gmail.com', NULL, '2025-05-28 08:14:22'),
(4, 'wagibi', 'philo', '2000-12-12', 'Male', 'William Street', '914-457-6842', 'rutahigwaemmanuelnoel@gmail.com', NULL, '2025-06-19 20:53:22'),
(5, 'jimmy', 'j', '2009-12-12', 'Male', 'William Street', '+256759411759', 'rutahigwaemmanuelnoel@gmail.com', NULL, '2025-06-19 21:10:45'),
(6, 'Deo', 'Mpalanyi', '2000-02-08', 'Male', '', '914-457-6842', 'example@gmail.com', NULL, '2025-06-27 18:13:41'),
(7, 'Elvis', 'Ntuyo', '1990-11-12', 'Male', 'mutungo', '0742020610', '', NULL, '2025-07-09 07:35:30'),
(8, 'martin', 'ssembuze', '1990-12-12', 'Male', 'William Street', '+256778485512', 'rutahigwaemmanuelnoel@gmail.com', NULL, '2025-07-09 11:42:35');

-- --------------------------------------------------------

--
-- Table structure for table `patient_insurance`
--

CREATE TABLE `patient_insurance` (
  `patient_insurance_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `insurance_id` int(11) NOT NULL,
  `policy_number` varchar(50) NOT NULL,
  `coverage_start` date NOT NULL,
  `coverage_end` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payment_terms`
--

CREATE TABLE `payment_terms` (
  `term_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `days` int(11) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment_terms`
--

INSERT INTO `payment_terms` (`term_id`, `name`, `days`, `description`) VALUES
(1, 'Due on Receipt', 0, 'Payment due immediately'),
(2, 'Net 15', 15, 'Payment due in 15 days'),
(3, 'Net 30', 30, 'Payment due in 30 days'),
(4, 'Net 60', 60, 'Payment due in 60 days');

-- --------------------------------------------------------

--
-- Table structure for table `pharmacy_details`
--

CREATE TABLE `pharmacy_details` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` text NOT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `prescriptions`
--

CREATE TABLE `prescriptions` (
  `prescription_id` int(11) NOT NULL,
  `visit_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `medication_id` int(11) NOT NULL,
  `dosage` varchar(100) NOT NULL,
  `frequency` varchar(100) NOT NULL,
  `duration` varchar(100) NOT NULL,
  `quantity` int(11) NOT NULL,
  `notes` text DEFAULT NULL,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `pharmacist_id` int(11) DEFAULT NULL,
  `approval_date` timestamp NULL DEFAULT NULL,
  `insurance_approved` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `prescriptions`
--

INSERT INTO `prescriptions` (`prescription_id`, `visit_id`, `doctor_id`, `medication_id`, `dosage`, `frequency`, `duration`, `quantity`, `notes`, `status`, `pharmacist_id`, `approval_date`, `insurance_approved`) VALUES
(1, 4, 1, 1, '500mg ', '3', '5 days', 0, '', 'Approved', NULL, '2025-06-05 10:31:59', 0),
(2, 5, 1, 1, '500mg ', '3', '5 days', 0, '', 'Approved', NULL, '2025-06-05 17:10:08', 0),
(3, 6, 1, 2, '500mg ', '3', '5 days', 0, '', 'Approved', NULL, '2025-06-06 09:12:29', 0),
(4, 6, 1, 1, '500mg ', '3', '5 days', 0, '', 'Approved', NULL, '2025-06-06 09:12:32', 0),
(5, 7, 1, 1, '500mg ', '3', '5 days', 0, '', 'Approved', NULL, '2025-06-06 10:21:44', 0),
(6, 6, 1, 1, '500mg ', '3', '5 days', 10, NULL, 'Approved', NULL, '2025-06-11 21:11:04', 0),
(7, 6, 1, 2, '500mg ', '3', '5 days', 30, NULL, 'Approved', NULL, '2025-06-11 21:11:06', 0),
(8, 6, 1, 3, '500mg ', '3', '5 days', 20, NULL, 'Approved', NULL, '2025-06-11 21:30:20', 0),
(9, 6, 1, 2, '500mg ', '3', '5 days', 1998, NULL, 'Approved', NULL, '2025-06-11 21:33:25', 0),
(10, 6, 1, 2, '500mg ', '3', '5 days', 1997, NULL, 'Approved', NULL, '2025-06-11 21:37:34', 0),
(11, 6, 1, 2, '500mg ', '3', '5 days', 20, NULL, 'Approved', NULL, '2025-06-13 05:47:51', 0),
(12, 8, 1, 1, '500mg ', '3', '5 days', 15, NULL, 'Approved', NULL, '2025-06-13 05:47:53', 0),
(13, 10, 1, 1, '500mg ', '3', '5 days', 10, NULL, 'Approved', NULL, '2025-06-24 19:41:57', 0),
(14, 13, 1, 2, '500mg ', '3', '5 days', 10, NULL, 'Pending', NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `procedures`
--

CREATE TABLE `procedures` (
  `procedure_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `cost` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `procurement_items_pharm`
--

CREATE TABLE `procurement_items_pharm` (
  `id` int(11) NOT NULL,
  `procurement_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `procurement_pharm`
--

CREATE TABLE `procurement_pharm` (
  `id` int(11) NOT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `invoice_date` date NOT NULL,
  `payment_status` enum('paid','credit') NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `created_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products_pharm`
--

CREATE TABLE `products_pharm` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `batch_number` varchar(50) NOT NULL,
  `quantity` decimal(10,2) DEFAULT NULL,
  `buying_price` decimal(10,2) NOT NULL,
  `selling_price` decimal(10,2) NOT NULL,
  `expiry_date` varchar(10) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `minimum_stock_level` int(11) DEFAULT 10,
  `barcode` varchar(50) DEFAULT NULL,
  `unit_type` varchar(20) DEFAULT NULL,
  `invoice_number` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products_pharm`
--

INSERT INTO `products_pharm` (`id`, `name`, `description`, `category_id`, `batch_number`, `quantity`, `buying_price`, `selling_price`, `expiry_date`, `supplier_id`, `created_at`, `updated_at`, `minimum_stock_level`, `barcode`, `unit_type`, `invoice_number`) VALUES
(1375, 'Paracetamol 500mg', 'Pain relief tablets', NULL, 'BATCH001', 61.70, 15.50, 25.00, '2025-12-31', NULL, '2025-07-24 07:38:37', '2025-08-06 21:35:01', 10, 'PARA001', 'tablet', NULL),
(1376, 'Ibuprofen 200mg', 'Anti-inflammatory pain relief', NULL, 'BATCH002', 50.00, 12.75, 20.00, '2026-06-15', NULL, '2025-07-24 07:38:37', NULL, 5, 'IBU002', 'tablet', NULL),
(1377, 'Amoxicillin 250mg', 'Antibiotic capsules', NULL, 'BATCH479JB67X', 404.70, 1000.00, 1200.00, '2027-12-12', NULL, '2025-07-24 07:38:37', '2025-08-06 21:35:01', 3, '20250801200318292', 'strp', NULL),
(1378, 'Vitamin C 1000mg', 'Immune support tablets', NULL, 'NOEL-24902-TESTS', 230.00, 200.00, 500.00, '2025-07-23', NULL, '2025-07-24 07:38:37', '2025-07-24 07:50:51', 20, '20250724065024945', 'syp', NULL),
(1379, 'Cough Syrup 100ml', 'Chesty cough relief', NULL, 'BATCH005', 15.00, 18.50, 30.00, '2025-12-31', NULL, '2025-07-24 07:38:37', NULL, 2, 'SYRP005', 'syrup', NULL),
(1380, 'Antiseptic Cream 30g', 'Skin infection treatment', NULL, 'NOEL-24902-TESTAS', 74.00, 100.00, 200.00, '2029-12-12', NULL, '2025-07-24 07:38:37', '2025-08-01 21:09:30', 3, '20250801200238100', 'strp', NULL),
(1381, 'Bandages 10cm x 4m', 'Wound dressing', NULL, 'BATCH007', 40.00, 12.00, 20.00, '2028-01-01', NULL, '2025-07-24 07:38:37', NULL, 5, 'BAND007', 'roll', NULL),
(1382, 'Thermometer Digital', 'Fever measurement', NULL, 'BATCH008', 10.00, 150.00, 250.00, '2030-05-15', NULL, '2025-07-24 07:38:37', NULL, 2, 'THER008', 'pce', NULL),
(1383, 'Hand Sanitizer 500ml', 'Alcohol-based sanitizer', NULL, 'BATCH009', 20.00, 35.00, 60.00, '2026-08-31', NULL, '2025-07-24 07:38:37', NULL, 5, 'SANI009', 'bottle', NULL),
(1384, 'First Aid Kit', 'Basic medical supplies', NULL, 'BATCH010', 5.00, 450.00, 750.00, '2027-12-31', NULL, '2025-07-24 07:38:37', NULL, 1, 'KIT010', 'kit', NULL),
(1385, 'Paracetamol 500mg', 'Pain relief tablets', NULL, 'BATCH001', 100.00, 15.50, 25.00, '2025-12-31', NULL, '2025-08-02 13:04:52', NULL, 10, 'BAR001', 'tablet', NULL),
(1386, 'Ibuprofen 200mg', 'Anti-inflammatory pain relief', NULL, 'BATCH002', 50.00, 12.75, 20.00, '2026-06-15', NULL, '2025-08-02 13:04:52', NULL, 5, 'BAR002', 'tablet', NULL),
(1387, 'Amoxicillin 250mg -', 'Antibiotic capsules', NULL, 'NOEL-24902-TESTSEST', 1130.00, 45.00, 75.00, '2025-09-11', NULL, '2025-08-02 13:04:52', '2025-08-16 14:52:05', 2, '20250816125626487', 'strp', 'INV-250716-745'),
(1388, 'Vitamin C 1000mg', 'Immune support tablets', NULL, 'BATCH004', 200.00, 8.25, 15.00, '2027-03-15', NULL, '2025-08-02 13:04:52', NULL, 20, 'BAR004', 'tablet', NULL),
(1389, 'Cough Syrup 100ml', 'Chesty cough relief', NULL, 'BATCH005', 15.00, 18.50, 30.00, '2025-12-31', NULL, '2025-08-02 13:04:52', NULL, 2, 'BAR005', 'syrup', NULL),
(1390, 'Antiseptic Cream 30g', 'Skin infection treatment', NULL, 'BATCH006', 25.00, 22.00, 35.00, '2025-09-30', NULL, '2025-08-02 13:04:52', NULL, 3, 'BAR006', 'cream', NULL),
(1391, 'Bandages 10cm x 4m', 'Wound dressing', NULL, 'BATCH007', 40.00, 12.00, 20.00, '2028-01-01', NULL, '2025-08-02 13:04:52', NULL, 5, 'BAR007', 'roll', NULL),
(1392, 'Thermometer Digital', 'Fever measurement', NULL, 'BATCH008', 10.00, 150.00, 250.00, '2030-05-15', NULL, '2025-08-02 13:04:52', NULL, 2, 'BAR008', 'pce', NULL),
(1393, 'Hand Sanitizer 500ml', 'Alcohol-based sanitizer', NULL, 'BATCH009', 20.00, 35.00, 60.00, '2026-08-31', NULL, '2025-08-02 13:04:52', NULL, 5, 'BAR009', 'bottle', NULL),
(1394, 'First Aid Kit', 'Basic medical supplies', NULL, 'BATCH010', 5.00, 450.00, 750.00, '2027-12-31', NULL, '2025-08-02 13:04:52', NULL, 1, 'BAR010', 'kit', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_batches_pharm`
--

CREATE TABLE `product_batches_pharm` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `batch_number` varchar(50) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `buying_price` decimal(10,2) DEFAULT NULL,
  `selling_price` decimal(10,2) DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `archived_at` datetime DEFAULT current_timestamp(),
  `unit_type` varchar(10) DEFAULT NULL,
  `invoice_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_batches_pharm`
--

INSERT INTO `product_batches_pharm` (`id`, `product_id`, `name`, `description`, `batch_number`, `quantity`, `buying_price`, `selling_price`, `expiry_date`, `barcode`, `archived_at`, `unit_type`, `invoice_id`) VALUES
(10, 1377, '', NULL, 'BATCH003', 30, 45.00, 75.00, '2024-11-30', 'AMOX003', '2025-07-24 07:47:35', 'capsule', 1),
(11, 1380, '', NULL, 'BATCH006', 25, 22.00, 35.00, '2025-09-30', 'ANTI006', '2025-07-24 07:50:12', 'cream', 2),
(12, 1378, '', NULL, 'BATCH004', 200, 8.25, 15.00, '2027-03-15', 'VITC004', '2025-07-24 07:50:51', 'tablet', 2),
(13, 1377, '', NULL, '230424-01210', 50, 200.00, 400.00, '2027-12-12', '20250724063856260', '2025-07-27 19:32:48', 'pce', 3),
(14, 1377, '', NULL, 'BATCH479JB67io', 120, 900.00, 1000.00, '2025-09-04', '20250727183220265', '2025-07-27 19:36:39', 'inj', 3),
(15, 1377, '', NULL, 'BATCH479JB67io', 190, 900.00, 1000.00, '2025-09-04', '20250727183220265', '2025-08-01 20:45:15', 'inj', 4),
(16, 1377, '', NULL, '230424-0090', 290, 400.00, 500.00, '2027-12-12', '20250801193856896', '2025-08-01 20:47:09', 'strp', 5),
(17, 1377, '', NULL, '230424-011', 300, 100.00, 120.00, '2025-12-12', '20250801194626645', '2025-08-01 20:49:34', 'strp', 6),
(18, 1377, '', NULL, '230424-091291', 400, 100.00, 120.00, '2025-12-12', '20250801194904890', '2025-08-01 20:58:40', 'strp', 7),
(19, 1380, '', NULL, '230424-01s', 45, 100.00, 200.00, '2025-07-23', '20250724064944280', '2025-08-01 20:59:36', 'strp', 7),
(20, 1380, '', NULL, '230424-0900009', 55, 100.00, 100.00, '2025-12-12', '20250801195902593', '2025-08-01 21:00:47', 'strp', 7),
(21, 1377, '', NULL, '230424-09099', 410, 100.00, 120.00, '2025-12-12', '20250801195803622', '2025-08-01 21:02:00', 'strp', 7),
(22, 1380, '', NULL, 'NOEL-24902-TESTs', 65, 100.00, 1000.00, '2027-12-12', '20250801200004644', '2025-08-01 21:03:08', 'inj', 7),
(23, 1377, '', NULL, 'NOEL-24902-TESTX', 420, 100.00, 200.00, '2029-12-12', '20250801200120123', '2025-08-01 21:03:55', 'inj', 7),
(24, 1387, '', NULL, 'BATCH003', 30, 45.00, 75.00, '2024-11-30', 'BAR003', '2025-08-16 13:51:18', 'strp', 8),
(25, 1387, '', NULL, '230424-012', 130, 45.00, 75.00, '2025-08-29', '20250816125051920', '2025-08-16 13:56:50', 'strp', 9);

-- --------------------------------------------------------

--
-- Stand-in structure for view `profit_loss_summary`
-- (See below for the actual view)
--
CREATE TABLE `profit_loss_summary` (
`period_id` int(11)
,`period_name` varchar(50)
,`start_date` date
,`end_date` date
,`total_revenue` decimal(35,2)
,`total_expenses` decimal(35,2)
,`net_profit` decimal(36,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `radiology_orders`
--

CREATE TABLE `radiology_orders` (
  `order_id` int(11) NOT NULL,
  `visit_id` int(11) NOT NULL,
  `admission_id` int(11) DEFAULT NULL,
  `doctor_id` int(11) NOT NULL,
  `radiology_id` int(11) NOT NULL,
  `order_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('Pending','Completed','Cancelled') DEFAULT 'Pending',
  `results` text DEFAULT NULL,
  `result_date` timestamp NULL DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `file_attachment` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `radiology_orders`
--

INSERT INTO `radiology_orders` (`order_id`, `visit_id`, `admission_id`, `doctor_id`, `radiology_id`, `order_date`, `status`, `results`, `result_date`, `notes`, `file_attachment`) VALUES
(1, 4, NULL, 1, 2, '2025-06-05 05:03:07', 'Completed', 'N/A', '2025-06-05 10:28:14', 'notes', NULL),
(2, 4, NULL, 1, 2, '2025-06-05 08:47:17', 'Completed', 'N/A', '2025-06-05 10:28:25', 'pain', NULL),
(3, 4, NULL, 1, 3, '2025-06-05 08:58:43', 'Completed', 'N/A', '2025-06-05 10:28:34', 'pains', NULL),
(4, 4, NULL, 1, 4, '2025-06-05 09:08:51', 'Completed', 'N/A', '2025-06-05 10:28:42', 'spine pain', NULL),
(5, 5, NULL, 1, 2, '2025-06-05 16:58:04', 'Completed', 'zero', '2025-06-05 17:12:49', 'pain', NULL),
(6, 8, NULL, 1, 2, '2025-06-13 05:45:42', 'Completed', 'djw fjs', '2025-06-24 18:12:13', '', NULL),
(7, 10, NULL, 1, 2, '2025-06-24 18:10:13', 'Completed', 'irnwns', '2025-06-24 18:12:03', '', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `radiology_tests`
--

CREATE TABLE `radiology_tests` (
  `radiology_id` int(11) NOT NULL,
  `test_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `cost` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `radiology_tests`
--

INSERT INTO `radiology_tests` (`radiology_id`, `test_name`, `description`, `cost`) VALUES
(1, 'Chest X-Ray', 'Imaging test that uses X-rays to look at the lungs, heart, and chest wall.', 40000.00),
(2, 'Abdominal Ultrasound', 'Uses sound waves to visualize abdominal organs such as the liver and kidneys.', 50000.00),
(3, 'CT Scan - Head', 'Detailed imaging of the head and brain using computed tomography.', 120000.00),
(4, 'MRI - Spine', 'Magnetic resonance imaging to assess spinal cord and vertebrae.', 180000.00),
(5, 'Mammography', 'X-ray imaging of the breast to detect abnormalities or cancer.', 60000.00);

-- --------------------------------------------------------

--
-- Stand-in structure for view `revenue_by_service_type`
-- (See below for the actual view)
--
CREATE TABLE `revenue_by_service_type` (
`service_type` varchar(12)
,`service_count` bigint(21)
,`total_revenue` decimal(42,2)
,`month` int(2)
,`year` int(4)
);

-- --------------------------------------------------------

--
-- Table structure for table `sales_pharm`
--

CREATE TABLE `sales_pharm` (
  `id` int(11) NOT NULL,
  `invoice_number` varchar(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `customer_name` varchar(100) DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `discount` decimal(10,2) DEFAULT 0.00,
  `tax` decimal(10,2) DEFAULT 0.00,
  `net_amount` decimal(10,2) NOT NULL,
  `payment_method` enum('cash','card','mobile_money') NOT NULL,
  `date` datetime DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales_pharm`
--

INSERT INTO `sales_pharm` (`id`, `invoice_number`, `user_id`, `customer_name`, `total_amount`, `discount`, `tax`, `net_amount`, `payment_method`, `date`, `notes`) VALUES
(1, 'INV-20250711-0C3105', 6, 'Walk-in Custo', 600.00, 0.00, 0.00, 600.00, 'cash', '2025-07-11 23:50:08', NULL),
(2, 'INV-20250711-0134E3', 6, 'Walk-in Custo', 600.00, 0.00, 0.00, 600.00, 'cash', '2025-07-11 23:56:48', NULL),
(3, 'INV-20250711-C85D2A', 6, 'Walk-in Customer', 2000.00, 0.00, 0.00, 2000.00, 'cash', '2025-07-11 23:57:48', NULL),
(4, 'INV-20250712-300CBD', 6, 'Walk-in Customer', 5000.00, 0.00, 0.00, 5000.00, 'cash', '2025-07-12 00:08:03', NULL),
(5, 'INV-20250714-0C2B03', 6, 'Walk-in Customer', 2400.00, 0.00, 0.00, 2400.00, 'cash', '2025-07-14 10:14:24', NULL),
(6, 'INV-20250714-2C261C', 6, 'Walk-in Customer', 112000.00, 0.00, 0.00, 112000.00, 'cash', '2025-07-14 11:11:30', NULL),
(7, 'INV1752689577', 6, 'Walk-in Customer', 5.00, 0.00, 0.00, 0.00, 'cash', '2025-07-16 20:12:57', NULL),
(8, 'INV1752725370', 6, 'Walk-in Customer', 56000.00, 0.00, 0.00, 0.00, 'cash', '2025-07-17 06:09:30', NULL),
(9, 'INV1752725506', 6, 'Walk-in Customer', 1400.00, 0.00, 0.00, 0.00, 'cash', '2025-07-17 06:11:46', NULL),
(10, 'INV1752726263', 6, 'Walk-in Customer', 5600.00, 0.00, 0.00, 0.00, 'cash', '2025-07-17 06:24:23', NULL),
(11, 'INV1752729952', 6, 'Walk-in Customer', 13500.00, 0.00, 0.00, 0.00, 'cash', '2025-07-17 07:25:52', NULL),
(12, 'INV1752827474', 6, 'Walk-in Customer', 32000.00, 0.00, 0.00, 0.00, 'cash', '2025-07-18 10:31:14', NULL),
(13, 'INV1752964762', 6, 'Walk-in Customer', 879000.00, 0.00, 0.00, 0.00, 'cash', '2025-07-20 00:39:22', NULL),
(14, 'INV1753634471', 6, 'noel', 250.00, 0.00, 0.00, 0.00, 'cash', '2025-07-27 18:41:11', NULL),
(15, 'INV1753635003', 6, 'noel', 250.00, 0.00, 0.00, 0.00, 'cash', '2025-07-27 18:50:03', NULL),
(16, 'INV1754071770', 6, 'phillipo', 200.00, 0.00, 0.00, 0.00, 'cash', '2025-08-01 20:09:30', NULL),
(17, 'INV1754072793', 6, 'phillipo', 100.00, 0.00, 0.00, 0.00, 'cash', '2025-08-01 20:26:33', NULL),
(18, 'INV1754073329', 6, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', '2025-08-01 20:35:29', NULL),
(19, 'INV1754499918', 6, 'noel', 0.00, 0.00, 0.00, 0.00, 'cash', '2025-08-06 19:05:18', NULL),
(20, 'INV1754500187', 6, 'Walk-in Customer', 14037.50, 0.00, 0.00, 0.00, 'cash', '2025-08-06 19:09:47', NULL),
(21, 'INV1754500954', 6, 'Walk-in Customer', 10780.00, 0.00, 0.00, 0.00, 'cash', '2025-08-06 19:22:34', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sale_items_pharm`
--

CREATE TABLE `sale_items_pharm` (
  `id` int(11) NOT NULL,
  `sale_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` decimal(10,2) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sale_items_pharm`
--

INSERT INTO `sale_items_pharm` (`id`, `sale_id`, `product_id`, `quantity`, `price`, `total`) VALUES
(25, 14, 1375, 10.00, 25.00, 250.00),
(26, 15, 1375, 10.00, 25.00, 250.00),
(27, 16, 1380, 1.00, 200.00, 200.00),
(28, 17, 1375, 1.00, 100.00, 100.00),
(29, 18, 1377, 5.00, 2000.00, 10000.00),
(30, 19, 1375, 0.00, 500.00, 0.00),
(31, 19, 1377, 0.00, 1200.00, 0.00),
(42, 21, 1375, 8.80, 25.00, 220.00),
(43, 21, 1377, 8.80, 1200.00, 10560.00),
(44, 20, 1375, 9.50, 25.00, 237.50),
(45, 20, 1377, 11.50, 1200.00, 13800.00);

-- --------------------------------------------------------

--
-- Table structure for table `stock_movements_pharm`
--

CREATE TABLE `stock_movements_pharm` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `movement_type` enum('purchase','sale','adjustment','return') NOT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sundries`
--

CREATE TABLE `sundries` (
  `sundry_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `cost_per_unit` decimal(10,2) NOT NULL,
  `stock_quantity` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sundries`
--

INSERT INTO `sundries` (`sundry_id`, `name`, `description`, `cost_per_unit`, `stock_quantity`, `created_at`) VALUES
(1, 'cotton', '', 500.00, 5, '2025-06-13 20:31:24');

-- --------------------------------------------------------

--
-- Table structure for table `sundry_orders`
--

CREATE TABLE `sundry_orders` (
  `order_id` int(11) NOT NULL,
  `visit_id` int(11) DEFAULT NULL,
  `admission_id` int(11) DEFAULT NULL,
  `procedure_id` int(11) DEFAULT NULL,
  `sundry_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `order_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('Pending','Delivered','Cancelled') DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `suppliers_pharm`
--

CREATE TABLE `suppliers_pharm` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `theaters`
--

CREATE TABLE `theaters` (
  `theater_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `status` enum('Available','In Use','Maintenance') DEFAULT 'Available',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `theaters`
--

INSERT INTO `theaters` (`theater_id`, `name`, `description`, `status`, `created_at`) VALUES
(1, 'philip', 'for', 'Available', '2025-06-14 14:59:18'),
(2, 'RUTAHIGWA EMMANUEL NOEL', 'plsu', 'Available', '2025-06-14 14:59:30');

-- --------------------------------------------------------

--
-- Table structure for table `theater_procedures`
--

CREATE TABLE `theater_procedures` (
  `procedure_id` int(11) NOT NULL,
  `visit_id` int(11) NOT NULL,
  `theater_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `procedure_name` varchar(100) NOT NULL,
  `procedure_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `duration_minutes` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `status` enum('Scheduled','In Progress','Completed','Cancelled') DEFAULT 'Scheduled'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `triage`
--

CREATE TABLE `triage` (
  `triage_id` int(11) NOT NULL,
  `visit_id` int(11) NOT NULL,
  `nurse_id` int(11) NOT NULL,
  `blood_pressure` varchar(20) DEFAULT NULL,
  `temperature` decimal(5,2) DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `height` decimal(5,2) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `triage`
--

INSERT INTO `triage` (`triage_id`, `visit_id`, `nurse_id`, `blood_pressure`, `temperature`, `weight`, `height`, `notes`, `created_at`) VALUES
(1, 1, 5, '', 0.00, 0.00, 0.00, '', '2025-05-17 22:34:31'),
(2, 3, 4, '120/80', 37.00, 120.00, 170.00, '', '2025-05-28 08:16:24'),
(3, 2, 4, '120/80', 37.00, 90.00, 200.00, '', '2025-06-02 12:41:23'),
(4, 5, 4, '120/80', 37.00, 70.00, 200.00, '', '2025-06-05 16:56:51'),
(5, 6, 4, '120/80', 37.00, 120.00, 175.00, '', '2025-06-06 09:10:04'),
(6, 7, 4, '120/80', 37.00, 120.00, 200.00, '', '2025-06-06 10:16:14'),
(7, 8, 4, '120/80', 37.00, 120.00, 200.00, '', '2025-06-13 05:44:04'),
(8, 10, 4, '120/80', 37.00, 200.00, 175.00, '', '2025-06-24 18:05:43');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('Admin','Doctor','Nurse','Receptionist','Lab Technician','Radiologist','Pharmacist','Finance') NOT NULL,
  `related_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `role`, `related_id`, `created_at`) VALUES
(1, 'admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Admin', NULL, '2025-05-17 21:13:31'),
(2, 'EmmanuelNoel', '46912445405c7dda1f0087c64a392f58c0476af6ac1f67a98b82d329ef6dd69d', 'Admin', NULL, '2025-05-17 21:52:25'),
(3, 'sanlam.insurance', '580f41d83bdd8d09e5c5a3b5e7c775bd7ece1370d23f930c764284b5e3226b9e', 'Receptionist', NULL, '2025-05-17 21:59:30'),
(4, 'PRCHMC', '580f41d83bdd8d09e5c5a3b5e7c775bd7ece1370d23f930c764284b5e3226b9e', 'Nurse', 4, '2025-05-17 22:04:35'),
(6, 'emmanoel', '580f41d83bdd8d09e5c5a3b5e7c775bd7ece1370d23f930c764284b5e3226b9e', 'Doctor', 1, '2025-05-17 22:35:59'),
(7, 'deo', '580f41d83bdd8d09e5c5a3b5e7c775bd7ece1370d23f930c764284b5e3226b9e', 'Pharmacist', NULL, '2025-06-04 05:09:56'),
(8, 'noel', '580f41d83bdd8d09e5c5a3b5e7c775bd7ece1370d23f930c764284b5e3226b9e', 'Lab Technician', NULL, '2025-06-04 11:32:49'),
(9, 'emma', '580f41d83bdd8d09e5c5a3b5e7c775bd7ece1370d23f930c764284b5e3226b9e', 'Radiologist', NULL, '2025-06-05 10:27:30'),
(13, 'testing', '580f41d83bdd8d09e5c5a3b5e7c775bd7ece1370d23f930c764284b5e3226b9e', 'Finance', NULL, '2025-06-22 12:42:48');

-- --------------------------------------------------------

--
-- Table structure for table `users_pharm`
--

CREATE TABLE `users_pharm` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','pharmacist') NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `last_login` datetime DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_pharm`
--

INSERT INTO `users_pharm` (`id`, `username`, `password`, `role`, `full_name`, `email`, `phone`, `created_at`, `last_login`, `status`) VALUES
(6, 'EmmanuelNoel', 'aVlDM1p1Ym1RQWpyK0laMUREN25QQT09OjoMsG0rdxp+X5PA5NjRI0D7', 'admin', 'System Admin', 'admin@noel.com', '+2567000000000', '2025-07-11 20:05:40', '2025-09-08 17:38:47', 1),
(13, 'sanlam.insurance', 'cGlKN0hNNnRxT25HWCtYeTliR0tZQT09Ojq0/Dqroa07PLQxOO4vPwA7', 'pharmacist', 'RUTAHIGWA EMML', 'rutsnoel@gmail.com', '+256778485510', '2025-07-21 22:23:37', '2025-08-03 17:06:23', 1);

-- --------------------------------------------------------

--
-- Table structure for table `vendors`
--

CREATE TABLE `vendors` (
  `vendor_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `tax_id` varchar(50) DEFAULT NULL,
  `account_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `visits`
--

CREATE TABLE `visits` (
  `visit_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `visit_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `visit_number` varchar(20) NOT NULL,
  `status` enum('Active','Completed','Cancelled') DEFAULT 'Active',
  `payment_type` enum('Cash','Insurance') DEFAULT 'Cash',
  `policy_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `visits`
--

INSERT INTO `visits` (`visit_id`, `patient_id`, `doctor_id`, `visit_date`, `visit_number`, `status`, `payment_type`, `policy_id`) VALUES
(1, 1, 1, '2025-05-17 22:02:56', 'VN202505182600', '', 'Cash', NULL),
(2, 2, 1, '2025-05-21 03:51:21', 'VN202505219840', '', 'Cash', NULL),
(3, 2, 1, '2025-05-28 08:14:45', 'VN202505284527', '', 'Cash', NULL),
(4, 2, 1, '2025-06-02 12:58:10', 'VN202506020228', NULL, 'Cash', NULL),
(5, 2, 1, '2025-06-05 16:55:39', 'VN202506055949', '', 'Cash', NULL),
(6, 1, 1, '2025-06-06 09:08:56', 'VN202506066888', '', 'Cash', NULL),
(7, 2, 1, '2025-06-06 10:15:15', 'VN202506064974', '', 'Cash', NULL),
(8, 1, 1, '2025-06-13 05:42:50', 'VN202506136531', '', 'Cash', NULL),
(9, 5, 1, '2025-06-19 21:38:22', 'VN202506195620', '', 'Cash', NULL),
(10, 5, 1, '2025-06-24 17:57:23', 'VN202506241704', 'Active', 'Cash', NULL),
(11, 6, 1, '2025-06-27 18:14:14', 'VN202506270754', 'Active', 'Insurance', 2),
(12, 7, 1, '2025-07-09 07:36:05', 'VN202507090085', 'Active', 'Insurance', 3),
(13, 8, 1, '2025-07-09 11:43:04', 'VN202507090532', 'Active', 'Insurance', 4);

-- --------------------------------------------------------

--
-- Table structure for table `wards`
--

CREATE TABLE `wards` (
  `ward_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `capacity` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `type` enum('General','Private') NOT NULL DEFAULT 'General'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wards`
--

INSERT INTO `wards` (`ward_id`, `name`, `description`, `capacity`, `created_at`, `type`) VALUES
(1, 'MBAHE ISINGOMA', '', 7, '2025-06-14 15:09:52', 'General'),
(2, 'RUTAHIGWA EMMANUEL NOEL', '', 5, '2025-06-14 18:46:13', 'General'),
(3, 'Edgar Kasirye', '', 10, '2025-06-14 19:14:09', 'General'),
(4, 'MBAHE ISINGOMA', '', 1, '2025-06-14 19:16:42', 'General');

-- --------------------------------------------------------

--
-- Structure for view `ap_aging`
--
DROP TABLE IF EXISTS `ap_aging`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ap_aging`  AS SELECT `b`.`bill_id` AS `bill_id`, `b`.`vendor_id` AS `vendor_id`, `v`.`name` AS `vendor_name`, `b`.`total_amount` AS `total_amount`, `b`.`amount_paid` AS `amount_paid`, `b`.`total_amount`- `b`.`amount_paid` AS `balance`, `b`.`due_date` AS `due_date`, CASE WHEN `b`.`due_date` >= curdate() THEN 'Current' WHEN to_days(curdate()) - to_days(`b`.`due_date`) between 1 and 30 THEN '1-30 Days' WHEN to_days(curdate()) - to_days(`b`.`due_date`) between 31 and 60 THEN '31-60 Days' WHEN to_days(curdate()) - to_days(`b`.`due_date`) between 61 and 90 THEN '61-90 Days' ELSE 'Over 90 Days' END AS `aging_bucket` FROM (`bills` `b` join `vendors` `v` on(`b`.`vendor_id` = `v`.`vendor_id`)) WHERE `b`.`status` <> 'Paid' AND `b`.`total_amount` - `b`.`amount_paid` > 0 ;

-- --------------------------------------------------------

--
-- Structure for view `ar_aging`
--
DROP TABLE IF EXISTS `ar_aging`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ar_aging`  AS SELECT `i`.`invoice_id` AS `invoice_id`, `i`.`visit_id` AS `visit_id`, `v`.`patient_id` AS `patient_id`, concat(`p`.`first_name`,' ',`p`.`last_name`) AS `patient_name`, `i`.`total_amount` AS `total_amount`, `i`.`amount_paid` AS `amount_paid`, `i`.`total_amount`- `i`.`amount_paid` AS `balance`, `i`.`due_date` AS `due_date`, CASE WHEN `i`.`due_date` >= curdate() THEN 'Current' WHEN to_days(curdate()) - to_days(`i`.`due_date`) between 1 and 30 THEN '1-30 Days' WHEN to_days(curdate()) - to_days(`i`.`due_date`) between 31 and 60 THEN '31-60 Days' WHEN to_days(curdate()) - to_days(`i`.`due_date`) between 61 and 90 THEN '61-90 Days' ELSE 'Over 90 Days' END AS `aging_bucket` FROM ((`invoices` `i` join `visits` `v` on(`i`.`visit_id` = `v`.`visit_id`)) join `patients` `p` on(`v`.`patient_id` = `p`.`patient_id`)) WHERE `i`.`payment_status` <> 'Paid' AND `i`.`total_amount` - `i`.`amount_paid` > 0 ;

-- --------------------------------------------------------

--
-- Structure for view `profit_loss_summary`
--
DROP TABLE IF EXISTS `profit_loss_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `profit_loss_summary`  AS SELECT `fp`.`period_id` AS `period_id`, `fp`.`name` AS `period_name`, `fp`.`start_date` AS `start_date`, `fp`.`end_date` AS `end_date`, (select ifnull(sum(`ji`.`debit_amount` - `ji`.`credit_amount`),0) from ((`journal_items` `ji` join `journal_entries` `je` on(`ji`.`entry_id` = `je`.`entry_id`)) join `accounts` `a` on(`ji`.`account_id` = `a`.`account_id`)) where `a`.`account_type` = 'Revenue' and `je`.`transaction_date` between `fp`.`start_date` and `fp`.`end_date`) AS `total_revenue`, (select ifnull(sum(`ji`.`debit_amount` - `ji`.`credit_amount`),0) from ((`journal_items` `ji` join `journal_entries` `je` on(`ji`.`entry_id` = `je`.`entry_id`)) join `accounts` `a` on(`ji`.`account_id` = `a`.`account_id`)) where `a`.`account_type` = 'Expense' and `je`.`transaction_date` between `fp`.`start_date` and `fp`.`end_date`) AS `total_expenses`, (select ifnull(sum(`ji`.`debit_amount` - `ji`.`credit_amount`),0) from ((`journal_items` `ji` join `journal_entries` `je` on(`ji`.`entry_id` = `je`.`entry_id`)) join `accounts` `a` on(`ji`.`account_id` = `a`.`account_id`)) where `a`.`account_type` = 'Revenue' and `je`.`transaction_date` between `fp`.`start_date` and `fp`.`end_date`) - (select ifnull(sum(`ji`.`debit_amount` - `ji`.`credit_amount`),0) from ((`journal_items` `ji` join `journal_entries` `je` on(`ji`.`entry_id` = `je`.`entry_id`)) join `accounts` `a` on(`ji`.`account_id` = `a`.`account_id`)) where `a`.`account_type` = 'Expense' and `je`.`transaction_date` between `fp`.`start_date` and `fp`.`end_date`) AS `net_profit` FROM `financial_periods` AS `fp` ;

-- --------------------------------------------------------

--
-- Structure for view `revenue_by_service_type`
--
DROP TABLE IF EXISTS `revenue_by_service_type`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `revenue_by_service_type`  AS SELECT 'Consultation' AS `service_type`, count(0) AS `service_count`, sum(`i`.`total_amount`) AS `total_revenue`, month(`i`.`created_at`) AS `month`, year(`i`.`created_at`) AS `year` FROM (`invoices` `i` join `visits` `v` on(`i`.`visit_id` = `v`.`visit_id`)) WHERE `i`.`payment_status` <> 'Cancelled' GROUP BY year(`i`.`created_at`), month(`i`.`created_at`)union all select 'Lab Tests' AS `service_type`,count(0) AS `service_count`,sum(`lt`.`cost`) AS `total_revenue`,month(`lo`.`order_date`) AS `month`,year(`lo`.`order_date`) AS `year` from ((`lab_orders` `lo` join `lab_tests` `lt` on(`lo`.`test_id` = `lt`.`test_id`)) join `invoices` `i` on(`lo`.`visit_id` = `i`.`visit_id`)) where `lo`.`status` = 'Completed' and `i`.`payment_status` <> 'Cancelled' group by year(`lo`.`order_date`),month(`lo`.`order_date`) union all select 'Radiology' AS `service_type`,count(0) AS `service_count`,sum(`rt`.`cost`) AS `total_revenue`,month(`ro`.`order_date`) AS `month`,year(`ro`.`order_date`) AS `year` from ((`radiology_orders` `ro` join `radiology_tests` `rt` on(`ro`.`radiology_id` = `rt`.`radiology_id`)) join `invoices` `i` on(`ro`.`visit_id` = `i`.`visit_id`)) where `ro`.`status` = 'Completed' and `i`.`payment_status` <> 'Cancelled' group by year(`ro`.`order_date`),month(`ro`.`order_date`) union all select 'Medications' AS `service_type`,count(0) AS `service_count`,sum(`p`.`quantity` * `m`.`cost_per_unit`) AS `total_revenue`,month(`p`.`approval_date`) AS `month`,year(`p`.`approval_date`) AS `year` from ((`prescriptions` `p` join `medications` `m` on(`p`.`medication_id` = `m`.`medication_id`)) join `invoices` `i` on(`p`.`visit_id` = `i`.`visit_id`)) where `p`.`status` = 'Approved' and `i`.`payment_status` <> 'Cancelled' group by year(`p`.`approval_date`),month(`p`.`approval_date`)  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`account_id`),
  ADD UNIQUE KEY `account_code` (`account_code`);

--
-- Indexes for table `beds`
--
ALTER TABLE `beds`
  ADD PRIMARY KEY (`bed_id`),
  ADD KEY `ward_id` (`ward_id`);

--
-- Indexes for table `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`bill_id`),
  ADD UNIQUE KEY `bill_number` (`bill_number`),
  ADD KEY `vendor_id` (`vendor_id`),
  ADD KEY `term_id` (`term_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `bill_items`
--
ALTER TABLE `bill_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `bill_id` (`bill_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `bill_payments`
--
ALTER TABLE `bill_payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `bill_id` (`bill_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `cashbook`
--
ALTER TABLE `cashbook`
  ADD PRIMARY KEY (`transaction_id`),
  ADD UNIQUE KEY `reference_number` (`reference_number`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `categories_pharm`
--
ALTER TABLE `categories_pharm`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `credit_notes_pharm`
--
ALTER TABLE `credit_notes_pharm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sale_id` (`sale_id`),
  ADD KEY `issued_by` (`issued_by`);

--
-- Indexes for table `credit_note_items_pharm`
--
ALTER TABLE `credit_note_items_pharm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `credit_note_id` (`credit_note_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`doctor_id`);

--
-- Indexes for table `doctor_notes`
--
ALTER TABLE `doctor_notes`
  ADD PRIMARY KEY (`note_id`),
  ADD KEY `visit_id` (`visit_id`),
  ADD KEY `doctor_id` (`doctor_id`);

--
-- Indexes for table `expenditures_pharm`
--
ALTER TABLE `expenditures_pharm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `financial_periods`
--
ALTER TABLE `financial_periods`
  ADD PRIMARY KEY (`period_id`),
  ADD KEY `closed_by` (`closed_by`);

--
-- Indexes for table `inpatient_admissions`
--
ALTER TABLE `inpatient_admissions`
  ADD PRIMARY KEY (`admission_id`),
  ADD KEY `visit_id` (`visit_id`),
  ADD KEY `bed_id` (`bed_id`);

--
-- Indexes for table `inpatient_medications`
--
ALTER TABLE `inpatient_medications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admission_id` (`admission_id`),
  ADD KEY `medication_id` (`medication_id`),
  ADD KEY `prescribed_by` (`prescribed_by`);

--
-- Indexes for table `inpatient_procedures`
--
ALTER TABLE `inpatient_procedures`
  ADD PRIMARY KEY (`inpatient_procedure_id`),
  ADD KEY `admission_id` (`admission_id`),
  ADD KEY `procedure_id` (`procedure_id`),
  ADD KEY `doctor_id` (`doctor_id`);

--
-- Indexes for table `insurance_claims`
--
ALTER TABLE `insurance_claims`
  ADD PRIMARY KEY (`claim_id`),
  ADD UNIQUE KEY `claim_number` (`claim_number`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `insurance_id` (`insurance_id`),
  ADD KEY `policy_id` (`policy_id`),
  ADD KEY `visit_id` (`visit_id`),
  ADD KEY `admission_id` (`admission_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `insurance_claim_items`
--
ALTER TABLE `insurance_claim_items`
  ADD PRIMARY KEY (`claim_item_id`),
  ADD KEY `claim_id` (`claim_id`);

--
-- Indexes for table `insurance_companies`
--
ALTER TABLE `insurance_companies`
  ADD PRIMARY KEY (`insurance_id`);

--
-- Indexes for table `insurance_lab_pricing`
--
ALTER TABLE `insurance_lab_pricing`
  ADD PRIMARY KEY (`pricing_id`),
  ADD KEY `insurance_id` (`insurance_id`),
  ADD KEY `test_id` (`test_id`);

--
-- Indexes for table `insurance_medication_pricing`
--
ALTER TABLE `insurance_medication_pricing`
  ADD PRIMARY KEY (`pricing_id`),
  ADD KEY `insurance_id` (`insurance_id`),
  ADD KEY `medication_id` (`medication_id`);

--
-- Indexes for table `insurance_negotiated_rates`
--
ALTER TABLE `insurance_negotiated_rates`
  ADD PRIMARY KEY (`rate_id`),
  ADD KEY `insurance_id` (`insurance_id`);

--
-- Indexes for table `insurance_payments`
--
ALTER TABLE `insurance_payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `claim_id` (`claim_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `insurance_policies`
--
ALTER TABLE `insurance_policies`
  ADD PRIMARY KEY (`policy_id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `insurance_id` (`insurance_id`);

--
-- Indexes for table `insurance_procedure_pricing`
--
ALTER TABLE `insurance_procedure_pricing`
  ADD PRIMARY KEY (`pricing_id`),
  ADD KEY `insurance_id` (`insurance_id`);

--
-- Indexes for table `insurance_radiology_pricing`
--
ALTER TABLE `insurance_radiology_pricing`
  ADD PRIMARY KEY (`pricing_id`),
  ADD KEY `insurance_id` (`insurance_id`),
  ADD KEY `radiology_id` (`radiology_id`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`invoice_id`),
  ADD KEY `visit_id` (`visit_id`),
  ADD KEY `fk_invoice_insurance` (`insurance_id`),
  ADD KEY `invoices_ibfk_3` (`term_id`),
  ADD KEY `invoices_ibfk_4` (`claim_id`);

--
-- Indexes for table `invoices_pharm`
--
ALTER TABLE `invoices_pharm`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `invoice_payments`
--
ALTER TABLE `invoice_payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `invoice_id` (`invoice_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `journal_entries`
--
ALTER TABLE `journal_entries`
  ADD PRIMARY KEY (`entry_id`),
  ADD UNIQUE KEY `reference_number` (`reference_number`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `journal_items`
--
ALTER TABLE `journal_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `entry_id` (`entry_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `lab_orders`
--
ALTER TABLE `lab_orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `visit_id` (`visit_id`),
  ADD KEY `doctor_id` (`doctor_id`),
  ADD KEY `test_id` (`test_id`),
  ADD KEY `lab_orders_ibfk_4` (`admission_id`);

--
-- Indexes for table `lab_tests`
--
ALTER TABLE `lab_tests`
  ADD PRIMARY KEY (`test_id`);

--
-- Indexes for table `medications`
--
ALTER TABLE `medications`
  ADD PRIMARY KEY (`medication_id`);

--
-- Indexes for table `medication_batches`
--
ALTER TABLE `medication_batches`
  ADD PRIMARY KEY (`batch_id`),
  ADD KEY `medication_id` (`medication_id`);

--
-- Indexes for table `medication_usage`
--
ALTER TABLE `medication_usage`
  ADD PRIMARY KEY (`usage_id`),
  ADD KEY `prescription_id` (`prescription_id`),
  ADD KEY `batch_id` (`batch_id`),
  ADD KEY `used_by` (`used_by`);

--
-- Indexes for table `notifications_pharm`
--
ALTER TABLE `notifications_pharm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`patient_id`),
  ADD KEY `fk_patient_insurance` (`insurance_id`);

--
-- Indexes for table `patient_insurance`
--
ALTER TABLE `patient_insurance`
  ADD PRIMARY KEY (`patient_insurance_id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `insurance_id` (`insurance_id`);

--
-- Indexes for table `payment_terms`
--
ALTER TABLE `payment_terms`
  ADD PRIMARY KEY (`term_id`);

--
-- Indexes for table `pharmacy_details`
--
ALTER TABLE `pharmacy_details`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `prescriptions`
--
ALTER TABLE `prescriptions`
  ADD PRIMARY KEY (`prescription_id`),
  ADD KEY `visit_id` (`visit_id`),
  ADD KEY `doctor_id` (`doctor_id`),
  ADD KEY `medication_id` (`medication_id`);

--
-- Indexes for table `procedures`
--
ALTER TABLE `procedures`
  ADD PRIMARY KEY (`procedure_id`);

--
-- Indexes for table `procurement_items_pharm`
--
ALTER TABLE `procurement_items_pharm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `procurement_id` (`procurement_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `procurement_pharm`
--
ALTER TABLE `procurement_pharm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `products_pharm`
--
ALTER TABLE `products_pharm`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `barcode` (`barcode`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- Indexes for table `product_batches_pharm`
--
ALTER TABLE `product_batches_pharm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_batches_pharm_ibfk_1` (`product_id`);

--
-- Indexes for table `radiology_orders`
--
ALTER TABLE `radiology_orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `visit_id` (`visit_id`),
  ADD KEY `doctor_id` (`doctor_id`),
  ADD KEY `radiology_id` (`radiology_id`),
  ADD KEY `radiology_orders_ibfk_4` (`admission_id`);

--
-- Indexes for table `radiology_tests`
--
ALTER TABLE `radiology_tests`
  ADD PRIMARY KEY (`radiology_id`);

--
-- Indexes for table `sales_pharm`
--
ALTER TABLE `sales_pharm`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invoice_number` (`invoice_number`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `sale_items_pharm`
--
ALTER TABLE `sale_items_pharm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sale_id` (`sale_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `stock_movements_pharm`
--
ALTER TABLE `stock_movements_pharm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `sundries`
--
ALTER TABLE `sundries`
  ADD PRIMARY KEY (`sundry_id`);

--
-- Indexes for table `sundry_orders`
--
ALTER TABLE `sundry_orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `visit_id` (`visit_id`),
  ADD KEY `admission_id` (`admission_id`),
  ADD KEY `procedure_id` (`procedure_id`),
  ADD KEY `sundry_id` (`sundry_id`);

--
-- Indexes for table `suppliers_pharm`
--
ALTER TABLE `suppliers_pharm`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `theaters`
--
ALTER TABLE `theaters`
  ADD PRIMARY KEY (`theater_id`);

--
-- Indexes for table `theater_procedures`
--
ALTER TABLE `theater_procedures`
  ADD PRIMARY KEY (`procedure_id`),
  ADD KEY `visit_id` (`visit_id`),
  ADD KEY `theater_id` (`theater_id`),
  ADD KEY `doctor_id` (`doctor_id`);

--
-- Indexes for table `triage`
--
ALTER TABLE `triage`
  ADD PRIMARY KEY (`triage_id`),
  ADD KEY `visit_id` (`visit_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `users_pharm`
--
ALTER TABLE `users_pharm`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `vendors`
--
ALTER TABLE `vendors`
  ADD PRIMARY KEY (`vendor_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `visits`
--
ALTER TABLE `visits`
  ADD PRIMARY KEY (`visit_id`),
  ADD UNIQUE KEY `visit_number` (`visit_number`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `doctor_id` (`doctor_id`),
  ADD KEY `policy_id` (`policy_id`);

--
-- Indexes for table `wards`
--
ALTER TABLE `wards`
  ADD PRIMARY KEY (`ward_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `beds`
--
ALTER TABLE `beds`
  MODIFY `bed_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `bills`
--
ALTER TABLE `bills`
  MODIFY `bill_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bill_items`
--
ALTER TABLE `bill_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bill_payments`
--
ALTER TABLE `bill_payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cashbook`
--
ALTER TABLE `cashbook`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories_pharm`
--
ALTER TABLE `categories_pharm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `credit_notes_pharm`
--
ALTER TABLE `credit_notes_pharm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `credit_note_items_pharm`
--
ALTER TABLE `credit_note_items_pharm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `doctor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `doctor_notes`
--
ALTER TABLE `doctor_notes`
  MODIFY `note_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `expenditures_pharm`
--
ALTER TABLE `expenditures_pharm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `financial_periods`
--
ALTER TABLE `financial_periods`
  MODIFY `period_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inpatient_admissions`
--
ALTER TABLE `inpatient_admissions`
  MODIFY `admission_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `inpatient_medications`
--
ALTER TABLE `inpatient_medications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inpatient_procedures`
--
ALTER TABLE `inpatient_procedures`
  MODIFY `inpatient_procedure_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `insurance_claims`
--
ALTER TABLE `insurance_claims`
  MODIFY `claim_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `insurance_claim_items`
--
ALTER TABLE `insurance_claim_items`
  MODIFY `claim_item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `insurance_companies`
--
ALTER TABLE `insurance_companies`
  MODIFY `insurance_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `insurance_lab_pricing`
--
ALTER TABLE `insurance_lab_pricing`
  MODIFY `pricing_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `insurance_medication_pricing`
--
ALTER TABLE `insurance_medication_pricing`
  MODIFY `pricing_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `insurance_negotiated_rates`
--
ALTER TABLE `insurance_negotiated_rates`
  MODIFY `rate_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `insurance_payments`
--
ALTER TABLE `insurance_payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `insurance_policies`
--
ALTER TABLE `insurance_policies`
  MODIFY `policy_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `insurance_procedure_pricing`
--
ALTER TABLE `insurance_procedure_pricing`
  MODIFY `pricing_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `insurance_radiology_pricing`
--
ALTER TABLE `insurance_radiology_pricing`
  MODIFY `pricing_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `invoice_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `invoices_pharm`
--
ALTER TABLE `invoices_pharm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `invoice_payments`
--
ALTER TABLE `invoice_payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `journal_entries`
--
ALTER TABLE `journal_entries`
  MODIFY `entry_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `journal_items`
--
ALTER TABLE `journal_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lab_orders`
--
ALTER TABLE `lab_orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `lab_tests`
--
ALTER TABLE `lab_tests`
  MODIFY `test_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `medications`
--
ALTER TABLE `medications`
  MODIFY `medication_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `medication_batches`
--
ALTER TABLE `medication_batches`
  MODIFY `batch_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medication_usage`
--
ALTER TABLE `medication_usage`
  MODIFY `usage_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications_pharm`
--
ALTER TABLE `notifications_pharm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `patient_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `patient_insurance`
--
ALTER TABLE `patient_insurance`
  MODIFY `patient_insurance_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payment_terms`
--
ALTER TABLE `payment_terms`
  MODIFY `term_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `pharmacy_details`
--
ALTER TABLE `pharmacy_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `prescriptions`
--
ALTER TABLE `prescriptions`
  MODIFY `prescription_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `procedures`
--
ALTER TABLE `procedures`
  MODIFY `procedure_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `procurement_items_pharm`
--
ALTER TABLE `procurement_items_pharm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `procurement_pharm`
--
ALTER TABLE `procurement_pharm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products_pharm`
--
ALTER TABLE `products_pharm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1395;

--
-- AUTO_INCREMENT for table `product_batches_pharm`
--
ALTER TABLE `product_batches_pharm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `radiology_orders`
--
ALTER TABLE `radiology_orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `radiology_tests`
--
ALTER TABLE `radiology_tests`
  MODIFY `radiology_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `sales_pharm`
--
ALTER TABLE `sales_pharm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `sale_items_pharm`
--
ALTER TABLE `sale_items_pharm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `stock_movements_pharm`
--
ALTER TABLE `stock_movements_pharm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `sundries`
--
ALTER TABLE `sundries`
  MODIFY `sundry_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `sundry_orders`
--
ALTER TABLE `sundry_orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `suppliers_pharm`
--
ALTER TABLE `suppliers_pharm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `theaters`
--
ALTER TABLE `theaters`
  MODIFY `theater_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `theater_procedures`
--
ALTER TABLE `theater_procedures`
  MODIFY `procedure_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `triage`
--
ALTER TABLE `triage`
  MODIFY `triage_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `users_pharm`
--
ALTER TABLE `users_pharm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `vendors`
--
ALTER TABLE `vendors`
  MODIFY `vendor_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `visits`
--
ALTER TABLE `visits`
  MODIFY `visit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `wards`
--
ALTER TABLE `wards`
  MODIFY `ward_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `beds`
--
ALTER TABLE `beds`
  ADD CONSTRAINT `beds_ibfk_1` FOREIGN KEY (`ward_id`) REFERENCES `wards` (`ward_id`);

--
-- Constraints for table `bills`
--
ALTER TABLE `bills`
  ADD CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`vendor_id`),
  ADD CONSTRAINT `bills_ibfk_2` FOREIGN KEY (`term_id`) REFERENCES `payment_terms` (`term_id`),
  ADD CONSTRAINT `bills_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `bill_items`
--
ALTER TABLE `bill_items`
  ADD CONSTRAINT `bill_items_ibfk_1` FOREIGN KEY (`bill_id`) REFERENCES `bills` (`bill_id`),
  ADD CONSTRAINT `bill_items_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`);

--
-- Constraints for table `bill_payments`
--
ALTER TABLE `bill_payments`
  ADD CONSTRAINT `bill_payments_ibfk_1` FOREIGN KEY (`bill_id`) REFERENCES `bills` (`bill_id`),
  ADD CONSTRAINT `bill_payments_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `cashbook`
--
ALTER TABLE `cashbook`
  ADD CONSTRAINT `cashbook_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`),
  ADD CONSTRAINT `cashbook_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `credit_notes_pharm`
--
ALTER TABLE `credit_notes_pharm`
  ADD CONSTRAINT `credit_notes_pharm_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `sales_pharm` (`id`),
  ADD CONSTRAINT `credit_notes_pharm_ibfk_2` FOREIGN KEY (`issued_by`) REFERENCES `users_pharm` (`id`);

--
-- Constraints for table `credit_note_items_pharm`
--
ALTER TABLE `credit_note_items_pharm`
  ADD CONSTRAINT `credit_note_items_pharm_ibfk_1` FOREIGN KEY (`credit_note_id`) REFERENCES `credit_notes_pharm` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `credit_note_items_pharm_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products_pharm` (`id`);

--
-- Constraints for table `doctor_notes`
--
ALTER TABLE `doctor_notes`
  ADD CONSTRAINT `doctor_notes_ibfk_1` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`visit_id`),
  ADD CONSTRAINT `doctor_notes_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`);

--
-- Constraints for table `expenditures_pharm`
--
ALTER TABLE `expenditures_pharm`
  ADD CONSTRAINT `expenditures_pharm_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users_pharm` (`id`);

--
-- Constraints for table `financial_periods`
--
ALTER TABLE `financial_periods`
  ADD CONSTRAINT `financial_periods_ibfk_1` FOREIGN KEY (`closed_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `inpatient_admissions`
--
ALTER TABLE `inpatient_admissions`
  ADD CONSTRAINT `inpatient_admissions_ibfk_1` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`visit_id`),
  ADD CONSTRAINT `inpatient_admissions_ibfk_2` FOREIGN KEY (`bed_id`) REFERENCES `beds` (`bed_id`);

--
-- Constraints for table `inpatient_medications`
--
ALTER TABLE `inpatient_medications`
  ADD CONSTRAINT `inpatient_medications_ibfk_1` FOREIGN KEY (`admission_id`) REFERENCES `inpatient_admissions` (`admission_id`),
  ADD CONSTRAINT `inpatient_medications_ibfk_2` FOREIGN KEY (`medication_id`) REFERENCES `medications` (`medication_id`),
  ADD CONSTRAINT `inpatient_medications_ibfk_3` FOREIGN KEY (`prescribed_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `inpatient_procedures`
--
ALTER TABLE `inpatient_procedures`
  ADD CONSTRAINT `inpatient_procedures_ibfk_1` FOREIGN KEY (`admission_id`) REFERENCES `inpatient_admissions` (`admission_id`),
  ADD CONSTRAINT `inpatient_procedures_ibfk_2` FOREIGN KEY (`procedure_id`) REFERENCES `procedures` (`procedure_id`),
  ADD CONSTRAINT `inpatient_procedures_ibfk_3` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`);

--
-- Constraints for table `insurance_claims`
--
ALTER TABLE `insurance_claims`
  ADD CONSTRAINT `insurance_claims_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
  ADD CONSTRAINT `insurance_claims_ibfk_2` FOREIGN KEY (`insurance_id`) REFERENCES `insurance_companies` (`insurance_id`),
  ADD CONSTRAINT `insurance_claims_ibfk_3` FOREIGN KEY (`policy_id`) REFERENCES `insurance_policies` (`policy_id`),
  ADD CONSTRAINT `insurance_claims_ibfk_4` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`visit_id`),
  ADD CONSTRAINT `insurance_claims_ibfk_5` FOREIGN KEY (`admission_id`) REFERENCES `inpatient_admissions` (`admission_id`),
  ADD CONSTRAINT `insurance_claims_ibfk_6` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `insurance_claim_items`
--
ALTER TABLE `insurance_claim_items`
  ADD CONSTRAINT `insurance_claim_items_ibfk_1` FOREIGN KEY (`claim_id`) REFERENCES `insurance_claims` (`claim_id`);

--
-- Constraints for table `insurance_lab_pricing`
--
ALTER TABLE `insurance_lab_pricing`
  ADD CONSTRAINT `insurance_lab_pricing_ibfk_1` FOREIGN KEY (`insurance_id`) REFERENCES `insurance_companies` (`insurance_id`),
  ADD CONSTRAINT `insurance_lab_pricing_ibfk_2` FOREIGN KEY (`test_id`) REFERENCES `lab_tests` (`test_id`);

--
-- Constraints for table `insurance_medication_pricing`
--
ALTER TABLE `insurance_medication_pricing`
  ADD CONSTRAINT `insurance_medication_pricing_ibfk_1` FOREIGN KEY (`insurance_id`) REFERENCES `insurance_companies` (`insurance_id`),
  ADD CONSTRAINT `insurance_medication_pricing_ibfk_2` FOREIGN KEY (`medication_id`) REFERENCES `medications` (`medication_id`);

--
-- Constraints for table `insurance_negotiated_rates`
--
ALTER TABLE `insurance_negotiated_rates`
  ADD CONSTRAINT `insurance_negotiated_rates_ibfk_1` FOREIGN KEY (`insurance_id`) REFERENCES `insurance_companies` (`insurance_id`);

--
-- Constraints for table `insurance_payments`
--
ALTER TABLE `insurance_payments`
  ADD CONSTRAINT `insurance_payments_ibfk_1` FOREIGN KEY (`claim_id`) REFERENCES `insurance_claims` (`claim_id`),
  ADD CONSTRAINT `insurance_payments_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `insurance_policies`
--
ALTER TABLE `insurance_policies`
  ADD CONSTRAINT `insurance_policies_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
  ADD CONSTRAINT `insurance_policies_ibfk_2` FOREIGN KEY (`insurance_id`) REFERENCES `insurance_companies` (`insurance_id`);

--
-- Constraints for table `insurance_procedure_pricing`
--
ALTER TABLE `insurance_procedure_pricing`
  ADD CONSTRAINT `insurance_procedure_pricing_ibfk_1` FOREIGN KEY (`insurance_id`) REFERENCES `insurance_companies` (`insurance_id`);

--
-- Constraints for table `insurance_radiology_pricing`
--
ALTER TABLE `insurance_radiology_pricing`
  ADD CONSTRAINT `insurance_radiology_pricing_ibfk_1` FOREIGN KEY (`insurance_id`) REFERENCES `insurance_companies` (`insurance_id`),
  ADD CONSTRAINT `insurance_radiology_pricing_ibfk_2` FOREIGN KEY (`radiology_id`) REFERENCES `radiology_tests` (`radiology_id`);

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `fk_invoice_insurance` FOREIGN KEY (`insurance_id`) REFERENCES `insurance_companies` (`insurance_id`),
  ADD CONSTRAINT `invoices_ibfk_1` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`visit_id`),
  ADD CONSTRAINT `invoices_ibfk_3` FOREIGN KEY (`term_id`) REFERENCES `payment_terms` (`term_id`),
  ADD CONSTRAINT `invoices_ibfk_4` FOREIGN KEY (`claim_id`) REFERENCES `insurance_claims` (`claim_id`);

--
-- Constraints for table `invoice_payments`
--
ALTER TABLE `invoice_payments`
  ADD CONSTRAINT `invoice_payments_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`invoice_id`),
  ADD CONSTRAINT `invoice_payments_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `journal_entries`
--
ALTER TABLE `journal_entries`
  ADD CONSTRAINT `journal_entries_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `journal_items`
--
ALTER TABLE `journal_items`
  ADD CONSTRAINT `journal_items_ibfk_1` FOREIGN KEY (`entry_id`) REFERENCES `journal_entries` (`entry_id`),
  ADD CONSTRAINT `journal_items_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`);

--
-- Constraints for table `lab_orders`
--
ALTER TABLE `lab_orders`
  ADD CONSTRAINT `lab_orders_ibfk_1` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`visit_id`),
  ADD CONSTRAINT `lab_orders_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`),
  ADD CONSTRAINT `lab_orders_ibfk_3` FOREIGN KEY (`test_id`) REFERENCES `lab_tests` (`test_id`),
  ADD CONSTRAINT `lab_orders_ibfk_4` FOREIGN KEY (`admission_id`) REFERENCES `inpatient_admissions` (`admission_id`);

--
-- Constraints for table `medication_batches`
--
ALTER TABLE `medication_batches`
  ADD CONSTRAINT `medication_batches_ibfk_1` FOREIGN KEY (`medication_id`) REFERENCES `medications` (`medication_id`);

--
-- Constraints for table `medication_usage`
--
ALTER TABLE `medication_usage`
  ADD CONSTRAINT `medication_usage_ibfk_1` FOREIGN KEY (`prescription_id`) REFERENCES `prescriptions` (`prescription_id`),
  ADD CONSTRAINT `medication_usage_ibfk_2` FOREIGN KEY (`batch_id`) REFERENCES `medication_batches` (`batch_id`),
  ADD CONSTRAINT `medication_usage_ibfk_3` FOREIGN KEY (`used_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `patients`
--
ALTER TABLE `patients`
  ADD CONSTRAINT `fk_patient_insurance` FOREIGN KEY (`insurance_id`) REFERENCES `insurance_companies` (`insurance_id`);

--
-- Constraints for table `patient_insurance`
--
ALTER TABLE `patient_insurance`
  ADD CONSTRAINT `patient_insurance_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
  ADD CONSTRAINT `patient_insurance_ibfk_2` FOREIGN KEY (`insurance_id`) REFERENCES `insurance_companies` (`insurance_id`);

--
-- Constraints for table `prescriptions`
--
ALTER TABLE `prescriptions`
  ADD CONSTRAINT `prescriptions_ibfk_1` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`visit_id`),
  ADD CONSTRAINT `prescriptions_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`),
  ADD CONSTRAINT `prescriptions_ibfk_3` FOREIGN KEY (`medication_id`) REFERENCES `medications` (`medication_id`);

--
-- Constraints for table `procurement_items_pharm`
--
ALTER TABLE `procurement_items_pharm`
  ADD CONSTRAINT `procurement_items_pharm_ibfk_1` FOREIGN KEY (`procurement_id`) REFERENCES `procurement_pharm` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `procurement_items_pharm_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products_pharm` (`id`);

--
-- Constraints for table `procurement_pharm`
--
ALTER TABLE `procurement_pharm`
  ADD CONSTRAINT `procurement_pharm_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers_pharm` (`id`),
  ADD CONSTRAINT `procurement_pharm_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users_pharm` (`id`);

--
-- Constraints for table `products_pharm`
--
ALTER TABLE `products_pharm`
  ADD CONSTRAINT `products_pharm_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories_pharm` (`id`),
  ADD CONSTRAINT `products_pharm_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers_pharm` (`id`);

--
-- Constraints for table `product_batches_pharm`
--
ALTER TABLE `product_batches_pharm`
  ADD CONSTRAINT `product_batches_pharm_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products_pharm` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `radiology_orders`
--
ALTER TABLE `radiology_orders`
  ADD CONSTRAINT `radiology_orders_ibfk_1` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`visit_id`),
  ADD CONSTRAINT `radiology_orders_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`),
  ADD CONSTRAINT `radiology_orders_ibfk_3` FOREIGN KEY (`radiology_id`) REFERENCES `radiology_tests` (`radiology_id`),
  ADD CONSTRAINT `radiology_orders_ibfk_4` FOREIGN KEY (`admission_id`) REFERENCES `inpatient_admissions` (`admission_id`);

--
-- Constraints for table `sales_pharm`
--
ALTER TABLE `sales_pharm`
  ADD CONSTRAINT `sales_pharm_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users_pharm` (`id`);

--
-- Constraints for table `sale_items_pharm`
--
ALTER TABLE `sale_items_pharm`
  ADD CONSTRAINT `sale_items_pharm_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `sales_pharm` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sale_items_pharm_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products_pharm` (`id`);

--
-- Constraints for table `stock_movements_pharm`
--
ALTER TABLE `stock_movements_pharm`
  ADD CONSTRAINT `stock_movements_pharm_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products_pharm` (`id`),
  ADD CONSTRAINT `stock_movements_pharm_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users_pharm` (`id`);

--
-- Constraints for table `sundry_orders`
--
ALTER TABLE `sundry_orders`
  ADD CONSTRAINT `sundry_orders_ibfk_1` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`visit_id`),
  ADD CONSTRAINT `sundry_orders_ibfk_2` FOREIGN KEY (`admission_id`) REFERENCES `inpatient_admissions` (`admission_id`),
  ADD CONSTRAINT `sundry_orders_ibfk_3` FOREIGN KEY (`procedure_id`) REFERENCES `theater_procedures` (`procedure_id`),
  ADD CONSTRAINT `sundry_orders_ibfk_4` FOREIGN KEY (`sundry_id`) REFERENCES `sundries` (`sundry_id`);

--
-- Constraints for table `theater_procedures`
--
ALTER TABLE `theater_procedures`
  ADD CONSTRAINT `theater_procedures_ibfk_1` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`visit_id`),
  ADD CONSTRAINT `theater_procedures_ibfk_2` FOREIGN KEY (`theater_id`) REFERENCES `theaters` (`theater_id`),
  ADD CONSTRAINT `theater_procedures_ibfk_3` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`);

--
-- Constraints for table `triage`
--
ALTER TABLE `triage`
  ADD CONSTRAINT `triage_ibfk_1` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`visit_id`);

--
-- Constraints for table `vendors`
--
ALTER TABLE `vendors`
  ADD CONSTRAINT `vendors_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`);

--
-- Constraints for table `visits`
--
ALTER TABLE `visits`
  ADD CONSTRAINT `visits_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
  ADD CONSTRAINT `visits_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`),
  ADD CONSTRAINT `visits_ibfk_3` FOREIGN KEY (`policy_id`) REFERENCES `insurance_policies` (`policy_id`),
  ADD CONSTRAINT `visits_ibfk_4` FOREIGN KEY (`policy_id`) REFERENCES `insurance_policies` (`policy_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
