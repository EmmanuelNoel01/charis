-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 11, 2025 at 07:29 AM
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

--
-- Dumping data for table `expenditures_pharm`
--

INSERT INTO `expenditures_pharm` (`id`, `user_id`, `title`, `description`, `amount`, `expense_date`, `created_at`, `category`) VALUES
(1, 13, 'rent', 'rent for the month of July', 500000.00, '2025-07-17', '2025-07-17 18:33:25', 'Maintenance'),
(2, 6, 'TRANSPORT ALLOWANCE', 'TRANSPORT FOR MEDICATION FROM TOWN', 5000.00, '2025-07-19', '2025-07-19 15:08:07', 'Transport'),
(3, 13, 'allowance', 'daily allowance', 5000.00, '2025-07-31', '2025-07-31 18:47:20', 'Maintenance'),
(4, 13, 'Allowance ', 'Day\'s allowance', 5000.00, '2025-08-01', '2025-08-01 20:55:33', 'Maintenance'),
(5, 13, 'allowance', 'day\'s allowance gloria', 5000.00, '2025-08-02', '2025-08-03 18:36:07', 'Maintenance'),
(6, 14, 'Allowance', '', 5000.00, '2025-08-04', '2025-08-04 16:31:42', 'Fuel'),
(7, 14, 'Allowance', '', 5000.00, '2025-08-06', '2025-08-06 13:28:01', 'Fuel'),
(8, 13, 'allowance', 'gloria\'s daily allowance', 5000.00, '2025-08-07', '2025-08-07 22:00:11', 'Fuel'),
(9, 14, ' alloance', 'daily allowance', 5000.00, '2025-08-08', '2025-08-08 16:56:14', 'Maintenance'),
(10, 14, 'omo', '', 500.00, '2025-08-12', '2025-08-12 17:32:44', 'Maintenance'),
(11, 14, 'allowance', '', 5000.00, '2025-08-12', '2025-08-12 17:33:13', 'Maintenance'),
(12, 14, 'Allowance', 'daily allowance', 5000.00, '2025-08-18', '2025-08-18 11:59:28', 'Maintenance'),
(13, 14, '   Allowance', '', 5000.00, '2025-08-20', '2025-08-20 21:56:00', 'Salary'),
(14, 14, 'omo', '', 1000.00, '2025-08-20', '2025-08-20 21:56:29', 'Maintenance'),
(15, 14, 'Allowance', '', 5000.00, '2025-08-21', '2025-08-21 18:13:05', 'Maintenance'),
(16, 14, 'Allowance', '', 5000.00, '2025-08-22', '2025-08-22 10:11:34', 'Maintenance'),
(17, 14, 'Allowance', 'daily allowance', 5000.00, '2025-08-25', '2025-08-25 18:10:10', 'Maintenance'),
(18, 14, 'buveera', ' for customer care', 1500.00, '2025-08-26', '2025-08-26 10:12:57', 'Maintenance'),
(19, 14, 'Allowance', 'daily allowance', 5000.00, '2025-08-26', '2025-08-26 10:13:48', 'Maintenance'),
(20, 14, 'Allowance', '', 5000.00, '2025-08-27', '2025-08-27 16:51:34', 'Maintenance'),
(21, 14, 'allowance', 'daily allowance', 5000.00, '2025-08-28', '2025-08-28 17:58:13', 'Maintenance'),
(22, 14, 'Allowance', 'daily expenses', 5000.00, '2025-08-29', '2025-08-29 21:28:14', 'Fuel'),
(23, 14, 'electricity', 'repair contribution', 1000.00, '2025-08-29', '2025-08-29 21:29:01', 'Fuel'),
(24, 14, 'Allowance', 'daiy allowance', 5000.00, '2025-09-01', '2025-09-01 17:55:00', 'Maintenance'),
(25, 14, 'Allowance', 'daiy allowance', 5000.00, '2025-09-02', '2025-09-02 18:06:09', 'Maintenance'),
(26, 14, 'allowance', 'daiy allowance', 5000.00, '2025-09-03', '2025-09-03 17:29:19', 'Maintenance'),
(27, 14, 'allowance', '', 5000.00, '2025-09-05', '2025-09-05 09:45:12', 'Maintenance'),
(28, 14, 'omo', '', 500.00, '2025-09-05', '2025-09-05 09:45:33', 'Maintenance'),
(29, 14, 'Allowance', 'daily allowance', 5000.00, '2025-09-09', '2025-09-09 16:25:38', 'Maintenance'),
(30, 14, 'Alllowance', 'daiy allowance', 5000.00, '2025-09-10', '2025-09-10 21:40:37', 'Maintenance'),
(31, 14, 'allowance', '', 5000.00, '2025-09-11', '2025-09-11 17:43:31', 'Maintenance'),
(32, 14, 'omo', '', 1000.00, '2025-09-11', '2025-09-11 17:43:48', 'Maintenance'),
(33, 14, 'Allowance', 'daily allowance', 5000.00, '2025-09-23', '2025-09-23 16:51:50', 'Maintenance'),
(34, 14, 'Allowance', 'daily allowance', 5000.00, '2025-09-29', '2025-09-29 17:15:08', 'Maintenance'),
(35, 14, 'papers', 'for envelopes', 1000.00, '2025-09-29', '2025-09-29 17:16:00', 'Maintenance'),
(36, 14, 'Allowance', 'daily allowance', 5000.00, '2025-09-30', '2025-09-30 16:42:47', 'Fuel'),
(37, 14, 'papers', 'for envelopes', 1000.00, '2025-09-30', '2025-09-30 16:43:19', 'Maintenance'),
(38, 14, 'Allowance', 'daily allowance', 5000.00, '2025-10-01', '2025-10-01 20:45:18', 'Maintenance'),
(39, 14, 'allowance', 'daily allowance', 5000.00, '2025-10-07', '2025-10-07 16:37:39', 'Maintenance'),
(40, 14, 'Allowance', 'daily allowance', 5000.00, '2025-10-30', '2025-10-30 12:51:13', 'Maintenance'),
(41, 14, 'Allowance', 'daily allowance', 5000.00, '2025-10-31', '2025-10-31 17:48:07', 'Maintenance'),
(42, 14, 'Allowance', 'daily allowance', 5000.00, '2025-11-06', '2025-11-06 09:02:36', 'Maintenance'),
(43, 13, 'kaveera', 'packaging materials', 1500.00, '2025-11-06', '2025-11-06 20:40:38', 'Supplies'),
(44, 14, 'allowance', 'daily allowance', 5000.00, '2025-11-07', '2025-11-07 22:03:11', 'Maintenance'),
(45, 14, 'Allowance', 'daily allowance', 5000.00, '2025-11-08', '2025-11-08 09:01:07', 'Maintenance'),
(46, 14, 'Allowance', 'daily allowance', 5000.00, '2025-11-08', '2025-11-08 09:01:36', 'Maintenance');

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
  `total_amount` decimal(10,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `supplier_address` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `invoices_pharm`
--

INSERT INTO `invoices_pharm` (`id`, `invoice_number`, `supplier_name`, `supplier_contact`, `invoice_status`, `invoice_date`, `total_amount`, `created_at`, `supplier_address`) VALUES
(0, 'm254d', 'kampala pharmaceuticals', '0700000000000', 'Paid', '2025-07-27', 0.00, '2025-07-27 16:24:21', 'WILSON ROAD'),
(0, '1437', 'ROYAL PHARMA 2011 LTD', '0414344940', 'Paid', '2025-07-31', 0.00, '2025-07-31 16:16:10', 'WILSON ROAD'),
(0, 'AIVEEN 2', 'AIVEEN 2', '0775480232', 'Paid', '2025-08-01', 0.00, '2025-08-01 17:17:23', 'WILSON ROAD'),
(0, '1633', 'royal pharma 2011 ltd', '0756984810', 'Paid', '2025-08-04', 0.00, '2025-08-04 15:41:42', 'WILSON ROAD'),
(0, '1830', 'royal pharma 2011 ltd', '0756984810', 'Paid', '2025-08-07', 0.00, '2025-08-07 19:43:44', 'WILSON ROAD'),
(0, 'wilson cash 3026/25-26', 'planet pharmaceuticals Uganda limited', 'raghuz@yahoo.com', 'Paid', '2025-08-05', 0.00, '2025-08-11 15:18:38', 'WILSON ROAD'),
(0, '4050', 'Salud pharmacy ltd', '0740640640', 'Paid', '2025-08-13', 0.00, '2025-08-13 16:12:55', 'WILSON ROAD'),
(0, '2417', 'royal pharma 2011 ltd', '0756984810', 'Paid', '2025-08-20', 0.00, '2025-08-20 17:10:03', 'WILSON ROAD'),
(0, '05AP015517/2025', 'ABACUS PHARMA A LTD', '0775480232', 'Paid', '2025-08-20', 0.00, '2025-08-20 17:23:19', 'WILSON STREET 1'),
(0, 'AUL03AW001570/2025', 'AIVEEN 2', '0775480232', 'Paid', '2025-08-11', 0.00, '2025-08-20 17:39:40', 'WILSON ROAD'),
(0, 'AUL03AW002019/2025', 'AIVEEN 2', '0775480232', 'Paid', '2025-08-22', 0.00, '2025-08-22 17:07:24', 'WILSON ROAD'),
(0, '4933', 'Salud pharmacy ltd', '0740640640', 'Paid', '2025-08-22', 0.00, '2025-08-22 17:33:15', 'WILSON ROAD'),
(0, '02AP004379/2025', 'ABACUS PHARMA A LTD', '014393', 'Paid', '2025-08-22', 0.00, '2025-08-22 17:42:58', 'WILSON STREET 1'),
(0, '6699', 'biogen pharma', '0703927939', 'Paid', '2025-08-26', 0.00, '2025-08-28 15:33:43', 'WILSON ROAD'),
(0, 'AUL03AW002159/2025', 'AIVEEN 2', '0149774', 'Paid', '2025-08-26', 0.00, '2025-08-28 15:55:05', 'WILSON ROAD'),
(0, 'AUL03AW002153/2025', 'AIVEEN 2', '0149768', 'Paid', '2025-08-26', 0.00, '2025-08-28 15:58:46', 'WILSON ROAD'),
(0, '9598', 'MEDREICH U LIMITED', '0776150192', 'Paid', '2025-08-26', 0.00, '2025-08-28 16:11:12', 'TITANIC PLAZA'),
(0, '1033', 'MEDREICH U LIMITED', '0776150192', 'Paid', '2025-09-04', 0.00, '2025-09-05 16:29:14', 'TITANIC PLAZA'),
(0, '10082', 'MEDREICH U LIMITED', '0776150192', 'Paid', '2025-09-05', 0.00, '2025-09-05 16:45:08', 'TITANIC PLAZA'),
(0, 'AUL03AW002449/2025', 'AIVEEN 2', '0775480232', 'Paid', '2025-09-04', 0.00, '2025-09-05 17:05:52', 'WILSON ROAD'),
(0, '05AP015779/2025', 'ABACUS PHARMA A LTD', '0775480232', 'Paid', '2025-08-23', 0.00, '2025-09-05 17:39:55', 'WILSON STREET 1'),
(0, 'AUL03AW002037/2025', 'AIVEEN 2', '0775480232', 'Paid', '2025-08-23', 0.00, '2025-09-05 17:52:48', 'WILSON ROAD'),
(0, '2569', 'royal pharma 2011 ltd', '0756984810', 'Paid', '2025-08-23', 0.00, '2025-09-05 18:03:31', 'WILSON ROAD'),
(0, '5478', 'Salud pharmacy ltd', '0756984810', 'Paid', '2025-09-05', 0.00, '2025-09-05 19:05:43', 'WILSON ROAD'),
(0, 'AUL03AW004199/2025', 'AIVEEN 2', '0775480232', 'Paid', '2025-10-28', 217000.00, '2025-10-28 16:29:56', 'WILSON STREET 1');

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
(9, 1, 'Low Stock Alert', 'SPAMCLOX 500MG is running low. Current stock: 5', 0, '2025-07-17 17:28:58', 'low_stock', 1824),
(10, 1, 'Low Stock Alert', 'CIPROBID 500MG TAB is running low. Current stock: 5', 0, '2025-07-19 11:14:32', 'low_stock', 2198),
(11, 1, 'Product Expiring Soon', 'ACTINAC PLUS TABLET (Batch: PM03884) expires on 2025-07-20', 0, '2025-07-19 21:07:10', 'expiry', 2893),
(12, 1, 'Product Expiring Soon', 'OSTEOMIN TABLET (Batch: G402942) expires on 2025-08-06', 0, '2025-07-28 21:56:11', 'expiry', 2929),
(13, 1, 'Low Stock Alert', 'INTAMINE CREAM is running low. Current stock: 1', 0, '2025-07-28 22:03:40', 'low_stock', 3083),
(14, 1, 'Low Stock Alert', 'KETOZ CREAM 15 G is running low. Current stock: 1', 0, '2025-07-28 22:03:40', 'low_stock', 3084),
(15, 1, 'Low Stock Alert', 'IBUMOL SUSPENSION is running low. Current stock: 1', 0, '2025-07-28 22:03:40', 'low_stock', 3115),
(16, 1, 'Low Stock Alert', 'BBC SPRAY is running low. Current stock: 1', 0, '2025-07-28 22:03:40', 'low_stock', 3116),
(17, 1, 'Low Stock Alert', 'VERMOX TABLETS 100MG 6\'S is running low. Current stock: 1', 0, '2025-07-28 22:03:40', 'low_stock', 3120),
(18, 1, 'Low Stock Alert', 'KAMAGRA 100MG TABLET is running low. Current stock: 2', 0, '2025-07-28 22:03:40', 'low_stock', 3127),
(19, 1, 'Low Stock Alert', 'ISORYN PEAD NASAL DROPS is running low. Current stock: 1', 0, '2025-07-28 22:03:40', 'low_stock', 3130),
(20, 1, 'Low Stock Alert', 'DEXONA EYE/EAR DROPS is running low. Current stock: 1', 0, '2025-07-28 22:03:40', 'low_stock', 3133),
(21, 1, 'Low Stock Alert', 'DEXTRACIN EYE/EAR DROPS is running low. Current stock: 1', 0, '2025-07-28 22:03:40', 'low_stock', 3136),
(22, 1, 'Low Stock Alert', 'TOBRADEX EYE DROPS is running low. Current stock: 1', 0, '2025-07-28 22:03:40', 'low_stock', 3138),
(23, 1, 'Low Stock Alert', 'COTTON WOOL 500G  is running low. Current stock: 1', 0, '2025-07-28 22:03:40', 'low_stock', 3144),
(24, 1, 'Low Stock Alert', 'AZITHROMYCIN 500 MG INDIA TABLETS is running low. Current stock: 3', 0, '2025-07-28 22:03:40', 'low_stock', 3150),
(25, 1, 'Low Stock Alert', 'TX-MF TABLETS 1X2 is running low. Current stock: 5', 0, '2025-07-30 21:19:37', 'low_stock', 3175),
(26, 1, 'Low Stock Alert', 'SURGICAL GLOVES 7.5 CM is running low. Current stock: 2', 0, '2025-07-30 21:31:42', 'low_stock', 3163),
(27, 1, 'Low Stock Alert', 'LEVOFLOXACIN 750 INDIA is running low. Current stock: 2', 0, '2025-07-30 21:31:42', 'low_stock', 3169),
(28, 1, 'Low Stock Alert', 'LEVOBACT 750MG is running low. Current stock: 4', 0, '2025-07-30 21:31:42', 'low_stock', 3170),
(29, 1, 'Low Stock Alert', 'JENA FLU 200 ML is running low. Current stock: 2', 0, '2025-07-30 21:40:15', 'low_stock', 3179),
(30, 1, 'Low Stock Alert', 'ALZENTEL SYRUP 15ML is running low. Current stock: 1', 0, '2025-07-31 12:17:55', 'low_stock', 3017),
(31, 1, 'Low Stock Alert', 'METRONIDAZOLE TABLETS INDIA 200MG is running low. Current stock: 20', 0, '2025-07-31 16:28:06', 'low_stock', 3096),
(32, 1, 'Low Stock Alert', 'LONART SYRUP 60ML is running low. Current stock: 1', 0, '2025-07-31 17:33:36', 'low_stock', 3183),
(33, 1, 'Low Stock Alert', 'KISS CONDOM STRAW BERRY is running low. Current stock: 3', 0, '2025-07-31 17:33:36', 'low_stock', 3184),
(34, 1, 'Low Stock Alert', 'KISS CONDOM CHOCOLATE is running low. Current stock: 1', 0, '2025-07-31 17:33:36', 'low_stock', 3187),
(35, 1, 'Low Stock Alert', 'JENACOF 200 ML is running low. Current stock: 1', 0, '2025-07-31 21:38:23', 'low_stock', 2988),
(36, 1, 'Low Stock Alert', 'CLARINASE TABLETS is running low. Current stock: 6', 0, '2025-08-01 19:41:58', 'low_stock', 3209),
(37, 1, 'Low Stock Alert', 'ZAHA SYRUP 200MG/5ML 15ML is running low. Current stock: 1', 0, '2025-08-01 19:48:33', 'low_stock', 3012),
(38, 1, 'Low Stock Alert', 'GABOGGOLA HERBAL COUGH SYRUP is running low. Current stock: 2', 0, '2025-08-01 19:48:33', 'low_stock', 3202),
(39, 1, 'Low Stock Alert', 'FLURID TABLETS PAIRS 2X2 is running low. Current stock: 5', 0, '2025-08-01 19:48:33', 'low_stock', 3203),
(40, 1, 'Low Stock Alert', 'SINAREST TABLETS is running low. Current stock: 5', 0, '2025-08-01 19:48:33', 'low_stock', 3210),
(41, 1, 'Low Stock Alert', 'TREFLUCAN 150 MG CAPSULE 1X1 is running low. Current stock: 2', 0, '2025-08-01 21:59:41', 'low_stock', 3219),
(42, 1, 'Low Stock Alert', 'RELCER GEL 180ML is running low. Current stock: 4', 0, '2025-08-02 16:56:11', 'low_stock', 3225),
(43, 1, 'Low Stock Alert', 'KABUUTI HERBAL SYRUP is running low. Current stock: 2', 0, '2025-08-02 16:56:11', 'low_stock', 3230),
(44, 1, 'Low Stock Alert', 'SYRINGES 5ML 		8			02-04-29			 is running low. Current stock: 8', 0, '2025-08-02 16:56:11', 'low_stock', 3239),
(45, 1, 'Low Stock Alert', 'PIRITEX WITH CODEINE SYRUP is running low. Current stock: 1', 0, '2025-08-02 16:56:11', 'low_stock', 3241),
(46, 1, 'Low Stock Alert', 'ABNAL NASAL DROPS is running low. Current stock: 1', 0, '2025-08-02 18:50:38', 'low_stock', 3135),
(47, 1, 'Low Stock Alert', 'FLUCOZYD 200MG CAPSULES is running low. Current stock: 6', 0, '2025-08-02 20:07:16', 'low_stock', 3109),
(48, 1, 'Low Stock Alert', 'CIPLADON 1000MG EFFERVESCENT TABLET is running low. Current stock: 4', 0, '2025-08-03 22:14:21', 'low_stock', 3002),
(49, 1, 'Low Stock Alert', 'ZAHA 250 TABLET 6\'S is running low. Current stock: 2', 0, '2025-08-04 18:05:20', 'low_stock', 3255),
(50, 1, 'Low Stock Alert', 'ZAHA 500 MG TABLETS 3\'S is running low. Current stock: 2', 0, '2025-08-04 18:05:20', 'low_stock', 3256),
(51, 1, 'Low Stock Alert', 'PROBETA-N EYE/EAR DROP is running low. Current stock: 1', 0, '2025-08-04 21:26:27', 'low_stock', 3134),
(52, 1, 'Low Stock Alert', 'BENZOX 5 GEL is running low. Current stock: 1', 0, '2025-08-05 13:33:35', 'low_stock', 3226),
(53, 1, 'Low Stock Alert', 'COTTON WOOL 50G  is running low. Current stock: 1', 0, '2025-08-06 12:48:07', 'low_stock', 3007),
(54, 1, 'Low Stock Alert', 'DREZ OINTMENT is running low. Current stock: 1', 0, '2025-08-06 12:48:07', 'low_stock', 3042),
(55, 1, 'Low Stock Alert', 'AMLODAC 5MG TABLETS is running low. Current stock: 10.00', 0, '2025-08-07 17:53:58', 'low_stock', 3278),
(56, 1, 'Low Stock Alert', 'LYDIA POST-PILL is running low. Current stock: 2.00', 0, '2025-08-07 21:07:43', 'low_stock', 2990),
(57, 1, 'Low Stock Alert', 'ORACURE GEL is running low. Current stock: 2.00', 0, '2025-08-07 21:59:24', 'low_stock', 3281),
(58, 1, 'Low Stock Alert', 'HIV TEST CASSETES is running low. Current stock: 4.00', 0, '2025-08-08 18:07:28', 'low_stock', 3285),
(59, 1, 'Low Stock Alert', 'HIV TEST STRIPS is running low. Current stock: 8.00', 0, '2025-08-08 18:07:28', 'low_stock', 3286),
(60, 1, 'Low Stock Alert', 'MALARIA RDT  is running low. Current stock: 5.00', 0, '2025-08-08 18:07:28', 'low_stock', 3287),
(61, 1, 'Low Stock Alert', 'SINAREST-PD DROPS is running low. Current stock: 1.00', 0, '2025-08-08 20:39:10', 'low_stock', 3131),
(62, 1, 'Low Stock Alert', 'NEUTRAFLAX TABLETS  is running low. Current stock: 9.00', 0, '2025-08-08 20:39:10', 'low_stock', 3155),
(63, 1, 'Low Stock Alert', 'DEXAMETHASONE 0.5 MG TABLETS is running low. Current stock: 10.00', 0, '2025-08-09 20:27:57', 'low_stock', 3205),
(64, 1, 'Low Stock Alert', 'PEN-V TABLETS is running low. Current stock: 15.00', 0, '2025-08-09 20:57:09', 'low_stock', 3107),
(65, 1, 'Low Stock Alert', 'APCALLIS SX 20 MG TABLET is running low. Current stock: 2.00', 0, '2025-08-10 20:09:10', 'low_stock', 3128),
(66, 1, 'Low Stock Alert', 'LOSACAR-H 50/12.5 is running low. Current stock: 10.00', 0, '2025-08-10 20:24:01', 'low_stock', 3011),
(67, 1, 'Low Stock Alert', 'METRONIDAZOLE SYRUP INDIA 200MG/5ML 100ML  is running low. Current stock: 1.00', 0, '2025-08-10 20:24:01', 'low_stock', 3014),
(68, 1, 'Low Stock Alert', 'CHLORAMPHENICOL CAPSULES 250 MG is running low. Current stock: 20.00', 0, '2025-08-11 15:34:28', 'low_stock', 3273),
(69, 1, 'Low Stock Alert', 'NUCOXOA 120MG					02-02-26			 is running low. Current stock: 3.00', 0, '2025-08-11 18:43:40', 'low_stock', 3247),
(70, 1, 'Low Stock Alert', 'P-ALAXIN TABLETS 9\'S is running low. Current stock: 3.00', 0, '2025-08-12 17:37:38', 'low_stock', 3294),
(71, 1, 'Low Stock Alert', 'BETAPYN TABLET is running low. Current stock: 3.00', 0, '2025-08-12 20:47:38', 'low_stock', 3304),
(72, 1, 'Low Stock Alert', 'LYDIA FINE PILLS is running low. Current stock: 1.00', 0, '2025-08-12 21:36:38', 'low_stock', 3307),
(73, 1, 'Low Stock Alert', 'BACTOCLAV 375 MG TABLET is running low. Current stock: 4.00', 0, '2025-08-17 21:51:59', 'low_stock', 3093),
(74, 1, 'Low Stock Alert', 'TORACTIN 4MG  is running low. Current stock: 20.00', 0, '2025-08-19 19:17:59', 'low_stock', 3206),
(75, 1, 'Low Stock Alert', 'DESLORA-DENK 5MG is running low. Current stock: 5.00', 0, '2025-08-19 19:17:59', 'low_stock', 3212),
(76, 1, 'Low Stock Alert', 'PREDNISOLONE 5MG INDIA is running low. Current stock: 50.00', 0, '2025-08-19 21:58:22', 'low_stock', 3189),
(77, 1, 'Low Stock Alert', 'COTRIMOXAZOLE 960 MG TABLET is running low. Current stock: 13.00', 0, '2025-08-20 11:15:41', 'low_stock', 3108),
(78, 1, 'Low Stock Alert', 'TERBIDERM FORTE 250MG TABLETS is running low. Current stock: 10.00', 0, '2025-08-20 20:13:12', 'low_stock', 3335),
(79, 1, 'Low Stock Alert', 'BIO-OIL 25ML is running low. Current stock: 1.00', 0, '2025-08-20 20:13:12', 'low_stock', 3338),
(80, 1, 'Low Stock Alert', 'BIO-OIL 60 ML is running low. Current stock: 1.00', 0, '2025-08-20 20:13:12', 'low_stock', 3339),
(81, 1, 'Low Stock Alert', 'BIO-OIL 125 ML is running low. Current stock: 1.00', 0, '2025-08-20 20:13:12', 'low_stock', 3341),
(82, 1, 'Low Stock Alert', 'OTRIVINE NASAL DROPS is running low. Current stock: 1.00', 0, '2025-08-20 20:13:12', 'low_stock', 3342),
(83, 1, 'Low Stock Alert', 'CETRIZINE 10MG TABLETS INDIA is running low. Current stock: 50.00', 0, '2025-08-21 09:56:51', 'low_stock', 3200),
(84, 1, 'Low Stock Alert', 'LONART TABLETS 20/120 24\'S  is running low. Current stock: 2.00', 0, '2025-08-21 15:05:47', 'low_stock', 3003),
(85, 1, 'Low Stock Alert', 'GOFEN 400 MG CAPSULE is running low. Current stock: 9.00', 0, '2025-08-21 18:33:59', 'low_stock', 3000),
(86, 1, 'Low Stock Alert', 'ZYCEL 200 MG 1X2 is running low. Current stock: 20.00', 0, '2025-08-21 19:58:20', 'low_stock', 3172),
(87, 1, 'Low Stock Alert', 'STREPSILS original is running low. Current stock: 2.00', 0, '2025-08-21 21:03:11', 'low_stock', 2972),
(88, 1, 'Low Stock Alert', 'ZENTEL SUSPENSION 400 MG is running low. Current stock: 1.00', 0, '2025-08-22 09:13:30', 'low_stock', 3122),
(89, 1, 'Low Stock Alert', 'LEVOCET-M SYRUP is running low. Current stock: 1.00', 0, '2025-08-22 20:03:52', 'low_stock', 3352),
(90, 1, 'Low Stock Alert', 'D-ARTEPP ADULT 6\'S 80/640 is running low. Current stock: 2.00', 0, '2025-08-22 20:03:52', 'low_stock', 3361),
(91, 1, 'Low Stock Alert', 'ROUGH RIDER is running low. Current stock: 1.00', 0, '2025-08-22 20:06:39', 'low_stock', 3363),
(92, 1, 'Low Stock Alert', 'PANADOL ADVANCE PAIRS is running low. Current stock: 10.00', 0, '2025-08-24 20:52:07', 'low_stock', 3216),
(93, 1, 'Low Stock Alert', 'MENTHOPLUS BALM 9G is running low. Current stock: 1.00', 0, '2025-08-24 20:52:07', 'low_stock', 3254),
(94, 1, 'Low Stock Alert', 'ANTINAL CAPS is running low. Current stock: 3.00', 0, '2025-08-25 10:05:17', 'low_stock', 3365),
(95, 1, 'Low Stock Alert', 'IBUPROFEN 200 MG INDIA 2X3 is running low. Current stock: 35.00', 0, '2025-08-25 17:07:15', 'low_stock', 3180),
(96, 1, 'Low Stock Alert', 'PROMETHAZINE SYRUP is running low. Current stock: 1.00', 0, '2025-08-25 22:52:56', 'low_stock', 3367),
(97, 1, 'Low Stock Alert', 'COUGH LINCTUS 200ML is running low. Current stock: 1.00', 0, '2025-08-25 22:52:56', 'low_stock', 3368),
(98, 1, 'Low Stock Alert', 'HCG CASSETE is running low. Current stock: 1.00', 0, '2025-08-25 22:52:56', 'low_stock', 3369),
(99, 1, 'Low Stock Alert', 'IBUMEX SYRUP 100MG/5ML 100 ML is running low. Current stock: 1.00', 0, '2025-08-25 22:54:01', 'low_stock', 3111),
(100, 1, 'Low Stock Alert', 'DUOCOTEXIN 40/320 is running low. Current stock: 1.00', 0, '2025-08-26 16:02:14', 'low_stock', 3330),
(101, 1, 'Low Stock Alert', 'VOMIKIND TAB 8MG is running low. Current stock: 5.00', 0, '2025-08-27 15:52:30', 'low_stock', 2996),
(102, 1, 'Low Stock Alert', 'POSTINOR 2 PILLS is running low. Current stock: 2.00', 0, '2025-08-29 16:09:19', 'low_stock', 3364),
(103, 1, 'Low Stock Alert', 'VITAMIN B COMPLEX INJECTION is running low. Current stock: 10.00', 0, '2025-08-29 16:09:19', 'low_stock', 3370),
(104, 1, 'Low Stock Alert', 'PANADO EXTRA PAIRS is running low. Current stock: 2.00', 0, '2025-08-29 20:27:41', 'low_stock', 2999),
(105, 1, 'Low Stock Alert', 'MEDIVEN CREAM is running low. Current stock: 1.00', 0, '2025-09-02 17:06:10', 'low_stock', 3037),
(106, 1, 'Low Stock Alert', 'CREPE BANDAGE/ELASTIC BANDAGE 4INCH is running low. Current stock: 1.00', 0, '2025-09-02 17:06:10', 'low_stock', 3142),
(107, 1, 'Low Stock Alert', 'COTTON WOOL 200G is running low. Current stock: 1.00', 0, '2025-09-02 21:49:02', 'low_stock', 3385),
(108, 1, 'Product Expiring Soon', 'PANADO EXTRA PAIRS (Batch: Y114ZN) expires on 2025-10-01', 0, '2025-09-03 09:52:58', 'expiry', 2999),
(109, 1, 'Low Stock Alert', 'KETOZ CREAM 30 G is running low. Current stock: 1.00', 0, '2025-09-04 14:20:41', 'low_stock', 3035),
(110, 1, 'Low Stock Alert', 'DRAGON LIQUID is running low. Current stock: 1.00', 0, '2025-09-04 14:20:41', 'low_stock', 3069),
(111, 1, 'Low Stock Alert', 'SUPER WELGRA 100 is running low. Current stock: 2.00', 0, '2025-09-04 14:20:41', 'low_stock', 3296),
(112, 1, 'Low Stock Alert', 'ACTINAC PLUS TABLET is running low. Current stock: 6.00', 0, '2025-09-04 19:34:10', 'low_stock', 3001),
(113, 1, 'Low Stock Alert', 'ESOFAG-D is running low. Current stock: 4.00', 0, '2025-09-06 15:53:33', 'low_stock', 3195),
(114, 1, 'Low Stock Alert', 'KISS CONDOM CLASSIC BLUE is running low. Current stock: 2.00', 0, '2025-09-06 21:20:39', 'low_stock', 3186),
(115, 1, 'Low Stock Alert', 'OLFEN 100 MG CAPSULES is running low. Current stock: 3.00', 0, '2025-09-06 21:26:31', 'low_stock', 3423),
(116, 1, 'Low Stock Alert', 'IBUMEX SYRUP 100MG/5ML 60 ML is running low. Current stock: 1.00', 0, '2025-09-06 21:55:42', 'low_stock', 3424),
(117, 1, 'Low Stock Alert', 'APIDONE SYRUP125ML is running low. Current stock: 1.00', 0, '2025-09-07 16:26:02', 'low_stock', 3297),
(118, 1, 'Low Stock Alert', 'COTTON WOOL 100G is running low. Current stock: 1.00', 0, '2025-09-07 19:07:11', 'low_stock', 3384),
(119, 1, 'Low Stock Alert', 'ORS PLAIN is running low. Current stock: 5.00', 0, '2025-09-08 15:04:14', 'low_stock', 3153),
(120, 1, 'Low Stock Alert', 'GINSOMIN CAPSULE is running low. Current stock: 3.00', 0, '2025-09-08 20:22:19', 'low_stock', 3280),
(121, 1, 'Low Stock Alert', 'CADIPHEN SYRUP 100ML is running low. Current stock: 1.00', 0, '2025-09-08 20:58:32', 'low_stock', 3425),
(122, 1, 'Low Stock Alert', 'FANSIDAR TABLETS 3\'S is running low. Current stock: 2.00', 0, '2025-09-09 09:25:15', 'low_stock', 3292),
(123, 1, 'Low Stock Alert', 'CREPE BANDAGE/ELASTIC BANDAGE 6INCH is running low. Current stock: 1.00', 0, '2025-09-09 10:48:54', 'low_stock', 3140),
(124, 1, 'Low Stock Alert', 'MAGNESIUM TRISILICATE MIXTURE 200 ML is running low. Current stock: 2.00', 0, '2025-09-09 16:17:03', 'low_stock', 3265),
(125, 1, 'Low Stock Alert', 'SKDERM 15G CREAM is running low. Current stock: 1.00', 0, '2025-09-09 22:04:57', 'low_stock', 3032),
(126, 1, 'Low Stock Alert', 'ACNESOL CREAM 25G is running low. Current stock: 1.00', 0, '2025-09-10 19:35:55', 'low_stock', 3227),
(127, 1, 'Low Stock Alert', 'RECODIN SYRUP 100 ML is running low. Current stock: 1.00', 0, '2025-09-11 17:01:25', 'low_stock', 3366),
(128, 1, 'Low Stock Alert', 'MINTOGEL SYRUP 180 ML is running low. Current stock: 1.00', 0, '2025-09-11 21:15:03', 'low_stock', 3407),
(129, 1, 'Low Stock Alert', 'NO SORES GEL is running low. Current stock: 1.00', 0, '2025-09-11 21:19:24', 'low_stock', 3419),
(130, 1, 'Low Stock Alert', 'ANAFRANIL 25MG is running low. Current stock: 10.00', 0, '2025-09-13 19:42:40', 'low_stock', 3289),
(131, 1, 'Low Stock Alert', 'GOPAYN MR is running low. Current stock: 5.00', 0, '2025-09-13 20:56:37', 'low_stock', 3269),
(132, 1, 'Low Stock Alert', 'VITAMIN C 100 MG 2X3 is running low. Current stock: 45.00', 0, '2025-09-15 17:22:25', 'low_stock', 3174),
(133, 1, 'Low Stock Alert', 'AMLODAC 10 MG TABLETS is running low. Current stock: 5.00', 0, '2025-09-16 19:53:30', 'low_stock', 3349),
(134, 1, 'Low Stock Alert', 'GYNANFORTE PESSARIES is running low. Current stock: 10.00', 0, '2025-09-25 12:49:05', 'low_stock', 3347),
(135, 1, 'Low Stock Alert', 'NAPROXEN 500 UK TABLETS is running low. Current stock: 10.00', 0, '2025-09-25 12:49:05', 'low_stock', 3379),
(136, 1, 'Low Stock Alert', 'COLDRID SYRUP 100 ML is running low. Current stock: 1.00', 0, '2025-09-26 20:21:13', 'low_stock', 3005),
(137, 1, 'Low Stock Alert', 'ORNILOX TABLET is running low. Current stock: 5.00', 0, '2025-09-26 20:27:04', 'low_stock', 3025),
(138, 1, 'Low Stock Alert', 'FUCOL 200 is running low. Current stock: 7.00', 0, '2025-09-27 19:03:32', 'low_stock', 3171),
(139, 1, 'Low Stock Alert', 'AMOXICILLIN 500 MG INDIA is running low. Current stock: 10.00', 0, '2025-09-28 18:07:26', 'low_stock', 3100),
(140, 1, 'Low Stock Alert', 'TOFFPLUSS CAPSULE is running low. Current stock: 8.00', 0, '2025-09-28 18:07:26', 'low_stock', 3168),
(141, 1, 'Low Stock Alert', 'EFFERVESCENT VITAMIN C + ZINC 1000/25 is running low. Current stock: 5.00', 0, '2025-09-28 20:24:08', 'low_stock', 2982),
(142, 1, 'Low Stock Alert', 'ZITHROX 250MG (PACKET) is running low. Current stock: 1.00', 0, '2025-09-28 20:29:05', 'low_stock', 3359),
(143, 1, 'Low Stock Alert', 'WELLNESS COLD AND FLUE TABS is running low. Current stock: 1.00', 0, '2025-09-30 15:37:50', 'low_stock', 3021),
(144, 1, 'Product Expiring Soon', 'BIO-SPA 40MG TABLETS (Batch: E3S1GTA195) expires on 2025-10-31', 0, '2025-10-01 12:19:28', 'expiry', 3267),
(145, 1, 'Low Stock Alert', 'HCG STRIPS is running low. Current stock: 10.00', 0, '2025-10-02 21:18:20', 'low_stock', 3211),
(146, 1, 'Low Stock Alert', 'KAPRON 500MG TABLETS is running low. Current stock: 4.00', 0, '2025-10-03 12:52:21', 'low_stock', 3301),
(147, 1, 'Low Stock Alert', 'DICLOFENAC TABLETS 50 MG INDIA is running low. Current stock: 40.00', 0, '2025-10-03 18:14:52', 'low_stock', 3263),
(148, 1, 'Low Stock Alert', 'PIRITEX JUNIOR SYRUP is running low. Current stock: 1.00', 0, '2025-10-06 15:51:35', 'low_stock', 3110),
(149, 1, 'Low Stock Alert', 'NEOLORIDIN 5MG TABLETS is running low. Current stock: 10.00', 0, '2025-10-09 19:15:42', 'low_stock', 3275),
(150, 1, 'Low Stock Alert', 'NANA HERBAL MOUTH WASH SPRAY is running low. Current stock: 1.00', 0, '2025-10-09 21:03:27', 'low_stock', 3402),
(151, 1, 'Low Stock Alert', 'LYDIA INJECTION is running low. Current stock: 1.00', 0, '2025-10-10 17:15:54', 'low_stock', 3362),
(152, 1, 'Low Stock Alert', 'ROHISOL 15 ML SYRUP is running low. Current stock: 1.00', 0, '2025-10-11 21:02:32', 'low_stock', 2986),
(153, 1, 'Product Expiring Soon', 'ACECLOFENAC100  MG TABLETS (Batch: D2203177) expires on 2025-11-11', 0, '2025-10-12 21:52:14', 'expiry', 3420),
(154, 1, 'Low Stock Alert', 'COUGH LINCTUS 1LTR is running low. Current stock: 1.00', 0, '2025-10-12 22:00:31', 'low_stock', 3336),
(155, 1, 'Low Stock Alert', 'MIOPAN PLUS SYRUP 100ML is running low. Current stock: 1.00', 0, '2025-10-16 20:48:58', 'low_stock', 3260),
(156, 1, 'Low Stock Alert', 'ZEPPAR 400MG SUSPENSION 10ML is running low. Current stock: 2.00', 0, '2025-10-17 12:48:00', 'low_stock', 3129),
(157, 1, 'Low Stock Alert', 'ALBENDAZOLE TABLETS INDIA 400 MG is running low. Current stock: 4.00', 0, '2025-10-17 21:27:18', 'low_stock', 3117),
(158, 1, 'Low Stock Alert', 'SYRINGES 2ML is running low. Current stock: 5.00', 0, '2025-10-17 21:27:18', 'low_stock', 3240),
(159, 1, 'Low Stock Alert', 'PARACETAMOL INDIA 500 MG is running low. Current stock: 10.00', 0, '2025-10-18 18:44:40', 'low_stock', 2968),
(160, 1, 'Low Stock Alert', 'MENTHOXYL LOZENGES PAIRS is running low. Current stock: 5.00', 0, '2025-10-18 19:51:21', 'low_stock', 3190),
(161, 1, 'Low Stock Alert', 'CIPROFLOXACIN 500 INDIA TABLETS is running low. Current stock: 15.00', 0, '2025-10-18 19:51:21', 'low_stock', 3272),
(162, 1, 'Low Stock Alert', 'OSTEOCARE ORIGINAL is running low. Current stock: 2.00', 0, '2025-10-19 18:08:09', 'low_stock', 2995),
(163, 1, 'Low Stock Alert', 'AMOXIKID 250MG TABLETS is running low. Current stock: 5.00', 0, '2025-10-20 17:54:41', 'low_stock', 3094),
(164, 1, 'Low Stock Alert', 'CETAMOL SYRUP 100ML 125MG/5ML is running low. Current stock: 1.00', 0, '2025-10-20 20:46:49', 'low_stock', 3453),
(165, 1, 'Low Stock Alert', 'DYNAPAR INJECTION 75MG/ML is running low. Current stock: 2.00', 0, '2025-10-21 10:11:47', 'low_stock', 3446),
(166, 1, 'Low Stock Alert', 'SKDERM 30G CREAM is running low. Current stock: 1.00', 0, '2025-10-23 15:33:01', 'low_stock', 3031),
(167, 1, 'Low Stock Alert', 'RELCER GEL 100ML is running low. Current stock: 1.00', 0, '2025-10-23 15:35:01', 'low_stock', 3224),
(168, 1, 'Low Stock Alert', 'O CONDOM is running low. Current stock: 2.00', 0, '2025-10-23 19:20:40', 'low_stock', 3421),
(169, 1, 'Low Stock Alert', 'METRONIDAZOLE 400 AXCEL is running low. Current stock: 20.00', 0, '2025-10-23 21:06:22', 'low_stock', 3097),
(170, 1, 'Low Stock Alert', 'ERYTHROMYCIN 250MG TABLETS is running low. Current stock: 12.00', 0, '2025-10-25 18:27:04', 'low_stock', 3088),
(171, 1, 'Low Stock Alert', 'DESLORAT TABLETS 5MG is running low. Current stock: 4.00', 0, '2025-10-27 18:59:44', 'low_stock', 3213),
(172, 1, 'Low Stock Alert', 'FLUCAP CAPSULES is running low. Current stock: 8.00', 0, '2025-10-28 12:57:58', 'low_stock', 3197),
(173, 1, 'Low Stock Alert', 'DYNAPAR TABLETS is running low. Current stock: 20.00', 0, '2025-10-28 19:22:59', 'low_stock', 3167),
(174, 1, 'Low Stock Alert', 'MOSEDIN 10MG TABLET is running low. Current stock: 4.00', 0, '2025-10-28 19:52:24', 'low_stock', 3215),
(175, 1, 'Low Stock Alert', 'COARTEM 20/120 TABLETS INDIA 24\'S is running low. Current stock: 16.00', 0, '2025-10-29 11:59:35', 'low_stock', 3271),
(176, 1, 'Low Stock Alert', 'GRISEOFULVIN 500MG INDIA TABLETS is running low. Current stock: 2.00', 0, '2025-10-29 16:23:07', 'low_stock', 3252),
(177, 1, 'Low Stock Alert', 'INFLAZONE OINTMENT 30G is running low. Current stock: 1.00', 0, '2025-10-29 20:00:09', 'low_stock', 3047),
(178, 1, 'Product Expiring Soon', 'HIV TEST STRIPS (Batch: 0000885925) expires on 2025-11-30', 0, '2025-10-31 09:37:03', 'expiry', 3286),
(179, 1, 'Low Stock Alert', 'LEVOCET-M is running low. Current stock: 10.00', 0, '2025-10-31 15:48:08', 'low_stock', 3220),
(180, 1, 'Low Stock Alert', 'MEBENDAZOLE SYRUP 30ML is running low. Current stock: 2.00', 0, '2025-10-31 20:59:35', 'low_stock', 3400),
(181, 1, 'Low Stock Alert', 'BACK-UP PILLS is running low. Current stock: 2.00', 0, '2025-11-01 11:55:25', 'low_stock', 3147),
(182, 1, 'Low Stock Alert', 'PIROXICAM 20 MG CAPSULES is running low. Current stock: 20.00', 0, '2025-11-01 17:32:03', 'low_stock', 3029),
(183, 1, 'Low Stock Alert', 'ZEPPAR 400MG TABLETS 2\'S  is running low. Current stock: 2.00', 0, '2025-11-01 20:12:50', 'low_stock', 3118),
(184, 1, 'Low Stock Alert', 'PENEGRA 100 MG TABLETS is running low. Current stock: 2.00', 0, '2025-11-01 20:29:09', 'low_stock', 3124),
(185, 1, 'Low Stock Alert', 'CANNULA is running low. Current stock: 4.00', 0, '2025-11-03 20:52:35', 'low_stock', 3456),
(186, 1, 'Low Stock Alert', 'OCUREST-AH EYEDROPS is running low. Current stock: 1.00', 0, '2025-11-03 21:02:24', 'low_stock', 3137),
(187, 1, 'Low Stock Alert', 'NORMAL SALINE 500 ML is running low. Current stock: 1.00', 0, '2025-11-04 11:10:56', 'low_stock', 3154),
(188, 1, 'Low Stock Alert', 'MUCOLEX EXPECTORANT SYRUP is running low. Current stock: 1.00', 0, '2025-11-04 19:22:52', 'low_stock', 3214),
(189, 1, 'Product Expiring Soon', 'ASCORIL SYRUP 200 ML (Batch: 10233167) expires on 2025-11-11', 0, '2025-11-05 14:10:15', 'expiry', 3465),
(190, 1, 'Low Stock Alert', 'CREPE BANDAGE/ELASTIC BANDAGE 3INCH is running low. Current stock: 1.00', 0, '2025-11-05 14:19:00', 'low_stock', 3141),
(191, 1, 'Low Stock Alert', 'FLUFED TABLETS is running low. Current stock: 6.00', 0, '2025-11-05 16:14:05', 'low_stock', 3418),
(192, 1, 'Low Stock Alert', 'COTRIMOXAZOLE 480 MG TABLETS INDIA is running low. Current stock: 20.00', 0, '2025-11-06 10:46:39', 'low_stock', 3105),
(193, 1, 'Low Stock Alert', 'CHLORAMPHENICOL SUSPENSION 100ML is running low. Current stock: 1.00', 0, '2025-11-06 10:46:39', 'low_stock', 3355),
(194, 1, 'Low Stock Alert', 'AMOXICILLIN 250 MG INDIA is running low. Current stock: 10.00', 0, '2025-11-07 11:54:41', 'low_stock', 3161),
(195, 1, 'Low Stock Alert', 'FERROUS SULPHATE / FOLIC ACID is running low. Current stock: 5.00', 0, '2025-11-08 20:12:17', 'low_stock', 3448),
(196, 1, 'Low Stock Alert', 'CATENOL 50 MG is running low. Current stock: 10.00', 0, '2025-11-09 21:08:04', 'low_stock', 3392),
(197, 1, 'Low Stock Alert', 'DERMOLIN-GM CREAM is running low. Current stock: 1.00', 0, '2025-11-10 19:44:24', 'low_stock', 2998),
(198, 1, 'Low Stock Alert', 'VITAMIN B COMPLEX TABLETS 2X2 is running low. Current stock: 10.00', 0, '2025-11-10 19:44:24', 'low_stock', 3222);

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

--
-- Dumping data for table `pharmacy_details`
--

INSERT INTO `pharmacy_details` (`id`, `name`, `address`, `phone`, `email`, `created_at`, `updated_at`) VALUES
(1, 'Charis Health Drugs', 'Luwafu-Amazon Makindye', '0775480232', 'Charishealth@gmail.com', '2025-07-27 16:35:11', '2025-07-27 16:35:11');

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
  `expiry_date` date NOT NULL,
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
(2968, 'PARACETAMOL INDIA 500 MG', 'Paracetamol 500mg', NULL, '5310', 120.00, 15.00, 50.00, '2027-07-31', NULL, '2025-07-28 23:01:10', '2025-11-09 23:21:46', 10, '20250822192615206', 'tab', NULL),
(2969, 'AMPICLOX 500MG INDIA', 'Ampiclox india', NULL, '03525', 40.00, 129.00, 200.00, '2027-07-07', NULL, '2025-07-28 23:01:10', '2025-11-10 16:31:17', 10, '20250905192530105', 'cap', NULL),
(2970, 'CRANMAX SACHETS', 'cranberry extract', NULL, '672', 7.00, 1900.00, 3000.00, '2026-06-25', NULL, '2025-07-28 23:01:10', '2025-11-03 22:55:55', 2, 'CHAR-3', 'scht', NULL),
(2971, 'STREPSILS HONEY AND LEMON', 'LOZENGES ', NULL, 'ABC991', 23.00, 542.00, 1000.00, '2027-02-23', NULL, '2025-07-28 23:01:10', '2025-11-10 21:46:29', 2, '20250905195254764', 'pce', NULL),
(2972, 'STREPSILS original', 'LOZENGES ', NULL, 'ABD6085', 1.00, 542.00, 1000.00, '0004-10-27', NULL, '2025-07-28 23:01:10', '2025-09-05 18:31:34', 2, 'CHAR-5', 'pair', NULL),
(2973, 'Ballet Mosquito repellant jelly 50g', 'mosquito repellant', NULL, '31A 0872', 1.00, 5500.00, 9000.00, '0002-01-30', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-6', 'tin', NULL),
(2974, 'Ballet Mosquito repellant jelly 100g', 'mosquito repellant', NULL, '31A 0872', 1.00, 9000.00, 15000.00, '0002-01-30', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-7', 'tin', NULL),
(2975, 'DERMOFIX CREAM 20G', 'SERTACONAZOLE NITRATE ', NULL, 'V004', 1.00, 18000.00, 27000.00, '0011-01-27', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-8', 'cream', NULL),
(2976, 'NORMAGUT 250 MG ', 'probiotic capsule', NULL, '440140', 30.00, 1834.00, 3000.00, '0026-08-31', NULL, '2025-07-28 23:01:10', NULL, 5, 'CHAR-9', 'capsule', NULL),
(2977, 'SENSODYNE RAPID ACTION 75 ML', 'TOOTH PASTE', NULL, 'Y036BB', 1.00, 13000.00, 23000.00, '2027-12-31', NULL, '2025-07-28 23:01:10', '2025-08-20 20:23:19', 0, '20250820192212857', 'pce', NULL),
(2978, 'SENSODYNE MULTICARE 40 ML', 'TOOTH PASTE', NULL, 'Y010AL', 0.00, 7000.00, 10000.00, '0009-01-27', NULL, '2025-07-28 23:01:10', '2025-08-12 20:07:47', 0, 'CHAR-11', 'gel', NULL),
(2979, 'SENSODYNE REPAIR AND PROTECT 75 ML', 'TOOTH PASTE', NULL, '50385KWC', 0.00, 14500.00, 23000.00, '0011-05-26', NULL, '2025-07-28 23:01:10', '2025-08-12 22:25:43', 0, 'CHAR-12', 'gel', NULL),
(2980, 'SENSODYNE MULTICARE 75 ML', 'TOOTH PASTE', NULL, 'Y012AL', 1.00, 11500.00, 17000.00, '0009-01-27', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-13', 'gel', NULL),
(2981, 'TAXIM-O 400MG ', 'cefixime 400 mg ', NULL, 'tcu24002emdt', 4.00, 2600.00, 4000.00, '0026-09-30', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-14', 'tablet', NULL),
(2982, 'EFFERVESCENT VITAMIN C + ZINC 1000/25', 'Vitamin c + zinc ', NULL, 'PHN-062465', 0.00, 650.00, 1500.00, '0027-05-30', NULL, '2025-07-28 23:01:10', '2025-11-09 23:04:44', 5, 'CHAR-15', 'tab', NULL),
(2983, 'GO-GEL 30 G', 'Diclofenac gel', NULL, 'DM24021', 2.00, 2500.00, 5000.00, '0026-05-30', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-16', 'gel', NULL),
(2984, 'XERIN TABS 5/10 MG', 'MONTELUKAST 10 MG + LEVOCETRIZIN 5MG', NULL, '426TX24', 10.00, 350.00, 700.00, '0010-01-27', NULL, '2025-07-28 23:01:10', '2025-08-02 17:13:02', 2, 'CHAR-17', 'tab', NULL),
(2985, 'OFLOTECH-O 500/200', 'ORNIDAZOLE 500 + OFLOXACIN 200', NULL, '417GG05', 0.00, 900.00, 2000.00, '0006-01-26', NULL, '2025-07-28 23:01:10', '2025-09-08 20:30:06', 5, 'CHAR-18', 'tablet', NULL),
(2986, 'ROHISOL 15 ML SYRUP', 'LEVAMISOL HYDRICHLORIDE SYRUP', NULL, '241411', 1.00, 2200.00, 3500.00, '0006-01-27', NULL, '2025-07-28 23:01:10', '2025-10-11 22:01:40', 1, 'CHAR-19', 'syrup', NULL),
(2987, 'KWESIIMA HERBAL SYRUP', 'HERBAL COUGH SYRUP', NULL, '625', 3.00, 2200.00, 3500.00, '0002-01-27', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-20', 'syrup', NULL),
(2988, 'JENACOF 200 ML', 'HERBAL COUGH SYRUP', NULL, 'JCFEB00251', 2.00, 4800.00, 7500.00, '2027-06-06', NULL, '2025-07-28 23:01:10', '2025-11-10 16:31:17', 1, '20250905201356893', 'btl', NULL),
(2989, 'SEDIPROCT CREAM', 'HAEMORRHOIDS CREAM', NULL, '244437', 1.00, 7500.00, 12000.00, '2028-01-31', NULL, '2025-07-28 23:01:10', '2025-08-28 18:56:47', 0, '20250828175611806', 'pce', NULL),
(2990, 'LYDIA POST-PILL', 'Levonogestrel 1.5 mg', NULL, 'NR0206OA', -1.00, 1700.00, 5000.00, '2027-09-09', NULL, '2025-07-28 23:01:10', '2025-11-09 23:04:44', 2, '20250905200828900', 'dos', NULL),
(2991, 'GYNOZOLE OVULES / PESSARIES', 'MICONAZOLE 400 MG PESSARIES', NULL, '231439', 0.00, 16100.00, 24000.00, '0004-01-26', NULL, '2025-07-28 23:01:10', '2025-10-16 19:19:31', 0, 'CHAR-24', 'dos', NULL),
(2992, 'MOXAFORTE 500 MG CAPSULES', 'AMOXICILLIN 250 / FLUCLOXACILLIN 250', NULL, '2410223', 17.00, 500.00, 1000.00, '0009-01-27', NULL, '2025-07-28 23:01:10', '2025-11-06 19:50:55', 5, 'CHAR-25', 'cap', NULL),
(2993, 'LIVOLIN FORTE CAPSULE', 'LIVER PROTECTING MULTI VITAMIN', NULL, '24I07C3', 18.00, 904.00, 1300.00, '0009-06-26', NULL, '2025-07-28 23:01:10', '2025-10-20 18:54:32', 5, 'CHAR-26', 'capsule', NULL),
(2994, 'OSTEOMIN TABLET', 'GLUCOSAMINE + CHONDROITIN', NULL, 'PF0207', 26.00, 1634.00, 2500.00, '0028-02-28', NULL, '2025-07-28 23:01:10', '2025-10-19 19:05:10', 5, 'CHAR-27', 'tablet', NULL),
(2995, 'OSTEOCARE ORIGINAL', 'CALCIUM/MAGNESIUM/VITAMIN D', NULL, '128823A', 0.00, 767.00, 1300.00, '0028-04-30', NULL, '2025-07-28 23:01:10', '2025-11-10 21:44:22', 5, 'CHAR-28', 'tab', NULL),
(2996, 'VOMIKIND TAB 8MG', 'ONDANSETRON 8MG', NULL, 'J82X003', 16.00, 310.00, 1000.00, '2027-10-10', NULL, '2025-07-28 23:01:10', '2025-11-08 09:00:41', 5, '20250905200149301', 'tab', NULL),
(2997, 'NEOMYCIN CREAM INDIA', 'NEOMYCIN CREAM', NULL, 'D26025001', 2.00, 2500.00, 5000.00, '2028-03-31', NULL, '2025-07-28 23:01:10', '2025-10-21 15:26:44', 1, '20250905190910651', 'pce', NULL),
(2998, 'DERMOLIN-GM CREAM', 'CLOBETASOL/MICONAZOLE/GENTAMYCIN', NULL, 'BB419', 1.00, 2700.00, 5000.00, '0026-09-30', NULL, '2025-07-28 23:01:10', '2025-11-10 21:44:22', 1, 'CHAR-31', 'cream', NULL),
(2999, 'PANADO EXTRA PAIRS', 'PARACETAMO/CAFFEINE', NULL, 'Y114ZN', 59.00, 410.00, 600.00, '2026-05-10', NULL, '2025-07-28 23:01:10', '2025-11-10 16:31:17', 5, '20250905200623685', 'dos', NULL),
(3000, 'GOFEN 400 MG CAPSULE', 'FAST ACTING IBUPROFEN 400', NULL, '24J26DI', 21.00, 580.00, 1000.00, '2026-10-25', NULL, '2025-07-28 23:01:10', '2025-11-10 21:44:22', 10, '20250905190455223', 'cap', NULL),
(3001, 'ACTINAC PLUS TABLET', 'ACECLOFENAC 100 / PARACETAMOL 500', NULL, 'PM05794', -4.00, 215.00, 500.00, '2027-11-11', NULL, '2025-07-28 23:01:10', '2025-11-09 23:04:44', 10, '20250905211243881', 'tab', NULL),
(3002, 'CIPLADON 1000MG EFFERVESCENT TABLET', 'EFFERVESCENT PARACETAMOL 1000 MG', NULL, '41D0832', 4.00, 1375.00, 2000.00, '2027-03-31', NULL, '2025-07-28 23:01:10', '2025-11-06 21:45:46', 4, '20250905200722448', 'tab', NULL),
(3003, 'LONART TABLETS 20/120 24\'S ', 'ARTEMETHER / LUMEFANTRINE 20/120', NULL, 'T3ACG025', 0.00, 2200.00, 5000.00, '2028-02-29', NULL, '2025-07-28 23:01:10', '2025-11-03 22:36:03', 2, '20250822193044736', 'dos', NULL),
(3004, 'VOMI-6 TABLETS', 'DOXYLAMINE / PYRIDOXIME ', NULL, 'FC4003', 26.00, 550.00, 1000.00, '2027-04-30', NULL, '2025-07-28 23:01:10', '2025-09-04 15:14:37', 5, '20250804174917910', 'tab', NULL),
(3005, 'COLDRID SYRUP 100 ML', 'CETRIZINE /PHENYLEPHRINE/PARACETAMOL', NULL, 'C40093', 2.00, 4000.00, 6000.00, '2027-08-31', NULL, '2025-07-28 23:01:10', '2025-11-04 21:20:06', 1, '20250731182514272', 'syp', NULL),
(3006, 'DYNAPAR SPRAY 30 ML', 'DICLOFENAC SPRAY', NULL, 'AB4045', 0.00, 17000.00, 25000.00, '0009-01-26', NULL, '2025-07-28 23:01:10', '2025-08-23 16:34:48', 0, 'CHAR-39', 'bottle', NULL),
(3007, 'COTTON WOOL 50G ', 'COTTON 50 G', NULL, 'BO1140725', 1.00, 1200.00, 2500.00, '2028-07-31', NULL, '2025-07-28 23:01:10', '2025-11-10 16:31:17', 1, '20250902213431617', 'strp', NULL),
(3008, 'AQUASAFE / WATERGUARD STRIP', 'WATER PURIFICATION', NULL, '624219', -0.70, 875.00, 1500.00, '0008-01-28', NULL, '2025-07-28 23:01:10', '2025-11-10 16:29:51', 2, 'CHAR-41', 'strip', NULL),
(3009, 'BACTOCLAV 625 MG TABLET', 'AMOXICILLIN + POTASSIUM CLAVUNATE 500/125 MG', NULL, 'BABBV0174', 8.00, 525.00, 1000.00, '2027-04-30', NULL, '2025-07-28 23:01:10', '2025-11-09 23:08:03', 5, '20250828175515428', 'tab', NULL),
(3010, 'BISACODYL 5MG TABLET', 'LAXATIVE FOR CONSTIPATION', NULL, 'DG0098', 25.00, 35.00, 100.00, '0006-01-27', NULL, '2025-07-28 23:01:10', '2025-10-21 11:01:40', 10, 'CHAR-43', 'tablet', NULL),
(3011, 'LOSACAR-H 50/12.5', 'LOSARTAN POTASSIUM/HYDROCHLOROTHIAZIDE', NULL, 'G402370', 18.00, 400.00, 600.00, '2027-08-31', NULL, '2025-07-28 23:01:10', '2025-11-10 21:44:22', 10, '20250902212804591', 'tab', NULL),
(3012, 'ZAHA SYRUP 200MG/5ML 15ML', 'AZITHROMYCIN SYRUP 15 ML', NULL, '1158', 0.00, 4300.00, 7000.00, '0026-11-30', NULL, '2025-07-28 23:01:10', '2025-08-29 17:32:26', 1, 'CHAR-45', 'syp', NULL),
(3013, 'GLYCERIN SUPPOSITORIES 4G', 'GLYCEROL SUPPOSITORIES FOR CONSTIPATION', NULL, 'G24105', 8.00, 1416.00, 3000.00, '0010-01-27', NULL, '2025-07-28 23:01:10', '2025-10-09 22:03:16', 2, 'CHAR-46', 'suppository', NULL),
(3014, 'METRONIDAZOLE SYRUP INDIA 200MG/5ML 100ML ', 'METRONIDAZOLE SYRUP 100 ML', NULL, '250772', 0.00, 2800.00, 5000.00, '2028-03-31', NULL, '2025-07-28 23:01:10', '2025-10-13 16:50:56', 1, '20250822191525124', 'btl', NULL),
(3015, 'AMOXICLAV DENK 500/62.5 TABS', 'AMOXICILLIN 500 / CLAVULANIC ACID 62.5 TABLETS', NULL, '29143', 40.00, 1200.00, 2000.00, '2026-01-26', NULL, '2025-07-28 23:01:10', '2025-10-02 19:31:17', 5, 'CHAR-48', 'tab', NULL),
(3016, 'CLONEM CREAM 15 G', 'CLOTRIMAZOLE CREAM', NULL, '18', 4.00, 900.00, 2000.00, '0027-08-30', NULL, '2025-07-28 23:01:10', '2025-10-31 22:59:33', 1, 'CHAR-49', 'cream', NULL),
(3017, 'ALZENTEL SYRUP 15ML', 'ALBENDAZOLE 400 MG SYRUP', NULL, '2403168', 1.00, 5600.00, 9000.00, '2027-01-27', NULL, '2025-07-28 23:01:10', '2025-08-01 20:11:26', 1, 'CHAR-50', 'dos', NULL),
(3018, 'ELFERB SYRUP 120 ML', 'COUGH SYRUP', NULL, '2644', 1.00, 11500.00, 17000.00, '2026-01-31', NULL, '2025-07-28 23:01:10', '2025-11-04 21:43:35', 0, 'CHAR-51', 'syp', NULL),
(3019, 'COFERB SYRUP 120 ,L', 'COLDS AND IMMUNITY SYRUP', NULL, '2503C', 1.00, 10500.00, 16000.00, '2026-05-26', NULL, '2025-07-28 23:01:10', '2025-11-04 21:47:45', 0, 'CHAR-52', 'syp', NULL),
(3020, 'NIGHT AND DAY TABS', 'PARACETAMO/PSEUDOEPHEDRINE/DIPHENHYDRAMINE TABS', NULL, '242167', 0.00, 5000.00, 8000.00, '2028-05-31', NULL, '2025-07-28 23:01:10', '2025-11-08 21:08:42', 0, '20250822191815781', 'strp', NULL),
(3021, 'WELLNESS COLD AND FLUE TABS', 'COLDS AND FEVER SYRUP', NULL, '60151', 1.00, 5750.00, 8000.00, '0011-01-26', NULL, '2025-07-28 23:01:10', '2025-09-30 16:37:49', 1, 'CHAR-54', 'strip', NULL),
(3022, 'MAGNES ACTIVE SACHETS', 'MAGNESIUM / VITAMIN D SUPPLEMENTS', NULL, '27430', 0.00, 800.00, 1200.00, '0025-08-31', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-55', 'sachet', NULL),
(3023, 'SURGICAL SPIRIT 100ML', 'SURGICAL SPIRIT', NULL, '1232', 3.00, 2200.00, 3500.00, '0006-01-27', NULL, '2025-07-28 23:01:10', '2025-11-06 11:52:15', 1, 'CHAR-56', 'bottle', NULL),
(3024, 'HYDROGEN PEROXIDE 100ML', 'HYDROGEN PEROXIDE SOLUTION', NULL, '3799', 3.00, 1300.00, 2000.00, '0011-01-26', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-57', 'bottle', NULL),
(3025, 'ORNILOX TABLET', 'ORNIDAZOLE 500 + OFLOXACIN 200', NULL, 'ONOH0173', 5.00, 2650.00, 4000.00, '0010-01-27', NULL, '2025-07-28 23:01:10', '2025-09-26 21:27:02', 5, 'CHAR-58', 'tablet', NULL),
(3026, 'METFORMIN DENK 1000MG', 'METFORMIN 1000 MG DIABETCS', NULL, '29858', 20.00, 490.00, 700.00, '2027-11-30', NULL, '2025-07-28 23:01:10', '2025-11-06 20:39:29', 5, '20250820195550216', 'tab', NULL),
(3027, 'LIMZER CAPSULES 20/30', 'OMEPRAZOLE/DOMPERIDONE 20/30 MG CAPSULES', NULL, 'A00252501', 30.00, 800.00, 1200.00, '0006-01-27', NULL, '2025-07-28 23:01:10', NULL, 5, 'CHAR-60', 'capsule', NULL),
(3028, 'BETANASE 5MG', 'GLIBENCLAMIDE 5MG INDIA', NULL, 'G402861', 220.00, 53.00, 100.00, '0009-01-28', NULL, '2025-07-28 23:01:10', '2025-10-10 19:43:07', 20, 'CHAR-61', 'tablet', NULL),
(3029, 'PIROXICAM 20 MG CAPSULES', 'PIROXICAM 20 MG', NULL, '18231', 0.00, 29.00, 100.00, '2026-06-30', NULL, '2025-07-28 23:01:10', '2025-11-03 23:00:31', 20, '20250820193853365', 'tab', NULL),
(3030, 'SUCRAFIL-O GEL 200 ML', 'SUCRALFATE / OXETACAINE SUSPENSION', NULL, 'M1783', 1.00, 11500.00, 2000.00, '0011-01-27', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-63', 'syrup', NULL),
(3031, 'SKDERM 30G CREAM', 'CLOTRIMAZOLE/BETAMETHASONE/GENTAMYCIN', NULL, 'BE25005', 0.00, 3400.00, 5000.00, '2027-12-31', NULL, '2025-07-28 23:01:10', '2025-10-29 18:23:03', 1, '20250905191024894', 'pce', NULL),
(3032, 'SKDERM 15G CREAM', 'CLOTRIMAZOLE/BETAMETHASONE/GENTAMYCIN', NULL, 'BE25001', 0.00, 2400.00, 4000.00, '2027-12-31', NULL, '2025-07-28 23:01:10', '2025-10-15 20:44:04', 1, '20250807214657294', 'pce', NULL),
(3033, 'FLUCAMOX SYRUP 250/5ML 100 ML', 'AMOXICILLIN / FLUCLOXACILLIN SYRUP ', NULL, '0923003', 1.00, 16500.00, 25000.00, '2026-09-30', NULL, '2025-07-28 23:01:10', '2025-08-22 20:15:15', 0, '20250822191400966', 'btl', NULL),
(3034, 'PIRITEX BABY SYRUP', 'PEADIATRIC COUGHS', NULL, '4923', 5.00, 3500.00, 4500.00, '0009-01-26', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-67', 'syrup', NULL),
(3035, 'KETOZ CREAM 30 G', 'KETOCONAZOLE 1% CREAM', NULL, 'KE24017', 1.00, 3500.00, 7000.00, '2026-06-27', NULL, '2025-07-28 23:01:10', '2025-09-05 20:38:05', 1, 'CHAR-68', 'pce', NULL),
(3036, 'MEDIVEN CREAM', 'BETAMETHASONE CREAM', NULL, '240935', 2.00, 2400.00, 3500.00, '0004-04-27', NULL, '2025-07-28 23:01:10', '2025-08-18 15:05:17', 1, 'CHAR-69', 'cream', NULL),
(3037, 'MEDIVEN CREAM', 'BETAMETHASONE CREAM', NULL, '231333', 0.00, 2400.00, 3500.00, '0006-06-26', NULL, '2025-07-28 23:01:10', '2025-10-31 16:52:57', 1, 'CHAR-70', 'cream', NULL),
(3038, 'FUNGNIL CREAM', 'CLOTRIMAZOLE CREAM 1%', NULL, 'D26223008', 2.00, 1500.00, 2500.00, '0006-06-26', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-71', 'cream', NULL),
(3039, 'DELOR CREAM', 'CLOBETASOLE CREAM', NULL, '2240167', 1.00, 18000.00, 24000.00, '0009-09-26', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-72', 'cream', NULL),
(3040, 'FUNGISAFE CREAM', 'TERBINAFINE CREAM EGYPT', NULL, '230497', 1.00, 12000.00, 17000.00, '0011-11-27', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-73', 'cream', NULL),
(3041, 'TERBIRIVCREAM', 'TERBINAFINE CREAM INDIA', NULL, 'EF033', 1.00, 4500.00, 8000.00, '2027-02-01', NULL, '2025-07-28 23:01:10', '2025-10-10 18:15:51', 0, '20250905200342724', 'pce', NULL),
(3042, 'DREZ OINTMENT', 'METRONIDZOLE /IODINE', NULL, 'XD0340', 1.00, 5000.00, 7000.00, '0011-11-27', NULL, '2025-07-28 23:01:10', '2025-08-06 22:29:37', 1, 'CHAR-75', 'cream', NULL),
(3043, 'DERMIDEX CREAM', 'MICONAZOLE CREAM', NULL, '232071', 2.00, 3000.00, 4000.00, '0010-10-26', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-76', 'cream', NULL),
(3044, 'SUPIROCIN CREAM', 'MUPIROCIN CREAM', NULL, '1020715', 0.00, 15000.00, 20000.00, '0002-02-26', NULL, '2025-07-28 23:01:10', '2025-09-23 21:50:05', 0, 'CHAR-77', 'cream', NULL),
(3045, 'SULFUR OINTMMENT', 'SULFUR INTMENT', NULL, '232668', 0.00, 1500.00, 2500.00, '0010-10-26', NULL, '2025-07-28 23:01:10', '2025-11-07 11:10:47', 0, 'CHAR-78', 'cream', NULL),
(3046, 'FASTUM GEL30G', 'KETOPROFEN GEL ', NULL, '4166A', 1.00, 15000.00, 19000.00, '0004-04-29', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-79', 'cream', NULL),
(3047, 'INFLAZONE OINTMENT 30G', 'DICLOFENAC/CAMPHOR/EUCALYPTUS', NULL, 'C207', 1.00, 4000.00, 6000.00, '0010-10-27', NULL, '2025-07-28 23:01:10', '2025-10-29 21:59:09', 1, 'CHAR-80', 'cream', NULL),
(3048, 'CANDIDERM CREAM', 'CLOTRIMAZOLE/BECLOMETASONE/GENTAMYCIN', NULL, '10241288', 1.00, 4500.00, 7000.00, '0005-10-27', NULL, '2025-07-28 23:01:10', '2025-10-31 22:59:33', 0, 'CHAR-81', 'pce', NULL),
(3049, 'MCG CREAM 15G ', 'MICONAZOLE/CLOBETASOLE/GENTAMYCIN', NULL, '1625', 0.00, 2500.00, 5000.00, '2026-02-07', NULL, '2025-07-28 23:01:10', '2025-11-04 21:19:08', 0, '20250807215101791', 'pce', NULL),
(3050, 'CLOTRIDENK CREAM 20G', 'CLOTRIMAZOLE CREAM 1%', NULL, '5669', 0.00, 12000.00, 18000.00, '0003-03-27', NULL, '2025-07-28 23:01:10', '2025-10-29 13:58:19', 0, 'CHAR-83', 'cream', NULL),
(3051, 'SONADERM GM CREAM', 'CLOBETASOL/MICONAZOLE/GENTAMYCIN', NULL, 'A2337', 0.00, 3800.00, 5000.00, '0002-02-26', NULL, '2025-07-28 23:01:10', '2025-11-06 17:03:55', 0, 'CHAR-84', 'cream', NULL),
(3052, 'GLYCERIN OF BORAX', 'GLYCERINE OF BORAX', NULL, '92300', 6.00, 1800.00, 2500.00, '0010-10-25', NULL, '2025-07-28 23:01:10', '2025-10-16 19:11:33', 0, 'CHAR-85', 'btl', NULL),
(3053, 'BUCONAZOLE ORAL GEL', 'MICONAZOLE ORAL CREAM 2%', NULL, '594', 1.00, 8000.00, 10000.00, '0004-04-26', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-86', 'cream', NULL),
(3054, 'MICONAZOLE ORAL GEL', 'MICONAZOLE ORAL CREAM 2%', NULL, '240214', 1.00, 8000.00, 11000.00, '0001-01-28', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-87', 'cream', NULL),
(3055, 'GLYCEROL SUPPOSITORIES 4G', 'GYCEROL', NULL, 'G24105', 8.00, 2000.00, 3000.00, '0010-10-27', NULL, '2025-07-28 23:01:10', '2025-09-06 14:53:57', 0, 'CHAR-88', 'suppository', NULL),
(3056, 'FERTILO FORTE', 'L-arginine,L-carnitine,coenzyme Q10,vitamin E,folic acid,zinc,selenium', NULL, '29239', 19.00, 2700.00, 3500.00, '0001-01-26', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-89', 'sachet', NULL),
(3057, 'MEDICAL MASKS', 'MASKS', NULL, '20241209', 49.00, 110.00, 1000.00, '2027-12-12', NULL, '2025-07-28 23:01:10', '2025-10-07 18:31:57', 0, '20250905203255112', 'pce', NULL),
(3058, 'SKDERM CREAM 30g', 'BETAMETHASONE/CLOTRIMAZOLE/GENTAMICIN', NULL, 'BE24089', 1.00, 3500.00, 5000.00, '0005-05-27', NULL, '2025-07-28 23:01:10', '2025-10-14 17:10:04', 0, 'CHAR-91', 'cream', NULL),
(3060, 'BETADERM N OINTMENT 15g', 'BETAMETHAZONE/NEOMYCIN', NULL, 'JZ006K', 1.00, 3000.00, 4000.00, '0002-03-26', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-93', 'cream', NULL),
(3061, 'UNISTEN CREAM ', 'CLOTRIMAZOLE CREAM 1%', NULL, '250300', 4.00, 1200.00, 3000.00, '2028-02-27', NULL, '2025-07-28 23:01:10', '2025-11-01 21:57:18', 1, 'CHAR-94', 'pce', NULL),
(3062, 'ADHESIVE PLASTER 5CMX5M', 'ZINC OXIDE', NULL, 'LBD20240408', 2.00, 2500.00, 4500.00, '2029-03-29', NULL, '2025-07-28 23:01:10', '2025-08-01 20:05:25', 0, 'CHAR-95', 'pce', NULL),
(3063, 'ADHESIVE PLASTER 2.5CMX4Y', 'ZINC OXIDE', NULL, 'LBD20240408', 2.00, 1500.00, 2500.00, '2029-03-29', NULL, '2025-07-28 23:01:10', '2025-08-01 20:04:34', 0, 'CHAR-96', 'pce', NULL),
(3064, 'BURNEM CREAM 20g', 'ACRIFLAVINE CREAM', NULL, '222', 2.00, 1800.00, 2500.00, '0001-01-28', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-97', 'cream', NULL),
(3065, 'FUNBACT-A', 'CLOTRIMAZOLE/BETAMETHASONE/NEOMYCIN/CHLOROCRESOL', NULL, 'KBF187', 0.00, 2600.00, 5000.00, '2028-12-27', NULL, '2025-07-28 23:01:10', '2025-10-08 16:35:46', 0, 'CHAR-98', 'pce', NULL),
(3066, 'TINODERM OINTMENT', 'BENZOIC ACID+SALICYLIC ACID+MENTHOL OITMENT', NULL, '237', 2.00, 1500.00, 3000.00, '2027-10-10', NULL, '2025-07-28 23:01:10', '2025-10-20 11:42:22', 0, '20250905195604614', 'pce', NULL),
(3067, 'CLONEM CREAM ', 'CLOTRIMAZOLE CREAM', NULL, '15', 5.00, 1000.00, 2000.00, '0008-08-27', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-100', 'cream', NULL),
(3068, 'DRAGON BALM', 'PAIN RELIEF OINTMENT', NULL, 'C4825001', 1.00, 1300.00, 2500.00, '2028-03-10', NULL, '2025-07-28 23:01:10', '2025-11-06 19:16:52', 0, '20250905195702456', 'strp', NULL),
(3069, 'DRAGON LIQUID', 'PAIN RELIEF SOLUTION', NULL, 'C4324011', 1.00, 3500.00, 5000.00, '0012-12-27', NULL, '2025-07-28 23:01:10', '2025-10-29 22:00:08', 1, 'CHAR-102', 'pce', NULL),
(3070, 'VOLINI GEL 30g', 'DICLOFENAC/PARACETAMOL/LINSEED OIL', NULL, 'SXF2400A', 1.00, 7000.00, 9000.00, '0004-04-26', NULL, '2025-07-28 23:01:10', '2025-10-23 13:45:09', 0, 'CHAR-103', 'cream', NULL),
(3071, 'SALIMIA LINIMENT', 'PAIN RELIEF SOLUTION', NULL, '2308072', 1.00, 4500.00, 6000.00, '0007-07-26', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-104', 'cream', NULL),
(3072, 'GO GEL', 'DICROFENAC/LINSEED OIL/METHYL/MENTHOL GEL', NULL, 'DM24021', 2.00, 2600.00, 5000.00, '0005-05-26', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-105', 'cream', NULL),
(3073, 'FABRIC PLASTERS', 'SANDRIES', NULL, '230733', 11.00, 300.00, 500.00, '0007-07-27', NULL, '2025-07-28 23:01:10', '2025-11-01 21:49:14', 0, 'CHAR-106', 'pair', NULL),
(3074, 'DYNAPAR SPRAY 30 ML', 'DICLOFENAC/ALCOHOL SOLUTION', NULL, 'AB4045', 1.00, 17000.00, 25000.00, '2026-09-30', NULL, '2025-07-28 23:01:10', '2025-10-27 12:51:31', 0, '20250828173510555', 'btl', NULL),
(3075, 'DEEP HEAT CREAM', 'MENTHOL/METHYL SALICILICATE CREAM', NULL, '40614', 0.00, 13000.00, 17000.00, '0012-12-25', NULL, '2025-07-28 23:01:10', '2025-09-03 15:11:49', 0, 'CHAR-108', 'cream', NULL),
(3076, 'DICLODAY GEL 30g', 'DICLOFENAC GEL', NULL, 'D11342', 1.00, 2200.00, 3500.00, '2027-11-30', NULL, '2025-07-28 23:01:10', '2025-11-01 21:57:18', 0, '20250822194306618', 'pce', NULL),
(3077, 'DINAC GEL', 'DICLOFENAC GEL 1%', NULL, 'DC23030', 1.00, 2000.00, 3000.00, '0009-09-26', NULL, '2025-07-28 23:01:10', '2025-09-15 22:04:46', 0, 'CHAR-110', 'cream', NULL),
(3078, 'GV PAINT 25mls', 'ETHANOL', NULL, '450', 4.00, 1500.00, 2500.00, '0006-06-27', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-111', 'bottle', NULL),
(3079, 'IODINE TINCTURE 22mls', 'IODINE', NULL, '767', 1.00, 1500.00, 2500.00, '0009-09-26', NULL, '2025-07-28 23:01:10', '2025-10-10 18:15:51', 0, 'CHAR-112', 'tin', NULL),
(3080, 'STAVLON ANTISEPTIC 100ML', 'antiseptic liquid', NULL, '24240002', 1.00, 2000.00, 3500.00, '0001-01-27', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-113', 'bottle', NULL),
(3081, 'CALAMINE LOTION 100 ML', 'ANTI-ITCH LOTION', NULL, '1730', 0.00, 2000.00, 3500.00, '0001-01-27', NULL, '2025-07-28 23:01:10', '2025-09-13 20:36:29', 0, 'CHAR-114', 'bottle', NULL),
(3082, 'TIOCON CREAM', 'TIOCONAZOLE CREAM', NULL, '2360003/A', 1.00, 11000.00, 15000.00, '0003-03-26', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-115', 'cream', NULL),
(3083, 'INTAMINE CREAM', 'MEPYRAMINE', NULL, '242346', 0.00, 3500.00, 5000.00, '0030-11-26', NULL, '2025-07-28 23:01:10', '2025-11-01 21:11:30', 1, 'CHAR-116', 'cream', NULL),
(3084, 'KETOZ CREAM 15 G', 'KETOCONAZOLE 2% CREAM', NULL, 'KE24030', 2.00, 2500.00, 5000.00, '2027-10-30', NULL, '2025-07-28 23:01:10', '2025-09-05 20:43:56', 1, '20250905194300102', 'strp', NULL),
(3085, 'LUCIN CREAM', 'HYDROCORTISONE CREAM', NULL, '231761', 2.00, 0.00, 0.00, '0030-08-26', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-118', 'cream', NULL),
(3086, 'ZARICORT CREAM', 'MICONAZOLE/HYDROCORTISONE CREAM', NULL, '527621', 0.00, 0.00, 0.00, '0030-07-26', NULL, '2025-07-28 23:01:10', '2025-09-08 21:53:14', 0, 'CHAR-119', 'cream', NULL),
(3087, 'CANDID POWDER', 'CLOTRIMAZOLE POWDER', NULL, '10233079', 1.00, 5500.00, 8000.00, '0030-11-26', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-120', 'tin', NULL),
(3088, 'ERYTHROMYCIN 250MG TABLETS', 'ERYTHROMYCIN 250', NULL, '3324', -8.00, 150.00, 200.00, '0031-10-26', NULL, '2025-07-28 23:01:10', '2025-10-25 19:37:22', 20, 'CHAR-121', 'tablet', NULL),
(3089, 'BACTOCLAV 1000MG TABLETS', 'AMOXICILLIN/POTASSIUM CLAVUNATE 1000', NULL, 'BACBV0099', 11.00, 2200.00, 3000.00, '0028-02-27', NULL, '2025-07-28 23:01:10', '2025-08-09 21:57:07', 5, 'CHAR-122', 'tablet', NULL),
(3090, 'CLAVAM 375 TABLET', 'AMOXICILLIN/POTASSIUM CLAVUNATE 375', NULL, '25280086', 20.00, 1000.00, 1500.00, '0030-12-26', NULL, '2025-07-28 23:01:10', NULL, 5, 'CHAR-123', 'tablet', NULL),
(3091, 'ZINKID TABLETS 20 MG', 'ZINC SULPHATE', NULL, 'NT10420', 0.00, 50.00, 100.00, '0030-12-27', NULL, '2025-07-28 23:01:10', NULL, 20, 'CHAR-124', 'tablet', NULL),
(3092, 'ENO SACHETS', 'LFTULENCE AND BLOATING', NULL, 'Y038AF', 6.00, 500.00, 700.00, '0030-10-27', NULL, '2025-07-28 23:01:10', '2025-11-07 18:56:32', 5, 'CHAR-125', 'sachet', NULL),
(3093, 'BACTOCLAV 375 MG TABLET', 'AMOXICILLIN + POTASSIUM CLAVUNATE 250/125 MG', NULL, 'BAABV0063', 10.00, 525.00, 1000.00, '2027-02-28', NULL, '2025-07-28 23:01:10', '2025-10-16 19:22:47', 5, '20250820191021216', 'tab', NULL),
(3094, 'AMOXIKID 250MG TABLETS', 'AMOXICILLIN DISPERSIBLE 250 MG TABLETS', NULL, '0652SP003', 75.00, 80.00, 200.00, '2028-03-31', NULL, '2025-07-28 23:01:10', '2025-11-04 16:33:40', 10, '20250804175415929', 'strp', NULL),
(3095, 'AMOXIKID 125MG TABLETS', 'AMOXICILLIN DISPERSIBLE 125 MG TABLETS', NULL, '3424', 26.00, 80.00, 100.00, '0008-08-26', NULL, '2025-07-28 23:01:10', '2025-10-28 14:57:55', 10, 'CHAR-128', 'tablet', NULL),
(3097, 'METRONIDAZOLE 400 AXCEL', 'METRONIDAZOLE 400 AXCEL', NULL, '2405039', 0.00, 250.00, 400.00, '0030-05-28', NULL, '2025-07-28 23:01:10', '2025-10-30 12:50:41', 20, 'CHAR-130', 'tablet', NULL),
(3098, 'CHARCOAL TABLETS', 'ACTIVATED CHARCOAL', NULL, 'FST-123', 120.00, 80.00, 200.00, '2027-02-28', NULL, '2025-07-28 23:01:10', '2025-10-02 13:48:33', 20, '20250822194428871', 'tab', NULL),
(3099, 'ORVAGIL 400 MG', 'METRONIDAZOLE 400 TABLETS', NULL, '67503', 15.00, 620.00, 800.00, '0010-10-28', NULL, '2025-07-28 23:01:10', NULL, 5, 'CHAR-132', 'tablet', NULL),
(3100, 'AMOXICILLIN 500 MG INDIA', 'AMOXICILLIN 500 CAPSULES', NULL, 'ALC012504', 190.00, 200.00, 300.00, '2027-12-27', NULL, '2025-07-28 23:01:10', '2025-11-06 21:58:13', 20, 'CHAR-133', 'cap', NULL),
(3101, 'TETRACYCLINE CAPS 250MG', 'TETRACYCLINE 250 CAPSULES', NULL, '724', 45.00, 100.00, 150.00, '0030-11-26', NULL, '2025-07-28 23:01:10', '2025-10-16 21:45:50', 20, 'CHAR-134', 'capsule', NULL),
(3102, 'AMPICILLIN 250MG CAPSULES', 'AMPICILLIN 250 CAPSULES', NULL, 'AMP407', 50.00, 64.00, 100.00, '2027-10-31', NULL, '2025-07-28 23:01:10', '2025-11-10 21:44:22', 20, '20250820194517758', 'strp', NULL),
(3103, 'CEFALEXIN 250 MG CAPSULES INDIA', 'CEFALEXIN 250 MG CAPSULES', NULL, 'CC-012502', 70.00, 130.00, 200.00, '0010-12-27', NULL, '2025-07-28 23:01:10', '2025-08-29 21:27:32', 20, 'CHAR-136', 'capsule', NULL),
(3104, 'AZITHROMYCIN 250 MG INDIA', 'AZITHROMYCIN 250 TABLETS', NULL, 'ABL10224A', 21.00, 800.00, 1000.00, '0002-04-27', NULL, '2025-07-28 23:01:10', '2025-11-01 19:09:16', 6, 'CHAR-137', 'tablet', NULL),
(3105, 'COTRIMOXAZOLE 480 MG TABLETS INDIA', 'COTRIMOXAZOLE TABLETS 480 INDIA', NULL, '5050', 20.00, 70.00, 100.00, '0004-04-27', NULL, '2025-07-28 23:01:10', '2025-11-06 12:46:38', 20, 'CHAR-138', 'tablet', NULL),
(3106, 'FLUCAMOX CAPSULES 500MG EGYPT', 'AMOXICILLIN 250 / FLUCLOXACILLIN 250', NULL, '1223328', 18.00, 1320.00, 2000.00, '0012-12-26', NULL, '2025-07-28 23:01:10', '2025-08-01 22:59:11', 5, 'CHAR-139', 'capsule', NULL),
(3107, 'PEN-V TABLETS', 'PHENOXYMETHYL PENICILIN 250MG', NULL, '250083', 60.00, 120.00, 200.00, '0009-09-27', NULL, '2025-07-28 23:01:10', '2025-11-09 23:21:46', 20, 'CHAR-140', 'tab', NULL),
(3108, 'COTRIMOXAZOLE 960 MG TABLET', 'COTRIMOXAZOLE TABLETS 960 INDIA', NULL, '5160', 53.00, 120.00, 200.00, '2027-05-27', NULL, '2025-07-28 23:01:10', '2025-11-10 16:29:51', 20, 'CHAR-141', 'tab', NULL),
(3109, 'FLUCOZYD 200MG CAPSULES', 'FLUCONAZOLE 200 MG INDIA', NULL, 'M408639', -2.00, 500.00, 1000.00, '0006-06-26', NULL, '2025-07-28 23:01:10', '2025-11-10 21:36:06', 10, 'CHAR-142', 'cap', NULL),
(3110, 'PIRITEX JUNIOR SYRUP', 'PEADIATRIC COLDS', NULL, 'PJ0425', 1.00, 3500.00, 4500.00, '0001-09-26', NULL, '2025-07-28 23:01:10', '2025-10-06 15:47:25', 1, 'CHAR-143', 'syrup', NULL),
(3111, 'IBUMEX SYRUP 100MG/5ML 100 ML', 'IBUPROFEN SYRUP', NULL, '250275', 1.00, 3500.00, 5000.00, '0012-12-27', NULL, '2025-07-28 23:01:10', '2025-08-25 23:53:59', 1, 'CHAR-144', 'syrup', NULL),
(3112, 'CURAMOL SYRUP', 'PARACETAMOL SYRUP 60 ML', NULL, '2312025', 4.00, 1500.00, 3000.00, '0011-11-26', NULL, '2025-07-28 23:01:10', '2025-09-10 21:28:31', 2, 'CHAR-145', 'syrup', NULL),
(3113, 'CATAMOL 60 ML SYP 120MG/5ML', 'PARACETAMOL SYRUP 60 ML', NULL, '250239', 2.00, 3000.00, 4000.00, '0012-12-27', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-146', 'syrup', NULL),
(3114, 'CATAMOL 100 ML SYP 120MG/5ML', 'PARACETAMOL SYRUP 100 ML', NULL, '250239', 2.00, 3500.00, 5000.00, '0004-04-27', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-147', 'syrup', NULL),
(3115, 'IBUMOL SUSPENSION', 'IBUPROFEN/PARACETAMOL 100/125 SYRUP', NULL, 'CK022512', 1.00, 4000.00, 6000.00, '0008-08-25', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-148', 'syrup', NULL),
(3116, 'BBC SPRAY', 'ANAESTHETIC / ANTISEPTIC ORAL SPRAY', NULL, '235132', 1.00, 22000.00, 30000.00, '0011-11-26', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-149', 'spray', NULL),
(3117, 'ALBENDAZOLE TABLETS INDIA 400 MG', 'ALBENDAZOLE 400 MG TABLET', NULL, 'bv4016', 1.00, 300.00, 1000.00, '2027-10-31', NULL, '2025-07-28 23:01:10', '2025-11-10 21:44:22', 5, '20250811171953143', 'dos', NULL),
(3118, 'ZEPPAR 400MG TABLETS 2\'S ', 'ALBENDAZOLE TABLET', NULL, '97', 2.00, 2900.00, 4000.00, '0010-10-26', NULL, '2025-07-28 23:01:10', '2025-11-01 22:12:44', 2, 'CHAR-151', 'dose', NULL),
(3119, 'ZENTEL 400 MG TABLETS', 'ALBENDAZOLE SPAIN', NULL, 'WB3T', 4.00, 8000.00, 10000.00, '0012-12-28', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-152', 'dose', NULL),
(3120, 'VERMOX TABLETS 100MG 6\'S', 'MEBENDAZOLE TABLETS SPAIN', NULL, '23FQ157', 1.00, 18000.00, 24000.00, '0005-05-26', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-153', 'dose', NULL),
(3121, 'MEBENDAZOLE 100MG TABLETS INDIA', 'MEBENDAZOLE TABLETS INDIA', NULL, '324', 60.00, 60.00, 100.00, '0012-12-25', NULL, '2025-07-28 23:01:10', NULL, 20, 'CHAR-154', 'tablet', NULL),
(3122, 'ZENTEL SUSPENSION 400 MG', 'ALBENDAZOLE SYRUP ', NULL, '24K005', 0.00, 8000.00, 10000.00, '0009-09-26', NULL, '2025-07-28 23:01:10', '2025-09-11 22:15:01', 1, 'CHAR-155', 'syrup', NULL),
(3123, 'PENEGRA 50 MG TABLETS', 'SILDENAFIL 50 MG', NULL, 'G500052', 3.00, 900.00, 1500.00, '0012-12-26', NULL, '2025-07-28 23:01:10', '2025-11-09 23:04:44', 2, 'CHAR-156', 'tablet', NULL),
(3124, 'PENEGRA 100 MG TABLETS', 'SILDENAFIL 100 MG', NULL, 'GH03005', 0.00, 975.00, 2000.00, '2026-10-31', NULL, '2025-07-28 23:01:10', '2025-11-06 13:29:33', 2, '20250905185353338', 'tab', NULL),
(3125, 'SILMELT 100 MG', 'SILDENAFIL 100 MG TABLET', NULL, 'BRE03343D', 3.00, 1200.00, 2000.00, '0004-04-26', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-158', 'tablet', NULL),
(3126, 'SILMELT 50 MG', 'SILDENAFIL 50 MG TABLET', NULL, 'BRE03343D', 3.00, 1200.00, 1500.00, '0004-04-26', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-159', 'tablet', NULL),
(3127, 'KAMAGRA 100MG TABLET', 'SILDENAFIL 100 MG TABLET', NULL, 'PA06114', 0.00, 3625.00, 5500.00, '2027-02-28', NULL, '2025-07-28 23:01:10', '2025-11-07 20:24:01', 2, '20250905184601836', 'tab', NULL),
(3128, 'APCALLIS SX 20 MG TABLET', 'TADALFIL 20 MG TABLET', NULL, 'PA09874', 0.00, 5375.00, 8000.00, '2027-05-30', NULL, '2025-07-28 23:01:10', '2025-11-01 19:51:23', 2, '20250905185042773', 'tab', NULL),
(3129, 'ZEPPAR 400MG SUSPENSION 10ML', 'ALBENDAZOLE SYRUP ', NULL, '151', 2.00, 2200.00, 4000.00, '2027-10-10', NULL, '2025-07-28 23:01:10', '2025-10-17 13:47:53', 2, '20250905191252686', 'syp', NULL),
(3130, 'ISORYN PEAD NASAL DROPS', 'EPHEDRINE NASAL DROPS', NULL, '242258', 1.00, 5500.00, 8000.00, '0011-11-27', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-163', 'bottle', NULL),
(3131, 'SINAREST-PD DROPS', 'OXYMETALOZONE INFANT NASAL DROPS', NULL, 'SGV2402', 0.00, 4200.00, 6000.00, '2027-04-27', NULL, '2025-07-28 23:01:10', '2025-08-18 13:38:14', 1, 'CHAR-164', 'btl', NULL),
(3132, 'GENTAMYCIN EYE/EAR DROPS', 'GENTAMYCIN EYE/EAR DROPS', NULL, 'STE00524', 3.00, 900.00, 2000.00, '0004-04-27', NULL, '2025-07-28 23:01:10', '2025-11-05 16:18:58', 2, 'CHAR-165', 'bottle', NULL),
(3133, 'DEXONA EYE/EAR DROPS', 'DEXAMETHASONE/NEOMYCIN DROPS', NULL, 'ABA5013', 3.00, 2200.00, 3500.00, '2026-08-31', NULL, '2025-07-28 23:01:10', '2025-11-10 21:46:29', 1, '20250828181325113', 'btl', NULL),
(3134, 'PROBETA-N EYE/EAR DROP', 'BETAMETHASONE/NEOMYCIN EYE DROPS', NULL, 'fw070k', 1.00, 3500.00, 5000.00, '2026-06-30', NULL, '2025-07-28 23:01:10', '2025-11-05 16:18:58', 1, '20250811172229725', 'pce', NULL),
(3135, 'ABNAL NASAL DROPS', 'NORMAL SALINE NASAL DROPS', NULL, '58AD1824', 0.00, 2000.00, 3000.00, '2027-12-26', NULL, '2025-07-28 23:01:10', '2025-09-13 12:21:28', 1, 'CHAR-168', 'btl', NULL),
(3136, 'DEXTRACIN EYE/EAR DROPS', 'NEOMYCIN/DEXAMETHASONE EYE', NULL, '529801', 1.00, 5000.00, 9000.00, '2026-07-31', NULL, '2025-07-28 23:01:10', '2025-10-16 17:42:32', 1, '20250902212427846', 'btl', NULL),
(3137, 'OCUREST-AH EYEDROPS', 'ALERG AND EYE WHITENER', NULL, 'UFV 2405', 1.00, 4000.00, 6000.00, '0008-08-27', NULL, '2025-07-28 23:01:10', '2025-11-03 23:00:31', 1, 'CHAR-170', 'bottle', NULL),
(3138, 'TOBRADEX EYE DROPS', 'TOBRAMYCIN /DEXAMETHASONE EYE', NULL, 'VJPH8A', 0.00, 13000.00, 18000.00, '0007-07-26', NULL, '2025-07-28 23:01:10', '2025-09-26 20:27:13', 1, 'CHAR-171', 'bottle', NULL),
(3139, 'MAXITROL EYE DROPS', 'NEOMYCIN/DEXAMETHASONE/POLYMYCIN', NULL, 'VJW32C', 0.00, 9000.00, 12000.00, '0007-07-26', NULL, '2025-07-28 23:01:10', '2025-09-06 22:19:21', 1, 'CHAR-172', 'bottle', NULL),
(3140, 'CREPE BANDAGE/ELASTIC BANDAGE 6INCH', 'ELASTIC BANDAGE', NULL, '231007', 1.00, 3000.00, 5000.00, '0010-10-28', NULL, '2025-07-28 23:01:10', '2025-09-09 11:45:56', 1, 'CHAR-173', 'piece', NULL),
(3141, 'CREPE BANDAGE/ELASTIC BANDAGE 3INCH', 'ELASTIC BANDAGE', NULL, '231006', 1.00, 3000.00, 4000.00, '2028-10-28', NULL, '2025-07-28 23:01:10', '2025-11-05 16:13:47', 1, 'CHAR-174', 'pce', NULL),
(3142, 'CREPE BANDAGE/ELASTIC BANDAGE 4INCH', 'ELASTIC BANDAGE', NULL, '230861', 1.00, 1500.00, 3000.00, '0008-08-28', NULL, '2025-07-28 23:01:10', '2025-09-02 18:00:21', 1, 'CHAR-175', 'piece', NULL),
(3143, 'NYSTATIN SUSPENSION INDIA', 'NYSTATIN SUSPENSION 30 ML', NULL, '2412041', 2.00, 2000.00, 3000.00, '0011-11-26', NULL, '2025-07-28 23:01:10', NULL, 1, 'CHAR-176', 'syrup', NULL),
(3144, 'COTTON WOOL 500G ', 'COTTON WOOL 500G ', NULL, 'B2503-04/25', 2.00, 7500.00, 12000.00, '2028-04-30', NULL, '2025-07-28 23:01:10', '2025-09-02 22:37:39', 1, '20250902213644656', 'pce', NULL),
(3145, 'GAUZE ROLL SMALL', 'GAUZE SMALL', NULL, 'A2301', 9.00, 1200.00, 2000.00, '0014-01-29', NULL, '2025-07-28 23:01:10', '2025-08-06 22:29:37', 2, 'CHAR-178', 'roll', NULL),
(3146, 'MAMA KIT SMALL', 'MAMA KIT', NULL, '23', 1.00, 8000.00, 10000.00, '0008-08-29', NULL, '2025-07-28 23:01:10', NULL, 0, 'CHAR-179', 'piece', NULL),
(3147, 'BACK-UP PILLS', 'Levonogestrel 1.5 mg', NULL, 'BKP2406015', 0.00, 2300.00, 5000.00, '2026-05-31', NULL, '2025-07-28 23:01:10', '2025-11-09 23:04:44', 2, '20250731181509798', 'dos', NULL),
(3148, 'MENIPHIB TABLETS', 'ARVURYEDIC MEDICINE FOR IRREGULAR MENSES', NULL, 'P-833', 34.00, 350.00, 500.00, '0011-11-28', NULL, '2025-07-28 23:01:10', '2025-10-23 16:35:00', 20, 'CHAR-181', 'tablet', NULL),
(3149, 'VITAMIN A CAPSULS 100 IU', 'VITAMIN A CAPSULS 100 IU', NULL, 'S23G002', 21.00, 700.00, 1000.00, '0006-06-26', NULL, '2025-07-28 23:01:10', '2025-11-01 21:11:30', 5, 'CHAR-182', 'capsule', NULL),
(3150, 'AZITHROMYCIN 500 MG INDIA TABLETS', 'AZITHROMYCIN 500 INDIA', NULL, 'BG10125A', 1.00, 2000.00, 5000.00, '2027-12-31', NULL, '2025-07-28 23:01:10', '2025-10-31 19:15:11', 5, '20250905182931993', 'dos', NULL),
(3151, 'AZITHROMYCIN INDIA TABLET(AZILIDE) 500 MG', 'AZITHROMYCIN 500 TABLET', NULL, 'AZG501', 32.00, 434.00, 2000.00, '2028-01-01', NULL, '2025-07-28 23:01:10', '2025-09-12 20:28:11', 3, '20250905190603582', 'tab', NULL),
(3152, 'ORS ORANGE FLAVOURED', 'ORAL REHYDRATION SOLUTION', NULL, '100', 29.00, 400.00, 1000.00, '0008-08-26', NULL, '2025-07-28 23:01:10', '2025-11-08 21:08:42', 5, 'CHAR-185', 'sachet', NULL),
(3153, 'ORS PLAIN', 'ORAL REHYDRATION SOLUTION', NULL, 'AH824012', 1.00, 500.00, 1000.00, '0008-08-26', NULL, '2025-07-28 23:01:10', '2025-10-07 16:34:46', 5, 'CHAR-186', 'sachet', NULL),
(3154, 'NORMAL SALINE 500 ML', 'SODIUM CLORIDE SOLUTINONFOR INFUSION', NULL, '02E02225A', 1.00, 2000.00, 3000.00, '0004-04-28', NULL, '2025-07-28 23:01:10', '2025-11-04 10:49:19', 1, 'CHAR-187', 'bottle', NULL),
(3155, 'NEUTRAFLAX TABLETS ', 'ANTACID TABS 2X3', NULL, '24-XNIT-036', 61.00, 335.00, 500.00, '2026-08-31', NULL, '2025-07-30 21:43:29', '2025-11-08 21:08:42', 10, '20250820195810434', 'tab', NULL),
(3159, 'COLDAFEX TABLETS', 'CHLORPHENIRAMINE /PARACETAMOL 2X2', NULL, 'CF8791023', 15.00, 350.00, 500.00, '2030-03-10', NULL, '2025-07-30 21:46:48', '2025-11-03 22:52:17', 5, 'CHAR-363', 'tab', NULL),
(3161, 'AMOXICILLIN 250 MG INDIA', 'AMOXICILLIN 250 MG 2X3', NULL, 'HC734', -20.00, 49.00, 100.00, '2026-10-10', NULL, '2025-07-30 21:48:56', '2025-11-08 21:10:43', 10, '20250905203421854', 'cap', NULL),
(3163, 'SURGICAL GLOVES 7.5 CM', 'SANDRIES', NULL, '124253', 1.00, 850.00, 1500.00, '2029-11-30', NULL, '2025-07-30 21:50:47', '2025-10-16 17:42:32', 2, '20250731182340597', 'pce', NULL),
(3165, 'ACTION TABLETS', 'ASPIRIN / PARACETAMOL', NULL, '231121', 11.00, 350.00, 500.00, '2028-10-10', NULL, '2025-07-30 21:53:36', '2025-11-06 20:39:29', 5, 'CHAR-366', 'dos', NULL),
(3167, 'DYNAPAR TABLETS', 'DICLOFENAC 50 /PARACETAMOL350', NULL, '2AY24005', 0.00, 100.00, 200.00, '2028-10-31', NULL, '2025-07-30 21:55:36', '2025-11-07 17:18:50', 20, '20250822192153637', 'tab', NULL),
(3168, 'TOFFPLUSS CAPSULE', 'CHLORPHENIRAMINE/CAFFEINE/PARACETAMOL', NULL, '44423013', 10.00, 430.00, 600.00, '2026-07-07', NULL, '2025-07-30 21:57:38', '2025-11-05 17:32:38', 10, 'CHAR-368', 'cap', NULL),
(3169, 'LEVOFLOXACIN 750 INDIA', 'LEVOFLOXACIN 750', NULL, '2407050', 1.00, 1000.00, 3000.00, '2027-06-06', NULL, '2025-07-30 22:01:21', '2025-08-02 21:48:44', 2, 'CHAR-369', 'tab', NULL),
(3170, 'LEVOBACT 750MG', 'LEVOFLOXACIN 750 MG', NULL, 'LFZH0036', 4.00, 2600.00, 4000.00, '2028-02-29', NULL, '2025-07-30 22:02:34', '2025-10-29 21:59:09', 5, '20250820193949141', 'tab', NULL),
(3171, 'FUCOL 200', 'FLUCONAZOLE 200 MG 1X1', NULL, '4KA0607', 0.00, 980.00, 1500.00, '2027-01-01', NULL, '2025-07-30 22:07:06', '2025-11-09 23:04:44', 10, 'CHAR-341', 'cap', NULL),
(3172, 'ZYCEL 200 MG 1X2', 'CELECOXIB 200 MG', NULL, 'G402942', 33.00, 334.00, 500.00, '2027-09-30', NULL, '2025-07-30 22:09:05', '2025-11-10 21:44:22', 20, '20250822194215463', 'cap', NULL),
(3173, 'BETANASE 5 1X1', 'GLIBENCLAMIDE 5 MG', NULL, 'G402861', 270.00, 662.00, 100.00, '2028-09-09', NULL, '2025-07-30 22:10:31', NULL, 50, 'CHAR-343', 'tab', NULL),
(3174, 'VITAMIN C 100 MG 2X3', 'ASCORBIC ACID', NULL, '2502193', 260.00, 30.00, 100.00, '2027-01-01', NULL, '2025-07-30 22:13:18', '2025-11-10 21:36:06', 50, 'CHAR-344', 'tab', NULL),
(3175, 'TX-MF TABLETS 1X2', 'TRANEXAMIC ACID/MEFENAMIC ACID', NULL, 'C4040', 0.00, 1100.00, 1500.00, '2026-02-02', NULL, '2025-07-30 22:15:49', '2025-08-14 14:05:53', 5, 'CHAR-345', 'tab', NULL),
(3176, 'NITROFURANTOIN TABS 1X3', 'NITROFURANTOIN 100 MG', NULL, 'T52007', 30.00, 100.00, 200.00, '2028-02-02', NULL, '2025-07-30 22:18:59', '2025-11-10 21:36:06', 20, 'CHAR-346', 'tab', NULL),
(3178, 'TEERBINAFINE 250 MG INDIA 1X1', 'TEERBINAFINE 250 MG ANTIFUNGAL', NULL, 'G291E4003', 30.00, 1000.00, 1500.00, '2026-05-05', NULL, '2025-07-30 22:33:40', NULL, 10, 'CHAR-347', 'tab', NULL),
(3179, 'JENA FLU 200 ML', 'HERBAL SYRUP FOR FLUE', NULL, 'JFUB00247', 2.00, 4600.00, 7000.00, '2027-03-31', NULL, '2025-07-30 22:35:18', '2025-10-03 15:36:40', 2, '20250822192515420', 'btl', NULL),
(3180, 'IBUPROFEN 200 MG INDIA 2X3', 'IBUPROFEN 200 MG', NULL, '005684', 190.00, 20.00, 100.00, '2028-03-03', NULL, '2025-07-30 22:37:16', '2025-11-09 23:08:03', 40, '20250905200947136', 'tab', NULL),
(3182, 'BACTOCLAV SYRUP 118 ML', 'AMOXICILLIN/POTASSIUM CLAVUNATE SYRUP', NULL, 'BATCH 362', 0.00, 8000.00, 13000.00, '2026-02-02', NULL, '2025-07-31 18:19:42', '2025-07-31 18:37:18', 0, 'CHAR-376', 'syp', NULL),
(3183, 'LONART SYRUP 60ML', 'ARTEMETHER LUMEFANTRINE', NULL, 'BKP2406015', 1.00, 8500.00, 13000.00, '2026-09-12', NULL, '2025-07-31 18:21:24', '2025-08-02 17:18:56', 1, 'CHAR-377', 'syp', NULL),
(3184, 'KISS CONDOM STRAW BERRY', 'CONDOMS', NULL, 'L34231104', 0.00, 900.00, 2000.00, '2028-10-10', NULL, '2025-07-31 18:24:42', '2025-09-09 16:24:31', 10, 'CHAR-379', 'pce', NULL),
(3186, 'KISS CONDOM CLASSIC BLUE', 'CONDOMS', NULL, 'L29240403', 11.00, 900.00, 2000.00, '2029-10-10', NULL, '2025-07-31 18:25:54', '2025-11-05 16:13:47', 2, 'CHAR-380', 'pce', NULL),
(3187, 'KISS CONDOM CHOCOLATE', 'CONDOMS', NULL, 'L3240401', 0.00, 900.00, 2000.00, '2029-10-10', NULL, '2025-07-31 18:26:52', '2025-08-09 20:53:59', 2, 'CHAR-381', 'pce', NULL),
(3188, 'MAGNESIUM TABLETS ', 'MAGNESIUM TRISILICATE TABLETS', NULL, '005514', 300.00, 20.00, 50.00, '2027-10-10', NULL, '2025-07-31 18:28:18', '2025-11-08 17:40:35', 50, '20250905201106631', 'tab', NULL),
(3189, 'PREDNISOLONE 5MG INDIA', 'PREDNISOLONE 5MG TABS', NULL, '2505105', 550.00, 23.00, 100.00, '2028-04-30', NULL, '2025-07-31 18:30:01', '2025-11-07 21:37:03', 50, '20250820194409811', 'tab', NULL),
(3190, 'MENTHOXYL LOZENGES PAIRS', 'COUGH LOZENGES', NULL, 'MX013', 5.00, 400.00, 500.00, '2027-11-11', NULL, '2025-07-31 18:31:25', '2025-10-18 20:51:15', 5, 'CHAR-384', 'pce', NULL),
(3191, 'LOPERAMIDE CAPSULES 2MG 2X1', 'LOPERAMIDE 2MG', NULL, 'C51008', 30.00, 55.00, 100.00, '2027-12-12', NULL, '2025-07-31 18:33:03', '2025-11-05 16:59:45', 20, 'CHAR-385', 'cap', NULL),
(3192, 'AMLOZAAR-H', 'AMLODIPINE / LOSARTAN/ HYDROCHLOROTHIAZIDE 5/50/12.5', NULL, 'ABHH0069', 19.00, 1417.00, 2000.00, '2027-01-01', NULL, '2025-07-31 18:58:47', '2025-11-03 23:00:31', 10, '18901302170189', 'tab', NULL),
(3193, 'RELEX COUGH SYRUP', 'DIPHENHYDRAMINE/AMMONIUM CHLORIDE/SODIUM CITRATE', NULL, 'D09325001', 2.00, 2300.00, 5000.00, '2027-12-12', NULL, '2025-07-31 19:01:36', NULL, 1, '1531-OSP', 'btl', NULL),
(3194, 'ASPIRIN DISPERSIBLE 75 MG', 'ASPIRIN DISPERSIBLE 75 MG', NULL, 'XT4C026', 80.00, 90.00, 150.00, '2027-02-02', NULL, '2025-07-31 19:03:33', '2025-10-16 19:22:47', 10, 'MNB/05-138', 'tab', NULL),
(3195, 'ESOFAG-D', 'ESOMEPRAZOLE / DOMPERIDONE 40/30', NULL, 'ESDH0105', 3.00, 734.00, 1000.00, '2028-02-02', NULL, '2025-07-31 19:05:56', '2025-10-18 21:45:23', 10, '18901302136611', 'cap', NULL),
(3196, 'GRAMOCEF-O 400', 'CEFIXIME 400 MG', NULL, 'GPFB0071', 8.00, 2850.00, 5000.00, '2027-02-02', NULL, '2025-07-31 19:07:34', '2025-09-04 20:58:23', 5, '3/25', 'cap', NULL),
(3197, 'FLUCAP CAPSULES', 'CHLORPHENIRAMINE/PARACETAMOL/CAFFEINE / PSEUDOEPHEDRINE', NULL, '3925', 68.00, 114.00, 200.00, '2028-02-29', NULL, '2025-07-31 19:10:52', '2025-11-09 23:06:07', 10, '03/25', 'cap', NULL),
(3198, 'FRUSEMIDE 40 MG INDIA', 'FRUSEMIDE 40 MG INDIA', NULL, '005443', 90.00, 30.00, 100.00, '2027-08-31', NULL, '2025-07-31 19:13:10', '2025-08-24 21:49:46', 10, '102298', 'tab', NULL),
(3199, 'NEUROTROY SR', 'METHYLCOBALAMIN/PYRIDOXIME/FOLIC ACID', NULL, '2CZ25002', 20.00, 900.00, 1500.00, '2026-08-31', NULL, '2025-07-31 19:30:12', NULL, 10, '37UASC/P-2006', 'tab', NULL),
(3200, 'CETRIZINE 10MG TABLETS INDIA', 'CETRIZINE 10MG TABLETS INDIA', NULL, '00325', 120.00, 45.00, 100.00, '2027-01-31', NULL, '2025-08-01 19:50:21', '2025-11-10 16:32:29', 50, 'CHAR388', 'tab', NULL),
(3202, 'GABOGGOLA HERBAL COUGH SYRUP', 'GABOGGOLA HERBAL COUGH SYRUP', NULL, '2204', 0.00, 2700.00, 4000.00, '2026-06-30', NULL, '2025-08-01 19:55:02', '2025-10-15 18:23:36', 2, '20250804174157896', 'syp', NULL),
(3203, 'FLURID TABLETS PAIRS 2X2', 'CHLORPHENIRAMINE/PARACETAMOL/PSEUDOEPHEDRINE', NULL, '1824', 42.00, 230.00, 500.00, '2026-03-31', NULL, '2025-08-01 19:56:41', '2025-11-06 21:58:13', 5, 'CHAR390', 'scht', NULL),
(3204, 'PRIMOLUT-N TABLETS', 'NORETHISTERONE 5MG TABLET', NULL, 'WEX8EB', 17.00, 1500.00, 2000.00, '2029-06-30', NULL, '2025-08-01 19:58:17', '2025-11-07 21:37:03', 10, 'CHAR391', 'tab', NULL),
(3205, 'DEXAMETHASONE 0.5 MG TABLETS', 'DEXAMETHASONE 0.5 MG TABLETS', NULL, 'MA00593A', 150.00, 20.00, 50.00, '2028-03-03', NULL, '2025-08-01 19:59:49', '2025-11-01 21:11:30', 10, '20250905192357920', 'tab', NULL),
(3206, 'TORACTIN 4MG ', 'CYPROHEPTADINE 4 MG TABLETS', NULL, 'D2472500G', 40.00, 60.00, 100.00, '2028-03-31', NULL, '2025-08-01 20:01:46', '2025-10-25 19:26:32', 20, '20250820194726326', 'tab', NULL),
(3207, 'CONTUS PLUS 650 TABLETS', 'CHLORPHENIRAMINE/PARACETAMOL/PHENYLEPHRINE', NULL, '25-XCFT-220', 95.00, 180.00, 300.00, '2028-01-31', NULL, '2025-08-01 20:13:40', '2025-09-26 20:27:13', 10, '20250820195242610', 'tab', NULL),
(3209, 'CLARINASE TABLETS', 'LORATADINE/PSEUDOEPHEDRINE', NULL, 'JRPG2444E', 0.00, 2286.00, 3500.00, '2027-04-04', NULL, '2025-08-01 20:37:14', '2025-11-10 21:44:22', 10, '20250905195852809', 'tab', NULL),
(3210, 'SINAREST TABLETS', 'CHLORPHENIRAMINE/CAFFEINE/PHENYLEPHRINE', NULL, 'SDT2336', 49.00, 450.00, 700.00, '2026-10-31', NULL, '2025-08-01 20:40:15', '2025-08-14 22:28:46', 5, 'CHR392', 'scht', NULL),
(3211, 'HCG STRIPS', 'HCG STRIP', NULL, 'HPS2501002', 40.00, 500.00, 2000.00, '2027-12-01', NULL, '2025-08-01 20:52:49', '2025-11-10 21:44:22', 10, 'CHR393', 'strp', NULL),
(3212, 'DESLORA-DENK 5MG', 'DESLORATADINE 5MG TABLET', NULL, 'AVT', 3.00, 1200.00, 2000.00, '2026-03-31', NULL, '2025-08-01 21:29:23', '2025-08-21 22:48:58', 5, 'CHAR395', 'tab', NULL),
(3213, 'DESLORAT TABLETS 5MG', 'DESLORATADINE 5MG', NULL, '2408706', 2.00, 475.00, 1500.00, '2027-08-31', NULL, '2025-08-01 22:32:17', '2025-11-06 21:49:45', 5, '20250820195025994', 'tab', NULL),
(3214, 'MUCOLEX EXPECTORANT SYRUP', 'AMBROXOL/GUANFENSIN/SALBUTAMOL/LEVOMENTHOL', NULL, 'CJ24001', 1.00, 4000.00, 6000.00, '2026-07-01', NULL, '2025-08-01 22:33:51', '2025-11-04 21:19:08', 1, 'CHAR401', 'syp', NULL),
(3215, 'MOSEDIN 10MG TABLET', 'LORATADINE 10MG', NULL, '241238', 4.00, 800.00, 1000.00, '2027-05-01', NULL, '2025-08-01 22:35:20', '2025-10-28 21:49:45', 10, 'CHAR402', 'tab', NULL),
(3216, 'PANADOL ADVANCE PAIRS', 'PARACETAMOL 500 MG', NULL, 'Y036AL', 2.00, 348.00, 500.00, '2027-09-30', NULL, '2025-08-01 22:37:29', '2025-11-09 23:12:48', 10, '20250828180239413', 'dos', NULL),
(3217, 'FOLIC ACID 5MG TABS', 'FOLIC ACID 5MG TABS', NULL, 'T5943', 100.00, 70.00, 100.00, '2027-01-01', NULL, '2025-08-01 22:39:33', '2025-09-27 15:41:21', 50, 'CHAR404', 'tab', NULL),
(3218, 'METRONIDAZOLE 200 MG INDIA', 'METRONIDAZOLE 200 MG', NULL, 'AM524052', 150.00, 27.00, 50.00, '2029-08-08', NULL, '2025-08-01 22:43:27', '2025-11-09 23:08:03', 10, '20250905211011782', 'tab', NULL),
(3219, 'TREFLUCAN 150 MG CAPSULE 1X1', 'FLUCONAZOLE 150 MG ', NULL, '2406418', 0.00, 4000.00, 5000.00, '2027-08-31', NULL, '2025-08-01 22:50:42', '2025-09-08 20:30:06', 10, 'CHAR406', 'cap', NULL),
(3220, 'LEVOCET-M', 'LEVOCETRIZINE/MONTELUKAST', NULL, '24101002A', 9.00, 600.00, 1000.00, '2027-09-30', NULL, '2025-08-01 22:55:33', '2025-11-05 16:13:47', 10, 'CHAR407', 'tab', NULL),
(3221, 'PANTOPRAZOLE 40MG INDIA', 'PANTOPRAZOLE 40MG', NULL, 'LS4001', 20.00, 350.00, 500.00, '2025-12-31', NULL, '2025-08-02 16:50:12', '2025-08-02 18:01:01', 10, 'CHAR409', 'tab', NULL),
(3222, 'VITAMIN B COMPLEX TABLETS 2X2', 'VITAMIN B1 B2 B12 TABS ', NULL, '01425', 10.00, 33.00, 50.00, '2027-03-31', NULL, '2025-08-02 16:52:05', '2025-11-10 21:44:22', 10, 'CHAR410', 'tab', NULL),
(3224, 'RELCER GEL 100ML', 'SIMETHICONE/MAGNESIUM/ALUMINIUM HYDROXIDE', NULL, '10241435', 1.00, 5500.00, 7000.00, '2028-05-31', NULL, '2025-08-02 16:54:10', '2025-10-23 16:35:00', 1, 'CHAR412', 'syp', NULL),
(3225, 'RELCER GEL 180ML', 'ALUMINIUM HYDROXIDE/MAGNESIUM/SIMETHICONE', NULL, '10241142', 3.00, 8000.00, 11000.00, '2028-04-30', NULL, '2025-08-02 16:55:59', '2025-09-01 18:53:21', 10, 'CHAR413', 'syp', NULL),
(3226, 'BENZOX 5 GEL', 'BENZOYL PEROXIDE GEL', NULL, 'C110', 0.00, 4000.00, 6500.00, '2027-04-30', NULL, '2025-08-02 16:59:49', '2025-10-09 20:15:37', 1, '20250902210851166', 'pce', NULL),
(3227, 'ACNESOL CREAM 25G', 'TRETINOIN0.05%', NULL, '13926', 1.00, 5500.00, 8500.00, '2027-08-31', NULL, '2025-08-02 17:03:33', '2025-09-10 20:35:54', 1, 'CHAR415', 'pce', NULL),
(3228, 'DOXYCYCLINE 100MG CAPSULES', 'DOXYCYCLINE 100MG', NULL, 'WB2401', 97.00, 55.00, 200.00, '2026-12-31', NULL, '2025-08-02 17:07:36', '2025-10-19 19:05:10', 10, 'CHAR416', 'cap', NULL),
(3230, 'KABUUTI HERBAL SYRUP', 'HERBAL COUGH SYRUP', NULL, '210425', 0.00, 2800.00, 4500.00, '2026-04-30', NULL, '2025-08-02 17:18:15', '2025-08-13 22:23:47', 10, 'CHAR417', 'btl', NULL),
(3232, 'INDOCID', 'INDOMETHACIN 25MG ', NULL, '01125', 30.00, 23.00, 100.00, '2027-04-30', NULL, '2025-08-02 17:20:59', '2025-11-06 19:16:52', 10, 'CHAR418', 'cap', NULL),
(3233, 'SYRINGE 10 ML', 'SYRINGE 10 ML', NULL, '1824', 10.00, 300.00, 1000.00, '2029-06-02', NULL, '2025-08-02 17:24:16', '2025-11-03 22:52:17', 5, 'CHAR419', 'pce', NULL),
(3234, 'PANTOP-D CAPSULES', 'PANTOPRAZOLE/DOMPERIDONE 20/10MG', NULL, 'EBPC250528', 30.00, 500.00, 800.00, '2027-02-28', NULL, '2025-08-02 17:26:54', NULL, 10, 'CHAR420', 'cap', NULL),
(3235, 'BENZATHINE INJ 2.4MEGA', 'BENZATHIN 2.G MEGA', NULL, '624240908', 5.00, 1000.00, 5000.00, '2027-09-02', NULL, '2025-08-02 17:30:44', NULL, 2, 'CHAR421', 'btl', NULL),
(3236, 'CANDITRAL 100 MG CAPSULES', 'ITRACONAZOLE 100 MG', NULL, '10241435', 30.00, 1625.00, 2500.00, '2026-11-30', NULL, '2025-08-02 17:34:00', '2025-08-23 21:01:26', 4, '10241435', 'cap', NULL),
(3237, 'NIFELAT 10MG', 'NIFEDIPINE 10mg	', NULL, '107595', 86.00, 180.00, 250.00, '2026-02-28', NULL, '2025-08-02 17:36:27', '2025-10-31 22:59:33', 10, 'CHAR422', 'tab', NULL),
(3238, 'DIAZEPAM 5MG INDIA', 'DIAZEPAM 5mg', NULL, '220764', 30.00, 120.00, 200.00, '2026-02-02', NULL, '2025-08-02 17:39:32', '2025-08-06 15:20:06', 10, 'CHAR423', 'tab', NULL),
(3239, 'SYRINGES 5ML 		8			02-04-29			', 'SYRINGES', NULL, '240402', 8.00, 300.00, 500.00, '2029-04-02', NULL, '2025-08-02 17:41:00', NULL, 10, 'CHAR424', 'pce', NULL),
(3240, 'SYRINGES 2ML', '2ML SYRINGES', NULL, '240402', 3.00, 250.00, 500.00, '2029-02-02', NULL, '2025-08-02 17:42:30', '2025-10-21 11:11:43', 5, 'CHAR425', 'pce', NULL),
(3241, 'PIRITEX WITH CODEINE SYRUP', 'DIPHENHYDRAMINE/CODEINE/PSEUDOEPHERDRINE', NULL, 'PC4324', 0.00, 6500.00, 10000.00, '2027-10-31', NULL, '2025-08-02 17:44:18', '2025-11-10 16:31:17', 10, '20250813181911781', 'syp', NULL),
(3243, 'EROSTIN-10 MG', 'EBASTINE 10MG TABLETS', NULL, 'SNTP005', 14.00, 800.00, 1000.00, '2026-01-31', NULL, '2025-08-02 17:46:27', '2025-09-08 22:56:29', 10, 'CHAR427', 'tab', NULL),
(3245, 'HYOSINE 10MG INDIA				03-03-26			', '', NULL, '4556', 20.00, 355.00, 500.00, '2026-03-31', NULL, '2025-08-02 17:48:05', '2025-10-28 19:03:34', 10, 'CHAR428', 'tab', NULL);
INSERT INTO `products_pharm` (`id`, `name`, `description`, `category_id`, `batch_number`, `quantity`, `buying_price`, `selling_price`, `expiry_date`, `supplier_id`, `created_at`, `updated_at`, `minimum_stock_level`, `barcode`, `unit_type`, `invoice_number`) VALUES
(3246, 'ZYNAC-SP TABLETS	', 'ACECLOFENAC  / PARACETAMOL /SERRATIOPEPTIDASE', NULL, 'EUGZY23002', 25.00, 500.00, 700.00, '2026-10-31', NULL, '2025-08-02 17:49:57', NULL, 10, 'CHAR429', 'tab', NULL),
(3247, 'NUCOXOA 120MG					02-02-26			', 'ETORICOXIB TABLES 120MG', NULL, 'G401978', 24.00, 1500.00, 2000.00, '2026-06-30', NULL, '2025-08-02 17:54:06', '2025-10-19 19:05:10', 5, '20250813181540829', 'tab', NULL),
(3248, 'NYSTATIN PESARIES', 'NYSTATIN', NULL, '01224', 17.00, 300.00, 500.00, '2026-06-30', NULL, '2025-08-04 18:03:31', '2025-10-31 22:59:33', 10, 'CHAR440', 'pce', NULL),
(3249, 'NASATAB TABLETS', 'CHLORPHENIRAMINE/PARACETAMOL/PSEUDOEPHEDRINE', NULL, '2410015', 43.00, 300.00, 500.00, '2027-10-31', NULL, '2025-08-04 18:04:58', '2025-11-10 16:29:51', 10, 'CHAR441', 'tab', NULL),
(3250, 'CURAMOL PAIRS', 'PARACETAMOL/CAFFEINE', NULL, '2402003', 17.00, 350.00, 500.00, '2027-01-31', NULL, '2025-08-04 18:06:11', '2025-11-07 21:59:29', 10, 'CHAR442', 'pce', NULL),
(3251, 'OMEPRAZOLE CAPS 20MG INDIA', 'OMEPRAZOLE CAPS 20MG', NULL, 'G500506', 185.00, 39.00, 100.00, '2027-01-31', NULL, '2025-08-04 18:07:28', '2025-11-08 21:08:42', 10, '20250902211905685', 'cap', NULL),
(3252, 'GRISEOFULVIN 500MG INDIA TABLETS', 'GRISEOFULVIN 500MG TABLETS', NULL, '005609', -3.00, 220.00, 400.00, '2028-01-31', NULL, '2025-08-04 18:10:39', '2025-11-10 17:17:45', 10, '20250807214514539', 'tab', NULL),
(3253, 'WELL WOMAN ORIGINAL CAPSULES', 'MULTIVITAMIN TABLETS FOR WOMEN', NULL, '302832A', 44.00, 1200.00, 2000.00, '2027-09-30', NULL, '2025-08-04 18:30:02', '2025-10-27 19:08:36', 10, '20250804174024966', 'cap', NULL),
(3254, 'MENTHOPLUS BALM 9G', 'PAIN RELIEVING BALM 9G', NULL, 'C50024P', 0.00, 1300.00, 2000.00, '2027-12-31', NULL, '2025-08-04 18:32:33', '2025-11-09 23:21:46', 2, '20250828180343135', 'btl', NULL),
(3255, 'ZAHA 250 TABLET 6\'S', 'AZITHROMYCIN 250 MG TABLETS', NULL, 'PA15014', 0.00, 5500.00, 8000.00, '2026-07-31', NULL, '2025-08-04 18:34:43', '2025-09-08 20:41:34', 10, '20250804175553191', 'pkt', NULL),
(3256, 'ZAHA 500 MG TABLETS 3\'S', 'AZITHROMYCIN 500 MG TABLETS', NULL, 'PA11184', 0.00, 4250.00, 7000.00, '2027-05-05', NULL, '2025-08-04 18:36:19', '2025-11-08 11:04:18', 2, '20250905192825110', 'dos', NULL),
(3257, 'ZECUF LOZENGES ORANGE PAIRS', 'LOZENGES', NULL, 'ME23J60', 12.00, 300.00, 500.00, '2029-07-31', NULL, '2025-08-04 18:38:38', '2025-10-18 19:41:52', 10, '20250804175747210', 'dos', NULL),
(3258, 'LEVOBACT 500MG TABLETS', 'LEVOFLOXACIN 500 MG TABLETS', NULL, 'LFYH0042', 35.00, 400.00, 2000.00, '2027-05-04', NULL, '2025-08-04 18:47:20', '2025-10-11 22:01:40', 10, '20250804174756568', 'tab', NULL),
(3259, 'BACLOFEN 10MG TABLETS 1X3', 'SKELETAL MUSCLE RELAXER', NULL, '4G02IX', 29.00, 433.00, 1000.00, '2026-06-30', NULL, '2025-08-04 21:25:46', '2025-09-02 21:28:19', 10, 'CHAR451', 'tab', NULL),
(3260, 'MIOPAN PLUS SYRUP 100ML', 'MAGALDRATE 540MG / SIMETHICONE 40 MG', NULL, '437', 1.00, 7000.00, 10000.00, '2026-07-31', NULL, '2025-08-04 21:29:17', '2025-10-16 21:45:50', 1, 'CHAR452', 'syp', NULL),
(3261, 'HEDEX PAIRS', 'PARACETAMOL/ASPIRIN/CAFFEINE 20/400/50 MG', NULL, '2502100', 23.00, 250.00, 500.00, '2027-01-31', NULL, '2025-08-04 22:02:47', '2025-11-05 18:14:04', 5, '20250807214231554', 'dos', NULL),
(3262, 'FEBRICOL TABLETS', 'PARACETAMOL 500/PSEUDOEPHEDRINE 30/ CHLORPHENIRAMINE 2MG', NULL, '550661', 40.00, 225.00, 500.00, '2028-03-31', NULL, '2025-08-05 18:17:26', '2025-10-25 20:51:57', 10, '20250820195137294', 'tab', NULL),
(3263, 'DICLOFENAC TABLETS 50 MG INDIA', 'DICLOFENAC TABLETS 50 MG', NULL, '00725', 0.00, 30.00, 50.00, '2026-12-31', NULL, '2025-08-05 18:18:43', '2025-10-29 21:59:09', 50, 'CHAR456', 'tab', NULL),
(3264, 'PIRITON 4MG TABLETS', 'CHLORPHENIRAMINE 4MG', NULL, '2502140', 320.00, 10.00, 100.00, '2028-01-01', NULL, '2025-08-05 18:20:50', '2025-10-28 14:57:55', 40, '20250905192449624', 'tab', NULL),
(3265, 'MAGNESIUM TRISILICATE MIXTURE 200 ML', 'MAGNESIUM TRISILICATE MIXTURE 200 ML', NULL, '3750', 0.00, 2800.00, 4000.00, '2027-05-31', NULL, '2025-08-05 18:22:03', '2025-10-15 20:02:19', 2, 'CHAR458', 'btl', NULL),
(3266, 'XYKAA EXTENDED 1000MG', 'SLOW RELEASE PARACETAMOL 1000MG', NULL, '2DX24018', 61.00, 300.00, 500.00, '2026-10-31', NULL, '2025-08-05 18:23:50', '2025-08-23 20:57:44', 10, '20250820200922829', 'tab', NULL),
(3267, 'BIO-SPA 40MG TABLETS', 'DROTAVERINE 40MG TABLETS', NULL, 'E3S1GTA195', 50.00, 400.00, 500.00, '2025-10-31', NULL, '2025-08-05 18:25:35', '2025-08-18 22:05:49', 10, 'CHAR460', 'tab', NULL),
(3268, 'LANSOPRAZOLE 30 MG INDIA CAPSULES', 'LANSOPRAZOLE 30 MG CAPSULES', NULL, 'LNH24014', 28.00, 350.00, 500.00, '2026-10-31', NULL, '2025-08-05 18:27:23', '2025-11-08 21:08:42', 10, 'CHAR361', 'cap', NULL),
(3269, 'GOPAYN MR', 'PARACETAMOL/ACECLOFENAC/SERATIOPASE', NULL, 'GPN7001', 17.00, 750.00, 1500.00, '2027-02-28', NULL, '2025-08-05 23:06:12', '2025-10-31 22:59:33', 5, '20250807215329593', 'tab', NULL),
(3271, 'COARTEM 20/120 TABLETS INDIA 24\'S', 'ARTEMETHER/LUMEFANTRINE 20/120', NULL, 'PA19674', 0.00, 84.00, 250.00, '2027-10-31', NULL, '2025-08-06 18:19:48', '2025-11-05 16:23:51', 24, 'CHAR471', 'tab', NULL),
(3272, 'CIPROFLOXACIN 500 INDIA TABLETS', 'CIPROFLOXACIN 500MG TABLETS', NULL, 'XT4K056', 50.00, 110.00, 200.00, '2027-10-31', NULL, '2025-08-06 18:22:34', '2025-11-10 21:36:06', 20, '20250807214755359', 'tab', NULL),
(3273, 'CHLORAMPHENICOL CAPSULES 250 MG', 'CHLORAMPHENICOL CAPSULES 250 MG', NULL, '01025', 30.00, 98.00, 200.00, '2028-04-30', NULL, '2025-08-06 18:24:18', '2025-11-07 13:54:40', 20, '20250822191004734', 'cap', NULL),
(3274, 'CREPE BANDAGE/ELASTIC BANDAGE 2.5INCH', 'CREPE BANDAGE/ELASTIC BANDAGE 2.5INCH', NULL, '250418', 0.00, 800.00, 1500.00, '2030-04-17', NULL, '2025-08-06 18:26:51', '2025-10-29 21:59:09', 0, '20250807215201393', 'pce', NULL),
(3275, 'NEOLORIDIN 5MG TABLETS', 'DESLORATADINE 5MG TABLETS', NULL, 'G301567', 0.00, 400.00, 600.00, '2026-05-31', NULL, '2025-08-06 21:13:01', '2025-11-10 21:44:22', 10, 'CHAR476', 'tab', NULL),
(3276, 'SECNIDAZOLE TABLETS INDIA 2G', 'SECNIDAZOLE 1G 2\'S', NULL, 'DYG005', 5.00, 1500.00, 5000.00, '2028-04-30', NULL, '2025-08-06 21:14:56', '2025-10-09 22:14:45', 2, '20250813181451587', 'pkt', NULL),
(3278, 'AMLODAC 5MG TABLETS', 'AMLODIPINE 5MG', NULL, 'G302952', 20.00, 184.00, 400.00, '2026-10-31', NULL, '2025-08-07 18:48:16', '2025-10-09 20:15:37', 10, '20250820195352506', 'tab', NULL),
(3279, 'LEVOCETRIZINE 5 MG TABLETS INDIA', 'LEVOCETRIZINE 5MG TABLETS', NULL, 'T23293', 15.00, 200.00, 300.00, '2026-08-31', NULL, '2025-08-07 18:49:57', '2025-10-23 13:45:09', 10, 'CHAR501', 'tab', NULL),
(3280, 'GINSOMIN CAPSULE', 'MULTIVITAMIN + GINSENG', NULL, '25A06L2', 6.00, 1100.00, 1500.00, '2027-01-31', NULL, '2025-08-07 18:52:30', '2025-11-01 21:57:18', 5, 'CHAR502', 'cap', NULL),
(3281, 'ORACURE GEL', 'LIDOCAINE / CETYLPYRIDIUM', NULL, '234060', 2.00, 12900.00, 19000.00, '2026-08-31', NULL, '2025-08-07 22:57:11', '2025-08-07 22:58:03', 10, '20250807215724379', 'pce', NULL),
(3282, 'SINURHON TABLETS SACHETS', 'PHENYL EPHRINE/CHLORPHENIRAMINE/CAFFEINE/PARACETAMOL', NULL, 'T3054', 16.00, 1000.00, 1500.00, '2027-09-30', NULL, '2025-08-07 23:02:20', NULL, 5, 'CHAR506', 'strp', NULL),
(3283, 'EXAMINATION GLOVES PAIRS', 'SANDRIES', NULL, '301023', 39.00, 360.00, 500.00, '2027-10-30', NULL, '2025-08-07 23:05:08', '2025-11-05 16:18:58', 10, 'CHAR507', 'pce', NULL),
(3285, 'HIV TEST CASSETES', 'HIV1/2 TEST KITS', NULL, '2024128', 5.00, 1200.00, 5000.00, '2027-12-31', NULL, '2025-08-08 18:30:01', '2025-11-01 19:29:49', 10, '20250902213216511', 'strp', NULL),
(3286, 'HIV TEST STRIPS', 'DETERMINE HIV 1/2 TEST KITS', NULL, '0000885925', 2.00, 2000.00, 5000.00, '2025-11-30', NULL, '2025-08-08 18:31:39', '2025-08-19 12:37:06', 10, 'CHAR557', 'strp', NULL),
(3287, 'MALARIA RDT ', 'MALARIA TEST STRIPS', NULL, 'MAGSLC077', 0.00, 2500.00, 5000.00, '2026-06-08', NULL, '2025-08-08 18:33:39', '2025-10-14 17:10:04', 10, 'CHAR558', 'strp', NULL),
(3288, 'LEVODENK 500MG TABLETS', 'LEVOFLOXACIN 500 MG TABLETS', NULL, '28708', 10.00, 4000.00, 5000.00, '2027-10-31', NULL, '2025-08-08 19:09:30', NULL, 5, 'CHAR559', 'tab', NULL),
(3289, 'ANAFRANIL 25MG', 'KLOMIPRAMINE 25MG', NULL, '23N390', 14.00, 850.00, 2000.00, '2026-08-31', NULL, '2025-08-08 19:22:08', '2025-11-09 23:04:44', 10, 'CHAR560', 'tab', NULL),
(3290, 'SANIX 400MG CAPSULES', 'CEFIXIME 400 MG CAPSULES', NULL, '4108006', 36.00, 900.00, 2000.00, '2026-02-28', NULL, '2025-08-08 19:24:27', '2025-11-08 19:18:07', 10, 'CHAR561', 'cap', NULL),
(3291, 'NEUROTONE TABLETS', 'VITAMIN B COMPLEX + FOLIC ACID', NULL, '242843', 30.00, 625.00, 1000.00, '2026-09-30', NULL, '2025-08-11 22:53:24', '2025-08-18 22:19:47', 5, '20250813181753268', 'tab', NULL),
(3292, 'FANSIDAR TABLETS 3\'S', 'SULFADOXIME / PYRIMETHAMINE TABLETS', NULL, '01624', 3.00, 1500.00, 2500.00, '2026-09-30', NULL, '2025-08-11 22:55:34', '2025-10-29 13:58:19', 2, 'CHAR-556', 'dos', NULL),
(3294, 'P-ALAXIN TABLETS 9\'S', 'DIHYDROARTEMISINE/PIPERAQUINE 40/480', NULL, 'TIAFN026', 0.00, 8500.00, 12000.00, '2028-02-29', NULL, '2025-08-12 18:32:32', '2025-09-16 20:51:04', 10, 'CHAR567', 'dos', NULL),
(3295, 'GROVIT MULTIVITAMIN TABLETS', 'MULTIVITAMIN TABLETS', NULL, '04011097', 26.00, 380.00, 500.00, '2026-11-30', NULL, '2025-08-12 18:34:39', '2025-11-06 12:46:38', 5, 'CHAR578', 'tab', NULL),
(3296, 'SUPER WELGRA 100', 'SILDENAFIL/DAPOXETINE 100/60', NULL, '426ME11', 1.00, 2000.00, 3000.00, '2027-07-31', NULL, '2025-08-12 18:39:31', '2025-09-16 21:55:43', 2, 'CHAR568', 'tab', NULL),
(3297, 'APIDONE SYRUP125ML', 'DEXAMETHASONE/CHLORPHENIRAMINE 0.5/2MG', NULL, '241726', 1.00, 18500.00, 25000.00, '2026-07-31', NULL, '2025-08-12 18:43:18', '2025-09-07 17:25:58', 1, 'CHAR569', 'syp', NULL),
(3298, 'ORAXIN SYRUP 200ML', 'CYPROHEPTADINE + LYSINE SYRUP', NULL, 'RAL2416', 1.00, 8500.00, 12000.00, '2027-09-30', NULL, '2025-08-12 18:45:20', '2025-11-09 23:14:43', 0, 'CHAR570', 'syp', NULL),
(3299, 'ORAXIN SYRUP 100ML', 'CYPROHEPTADINE + LYSINE SYRUP', NULL, 'RAL2416', 1.00, 4500.00, 7000.00, '2027-07-31', NULL, '2025-08-12 18:46:35', '2025-11-09 23:14:54', 0, 'CHAR571', 'syp', NULL),
(3300, 'TORACTIN SYRUP 100ML', 'CYPROHEPTADINE SYRUP', NULL, 'D21125002', 1.00, 4500.00, 5500.00, '2027-12-31', NULL, '2025-08-12 18:48:23', NULL, 0, 'CHAR572', 'syp', NULL),
(3301, 'KAPRON 500MG TABLETS', 'TRANEXAMIC ACID 500MG TABLETS', NULL, '243241', 4.00, 1100.00, 1500.00, '2027-10-31', NULL, '2025-08-12 18:54:32', '2025-10-03 13:52:10', 5, 'CHAR573', 'tab', NULL),
(3302, 'IBUMOL 400 MG TABLETS', 'PARACETAMOL/IBUPROFEN TAB 325/400', NULL, 'PA05453', 12.00, 350.00, 500.00, '2026-04-30', NULL, '2025-08-12 18:56:47', '2025-10-27 19:50:44', 5, 'CHAR574', 'tab', NULL),
(3303, 'FEFOL INDIA TABLETS', 'IRON / FOLIC ACID TABLETS INDIA', NULL, '65040', 50.00, 60.00, 100.00, '2026-11-30', NULL, '2025-08-12 18:59:44', '2025-08-12 19:01:26', 10, 'CHAR580', 'tab', NULL),
(3304, 'BETAPYN TABLET', 'PARACETAMOL/CODEINE 10MG/CAFFEINE 50 MG /DOXYLAMINE 5MG', NULL, 'AG0537', 7.00, 1100.00, 1500.00, '2026-02-28', NULL, '2025-08-12 21:42:25', '2025-10-16 17:42:32', 10, 'CHAR575', 'tab', NULL),
(3306, 'BRUSTAN TABLETS', 'IBUPROFEN/PARACETAMOL 400/325MG', NULL, 'DFF077OA', 13.00, 400.00, 500.00, '2027-01-31', NULL, '2025-08-12 21:45:40', '2025-11-03 23:00:31', 5, 'CHAR585', 'tab', NULL),
(3307, 'LYDIA FINE PILLS', 'LEVONOGESTREL 0.15/ETHINYL ESTRADIOL 0.03MG', NULL, 'KO2240402', 1.00, 1500.00, 3000.00, '2026-10-10', NULL, '2025-08-12 22:36:20', '2025-11-01 19:51:23', 1, '20250905201234135', 'strp', NULL),
(3308, 'TRAMADOL 50 MG CAPSULE', 'TRAMADOL 50 MG CAPSULE', NULL, 'G400595', -35.00, 80.00, 300.00, '2027-07-31', NULL, '2025-08-13 18:52:03', '2025-10-31 22:59:33', 10, '20250813182526191', 'tab', NULL),
(3310, 'WAXFREE ESR DROPS', 'SODIUM BI-CARBONATE EAR DROPS', NULL, 'DY501', 2.00, 5500.00, 9000.00, '2028-01-31', NULL, '2025-08-13 18:54:00', '2025-08-13 19:25:13', 0, '20250813182314452', 'btl', NULL),
(3311, 'NAT-B CAPSULES', 'VITAMIN B FORMULA', NULL, '24L07D1', 15.00, 584.00, 1000.00, '2026-12-31', NULL, '2025-08-13 18:57:21', '2025-10-20 15:09:18', 10, '20250813181303583', 'cap', NULL),
(3312, 'MULTIVITAMIN TABLETS INDIA', 'MULTIVITAMIN TABLETS ', NULL, 'ST241201', 80.00, 30.00, 100.00, '2027-11-30', NULL, '2025-08-13 18:59:03', '2025-11-06 12:46:38', 10, '20250813182228117', 'tab', NULL),
(3314, 'CEFTRIAXONE 1G INDIA ', 'CEFTRIAXONE 1G INDIA ', NULL, '06725024', 8.00, 1100.00, 2000.00, '2025-02-28', NULL, '2025-08-13 19:06:40', '2025-08-14 22:28:46', 5, '20250813181216427', 'pce', NULL),
(3315, 'AVARIN CAPSULES', 'SIMETHICONE / ALVERINE CITRATE', NULL, '24J09F1', 32.00, 640.00, 1000.00, '2026-10-08', NULL, '2025-08-13 19:08:39', '2025-10-31 22:59:33', 10, '20250905200426193', 'cap', NULL),
(3316, 'RABEPRAZOLE 20MG TABLETS', 'RABEPRAZOLE 20MG TABLETS', NULL, 'AR184032B', 12.00, 800.00, 1200.00, '2026-07-31', NULL, '2025-08-13 19:10:46', NULL, 10, 'CHAR592', 'tab', NULL),
(3317, 'COVIDEX 20ML', 'HERBAL COUGH MEDICINE', NULL, 'COVA00102', 1.00, 9200.00, 12000.00, '2026-09-30', NULL, '2025-08-13 22:21:04', '2025-08-13 22:29:46', 0, 'CHAR593', 'btl', NULL),
(3318, 'LIGABA 75MG CAPSULES', 'PREGABALIN 75 CAPSULES', NULL, 'BRE09045B', 14.00, 1100.00, 1500.00, '2026-08-31', NULL, '2025-08-13 22:22:56', '2025-10-28 21:49:45', 10, 'CHAR595', 'cap', NULL),
(3319, 'BENA EXPECTORANT', 'AMMONIUM CHLORIDE/DIPHENHYDRAMINE', NULL, '514181', 1.00, 8500.00, 12000.00, '2027-03-31', NULL, '2025-08-14 22:24:37', '2025-08-14 22:26:04', 0, 'CHA111', 'btl', NULL),
(3322, 'MENTHODEX COUGH MIXTURE 200 ML', 'MENTHODEX COUGH MIXTURE', NULL, '796D1', 1.00, 19000.00, 24000.00, '2027-02-28', NULL, '2025-08-14 22:31:23', '2025-11-04 21:34:48', 0, 'CHAR600', 'btl', NULL),
(3323, 'ANTINAL SYRUP 60ML', 'NIFUROZIDE', NULL, 'G402942', 0.00, 13000.00, 18000.00, '2027-10-31', NULL, '2025-08-14 22:33:01', '2025-08-14 22:41:26', 0, 'CHAR601', 'syp', NULL),
(3324, 'ZINKID 20MG', 'ZINC SULPHATE 20 MG', NULL, 'NT40400-B', 80.00, 110.00, 200.00, '2027-05-31', NULL, '2025-08-18 18:09:26', '2025-10-11 10:05:36', 10, 'CHAR602', 'tab', NULL),
(3326, 'ASPIRIN 300 MG TABLETS', 'ASPIRIN 300 MG TABLETS', NULL, '00224', 35.00, 60.00, 100.00, '2026-06-30', NULL, '2025-08-18 18:10:54', '2025-10-29 13:58:19', 10, 'CHAR603', 'tab', NULL),
(3327, 'CETAMOL SYRUP 60 ML', 'PARACETAMOL SYRUP', NULL, '250239', 0.00, 3000.00, 4000.00, '2027-12-31', NULL, '2025-08-19 22:38:48', '2025-09-13 09:50:26', 0, 'CHAR604', 'syp', NULL),
(3328, 'LORHISTINA SYRUP 5MG/5ML 60 ML', 'LORATADINE SYRUP', NULL, '250438', 0.00, 4000.00, 8000.00, '2027-03-25', NULL, '2025-08-19 22:40:51', '2025-10-03 21:57:53', 0, '20250905191348719', 'syp', NULL),
(3329, 'FERROFOL CAPSULES', 'FERROUS SULFATE / FOLIC ACID', NULL, '2410164', 85.00, 234.00, 400.00, '2027-11-30', NULL, '2025-08-19 22:43:49', '2025-10-04 20:31:13', 10, '20250902211459515', 'cap', NULL),
(3330, 'DUOCOTEXIN 40/320', 'DIHYDROARTEMISIN /PIPERAQUIN', NULL, '241101', 1.00, 10700.00, 17000.00, '2026-10-31', NULL, '2025-08-20 20:04:28', '2025-10-30 22:37:09', 1, '20250822191943578', 'dos', NULL),
(3331, 'KAMAGRA 50 MG', 'SILDENAFIL 50 MG TABLETS', NULL, 'PA10993', 0.00, 2125.00, 3500.00, '2026-04-30', NULL, '2025-08-20 20:16:46', '2025-10-03 21:11:50', 0, '20250820191657880', 'tab', NULL),
(3332, 'CEFAMOR SYRUP 100 ML', 'CEFALEXIN SYRUP 100 ML', NULL, 'G27E5001', 2.00, 4800.00, 8000.00, '2027-12-31', NULL, '2025-08-20 20:25:42', '2025-08-20 20:26:26', 0, '20250820192555588', 'syp', NULL),
(3333, 'AZITRO TURKEY 500MG TABLETS', 'AZITHROMYCIN 500 MG TABLET', NULL, 'A19971A', 2.00, 7500.00, 12000.00, '2028-10-30', NULL, '2025-08-20 20:30:20', '2025-08-20 20:30:54', 1, '20250820193029661', 'dos', NULL),
(3334, 'TERBINAFINE TABLETS 250 MG UK', 'TERBINAFINE TABLETS 250 MG ', NULL, 'AEX005', 12.00, 786.00, 2000.00, '2026-05-31', NULL, '2025-08-20 20:32:52', '2025-11-01 12:53:45', 10, '20250820193304400', 'tab', NULL),
(3335, 'TERBIDERM FORTE 250MG TABLETS', 'TERBINAFINE 250', NULL, 'HH005K', 10.00, 1100.00, 2000.00, '2026-07-31', NULL, '2025-08-20 20:43:26', '2025-08-20 20:43:58', 10, '20250820194333641', 'tab', NULL),
(3336, 'COUGH LINCTUS 1LTR', 'CHLORPHENIRAMINE/PARACETAMOL SYRUP', NULL, '9595', 0.00, 4400.00, 7000.00, '2027-07-31', NULL, '2025-08-20 20:49:34', '2025-10-15 20:44:04', 1, '20250820194950547', 'btl', NULL),
(3338, 'BIO-OIL 25ML', 'BIO OIL', NULL, '00024416', 0.00, 8800.00, 14000.00, '2030-02-28', NULL, '2025-08-20 21:02:36', '2025-10-06 15:47:25', 10, '20250820200520146', 'btl', NULL),
(3339, 'BIO-OIL 60 ML', 'BIO-OIL 60 ML', NULL, '00024419', 1.00, 17500.00, 27000.00, '2030-02-28', NULL, '2025-08-20 21:03:56', '2025-08-20 21:06:18', 1, '20250820200551660', 'btl', NULL),
(3341, 'BIO-OIL 125 ML', 'BIO-OIL 125 ML', NULL, '00024360', 1.00, 28500.00, 43000.00, '2030-02-28', NULL, '2025-08-20 21:05:12', '2025-08-20 21:06:42', 1, '20250820200623670', 'btl', NULL),
(3342, 'OTRIVINE NASAL DROPS', 'XYLOMETALOZONE 0.05%', NULL, 'T476', 1.00, 19000.00, 28000.00, '2026-12-31', NULL, '2025-08-20 21:08:39', '2025-08-20 21:09:16', 1, '20250820200847752', 'btl', NULL),
(3343, 'BORIC ACID PESSARIES', 'BORIC ACID PESSARIES', NULL, '2028-03', 19.00, 0.00, 2000.00, '2027-03-31', NULL, '2025-08-21 17:48:57', '2025-11-01 22:29:07', 5, 'CHAR612', 'pce', NULL),
(3344, 'CERUMOL EAR DROP', 'CERUMOL EAR DROP', NULL, 'LBD202404085', 0.00, 30500.00, 45000.00, '2027-10-31', NULL, '2025-08-21 18:06:42', NULL, 1, 'CHAR4115', 'btl', NULL),
(3345, 'PAINEX PAIRS', 'PARACETAMOL/ASPIRIN/CAFFEINE', NULL, '02324', 11.00, 320.00, 500.00, '2026-02-28', NULL, '2025-08-21 18:08:17', '2025-11-10 16:31:17', 10, 'CHAR616', 'scht', NULL),
(3347, 'GYNANFORTE PESSARIES', 'METRONIDAZOLE/NEOMYCIN/NYSTATIN PESSARIES', NULL, 'TIAHG021', 7.00, 900.00, 1500.00, '2026-12-31', NULL, '2025-08-21 21:01:01', '2025-11-10 17:17:45', 10, 'CHAR617', 'pce', NULL),
(3349, 'AMLODAC 10 MG TABLETS', 'AMLODIPINE 10 MG TABLETS', NULL, 'G401280', 25.00, 400.00, 600.00, '2027-04-30', NULL, '2025-08-21 21:05:16', '2025-11-10 21:44:22', 10, 'CHAR618', 'tab', NULL),
(3352, 'LEVOCET-M SYRUP', 'LEVOCETRIZIN/MONTELUKAST SOLUTION', NULL, 'L-1098008', 1.00, 14500.00, 22000.00, '2028-02-29', NULL, '2025-08-22 19:42:24', '2025-08-22 20:30:17', 1, '20250822192936945', 'btl', NULL),
(3353, 'CLOMID 50 MG', 'CLOMIPHENE CITRATE TABLETS 50 MG', NULL, '250242', 10.00, 2200.00, 3500.00, '2030-01-31', NULL, '2025-08-22 19:45:47', '2025-08-22 20:07:24', 5, '20250822190652749', 'tab', NULL),
(3354, 'CIPRODAR 500 MG', 'CIPROFLOXACIN 500 MG TABLETS', NULL, '8892', 10.00, 850.00, 1500.00, '2027-05-31', NULL, '2025-08-22 19:47:35', '2025-10-27 19:50:44', 5, '20250822192710341', 'tab', NULL),
(3355, 'CHLORAMPHENICOL SUSPENSION 100ML', 'CHLORAMPHENICOL SUSPENSION 100ML', NULL, '241165', 1.00, 3200.00, 5000.00, '2027-05-31', NULL, '2025-08-22 19:49:32', '2025-11-06 12:46:38', 1, '20250822191149861', 'syp', NULL),
(3356, 'D-ARTEPP CHILD TALBETS', 'DIHYDROARTEMISIN/PIPERAQUINE', NULL, 'DS241103', 2.00, 7000.00, 10000.00, '2026-11-30', NULL, '2025-08-22 19:54:20', '2025-08-22 20:33:15', 1, '20250822193230248', 'dos', NULL),
(3357, 'XITHRONE 500MG TABLET', 'AZITHROMYCIN 500 MG TABLET', NULL, '250223', 5.00, 5300.00, 8000.00, '2027-01-31', NULL, '2025-08-22 19:56:08', '2025-08-22 20:35:05', 1, '20250822193419301', 'tab', NULL),
(3358, 'CEFUTIL 500 MG TABLET', 'CEFUROXIME 500 MG TABLET', NULL, '6240800', 10.00, 3300.00, 5000.00, '2027-08-31', NULL, '2025-08-22 19:59:39', '2025-08-22 20:28:56', 5, '20250822192819413', 'tab', NULL),
(3359, 'ZITHROX 250MG (PACKET)', 'AZITHROMYCIN 250MG TABLETS ', NULL, '240632', 0.00, 3000.00, 7000.00, '2027-05-31', NULL, '2025-08-22 20:01:41', '2025-10-02 19:31:17', 1, '20250822191736205', 'dos', NULL),
(3360, 'MAGNES DIRECT', 'MAGNESIUM 400 MG ', NULL, '30588', 13.00, 800.00, 1300.00, '2027-09-30', NULL, '2025-08-22 20:03:01', '2025-10-23 22:04:33', 5, '20250822193518500', 'scht', NULL),
(3361, 'D-ARTEPP ADULT 6\'S 80/640', 'DIHYDROARTEMISIN/PIPERAQUINE ', NULL, 'SQ240708', 1.00, 7000.00, 12000.00, '2026-07-31', NULL, '2025-08-22 20:05:21', '2025-09-10 21:28:31', 5, '20250822193323419', 'dos', NULL),
(3362, 'LYDIA INJECTION', 'LYDIA INJECTION', NULL, 'EVM25008', 4.00, 2500.00, 7000.00, '2028-01-31', NULL, '2025-08-22 20:39:08', '2025-10-20 21:46:47', 1, 'CHAR640', 'inj', NULL),
(3363, 'ROUGH RIDER', 'STUDDED CONDOMS', NULL, '2310361616', 1.00, 6900.00, 11000.00, '2028-09-09', NULL, '2025-08-22 21:05:24', '2025-09-08 12:53:13', 1, '20250905195513961', 'pce', NULL),
(3364, 'POSTINOR 2 PILLS', 'LEVONOGESTREL 1.5 MG', NULL, 't46249r', 0.00, 8000.00, 12000.00, '2029-06-30', NULL, '2025-08-24 21:51:02', '2025-11-01 21:11:30', 10, '20250828173250686', 'dos', NULL),
(3365, 'ANTINAL CAPS', 'NIFUROXAZIDE 200MG', NULL, '251500', 12.00, 625.00, 1000.00, '2028-03-31', NULL, '2025-08-24 22:16:25', '2025-11-06 17:25:53', 5, '20250828173400546', 'cap', NULL),
(3366, 'RECODIN SYRUP 100 ML', 'CODEINE SYRUP', NULL, '00425', 0.00, 4000.00, 6000.00, '2027-01-31', NULL, '2025-08-25 23:39:37', '2025-09-12 20:15:37', 1, '20250902212936496', 'syp', NULL),
(3367, 'PROMETHAZINE SYRUP', 'PROMETHAZINE', NULL, '00324', 1.00, 2000.00, 3000.00, '2026-04-30', NULL, '2025-08-25 23:40:57', '2025-08-25 23:45:29', 1, 'CHAR641', 'syp', NULL),
(3368, 'COUGH LINCTUS 200ML', 'CHLORPHENIRAMINE /CITRIC ACID/MENTHOL', NULL, '9568', 0.00, 1600.00, 3000.00, '2027-06-30', NULL, '2025-08-25 23:42:33', '2025-10-31 19:15:11', 2, '20250828180631690', 'syp', NULL),
(3369, 'HCG CASSETE', 'HCG CASSETE', NULL, '25031131', 0.00, 2500.00, 6000.00, '2028-04-09', NULL, '2025-08-25 23:44:06', '2025-09-10 12:53:04', 1, 'CHAR643', 'pce', NULL),
(3370, 'VITAMIN B COMPLEX INJECTION', 'VITAMIN B COMPLEX INJECTION', NULL, '147F', 10.00, 800.00, 1500.00, '2026-10-31', NULL, '2025-08-28 18:39:31', '2025-08-28 18:40:04', 10, '20250828173943457', 'inj', NULL),
(3371, 'ORLISTAT 120MG CAPSULES', 'ORLISTAT 120MG CAPSULES', NULL, 'D2401845', 20.00, 3550.00, 5500.00, '2026-08-31', NULL, '2025-08-28 18:42:55', '2025-08-28 18:58:46', 10, '20250828175754941', 'cap', NULL),
(3372, 'VITAMIN D 1000 D CAP', 'VITAMIN D SOFTGEL CAPSULES', NULL, '4249', 30.00, 633.00, 1000.00, '2028-03-31', NULL, '2025-08-28 18:50:40', '2025-08-28 19:05:09', 10, '20250828180441619', 'cap', NULL),
(3373, 'DEXAMETHASONE INJECTION 4MG/ML', 'DEXAMETHASONE INJECTION 4MG/ML', NULL, '4276', 9.00, 850.00, 1500.00, '2026-09-30', NULL, '2025-08-28 18:52:18', '2025-10-14 17:10:04', 2, '20250828180131269', 'inj', NULL),
(3374, 'APPETITE PLUS SYRUP', 'APPETITE PLUS SYRUP', NULL, '25010037', 1.00, 18000.00, 28000.00, '2028-01-31', NULL, '2025-08-28 18:53:26', '2025-08-28 18:55:05', 0, '20250828175438688', 'syp', NULL),
(3376, 'CELABET TABLETS 1X2', 'BETAMETHASONE 0.25MG/DEXCHLORPHENIRAMINE 2MG TABLETS', NULL, '678', 19.00, 483.00, 1000.00, '2027-01-31', NULL, '2025-08-28 19:15:59', '2025-11-08 21:43:53', 10, '20250828181625534', 'tab', NULL),
(3377, 'DIPROFOS INJECTION', 'BETAMETHASONE INJ', NULL, 'W025759', 0.00, 33000.00, 45000.00, '2027-02-28', NULL, '2025-08-28 19:18:38', NULL, 1, 'CHAR4117', 'pce', NULL),
(3379, 'NAPROXEN 500 UK TABLETS', 'NAPROXEN 500 MG TABLETS', NULL, '250430', 18.00, 536.00, 1000.00, '2027-12-31', NULL, '2025-09-02 21:45:41', '2025-11-05 17:32:38', 10, 'CHAR6111', 'tab', NULL),
(3380, 'PANDURA TAB 2MG', 'CLONAZEPAM 2MG', NULL, '00525', 82.00, 550.00, 850.00, '2027-03-31', NULL, '2025-09-02 21:47:29', '2025-09-15 12:23:47', 10, 'CHAR6112', 'tab', NULL),
(3381, 'AMOKLAVIN BD SYRUP 228/5ML', 'AMOXICILLIN/POTTASIUM CLAVUNATE', NULL, 'A15058', 2.00, 13000.00, 20000.00, '2028-04-30', NULL, '2025-09-02 21:50:14', '2025-09-02 22:08:41', 1, '20250902210812517', 'syp', NULL),
(3382, 'PREGNACARE PLUS OMEGA 3 56 TAB', 'PREGNACARE VITAMINTS /OMEGA 3 OILS', NULL, 'PP2521', 1.00, 55000.00, 80000.00, '2027-11-30', NULL, '2025-09-02 21:55:52', '2025-09-02 22:26:12', 0, '20250902212546582', 'dos', NULL),
(3383, 'PREGNACARE MAX TABLETS 84\'S', 'PREGNACARE MAX TABLETS 84\'S', NULL, 'PM2508CP', 1.00, 57500.00, 100000.00, '2027-10-31', NULL, '2025-09-02 21:58:56', '2025-09-02 22:26:52', 0, '20250902212623114', 'dos', NULL),
(3384, 'COTTON WOOL 100G', 'COTTON WOOL 100G', NULL, '824-10/11', 1.00, 1800.00, 3500.00, '2028-07-31', NULL, '2025-09-02 22:01:20', '2025-09-07 20:07:09', 1, '20250902213537169', 'pce', NULL),
(3385, 'COTTON WOOL 200G', 'COTTON WOOL 200G', NULL, 'B-03-04/23', 1.00, 3500.00, 5000.00, '2028-02-29', NULL, '2025-09-02 22:02:07', '2025-09-02 22:39:06', 1, '20250902213746629', 'pce', NULL),
(3387, 'PARADENK 125 SUPPOSITORIES', 'RECTAL PARACETAMOL', NULL, '30629', 10.00, 750.00, 1500.00, '2027-07-07', NULL, '2025-09-02 22:04:05', '2025-09-02 22:34:06', 2, '20250902213322773', 'pce', NULL),
(3388, 'AMINORICH CAPSULES', 'AMINO ACID CAPSULES', NULL, '24XARC-014', 10.00, 800.00, 1200.00, '2026-11-30', NULL, '2025-09-02 22:05:17', '2025-10-23 22:04:33', 5, '20250902212659437', 'tab', NULL),
(3389, 'DESLORAT SYRUP 100ML SYP', 'DESLORATADINE SYRUP 2.5MG/ML', NULL, '2312717', 0.00, 7000.00, 15000.00, '2026-12-31', NULL, '2025-09-02 22:13:48', '2025-10-16 19:22:47', 0, '20250902211403797', 'syp', NULL),
(3390, 'CETRIZINE 10MG TABLETS UK', 'CETRIZINE 10MG TABLETS UK', NULL, '24010569', 27.00, 234.00, 500.00, '2027-09-30', NULL, '2025-09-02 22:17:31', '2025-09-11 22:15:01', 10, '20250902211739409', 'tab', NULL),
(3391, 'OMEPRAZOLE 40 MG TABLETS UK', 'OMEPRAZOLE 40 MG TABLETS UK', NULL, '25958', 28.00, 643.00, 1000.00, '2026-09-30', NULL, '2025-09-02 22:22:11', '2025-09-02 22:24:16', 10, '20250902212220119', 'cap', NULL),
(3392, 'CATENOL 50 MG', 'ATENOLOL 50 MG TABLETS', NULL, 'G402806', 10.00, 57.00, 100.00, '2027-09-30', NULL, '2025-09-02 22:41:10', '2025-11-09 23:08:03', 10, '20250902214120284', 'tab', NULL),
(3393, 'CAUSTIC PENCIL 40%', 'CAUSTIC PECIL 40%', NULL, '39050', 1.00, 6500.00, 10000.00, '2029-10-31', NULL, '2025-09-02 22:44:12', '2025-09-02 22:45:12', 0, '20250902214418811', 'pce', NULL),
(3394, 'MYOSPAZ TABLETS', 'Chlorzoxazone/Paracetamol tablets 250/500 mg', NULL, 'NO184', 60.00, 500.00, 700.00, '2027-10-31', NULL, '2025-09-03 19:21:08', '2025-10-28 21:49:45', 10, 'CHR12', 'tab', NULL),
(3395, 'BRONCHOPHANE SYRUP ', 'ANTIHISTAMINE/EXPECTORANT', NULL, 'BGDFG', 0.00, 13500.00, 17000.00, '2027-10-24', NULL, '2025-09-04 20:24:31', '2025-09-04 20:33:07', 0, 'CHR132', 'syp', NULL),
(3396, 'ARTESUNATE INJ 60MG', 'ARTESUNATE INJ 60MG', NULL, 'AR1042507', 3.00, 1800.00, 5000.00, '2028-03-31', NULL, '2025-09-05 19:33:45', '2025-09-05 19:45:48', 0, '20250905184517218', 'inj', NULL),
(3397, 'ARTESUNATE INJ 120 MG', 'ARTESUNATE INJ 120MG', NULL, 'IP24316', 3.00, 5000.00, 10000.00, '2026-11-11', NULL, '2025-09-05 19:36:33', '2025-09-05 19:45:08', 0, '20250905184430294', 'inj', NULL),
(3398, 'BORIC ACID FEMININE WASH', 'BORIC ACID FEMININE WASH', NULL, '5FL.0Z', 1.00, 35000.00, 50000.00, '2027-11-30', NULL, '2025-09-05 19:44:17', '2025-09-05 20:03:16', 0, '20250905190143676', 'btl', NULL),
(3399, 'PHENOBARBITONE TABLETS 30MG', 'PHENOBARBITONE TABLETS 30MG', NULL, '2502166', 90.00, 40.00, 100.00, '2028-01-01', NULL, '2025-09-05 20:18:19', '2025-09-07 21:40:40', 10, '20250905192210926', 'tab', NULL),
(3400, 'MEBENDAZOLE SYRUP 30ML', 'MEBENDAZOLE SYRUP 30ML', NULL, '2503133', 2.00, 800.00, 3000.00, '2028-02-02', NULL, '2025-09-05 20:20:05', '2025-10-31 22:59:33', 2, '20250905192311390', 'syp', NULL),
(3401, 'ENAT 400 CAPSULE', 'VITAMIN E CAPSULE', NULL, '24J20B1', 27.00, 950.00, 1500.00, '2027-10-19', NULL, '2025-09-05 20:31:18', '2025-09-11 10:27:27', 10, '20250905193125293', 'cap', NULL),
(3402, 'NANA HERBAL MOUTH WASH SPRAY', 'NANA HERBAL MOUTH WASH', NULL, '007DK', 1.00, 5000.00, 7500.00, '2027-01-20', NULL, '2025-09-05 20:36:57', '2025-10-09 22:03:16', 1, '20250905193934469', 'btl', NULL),
(3403, 'KENAZOLE CREAM 20G', 'KETOCONAZOLE CREAM', NULL, '2411090', 1.00, 2000.00, 4000.00, '2027-10-10', NULL, '2025-09-05 20:50:02', '2025-09-08 16:04:12', 0, '20250905195359965', 'pce', NULL),
(3404, 'GLEVATE CREAM', 'CLOBETASOL CREAM', NULL, '10250572', 2.00, 8500.00, 13000.00, '2027-02-22', NULL, '2025-09-05 21:21:02', '2025-09-05 21:32:48', 0, '20250905203224664', 'pce', NULL),
(3405, 'MOMATE-F CREAM', 'MOMETASONE/FUSIDIC ACID CREAM', NULL, '11250095', 0.00, 11000.00, 17000.00, '2026-12-12', NULL, '2025-09-05 21:22:17', '2025-10-25 20:51:57', 0, '20250905203145531', 'pce', NULL),
(3406, 'RECTOL 125 MG SUPPOSITORY', 'ACETAMINOPHEN 125 SUPPOSITORIES', NULL, 'TIACJ007', 8.00, 560.00, 1500.00, '2028-03-03', NULL, '2025-09-05 21:24:07', '2025-10-02 22:17:16', 0, '20250905203600236', 'pce', NULL),
(3407, 'MINTOGEL SYRUP 180 ML', 'MAGNESIUM SYRUP', NULL, 'BV5001', 1.00, 2700.00, 5000.00, '2028-03-03', NULL, '2025-09-05 21:26:43', '2025-09-11 22:15:01', 1, '20250905203703188', 'btl', NULL),
(3408, 'AUROFORTE EYE DROP', 'PREDNISOLONE EYE DROP', NULL, '5A054E', 1.00, 15000.00, 22000.00, '2026-12-12', NULL, '2025-09-05 21:28:08', '2025-09-05 21:38:16', 0, '20250905203748961', 'btl', NULL),
(3409, 'ZIMUNE D3 TABLET', 'VITAMIN C / ZINC/VITAMIN D', NULL, 'EATA2313A', 29.00, 600.00, 1000.00, '2026-11-11', NULL, '2025-09-05 21:31:05', '2025-11-09 23:08:03', 10, '20250905203827731', 'tab', NULL),
(3410, 'SOLANGE WOMEN SYRUP', 'PERIOD PAINS ANAD CRAMPS', NULL, '00IEU', 1.00, 6000.00, 9000.00, '2027-01-01', NULL, '2025-09-05 21:41:51', '2025-09-05 21:43:39', 0, 'CHR392HH', 'syp', NULL),
(3411, 'DIGITAL THERMOMETER', 'DIGITAL THERMOMETER', NULL, '2111001', 1.00, 5000.00, 8000.00, '2027-01-01', NULL, '2025-09-05 21:42:49', '2025-09-05 21:44:24', 0, 'CHR392HHR', 'pce', NULL),
(3412, 'DOMPERIDONE SYRUP 30ML', 'DOMPERIDONE SYRUP', NULL, 'R954003A', 1.00, 5500.00, 9000.00, '2027-05-05', NULL, '2025-09-05 21:47:12', '2025-09-05 22:05:43', 0, '20250905210516704', 'syp', NULL),
(3413, 'GOLDEN TIME HIV TEST CASSETE', 'HIV TEST CASSETE', NULL, '25031131', 0.00, 4000.00, 8000.00, '2028-04-09', NULL, '2025-09-05 22:00:31', '2025-09-25 18:50:12', 0, '20250905211109164', 'pce', NULL),
(3414, 'GOLDEN TIME HCG TEST CASSETE', 'GOLDEN TIME HCG TEST CASSETE', NULL, '25011411', 2.00, 3000.00, 6000.00, '2027-01-03', NULL, '2025-09-05 22:01:37', '2025-10-29 21:59:09', 0, '20250905211147612', 'pce', NULL),
(3415, 'OLOPATADINE EYE DROP OLOHISTINE', 'OLOPATADINE EYE DROP', NULL, '2406698', 1.00, 14000.00, 20000.00, '2027-10-10', NULL, '2025-09-05 22:03:26', '2025-09-05 22:14:10', 0, '20250905211334886', 'pce', NULL),
(3416, 'LAXOLAC SYRUP 120ML', 'LACTULOSE SYRUP', NULL, '250285', 2.00, 7300.00, 11000.00, '2027-01-01', NULL, '2025-09-05 22:07:34', '2025-09-05 22:09:19', 0, '20250905210856168', 'syp', NULL),
(3417, 'CLAVULIN 228 SYRUP', 'AMOXICILLIN/CLAVULANIC ACID 228 SYRUP', NULL, 'N97K', 1.00, 17000.00, 25000.00, '2026-02-22', NULL, '2025-09-05 22:08:47', '2025-09-05 22:10:04', 0, '20250905210928319', 'syp', NULL),
(3418, 'FLUFED TABLETS', 'TRIPOLIDINE T', NULL, 'L-1098008', -4.00, 130.00, 200.00, '2026-08-08', NULL, '2025-09-05 22:29:14', '2025-11-10 21:44:22', 10, 'CHAR390D', 'tab', NULL),
(3419, 'NO SORES GEL', 'NO SORES GEL', NULL, 'PM03884H', 1.00, 3500.00, 5000.00, '2026-05-20', NULL, '2025-09-06 10:58:42', '2025-09-11 22:18:45', 1, 'BVM65', 'pce', NULL),
(3420, 'ACECLOFENAC100  MG TABLETS', 'ACECLOFENAC100  MG', NULL, 'D2203177', 43.00, 320.00, 500.00, '2025-11-11', NULL, '2025-09-06 11:04:24', '2025-09-16 21:55:43', 10, 'CHAR-3778', 'tab', NULL),
(3421, 'O CONDOM', 'O CONDOM', NULL, '24N2857', 0.00, 2000.00, 3000.00, '2029-11-11', NULL, '2025-09-06 17:38:39', '2025-11-07 19:36:59', 2, 'CHAR-379GG', 'pce', NULL),
(3422, 'CEFIXIME SYRUP INDIA100MG/5L 60 ML ', 'CEFIXIME SYRUP 100MG/5L 60 ML ', NULL, 'PM03884G', 0.00, 6500.00, 10000.00, '2027-04-02', NULL, '2025-09-06 17:40:14', '2025-09-06 17:41:09', 0, 'CHAR-379HG', 'syp', NULL),
(3423, 'OLFEN 100 MG CAPSULES', 'SLOW RELEASE DICLOFENAC 100 MG', NULL, '24055331', 0.00, 2450.00, 3500.00, '2027-03-31', NULL, '2025-09-06 22:25:25', '2025-10-25 19:26:32', 10, 'CHAR-379H', 'cap', NULL),
(3424, 'IBUMEX SYRUP 100MG/5ML 60 ML', 'IBUPROFEN SYRUP 100MG/5ML 60 ML', NULL, '241756', 1.00, 3000.00, 4000.00, '2027-08-08', NULL, '2025-09-06 22:54:10', '2025-09-06 22:55:39', 1, 'CHAR-379KK', 'btl', NULL),
(3425, 'CADIPHEN SYRUP 100ML', 'CHLORPHENIRAMINE/GUANFENESIN/AMMONIUM CHLORIDE', NULL, 'N66020B', 1.00, 4000.00, 6000.00, '2028-11-11', NULL, '2025-09-08 21:56:10', '2025-09-08 21:58:31', 1, 'CHAR-379LK', 'syp', NULL),
(3426, 'TOREX TABLETS', 'CHLORPHENIRAMINE/GUANFENESIN/DEXTROMETHOPHAN/BROMHEXINE', NULL, 'D25023003', 9.00, 2200.00, 3000.00, '2026-05-05', NULL, '2025-09-08 21:58:11', '2025-09-08 21:58:31', 2, 'CHAR-379LKG', 'strp', NULL),
(3427, 'BUSCOPAN 10 MG TABLETS', 'HYOSCINE BUTYLBROMIDE', NULL, '004556', 60.00, 300.00, 500.00, '2026-03-01', NULL, '2025-09-09 18:18:22', NULL, 10, 'CHAR394BB', 'tab', NULL),
(3428, 'CANNULATION PROCEDURE', 'CANNULATION PROCEDURE', NULL, 'ZZZZ', 10.00, 3000.00, 5000.00, '2029-12-12', NULL, '2025-09-13 16:52:14', NULL, 0, '2', 'inj', NULL),
(3429, 'FERROTONE CAPSULES', 'IRON/FOLIC ACID / VITAMIN B 12', NULL, '24F19A1', 48.00, 350.00, 500.00, '2026-06-18', NULL, '2025-09-13 16:55:51', NULL, 10, 'CHAR-372G', 'cap', NULL),
(3430, 'PYLOKIT', 'LANSOPRAZOLE/CLARITHROMYCIN/TINIDAZOLE', NULL, '4KA1725', 3.00, 4500.00, 6000.00, '2026-04-04', NULL, '2025-09-13 16:57:55', '2025-11-07 21:37:03', 2, 'CHAR-372GG', 'pkt', NULL),
(3431, 'AIVPOD 200MG TABLETS', 'CEFPODOXIME 200 MG TABLETS', NULL, 'TCP04025', 7.00, 1300.00, 2000.00, '2026-04-04', NULL, '2025-09-13 17:00:50', '2025-09-23 21:02:31', 5, 'CHAR-372H', 'tab', NULL),
(3432, 'CEFODOX 200MG TABLETS', 'CEFPODOXIME 200 MG TABLETS', NULL, '6250217', 10.00, 3500.00, 5000.00, '2028-04-04', NULL, '2025-09-13 17:01:58', NULL, 5, 'CHAR-372HH', 'tab', NULL),
(3433, 'LOOBID TABLETS', 'OFLOXACIN/ORNIDAZOLE/LACTIC ACID BACILLUS', NULL, 'LBT25005E', 0.00, 1700.00, 2500.00, '2027-03-31', NULL, '2025-09-13 17:04:06', '2025-10-19 19:05:10', 5, 'CHAR-372HHK', 'tab', NULL),
(3434, 'KISS LUBRICATING GEL', 'LUBRICANT', NULL, '250438', 1.00, 6000.00, 9000.00, '2028-03-31', NULL, '2025-09-13 17:06:25', '2025-11-06 19:21:03', 0, 'CHAR-372HHKH', 'pce', NULL),
(3435, 'CENTIPAR 30 ML SYRUP', 'PIPERAZINE 30 ML SYRUP', NULL, 'CFL2501', 2.00, 3500.00, 2600.00, '2027-04-04', NULL, '2025-09-16 20:52:53', '2025-11-08 22:12:15', 0, 'CHAR-372NB', 'syp', NULL),
(3438, 'DREZ-V GEL 30G', 'MICONAZOLE/GENTAMYCIN GEL', NULL, 'L-1098008F', 0.00, 9500.00, 14000.00, '2026-11-11', NULL, '2025-09-23 19:33:26', '2025-10-19 19:08:07', 0, 'CHAR394BBV', 'pce', NULL),
(3439, 'MIXIF 400 MG CAPSULES', 'CEFIXIME 400MG CAPSULES', NULL, 'NR02058AV', 0.00, 5500.00, 7000.00, '2026-01-31', NULL, '2025-09-23 19:34:55', '2025-09-23 19:35:57', 0, 'CHAR617FD', 'cap', NULL),
(3440, 'ZITHROX SYRUP 15ML', 'AZITHROMYCIN SYRUP 200MG/5ML', NULL, '240064', 1.00, 4000.00, 6000.00, '2027-12-12', NULL, '2025-09-26 21:22:52', '2025-09-26 21:27:02', 0, 'JAN2025', 'btl', NULL),
(3441, 'AMOXICLAV SYRUP INDIA 228', 'AMOXICLAV SYRUP INDIA 228', NULL, 'G402942NB', 0.00, 6500.00, 10000.00, '2027-03-23', NULL, '2025-10-02 22:22:38', '2025-10-02 22:23:45', 0, 'CHAR-372,,', 'syp', NULL),
(3442, 'LONART DS TABLET', 'ARTEMETHER LUMEFANTRINE 80/480 TABLET', NULL, 'AAAAAAAAA', 0.00, 1334.00, 2000.00, '2026-10-01', NULL, '2025-10-11 19:54:23', '2025-10-21 11:01:40', 0, 'CHAR388/', 'tab', NULL),
(3443, 'DAZEL KIT', 'FLUCONZOLE/SECNIDAZOLE/AZITHROMYCIN', NULL, '1824FF', 0.00, 12500.00, 19000.00, '2026-04-14', NULL, '2025-10-12 22:58:16', '2025-10-12 23:00:30', 0, 'CHAR388VC', 'dos', NULL),
(3444, 'DREZ POWDER', 'IODINE/METRONIDAZOLE POWDER', NULL, 'NR02058ABB', 0.00, 7000.00, 9000.00, '2027-06-04', NULL, '2025-10-12 23:00:03', '2025-10-12 23:00:30', 0, 'VBVB', 'pce', NULL),
(3445, 'METRONIDAZOLE UNCOATED 200 MG TABLETS', 'METRONIDAZOLE UNCOATED 200 MG TABLETS', NULL, '5232', 80.00, 20.00, 100.00, '2027-05-05', NULL, '2025-10-16 19:18:25', '2025-11-08 22:12:15', 50, '5232', 'tab', NULL),
(3446, 'DYNAPAR INJECTION 75MG/ML', 'DICLOFENAC INJECTION 75 MG', NULL, '4g02IXM', 2.00, 1860.00, 2500.00, '2026-11-11', NULL, '2025-10-19 22:15:07', '2025-10-21 11:11:43', 2, 'CHAR-368GH', 'inj', NULL),
(3447, 'DICLODENK PESSARIES 100MG', 'DICLOFENAC 100 MG SUPPOSITORIES', NULL, '29199', 9.00, 2200.00, 3000.00, '2027-04-04', NULL, '2025-10-19 22:21:50', '2025-10-20 20:40:06', 4, 'CHAR-368nn', 'pce', NULL),
(3448, 'FERROUS SULPHATE / FOLIC ACID', 'FERROUS SULPHATE / FOLIC ACID', NULL, '85040', 5.00, 60.00, 100.00, '2026-11-11', NULL, '2025-10-19 22:39:10', '2025-11-08 22:12:15', 10, 'CHAR-368CC', 'tab', NULL),
(3449, 'AMPICLOX SYRUP 250MG/5ML', 'AMPICLOX SYRUP 250MG/5ML', NULL, '240862', 2.00, 3500.00, 5000.00, '2026-03-31', NULL, '2025-10-19 22:43:22', NULL, 1, 'CHAR-368GG', 'btl', NULL),
(3450, 'ECODAX CREAM 15G', 'MICONAZOLE/GENTAMYCIN/CLOBETASOL', NULL, '2502193', 0.00, 3500.00, 5000.00, '2026-05-05', NULL, '2025-10-19 22:45:23', NULL, 0, 'CHAR-368JU', 'pce', NULL),
(3451, 'SAYANA PRESS INJECTION', 'DEPOPROVERA DEPOT INJ', NULL, 'LC1243', 4.00, 1500.00, 5000.00, '2027-02-22', NULL, '2025-10-19 22:47:13', NULL, 2, 'CHAR-34GT', 'inj', NULL),
(3452, 'BRUTAFLAM 90 MG TABLET', 'ETORICOXIB 90 MG TABLET', NULL, '270930', 24.00, 110.00, 1500.00, '2027-09-09', NULL, '2025-10-19 22:49:39', '2025-11-01 21:39:38', 10, 'CHAR-368NM', 'tab', NULL),
(3453, 'CETAMOL SYRUP 100ML 125MG/5ML', 'PARACETAMOL SYRUP 100ML 125MG/5ML', NULL, '241087', 1.00, 3500.00, 5000.00, '2027-04-04', NULL, '2025-10-20 21:44:59', '2025-10-20 21:46:47', 1, 'CHAR-368 C', 'btl', NULL),
(3454, 'PREGNACARE ORIGINAL TABLETS ', 'MULTIVITAMINS FOR PREGNANCY ', NULL, '129637A', 28.00, 1035.00, 1500.00, '2027-02-02', NULL, '2025-10-23 22:20:10', '2025-10-23 22:21:09', 15, 'FEB27', 'tab', NULL),
(3455, 'CLEAR-T CREAM 30G', 'CLINDAMYCIN / TRTINOIN 0.25%', NULL, '796D1FD', 0.00, 11000.00, 15000.00, '2027-02-21', NULL, '2025-10-27 19:10:10', '2025-10-27 19:10:58', 0, 'CHAR-368DD', 'pce', NULL),
(3456, 'CANNULA', 'SANDRIES', NULL, '10241435CX', 2.00, 600.00, 1000.00, '2027-02-22', NULL, '2025-10-28 18:54:32', '2025-11-04 10:49:19', 5, 'CHAR388XZ', 'pce', NULL),
(3457, 'ZITHROX 500MG (PACKET)', 'AZITHROMYCIN 500 MG TABLETS', NULL, 'LKHJ', 4.00, 3600.00, 7000.00, '2026-05-05', NULL, '2025-10-28 19:00:05', '2025-10-28 19:03:34', 2, 'CHAR388VB', 'dos', NULL),
(3458, 'TRAP TABLETS', 'TRAMADOL/PARACETAMOL TABLETS', NULL, 'G401682', 32.00, 380.00, 500.00, '2026-06-06', NULL, '2025-10-28 21:51:34', '2025-10-30 22:40:52', 10, 'JHUGT', 'tab', NULL),
(3459, 'PROMETHAZINE 25MG TABLET', 'PROMETHAZINE 25MG TABLET', NULL, '2306187', 70.00, 50.00, 100.00, '2026-05-31', NULL, '2025-10-29 18:41:21', '2025-11-08 21:10:43', 20, 'PROM 1', 'tab', NULL),
(3460, 'LORATADINE 10 MG TABLETS INDIA', 'LORATADINE 10 MG TABLETS', NULL, 'G401824', 96.00, 300.00, 500.00, '2027-06-30', NULL, '2025-10-29 18:44:09', '2025-10-29 22:00:08', 10, 'LOR1', 'tab', NULL),
(3461, 'AMITRIPTYLIN 25 MG TABLETS', 'AMITRIPTYLIN 25 MG TABLETS', NULL, '240066', 70.00, 55.00, 100.00, '2027-04-04', NULL, '2025-10-31 19:22:55', '2025-10-31 22:59:33', 20, '240066', 'tab', NULL),
(3462, 'COLDCAP SYRUP', 'CHLORPHENIRAMINE, PARCETAMOL/PHENYLEPHRINE', NULL, 'G402942B', 0.00, 5200.00, 7000.00, '2026-02-02', NULL, '2025-11-04 21:22:25', '2025-11-04 21:22:51', 0, 'CHAR-34.,', 'syp', NULL),
(3463, 'ZYNCET TABS 10MG', 'CETRIZINE HYDROCHLORIDE TABLETS', NULL, 'BZN-24013', 70.00, 140.00, 200.00, '2027-06-30', NULL, '2025-11-04 21:25:53', NULL, 10, 'CHAR-34LOI', 'tab', NULL),
(3464, 'ASCORIL SYRUP 100 ML', 'SALBUTAMOL/GUAIFENESIN/BROMHEXINE', NULL, '10242318', 1.00, 6200.00, 9000.00, '2026-09-09', NULL, '2025-11-04 21:28:57', NULL, 0, 'CHAR-34,L', 'syp', NULL),
(3465, 'ASCORIL SYRUP 200 ML', 'SALBUTAMOL/GUAINFENESIN/BROMHEXINE', NULL, '10233167', 1.00, 12000.00, 15000.00, '2025-11-11', NULL, '2025-11-04 21:30:29', NULL, 0, 'CHAR-34./;', 'syp', NULL),
(3466, 'COFTA SYRUP', 'COFTA SYRUP', NULL, '2406179', 2.00, 4000.00, 6000.00, '2027-05-24', NULL, '2025-11-04 21:32:54', NULL, 0, 'CHAR-3422', 'syp', NULL),
(3467, 'COLDRIL SYRUP 100ML', 'PSEUDOEPHEDRINE/CHLORPHENIRAMINE/PARACETAMOL', NULL, '2505128', 1.00, 4200.00, 6000.00, '2028-04-04', NULL, '2025-11-04 21:38:15', NULL, 0, 'CHAR-34365', 'syp', NULL),
(3468, 'HISTALIN SYRUP', 'CHLORPHENIRAMINE/PROMETHAZINE/EPHEDRINE/DIPHENHYDRAMINE', NULL, '230371', 1.00, 4000.00, 6000.00, '2026-01-30', NULL, '2025-11-04 21:39:58', NULL, 0, 'CHAR-34258', 'syp', NULL),
(3469, 'QUININE SYRUP', 'QUININE SYRUP', NULL, 'L52006', 1.00, 3500.00, 5000.00, '2028-02-28', NULL, '2025-11-04 21:41:17', NULL, 0, 'CHAR-34369', 'syp', NULL),
(3470, 'EPTI SYRUP 120 ML', 'NATURAL APPETITE STIMULANT', NULL, '2459', 1.00, 12000.00, 16000.00, '2026-05-30', NULL, '2025-11-04 21:42:39', NULL, 0, 'CHAR-362[]', 'syp', NULL),
(3471, 'ARTEFAN SYRUP 60 ML', 'ARTEMETHER/LUMEFANTRINE', NULL, 'PA12824', 2.00, 8000.00, 12000.00, '2027-06-30', NULL, '2025-11-04 21:45:53', NULL, 0, 'CHAR-34BHYT', 'syp', NULL),
(3472, 'PACIFIC\'S JACK & JILL', 'DEXTROMETHORPHAN/CHLORPHENIRAMINE', NULL, 'BJ0504S', 2.00, 3500.00, 5000.00, '2026-04-30', NULL, '2025-11-04 21:51:09', NULL, 0, 'CHAR-34YTREW', 'syp', NULL),
(3473, 'NEUTRAFLAX SYRUP', 'MAGNESIUM/ALUMINIUM/ALGINIC ACID/SIMETHICONE', NULL, 'AAAAAA', 0.00, 11000.00, 15000.00, '2027-05-10', NULL, '2025-11-06 19:20:30', '2025-11-06 19:21:03', 0, 'CHAR394BBLK', 'syp', NULL),
(3474, 'LOBAK TABLETS', 'DICLOFENAC/PARACETAMOL/CHLORZOXAZONE ', NULL, 'GL015038', 6.00, 320.00, 500.00, '2028-04-30', NULL, '2025-11-06 19:50:11', '2025-11-06 20:39:29', 5, 'CHAR6111\';P', 'tab', NULL);

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
  `invoice_number` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_batches_pharm`
--

INSERT INTO `product_batches_pharm` (`id`, `product_id`, `name`, `description`, `batch_number`, `quantity`, `buying_price`, `selling_price`, `expiry_date`, `barcode`, `archived_at`, `unit_type`, `invoice_number`) VALUES
(0, 2925, '', NULL, 'NR002054C', 10, 1600.00, 5000.00, '2027-09-01', 'CHAR-23', '2025-07-27 19:31:00', 'dose', '0'),
(0, 2929, '', NULL, 'PF0207', 30, 1634.00, 2500.00, '2028-02-28', 'CHAR-27', '2025-07-27 19:41:20', 'tablet', '0'),
(0, 2949, '', NULL, '29143', 36, 1200.00, 2000.00, '2026-11-01', 'CHAR-48', '2025-07-27 19:55:13', 'tablet', '0'),
(0, 3147, '', NULL, 'BKP2406015', 4, 2500.00, 5000.00, '0005-05-26', 'CHAR-180', '2025-07-31 19:16:10', 'dose', '0'),
(0, 3032, '', NULL, 'BE24089', 2, 3400.00, 5000.00, '0005-05-27', 'CHAR-65', '2025-07-31 19:19:29', 'cream', '0'),
(0, 3031, '', NULL, 'BE24089', 2, 3400.00, 5000.00, '0005-05-27', 'CHAR-64', '2025-07-31 19:23:14', 'cream', '0'),
(0, 3163, '', NULL, 'SSB2024', 2, 900.00, 1500.00, '2027-01-01', 'CHAR-365', '2025-07-31 19:24:30', 'pce', '0'),
(0, 3005, '', NULL, 'C40126', 2, 3500.00, 5000.00, '0011-01-27', 'CHAR-38', '2025-07-31 19:26:18', 'bottle', '0'),
(0, 3094, '', NULL, '0653P005', 20, 120.00, 200.00, '0011-11-26', 'CHAR-127', '2025-08-01 20:17:23', 'tablet', '0'),
(0, 3253, '', NULL, '220829', 16, 1400.00, 2000.00, '2026-10-31', 'CHAR445', '2025-08-04 18:41:42', 'cap', '0'),
(0, 3202, '', NULL, '2197', 0, 3000.00, 4000.00, '2026-04-23', 'CHAR389', '2025-08-04 18:42:48', 'syp', '0'),
(0, 3170, '', NULL, 'LFZH0036', 3, 3850.00, 4000.00, '2028-02-02', 'CHAR-340', '2025-08-04 18:44:13', 'tab', '0'),
(0, 3258, '', NULL, 'LFYHOO41', 23, 450.00, 2000.00, '2027-11-30', 'CHAR450', '2025-08-04 18:48:56', 'tab', '0'),
(0, 3004, '', NULL, 'FC4003', 8, 550.00, 1000.00, '0004-01-27', 'CHAR-37', '2025-08-04 18:49:54', 'tablet', '0'),
(0, 3254, '', NULL, 'C50026P', 2, 1300.00, 2000.00, '2027-12-31', 'CHAR446', '2025-08-04 18:50:48', 'btl', '0'),
(0, 3002, '', NULL, '4ID0832', 4, 1400.00, 2000.00, '0027-03-30', 'CHAR-35', '2025-08-04 18:52:22', 'tablet', '0'),
(0, 3241, '', NULL, 'PC3424', 0, 7000.00, 10000.00, '2027-10-30', 'CHAR426', '2025-08-04 18:53:15', 'syp', '0'),
(0, 3161, '', NULL, 'AMX408', 30, 70.00, 100.00, '2027-03-03', 'CHAR-364', '2025-08-04 18:54:04', 'cap', '0'),
(0, 3094, '', NULL, 'LBD20240408', 120, 70.00, 100.00, '2027-06-01', '20250801191530723', '2025-08-04 18:55:43', 'cap', '0'),
(0, 3255, '', NULL, 'PA15014', 0, 5500.00, 8000.00, '2026-07-31', 'CHAR447', '2025-08-04 18:56:35', 'pkt', '0'),
(0, 3256, '', NULL, 'PA10124', 0, 5000.00, 7000.00, '2027-05-31', 'CHAR448', '2025-08-04 18:57:36', 'dos', '0'),
(0, 3257, '', NULL, 'ME23J60', 0, 300.00, 500.00, '2029-07-31', 'CHAR449', '2025-08-04 18:58:25', 'dos', '0'),
(0, 3213, '', NULL, '2311579', 12, 700.00, 1500.00, '2026-11-01', 'CHAR411', '2025-08-04 18:59:50', 'tab', '0'),
(0, 3261, '', NULL, '2406102', 23, 380.00, 500.00, '2026-05-31', 'CHAR05444', '2025-08-07 22:43:44', 'dos', '0'),
(0, 2999, '', NULL, 'Y04ZP', 22, 360.00, 500.00, '0011-11-25', 'CHAR-32', '2025-08-07 22:45:06', 'pair', '0'),
(0, 3252, '', NULL, '00225', 32, 300.00, 400.00, '2027-01-31', 'CHAR444', '2025-08-07 22:46:08', 'tab', '0'),
(0, 3032, '', NULL, '231213', 2, 2500.00, 4000.00, '2028-05-31', '20250731181656354', '2025-08-07 22:47:45', 'pce', '0'),
(0, 3272, '', NULL, 'T4939', 45, 110.00, 200.00, '2027-10-31', 'CHAR472', '2025-08-07 22:48:29', 'tab', '0'),
(0, 2990, '', NULL, 'NR002054C', 2, 1600.00, 5000.00, '0009-01-27', 'CHAR-23', '2025-08-07 22:49:33', 'dose', '0'),
(0, 2969, '', NULL, 'C25081', 70, 150.00, 200.00, '0002-01-27', 'CHAR-2', '2025-08-07 22:50:47', 'bottle', '0'),
(0, 3049, '', NULL, '14324', 2, 4000.00, 5000.00, '0002-02-26', 'CHAR-82', '2025-08-07 22:51:47', 'cream', '0'),
(0, 3274, '', NULL, '231007', 0, 1000.00, 1500.00, '2027-10-31', 'CHAR474', '2025-08-07 22:52:46', 'pce', '0'),
(0, 3269, '', NULL, '23115791', 0, 700.00, 1000.00, '2027-10-31', 'CHAR466', '2025-08-07 22:54:44', 'tab', '0'),
(0, 3281, '', NULL, '234060', 1, 12900.00, 19000.00, '2026-08-31', 'CHAR505', '2025-08-07 22:58:03', 'pce', '0'),
(0, 3209, '', NULL, 'JRPG2416E', -1, 2800.00, 3500.00, '2026-10-31', 'CHR394', '2025-08-11 18:18:38', 'tab', '0'),
(0, 3205, '', NULL, 'M415753', 0, 32.00, 50.00, '2027-10-31', 'CHAR392', '2025-08-11 18:19:42', 'tab', '0'),
(0, 3117, '', NULL, 'QLE403', 8, 500.00, 1000.00, '2027-10-27', 'CHAR-150', '2025-08-11 18:20:52', 'dos', '0'),
(0, 3150, '', NULL, 'BG10524A', 4, 2500.00, 5000.00, '2028-01-27', 'CHAR-183', '2025-08-11 18:22:15', 'dos', '0'),
(0, 3134, '', NULL, 'FW130K', 1, 3600.00, 5000.00, '0009-09-26', 'CHAR-167', '2025-08-11 18:23:26', 'bottle', '0'),
(0, 3314, '', NULL, '1012015', 0, 1100.00, 2000.00, '2028-02-13', 'CHAR590', '2025-08-13 19:12:55', 'pce', '0'),
(0, 3311, '', NULL, '25B11G1', 13, 600.00, 1000.00, '2027-02-10', 'CHAR586', '2025-08-13 19:14:26', 'cap', '0'),
(0, 3276, '', NULL, 'T24070', 3, 2000.00, 5000.00, '2026-02-28', 'CHAR477', '2025-08-13 19:15:26', 'pkt', '0'),
(0, 3247, '', NULL, 'G400595', 3, 1500.00, 2000.00, '2026-02-02', 'CHAR430', '2025-08-13 19:17:43', 'tab', '0'),
(0, 3291, '', NULL, '241685', 11, 750.00, 1000.00, '2026-06-30', 'CHAR-555', '2025-08-13 19:18:52', 'tab', '0'),
(0, 3241, '', NULL, 'PC3524', 0, 6300.00, 10000.00, '2027-08-31', '20250804175232540', '2025-08-13 19:20:01', 'syp', '0'),
(0, 3136, '', NULL, '5158122AI', 0, 6500.00, 8000.00, '0004-04-26', 'CHAR-169', '2025-08-13 19:21:54', 'bottle', '0'),
(0, 3312, '', NULL, 'ST241201', 0, 30.00, 100.00, '2027-11-30', 'CHAR587', '2025-08-13 19:23:05', 'tab', '0'),
(0, 3310, '', NULL, 'DY501', 0, 5500.00, 9000.00, '2028-01-31', 'CHAR583', '2025-08-13 19:25:13', 'btl', '0'),
(0, 3308, '', NULL, 'G402821', 0, 80.00, 300.00, '2027-09-30', 'CHAR582', '2025-08-13 19:34:04', 'tab', '0'),
(0, 2969, '', NULL, '04825P035', 90, 130.00, 200.00, '2028-03-31', '20250807214947764', '2025-08-20 20:10:03', 'cap', '0'),
(0, 3093, '', NULL, 'BABBV0061', 4, 550.00, 1000.00, '0003-03-27', 'CHAR-126', '2025-08-20 20:11:24', 'tablet', '0'),
(0, 3285, '', NULL, 'HHR2407037', 0, 2000.00, 5000.00, '2026-06-30', 'CHAR556', '2025-08-20 20:13:02', 'strp', '0'),
(0, 2990, '', NULL, 'NR02058A', 6, 1700.00, 5000.00, '2027-09-30', '20250807214845412', '2025-08-20 20:14:54', 'dos', '0'),
(0, 3331, '', NULL, '00000', 0, 0.00, 0.00, '2025-08-20', 'CHAR608', '2025-08-20 20:17:46', 'tab', '0'),
(0, 2977, '', NULL, 'Y018AL', 0, 14500.00, 23000.00, '0001-01-27', 'CHAR-10', '2025-08-20 20:23:19', 'gel', '0'),
(0, 3332, '', NULL, 'G72E5001', 0, 4800.00, 8000.00, '2027-12-31', 'CHAR608', '2025-08-20 20:26:26', 'syp', '0'),
(0, 3170, '', NULL, 'LFYH0037', -1, 2650.00, 4000.00, '2028-02-29', '20250804174301797', '2025-08-20 20:27:45', 'tab', '0'),
(0, 3333, '', NULL, 'A19971A', 0, 7500.00, 12000.00, '2028-10-31', 'CHAR609', '2025-08-20 20:30:54', 'dos', '0'),
(0, 3334, '', NULL, 'LBD20240408', 0, 786.00, 2000.00, '2026-05-31', 'CHAR610', '2025-08-20 20:33:39', 'tab', '0'),
(0, 3029, '', NULL, 'E2023', 30, 30.00, 100.00, '0009-09-26', 'CHAR-62', '2025-08-20 20:39:40', 'capsule', '0'),
(0, 3170, '', NULL, 'LFZH0036', 9, 2700.00, 4000.00, '2028-02-29', '20250820192633452', '2025-08-20 20:41:28', 'tab', '0'),
(0, 3335, '', NULL, 'HH005K', 0, 1100.00, 2000.00, '2026-07-31', 'CHAR611', '2025-08-20 20:43:58', 'tab', '0'),
(0, 3189, '', NULL, '250508', 40, 60.00, 100.00, '2029-01-01', 'CHAR-383', '2025-08-20 20:45:01', 'tab', '0'),
(0, 3102, '', NULL, '29128', 90, 70.00, 100.00, '0030-03-26', 'CHAR-135', '2025-08-20 20:45:48', 'capsule', '0'),
(0, 3014, '', NULL, '25007', 0, 2800.00, 5000.00, '0012-01-27', 'CHAR-47', '2025-08-20 20:46:31', 'syrup', '0'),
(0, 3226, '', NULL, 'C104', 0, 4200.00, 6500.00, '2026-07-31', 'CHAR414', '2025-08-20 20:47:15', 'pce', '0'),
(0, 3206, '', NULL, 'D24725002', 20, 70.00, 100.00, '2027-12-31', 'CHAR393', '2025-08-20 20:48:07', 'tab', '0'),
(0, 3336, '', NULL, 'LBD20240408', 0, 4400.00, 7000.00, '2027-07-31', 'CHAR612', '2025-08-20 20:50:17', 'btl', '0'),
(0, 3213, '', NULL, '2311579', 11, 335.00, 1500.00, '2026-11-04', '20250804175835633', '2025-08-20 20:51:14', 'tab', '0'),
(0, 3262, '', NULL, '550651', 24, 300.00, 500.00, '2028-03-31', 'CHAR455', '2025-08-20 20:52:14', 'tab', '0'),
(0, 3207, '', NULL, '24-XCFT-193', 15, 230.00, 300.00, '2027-03-31', 'CHAR394', '2025-08-20 20:53:43', 'tab', '0'),
(0, 3278, '', NULL, 'G401988', 10, 300.00, 400.00, '2027-07-31', 'CHAR500', '2025-08-20 20:54:44', 'tab', '0'),
(0, 3026, '', NULL, '29929', 15, 482.00, 700.00, '0027-09-30', 'CHAR-59', '2025-08-20 20:57:07', 'tablet', '0'),
(0, 3128, '', NULL, 'PA12603', 0, 6200.00, 8000.00, '0007-07-26', 'CHAR-161', '2025-08-20 20:58:00', 'tablet', '0'),
(0, 3155, '', NULL, '24XNLT-037', -1, 320.00, 500.00, '2026-10-10', '', '2025-08-20 20:59:00', 'tab', '0'),
(0, 3011, '', NULL, 'G402863', 10, 400.00, 600.00, '0001-04-27', 'CHAR-44', '2025-08-20 20:59:39', 'tablet', '0'),
(0, 3031, '', NULL, '232313', 2, 3500.00, 5000.00, '2027-05-31', '20250731182046343', '2025-08-20 21:00:11', 'pce', '0'),
(0, 3338, '', NULL, '1824', 0, 8800.00, 14000.00, '2030-02-28', 'CHAR613', '2025-08-20 21:05:47', 'btl', '0'),
(0, 3339, '', NULL, '1824', 0, 17500.00, 27000.00, '2025-06-30', 'CHAR614', '2025-08-20 21:06:18', 'btl', '0'),
(0, 3341, '', NULL, 'DY501', 0, 28500.00, 43000.00, '2025-08-20', 'CHAR615', '2025-08-20 21:06:42', 'btl', '0'),
(0, 3342, '', NULL, 'T476', 0, 19000.00, 28000.00, '2025-08-20', 'CHAR615', '2025-08-20 21:09:16', 'btl', '0'),
(0, 3266, '', NULL, '2DX24010', 25, 390.00, 500.00, '2026-06-05', 'CHAR459', '2025-08-20 21:10:04', 'tab', '0'),
(0, 3264, '', NULL, '2408153', 85, 60.00, 100.00, '2027-01-31', 'CHAR457', '2025-08-20 21:10:48', 'tab', '0'),
(0, 3353, '', NULL, '250242', 0, 2200.00, 3500.00, '2030-01-31', 'CHAR631', '2025-08-22 20:07:24', 'tab', '0'),
(0, 3256, '', NULL, 'PA10124', 0, 4400.00, 7000.00, '2027-05-31', '20250804175644923', '2025-08-22 20:08:20', 'dos', '0'),
(0, 3128, '', NULL, 'PA09874', 4, 5500.00, 8000.00, '2027-05-31', '20250820195721590', '2025-08-22 20:09:53', 'tab', '0'),
(0, 3273, '', NULL, '0C01', 20, 120.00, 200.00, '2027-05-31', 'CHAR473', '2025-08-22 20:11:40', 'cap', '0'),
(0, 3355, '', NULL, '241165', 0, 3200.00, 5000.00, '2027-05-31', 'CHAR633', '2025-08-22 20:13:19', 'syp', '0'),
(0, 3033, '', NULL, '18000', 0, 18000.00, 25000.00, '0006-06-26', 'CHAR-66', '2025-08-22 20:15:15', 'syrup', '0'),
(0, 3014, '', NULL, '250772', 1, 2800.00, 5000.00, '2028-03-31', '20250820194603843', '2025-08-22 20:16:37', 'btl', '0'),
(0, 3359, '', NULL, '240632', 0, 3000.00, 7000.00, '2027-05-31', 'CHAR637', '2025-08-22 20:18:09', 'dos', '0'),
(0, 3020, '', NULL, '242157', 0, 5000.00, 8000.00, '0005-01-28', 'CHAR-53', '2025-08-22 20:19:30', 'dose', '0'),
(0, 3330, '', NULL, 'LBD20240408', 0, 13000.00, 17000.00, '2027-09-30', 'CHAR607', '2025-08-22 20:20:55', 'dos', '0'),
(0, 3167, '', NULL, '2AU24025', 95, 130.00, 200.00, '2028-05-05', 'CHAR-367', '2025-08-22 20:25:01', 'tab', '0'),
(0, 3179, '', NULL, 'JFUB00232', 1, 5000.00, 7000.00, '2026-11-11', 'CHAR-371', '2025-08-22 20:26:06', 'btl', '0'),
(0, 2968, '', NULL, '31425', 170, 20.00, 50.00, '0005-01-28', 'CHAR-1', '2025-08-22 20:26:59', 'capsule', '0'),
(0, 3354, '', NULL, '8892', 10, 850.00, 1500.00, '2027-05-31', 'CHAR632', '2025-08-22 20:27:59', 'tab', '0'),
(0, 3358, '', NULL, '6240800', 0, 3300.00, 5000.00, '2027-08-31', 'CHAR636', '2025-08-22 20:28:56', 'tab', '0'),
(0, 3352, '', NULL, 'L-1098008', 0, 14500.00, 22000.00, '2027-09-30', 'CHAR630', '2025-08-22 20:30:17', 'btl', '0'),
(0, 3003, '', NULL, 'T3ACG008', 2, 2200.00, 5000.00, '0001-01-28', 'CHAR-36', '2025-08-22 20:31:18', 'dose', '0'),
(0, 3356, '', NULL, 'DS241103', 0, 7000.00, 10000.00, '2026-11-30', 'CHAR634', '2025-08-22 20:33:15', 'dos', '0'),
(0, 3361, '', NULL, 'SQ240708', 0, 7000.00, 12000.00, '2026-07-31', 'CHAR639', '2025-08-22 20:34:11', 'dos', '0'),
(0, 3357, '', NULL, '250223', 0, 5300.00, 8000.00, '2027-01-31', 'CHAR635', '2025-08-22 20:35:05', 'tab', '0'),
(0, 3360, '', NULL, '240632', 0, 800.00, 1300.00, '2027-09-30', 'CHAR638', '2025-08-22 20:36:08', 'scht', '0'),
(0, 3172, '', NULL, 'G402942', 19, 350.00, 500.00, '2027-06-06', 'CHAR-342', '2025-08-22 20:42:58', 'cap', '0'),
(0, 3076, '', NULL, 'D11325', 0, 2000.00, 3000.00, '0008-08-27', 'CHAR-109', '2025-08-22 20:44:11', 'cream', '0'),
(0, 3098, '', NULL, 'EAC-VO7', 30, 120.00, 200.00, '0028-08-26', 'CHAR-131', '2025-08-22 20:45:19', 'tablet', '0'),
(0, 3364, '', NULL, 'FFFFFF', 0, 7200.00, 12000.00, '2027-09-24', 'CHAR621', '2025-08-28 18:33:43', 'dos', '0'),
(0, 3365, '', NULL, '240249', 1, 800.00, 1000.00, '2027-01-01', 'CHAR632', '2025-08-28 18:34:58', 'cap', '0'),
(0, 3074, '', NULL, 'AB4045', 1, 18000.00, 25000.00, '0009-09-26', 'CHAR-107', '2025-08-28 18:38:11', 'cream', '0'),
(0, 3370, '', NULL, '147F', 0, 800.00, 1500.00, '2026-10-31', 'CHAR4116', '2025-08-28 18:40:04', 'inj', '0'),
(0, 3374, '', NULL, '25010037', 0, 18000.00, 28000.00, '2026-01-01', 'CHAR4114', '2025-08-28 18:55:05', 'syp', '0'),
(0, 3009, '', NULL, 'BABBV0173', 13, 550.00, 1000.00, '0003-03-27', 'CHAR-42', '2025-08-28 18:56:04', 'tablet', '0'),
(0, 2989, '', NULL, '244437', 0, 8000.00, 12000.00, '0001-01-28', 'CHAR-22', '2025-08-28 18:56:47', 'cream', '0'),
(0, 3371, '', NULL, 'D2401845', 0, 3550.00, 5500.00, '2023-01-20', 'CHAR4111', '2025-08-28 18:58:46', 'cap', '0'),
(0, 3161, '', NULL, '767241106', 70, 43.00, 100.00, '2027-11-30', '20250804175325630', '2025-08-28 19:00:21', 'cap', '0'),
(0, 3256, '', NULL, 'PA111842', 0, 4300.00, 7000.00, '2027-05-31', '20250822190734504', '2025-08-28 19:01:18', 'dos', '0'),
(0, 3373, '', NULL, '4276', 0, 850.00, 1500.00, '2026-01-01', 'CHAR4113', '2025-08-28 19:02:32', 'inj', '0'),
(0, 3216, '', NULL, 'Y061ZF', 10, 380.00, 500.00, '2026-05-31', 'CHAR403', '2025-08-28 19:03:32', 'dos', '0'),
(0, 3254, '', NULL, 'C50026P', 1, 1260.00, 2000.00, '2027-12-31', '20250804175003989', '2025-08-28 19:04:31', 'btl', '0'),
(0, 3372, '', NULL, '4249', 0, 633.00, 1000.00, '2026-01-01', 'CHAR4112', '2025-08-28 19:05:09', 'cap', '0'),
(0, 3366, '', NULL, '796D1', 0, 4500.00, 6000.00, '2025-11-30', 'CHAR-651', '2025-08-28 19:06:25', 'syp', '0'),
(0, 3368, '', NULL, '9544', 1, 2000.00, 3000.00, '2027-05-31', 'CHAR642', '2025-08-28 19:07:25', 'syp', '0'),
(0, 3329, '', NULL, '2407564', -5, 300.00, 400.00, '2027-09-30', 'CHAR606', '2025-08-28 19:11:12', 'cap', '0'),
(0, 3133, '', NULL, 'ABA5008', 0, 2300.00, 3500.00, '0001-01-26', 'CHAR-166', '2025-08-28 19:14:10', 'bottle', '0'),
(0, 3376, '', NULL, '1824E', 0, 483.00, 1000.00, '2027-01-01', 'CHAR4116', '2025-08-28 19:16:53', 'tab', '0'),
(0, 3381, '', NULL, '145', 0, 13000.00, 20000.00, '2028-04-01', 'CHER', '2025-09-02 22:08:41', 'syp', '0'),
(0, 3226, '', NULL, 'C107', 0, 4000.00, 6500.00, '2026-10-31', '20250820194640460', '2025-09-02 22:09:35', 'pce', '0'),
(0, 3389, '', NULL, 'GFGFG', 0, 7000.00, 15000.00, '2026-10-28', 'CHR07', '2025-09-02 22:14:51', 'syp', '0'),
(0, 3329, '', NULL, '2410164', 55, 233.00, 400.00, '2027-11-30', '20250828181010571', '2025-09-02 22:15:58', 'cap', '0'),
(0, 3390, '', NULL, 'NBNV', 0, 234.00, 500.00, '2026-04-05', 'CHR08', '2025-09-02 22:18:56', 'tab', '0'),
(0, 3251, '', NULL, 'G500233', 205, 40.00, 100.00, '2026-12-31', 'CHAR443', '2025-09-02 22:20:15', 'cap', '0'),
(0, 3031, '', NULL, 'BE24170', 2, 3400.00, 5000.00, '2027-11-30', '20250820195947737', '2025-09-02 22:20:53', 'pce', '0'),
(0, 3391, '', NULL, '1824DF', 0, 600.00, 1000.00, '2027-06-05', 'CHR08', '2025-09-02 22:24:16', 'cap', '0'),
(0, 3136, '', NULL, '515B12A1', 1, 5500.00, 9000.00, '2026-04-30', '20250813182018479', '2025-09-02 22:25:32', 'btl', '0'),
(0, 3382, '', NULL, 'TIAHG001G', 0, 55000.00, 80000.00, '2027-11-30', 'CHR01', '2025-09-02 22:26:12', 'dos', '0'),
(0, 3383, '', NULL, '1824H', 0, 57500.00, 100000.00, '2027-10-10', 'CHR02', '2025-09-02 22:26:52', 'dos', '0'),
(0, 3388, '', NULL, 'LBD20240408GR', 0, 800.00, 1200.00, '2025-09-30', 'CHR06', '2025-09-02 22:27:57', 'tab', '0'),
(0, 3011, '', NULL, 'G500308', 10, 400.00, 600.00, '2027-12-31', '20250820195907363', '2025-09-02 22:28:41', 'tab', '0'),
(0, 2969, '', NULL, '04825P035', 170, 130.00, 200.00, '2028-03-31', '20250820190925192', '2025-09-02 22:29:27', 'cap', '0'),
(0, 3366, '', NULL, '01525', 2, 3700.00, 6000.00, '2027-05-31', '20250828180521941', '2025-09-02 22:30:13', 'syp', '0'),
(0, 3128, '', NULL, 'PAO987', 6, 5500.00, 8000.00, '2027-05-31', '20250822190848917', '2025-09-02 22:32:03', 'tab', '0'),
(0, 3285, '', NULL, 'HHR2312060', 5, 1000.00, 5000.00, '2025-11-30', '20250820191135234', '2025-09-02 22:33:14', 'strp', '0'),
(0, 3387, '', NULL, 'LBD20240408G', 0, 750.00, 1500.00, '2025-09-30', 'CHR05', '2025-09-02 22:34:06', 'pce', '0'),
(0, 3007, '', NULL, '3', 1, 1200.00, 2500.00, '0028-11-30', 'CHAR-40', '2025-09-02 22:35:20', 'pack', '0'),
(0, 3384, '', NULL, '1824B', 0, 1800.00, 3000.00, '2025-09-30', 'CHR03', '2025-09-02 22:36:35', 'pce', '0'),
(0, 3144, '', NULL, 'A52023119', 1, 8000.00, 10000.00, '0011-11-28', 'CHAR-177', '2025-09-02 22:37:39', 'roll', '0'),
(0, 3385, '', NULL, '1824BF', 0, 3500.00, 5000.00, '2025-09-30', 'CHR04', '2025-09-02 22:39:06', 'pce', '0'),
(0, 3392, '', NULL, 'G402806', 0, 56.00, 100.00, '2025-09-30', 'CHR10', '2025-09-02 22:41:54', 'tab', '0'),
(0, 3393, '', NULL, '1824BGG', 0, 6500.00, 10000.00, '2029-07-06', 'CHR11', '2025-09-02 22:45:12', 'pce', '0'),
(0, 3057, '', NULL, '220725', 7, 500.00, 1000.00, '0007-07-25', 'CHAR-90', '2025-09-02 22:47:04', 'piece', '0'),
(0, 2990, '', NULL, 'NR02058A', 0, 1700.00, 5000.00, '2027-09-30', '20250820191316981', '2025-09-05 19:29:14', 'dos', '0'),
(0, 3150, '', NULL, 'bg10424a', 0, 2000.00, 5000.00, '2027-08-31', '20250811172106799', '2025-09-05 19:30:21', 'dos', '0'),
(0, 3397, '', NULL, 'IP24317', 0, 5000.00, 10000.00, '2026-11-11', 'CHR2392', '2025-09-05 19:45:08', 'inj', '0'),
(0, 3396, '', NULL, 'AR1042507', 0, 1800.00, 5000.00, '2028-03-03', 'CHR1392', '2025-09-05 19:45:48', 'inj', '0'),
(0, 3127, '', NULL, 'PAI8543', 2, 4000.00, 5000.00, '0002-02-27', 'CHAR-160', '2025-09-05 19:49:40', 'tab', '0'),
(0, 3128, '', NULL, 'PA09874', 9, 5375.00, 8000.00, '2027-05-31', '20250902213024823', '2025-09-05 19:53:26', 'tab', '0'),
(0, 3124, '', NULL, 'G500052', 7, 1000.00, 2000.00, '0012-12-26', 'CHAR-157', '2025-09-05 19:57:20', 'tablet', '0'),
(0, 3398, '', NULL, 'NR02058AG', 0, 35000.00, 50000.00, '2027-11-11', 'CHR13955', '2025-09-05 20:03:16', 'btl', '0'),
(0, 3000, '', NULL, '24I13E1', 15, 575.00, 1000.00, '2026-09-12', 'CHAR-33', '2025-09-05 20:05:52', 'cap', '0'),
(0, 3151, '', NULL, 'AZIH0027', 4, 1500.00, 2000.00, '0010-10-27', 'CHAR-184', '2025-09-05 20:08:40', 'tablet', '0'),
(0, 2997, '', NULL, 'D26024005', 3, 2200.00, 4000.00, '0028-10-30', 'CHAR-30', '2025-09-05 20:09:54', 'cream', '0'),
(0, 3031, '', NULL, 'BE25022', 3, 3500.00, 5000.00, '2028-01-31', '20250902212024915', '2025-09-05 20:11:07', 'pce', '0'),
(0, 3129, '', NULL, '149', 0, 2500.00, 4000.00, '0005-05-27', 'CHAR-162', '2025-09-05 20:13:40', 'syrup', '0'),
(0, 3328, '', NULL, '24097', 0, 5200.00, 8000.00, '2026-08-19', 'CHAR605', '2025-09-05 20:16:10', 'syp', '0'),
(0, 3399, '', NULL, 'GGG', 0, 40.00, 100.00, '2028-01-31', 'VBCB', '2025-09-05 20:22:51', 'tab', '0'),
(0, 3400, '', NULL, '2503133', 0, 800.00, 3000.00, '2028-02-02', 'VBCB1', '2025-09-05 20:23:48', 'syp', '0'),
(0, 3205, '', NULL, 'm413301', 340, 20.00, 50.00, '2027-07-30', '20250811171849576', '2025-09-05 20:24:27', 'tab', '0'),
(0, 3264, '', NULL, '2502140', 150, 12.00, 100.00, '2028-01-31', '20250820201011370', '2025-09-05 20:25:18', 'tab', '0'),
(0, 2969, '', NULL, '251101', 240, 140.00, 200.00, '2028-05-31', '20250902212857304', '2025-09-05 20:28:13', 'cap', '0'),
(0, 3256, '', NULL, 'PA11184', 0, 4400.00, 7000.00, '2027-05-31', '20250828180035436', '2025-09-05 20:29:12', 'dos', '0'),
(0, 3401, '', NULL, 'FDSF', 0, 950.00, 1500.00, '2027-10-09', 'GSGFS', '2025-09-05 20:32:00', 'cap', '0'),
(0, 3402, '', NULL, '007DK', 0, 5000.00, 7500.00, '2027-01-02', 'CHR39233', '2025-09-05 20:39:55', 'btl', '0'),
(0, 2999, '', NULL, 'Y114ZN', 71, 360.00, 500.00, '2025-10-01', '20250807214352947', '2025-09-05 20:40:50', 'dos', '0'),
(0, 3084, '', NULL, 'KE23023', 0, 3000.00, 4000.00, '0020-08-26', 'CHAR-117', '2025-09-05 20:43:56', 'cream', '0'),
(0, 2988, '', NULL, 'JCF00222', 0, 5000.00, 7500.00, '0004-01-27', 'CHAR-21', '2025-09-05 20:52:48', 'syrup', '0'),
(0, 2971, '', NULL, 'ABD9173', 15, 542.00, 1000.00, '0027-01-14', 'CHAR-4', '2025-09-05 20:53:51', 'pce', '0'),
(0, 3403, '', NULL, '10241435F', 0, 2000.00, 4000.00, '2025-03-31', 'GHJF', '2025-09-05 20:54:29', 'pce', '0'),
(0, 3363, '', NULL, 'EEEEEE', 0, 8800.00, 11000.00, '2027-09-30', 'CHAR650', '2025-09-05 20:55:56', 'pce', '0'),
(0, 3066, '', NULL, '219', 1, 2000.00, 3000.00, '0002-02-27', 'CHAR-99', '2025-09-05 20:56:54', 'cream', '0'),
(0, 3068, '', NULL, 'C4824018', 0, 1500.00, 2500.00, '0012-12-27', 'CHAR-101', '2025-09-05 20:58:43', 'tin', '0'),
(0, 3209, '', NULL, 'jrpg2445e', 2, 2360.00, 3500.00, '2026-02-01', '20250811171514421', '2025-09-05 20:59:46', 'tab', '0'),
(0, 2996, '', NULL, 'J82X002', 0, 350.00, 1000.00, '0027-10-30', 'CHAR-29', '2025-09-05 21:03:31', 'tablet', '0'),
(0, 3041, '', NULL, 'EF033', 0, 6000.00, 8000.00, '0011-11-26', 'CHAR-74', '2025-09-05 21:04:21', 'cream', '0'),
(0, 3315, '', NULL, '23K28B1', 11, 800.00, 1000.00, '2025-11-27', 'CHAR591', '2025-09-05 21:06:09', 'cap', '0'),
(0, 2999, '', NULL, 'KE24030', 121, 340.00, 500.00, '2025-10-31', '20250905194001863', '2025-09-05 21:07:10', 'dos', '0'),
(0, 3002, '', NULL, '41D1036', 5, 1375.00, 2000.00, '2027-04-04', '20250804175100706', '2025-09-05 21:08:17', 'tab', '0'),
(0, 2990, '', NULL, 'NR02058A', 10, 1600.00, 5000.00, '2027-09-30', '20250905182823974', '2025-09-05 21:09:33', 'dos', '0'),
(0, 3180, '', NULL, '25116', 150, 45.00, 100.00, '2027-02-02', 'CHAR-372', '2025-09-05 21:10:55', 'tab', '0'),
(0, 3188, '', NULL, '01825', 70, 30.00, 50.00, '2027-03-03', 'CHAR-382', '2025-09-05 21:12:23', 'tab', '0'),
(0, 3307, '', NULL, 'K02240421', 1, 1800.00, 3000.00, '2026-10-31', 'CHAR581', '2025-09-05 21:13:38', 'strp', '0'),
(0, 2988, '', NULL, 'JCFEB00221', 2, 4600.00, 7500.00, '2027-04-04', '20250905195118462', '2025-09-05 21:15:08', 'strp', '0'),
(0, 3405, '', NULL, 'FDFXCD', 0, 11000.00, 17000.00, '2028-12-12', 'CHR392E', '2025-09-05 21:32:15', 'pce', '0'),
(0, 3404, '', NULL, 'FDFXC', 0, 8500.00, 13000.00, '2029-12-12', 'CHR392F', '2025-09-05 21:32:48', 'pce', '0'),
(0, 3057, '', NULL, '20240709', 55, 130.00, 1000.00, '2030-09-30', '20250902214546879', '2025-09-05 21:34:10', 'pce', '0'),
(0, 3161, '', NULL, 'AMX428', 200, 55.00, 100.00, '2027-08-31', '20250828175906677', '2025-09-05 21:35:40', 'cap', '0'),
(0, 3406, '', NULL, 'FDFXCDD', 0, 560.00, 1500.00, '2028-12-12', 'CHR392EF', '2025-09-05 21:36:54', 'pce', '0'),
(0, 3407, '', NULL, 'GHFF', 0, 2700.00, 5000.00, '2028-12-12', 'CHRB', '2025-09-05 21:37:38', 'btl', '0'),
(0, 3408, '', NULL, '5A050E', 0, 15000.00, 22000.00, '2026-12-12', 'CHRBU', '2025-09-05 21:38:16', 'btl', '0'),
(0, 3409, '', NULL, '5A050EFH', 0, 600.00, 1000.00, '2026-11-12', 'CHRBUY', '2025-09-05 21:39:11', 'tab', '0'),
(0, 3412, '', NULL, 'R594003A', 0, 5500.00, 9000.00, '2027-05-05', 'CHR392NB', '2025-09-05 22:05:43', 'syp', '0'),
(0, 3416, '', NULL, 'VF', 0, 7300.00, 11000.00, '2025-09-30', 'FGS', '2025-09-05 22:09:19', 'syp', '0'),
(0, 3417, '', NULL, 'VFFA', 0, 17000.00, 25000.00, '2026-10-30', 'FGSG', '2025-09-05 22:10:04', 'syp', '0'),
(0, 3218, '', NULL, 'T4329', 140, 30.00, 50.00, '2026-03-01', 'CHAR405', '2025-09-05 22:10:57', 'tab', '0'),
(0, 3413, '', NULL, 'GGDFG', 0, 4000.00, 8000.00, '2027-05-05', 'CHR392NBB', '2025-09-05 22:11:43', 'pce', '0'),
(0, 3414, '', NULL, 'GGDFG65', 0, 3000.00, 6000.00, '2026-05-05', 'CHR392NBB9', '2025-09-05 22:12:32', 'pce', '0'),
(0, 3001, '', NULL, 'PM03884', 6, 225.00, 500.00, '2027-11-27', 'CHAR-34', '2025-09-05 22:13:25', 'tab', '0'),
(0, 3415, '', NULL, 'GGDFG654', 0, 14000.00, 20000.00, '2027-06-05', 'CHR92', '2025-09-05 22:14:10', 'pce', '0');

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
  `transaction_id` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales_pharm`
--

INSERT INTO `sales_pharm` (`id`, `invoice_number`, `user_id`, `customer_name`, `total_amount`, `discount`, `tax`, `net_amount`, `payment_method`, `transaction_id`, `date`, `notes`) VALUES
(1, 'INV-20250711-0C3105', 6, 'Walk-in Custo', 600.00, 0.00, 0.00, 600.00, 'cash', NULL, '2025-07-11 23:50:08', NULL),
(2, 'INV-20250711-0134E3', 6, 'Walk-in Custo', 600.00, 0.00, 0.00, 600.00, 'cash', NULL, '2025-07-11 23:56:48', NULL),
(3, 'INV-20250711-C85D2A', 6, 'Walk-in Customer', 2000.00, 0.00, 0.00, 2000.00, 'cash', NULL, '2025-07-11 23:57:48', NULL),
(4, 'INV-20250712-300CBD', 6, 'Walk-in Customer', 5000.00, 0.00, 0.00, 5000.00, 'cash', NULL, '2025-07-12 00:08:03', NULL),
(5, 'INV-20250714-0C2B03', 6, 'Walk-in Customer', 2400.00, 0.00, 0.00, 2400.00, 'cash', NULL, '2025-07-14 10:14:24', NULL),
(6, 'INV-20250714-2C261C', 6, 'Walk-in Customer', 112000.00, 0.00, 0.00, 112000.00, 'cash', NULL, '2025-07-14 11:11:30', NULL),
(7, 'INV1752689577', 6, 'Walk-in Customer', 5.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-16 20:12:57', NULL),
(8, 'INV1752725370', 6, 'Walk-in Customer', 56000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-17 06:09:30', NULL),
(9, 'INV1752725506', 6, 'Walk-in Customer', 1400.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-17 06:11:46', NULL),
(10, 'INV1752726263', 6, 'Walk-in Customer', 5600.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-17 06:24:23', NULL),
(11, 'INV1752729952', 6, 'Walk-in Customer', 13500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-17 07:25:52', NULL),
(12, 'INV1752765322', 6, 'kakembo', 645.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-17 17:15:22', NULL),
(13, 'INV1752766114', 6, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-17 17:28:34', NULL),
(14, 'INV1752863000', 6, 'Walk-in Customer', 2510.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-18 20:23:20', NULL),
(15, 'INV1753286153', 14, 'Walk-in Customer', 67000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-23 17:55:53', NULL),
(16, 'INV1753634227', 13, 'Walk-in Customer', 37000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-27 18:37:07', NULL),
(17, 'INV1753634278', 13, 'Walk-in Customer', 37000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-27 18:37:58', NULL),
(18, 'INV1753634286', 13, 'Walk-in Customer', 37000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-27 18:38:06', NULL),
(19, 'INV1753634425', 13, 'Walk-in Customer', 37000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-27 18:40:25', NULL),
(20, 'INV1753635393', 13, 'Walk-in Customer', 9000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-27 18:56:33', NULL),
(21, 'INV1753859129', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-30 09:05:29', NULL),
(22, 'INV1753870095', 14, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-30 12:08:15', NULL),
(23, 'INV1753891998', 14, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-30 18:13:18', NULL),
(24, 'INV1753900192', 13, 'Walk-in Customer', 17000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-30 20:29:52', NULL),
(25, 'INV1753900201', 13, 'Walk-in Customer', 17000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-30 20:30:01', NULL),
(26, 'INV1753900580', 13, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-30 20:36:20', NULL),
(27, 'INV1753900671', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-30 20:37:51', NULL),
(28, 'INV1753900725', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-30 20:38:45', NULL),
(29, 'INV1753903775', 14, 'Walk-in Customer', 90700.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-30 21:29:35', NULL),
(30, 'INV1753904287', 13, 'Walk-in Customer', 147000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-30 21:38:07', NULL),
(31, 'INV1753957058', 14, 'Walk-in Customer', 26000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-31 12:17:38', NULL),
(32, 'INV1753972079', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-31 16:27:59', NULL),
(33, 'INV1753976238', 14, 'Walk-in Customer', 33000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-31 17:37:18', NULL),
(34, 'INV1753981779', 13, 'Walk-in Customer', 19500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-31 19:09:39', NULL),
(35, 'INV1753983255', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-07-31 19:34:15', NULL),
(36, 'INV1754037114', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-01 10:31:54', NULL),
(37, 'INV1754040847', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-01 11:34:07', NULL),
(38, 'INV1754059707', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-01 16:48:27', NULL),
(39, 'INV1754064400', 14, 'Walk-in Customer', 7200.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-01 18:06:40', NULL),
(40, 'INV1754065005', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-01 18:16:45', NULL),
(41, 'INV1754065709', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-01 18:28:29', NULL),
(42, 'INV1754070467', 14, 'Walk-in Customer', 27700.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-01 19:47:47', NULL),
(43, 'INV1754073033', 13, 'Walk-in Customer', 12000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-01 20:30:33', NULL),
(44, 'INV1754074953', 13, 'Walk-in Customer', 24500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-01 21:02:33', NULL),
(45, 'INV1754077331', 13, 'Walk-in Customer', 16500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-01 21:42:11', NULL),
(46, 'INV1754078021', 13, 'Walk-in Customer', 12000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-01 21:53:41', NULL),
(47, 'INV1754078351', 13, 'Walk-in Customer', 15000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-01 21:59:11', NULL),
(48, 'INV1754136930', 14, 'Walk-in Customer', 17500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-02 14:15:30', NULL),
(49, 'INV1754146861', 14, 'Walk-in Customer', 13000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-02 17:01:01', NULL),
(50, 'INV1754149026', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-02 17:37:06', NULL),
(51, 'INV1754153427', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-02 18:50:27', NULL),
(52, 'INV1754158034', 14, 'Walk-in Customer', 7500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-02 20:07:14', NULL),
(53, 'INV1754160524', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-02 20:48:44', NULL),
(54, 'INV1754161136', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-02 20:58:56', NULL),
(55, 'INV1754161327', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-02 21:02:07', NULL),
(56, 'INV1754230457', 13, 'charles', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-03 16:14:17', NULL),
(57, 'INV1754235254', 13, 'Walk-in Customer', 15000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-03 17:34:14', NULL),
(58, 'INV1754235282', 13, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-03 17:34:42', NULL),
(59, 'INV1754237294', 13, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-03 18:08:14', NULL),
(60, 'INV1754239973', 13, 'JAJJA', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-03 18:52:53', NULL),
(61, 'INV1754251230', 13, 'charles', 25000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-03 22:00:30', NULL),
(62, 'INV1754251277', 13, 'charles', 12000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-03 22:01:17', NULL),
(63, 'INV1754251386', 13, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-03 22:03:06', NULL),
(64, 'INV1754251739', 13, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-03 22:08:59', NULL),
(65, 'INV1754252277', 13, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-03 22:17:57', NULL),
(66, 'INV1754315040', 14, 'Walk-in Customer', 32500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-04 15:44:00', NULL),
(67, 'INV1754316397', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-04 16:06:37', NULL),
(68, 'INV1754320452', 14, 'Walk-in Customer', 11000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-04 17:14:12', NULL),
(69, 'INV1754320505', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-04 17:15:05', NULL),
(70, 'INV1754326655', 13, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-04 18:57:35', NULL),
(71, 'INV1754331802', 13, 'Walk-in Customer', 11000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-04 20:23:22', NULL),
(72, 'INV1754332217', 13, 'Walk-in Customer', 16000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-04 20:30:17', NULL),
(73, 'INV1754332623', 13, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-04 20:37:03', NULL),
(74, 'INV1754334296', 13, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-04 21:04:56', NULL),
(75, 'INV1754335585', 13, 'Walk-in Customer', 12000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-04 21:26:25', NULL),
(76, 'INV1754335866', 13, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-04 21:31:06', NULL),
(77, 'INV1754393390', 14, 'Walk-in Customer', 12800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-05 13:29:50', NULL),
(78, 'INV1754404853', 14, 'Walk-in Customer', 7300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-05 16:40:53', NULL),
(79, 'INV1754405644', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-05 16:54:04', NULL),
(80, 'INV1754408027', 14, 'Walk-in Customer', 18000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-05 17:33:47', NULL),
(81, 'INV1754408078', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-05 17:34:38', NULL),
(82, 'INV1754408118', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-05 17:35:18', NULL),
(83, 'INV1754410570', 13, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-05 18:16:10', NULL),
(84, 'INV1754418058', 13, 'Walk-in Customer', 4500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-05 20:20:58', NULL),
(85, 'INV1754418832', 13, 'Walk-in Customer', 19000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-05 20:33:52', NULL),
(86, 'INV1754424184', 13, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-05 22:03:04', NULL),
(87, 'INV1754424291', 13, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-05 22:04:51', NULL),
(88, 'INV1754424389', 13, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-05 22:06:29', NULL),
(89, 'INV1754476969', 14, 'Walk-in Customer', 18700.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-06 12:42:49', NULL),
(90, 'INV1754477285', 14, 'Walk-in Customer', 4500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-06 12:48:05', NULL),
(91, 'INV1754477794', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-06 12:56:34', NULL),
(92, 'INV1754482806', 14, 'Walk-in Customer', 4300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-06 14:20:06', NULL),
(93, 'INV1754491699', 14, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-06 16:48:19', NULL),
(94, 'INV1754494618', 14, 'Walk-in Customer', 10500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-06 17:36:58', NULL),
(95, 'INV1754503228', 14, 'Walk-in Customer', 39000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-06 20:00:28', NULL),
(96, 'INV1754504175', 13, 'Walk-in Customer', 11000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-06 20:16:15', NULL),
(97, 'INV1754507103', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-06 21:05:03', NULL),
(98, 'INV1754580939', 14, 'Walk-in Customer', 30300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-07 17:35:39', NULL),
(99, 'INV1754582034', 13, 'Walk-in Customer', 14500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-07 17:53:54', NULL),
(100, 'INV1754584160', 13, 'Walk-in Customer', 4500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-07 18:29:20', NULL),
(101, 'INV1754590484', 13, 'Walk-in Customer', 10500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-07 20:14:44', NULL),
(102, 'INV1754590840', 13, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-07 20:20:40', NULL),
(103, 'INV1754593658', 13, 'Walk-in Customer', 15000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-07 21:07:38', NULL),
(104, 'INV1754593755', 13, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-07 21:09:15', NULL),
(105, 'INV1754596779', 13, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-07 21:59:39', NULL),
(106, 'INV1754597120', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-07 22:05:20', NULL),
(107, 'INV1754597217', 13, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-07 22:06:57', NULL),
(108, 'INV1754632495', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-08 07:54:55', NULL),
(109, 'INV1754633230', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-08 08:07:10', NULL),
(110, 'INV1754642312', 14, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-08 10:38:32', NULL),
(111, 'INV1754661081', 14, 'Walk-in Customer', 7300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-08 15:51:21', NULL),
(112, 'INV1754663928', 14, 'Walk-in Customer', 11500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-08 16:38:48', NULL),
(113, 'INV1754678340', 14, 'Walk-in Customer', 42200.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-08 20:39:00', NULL),
(114, 'INV1754679535', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-08 20:58:55', NULL),
(115, 'INV1754721759', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-09 08:42:39', NULL),
(116, 'INV1754728578', 14, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-09 10:36:18', NULL),
(117, 'INV1754731641', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-09 11:27:21', NULL),
(118, 'INV1754762039', 14, 'Walk-in Customer', 6500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-09 19:53:59', NULL),
(119, 'INV1754763247', 14, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-09 20:14:07', NULL),
(120, 'INV1754763986', 14, 'Walk-in Customer', 6300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-09 20:26:26', NULL),
(121, 'INV1754765827', 14, 'Walk-in Customer', 7700.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-09 20:57:07', NULL),
(122, 'INV1754828770', 13, 'Walk-in Customer', 24000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-10 14:26:10', NULL),
(123, 'INV1754849847', 13, 'Walk-in Customer', 50300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-10 20:17:27', NULL),
(124, 'INV1754850238', 13, 'Walk-in Customer', 11000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-10 20:23:58', NULL),
(125, 'INV1754851822', 13, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-10 20:50:22', NULL),
(126, 'INV1754852204', 13, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-10 20:56:44', NULL),
(127, 'INV1754895784', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 09:03:04', NULL),
(128, 'INV1754899888', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 10:11:28', NULL),
(129, 'INV1754900921', 14, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 10:28:41', NULL),
(130, 'INV1754902974', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 11:02:54', NULL),
(131, 'INV1754905473', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 11:44:33', NULL),
(132, 'INV1754919264', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 15:34:24', NULL),
(133, 'INV1754921980', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 16:19:40', NULL),
(134, 'INV1754923629', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 16:47:09', NULL),
(135, 'INV1754929990', 13, 'Walk-in Customer', 26000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 18:33:10', NULL),
(136, 'INV1754930616', 13, 'Walk-in Customer', 14500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 18:43:36', NULL),
(137, 'INV1754934796', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 19:53:16', NULL),
(138, 'INV1754936213', 13, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 20:16:53', NULL),
(139, 'INV1754937711', 13, 'Walk-in Customer', 7800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 20:41:51', NULL),
(140, 'INV1754937923', 13, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 20:45:23', NULL),
(141, 'INV1754938324', 13, 'charles', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 20:52:04', NULL),
(142, 'INV1754939221', 13, 'Walk-in Customer', 9000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 21:07:01', NULL),
(143, 'INV1754940297', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 21:24:57', NULL),
(144, 'INV1754942214', 13, 'Walk-in Customer', 12500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-11 21:56:54', NULL),
(145, 'INV1754977612', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-12 07:46:52', NULL),
(146, 'INV1754991459', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-12 11:37:39', NULL),
(147, 'INV1754991493', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-12 11:38:13', NULL),
(148, 'INV1755002082', 14, 'Walk-in Customer', 6500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-12 14:34:42', NULL),
(149, 'INV1755008841', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-12 16:27:21', NULL),
(150, 'INV1755012424', 13, 'Walk-in Customer', 9000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-12 17:27:04', NULL),
(151, 'INV1755013823', 14, 'Walk-in Customer', 26000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-12 17:50:23', NULL),
(152, 'INV1755014486', 13, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-12 18:01:26', NULL),
(153, 'INV1755014908', 13, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-12 18:08:28', NULL),
(154, 'INV1755018467', 13, 'Walk-in Customer', 16000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-12 19:07:47', NULL),
(155, 'INV1755024456', 13, 'Walk-in Customer', 22500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-12 20:47:36', NULL),
(156, 'INV1755026743', 13, 'Walk-in Customer', 32000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-12 21:25:43', NULL),
(157, 'INV1755026789', 13, 'Walk-in Customer', 11500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-12 21:26:29', NULL),
(158, 'INV1755027395', 13, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-12 21:36:35', NULL),
(159, 'INV1755027564', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-12 21:39:24', NULL),
(160, 'INV1755073151', 14, 'Walk-in Customer', 6500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-13 10:19:11', NULL),
(161, 'INV1755079776', 14, 'Walk-in Customer', 18500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-13 12:09:36', NULL),
(162, 'INV1755085521', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-13 13:45:21', NULL),
(163, 'INV1755097418', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-13 17:03:38', NULL),
(164, 'INV1755103130', 13, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-13 18:38:50', NULL),
(165, 'INV1755103362', 14, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-13 18:42:42', NULL),
(166, 'INV1755103446', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-13 18:44:06', NULL),
(167, 'INV1755103701', 14, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-13 18:48:21', NULL),
(168, 'INV1755107814', 13, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-13 19:56:54', NULL),
(169, 'INV1755113386', 14, 'Walk-in Customer', 33400.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-13 21:29:46', NULL),
(170, 'INV1755113597', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-13 21:33:17', NULL),
(171, 'INV1755113817', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-13 21:36:57', NULL),
(172, 'INV1755114483', 13, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-13 21:48:03', NULL),
(173, 'INV1755114548', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-13 21:49:08', NULL),
(174, 'INV1755169553', 14, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-14 13:05:53', NULL),
(175, 'INV1755192144', 13, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-14 19:22:24', NULL),
(176, 'INV1755199564', 13, 'charles', 24500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-14 21:26:04', NULL),
(177, 'INV1755199726', 13, 'Walk-in Customer', 43000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-14 21:28:46', NULL),
(178, 'INV1755200486', 13, 'Walk-in Customer', 70500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-14 21:41:26', NULL),
(179, 'INV1755201277', 13, 'Walk-in Customer', 15000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-14 21:54:37', NULL),
(180, 'INV1755269417', 14, 'Walk-in Customer', 10500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-15 16:50:17', NULL),
(181, 'INV1755269915', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-15 16:58:35', NULL),
(182, 'INV1755270412', 14, 'Walk-in Customer', 16000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-15 17:06:52', NULL),
(183, 'INV1755459418', 13, 'Walk-in Customer', 51500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-17 21:36:58', NULL),
(184, 'INV1755460317', 13, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-17 21:51:57', NULL),
(185, 'INV1755507458', 14, 'Walk-in Customer', 23000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 10:57:38', NULL),
(186, 'INV1755507501', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 10:58:21', NULL),
(187, 'INV1755511092', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 11:58:12', NULL),
(188, 'INV1755513494', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 12:38:14', NULL),
(189, 'INV1755518717', 14, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 14:05:17', NULL),
(190, 'INV1755520333', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 14:32:13', NULL),
(191, 'INV1755525017', 14, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 15:50:17', NULL),
(192, 'INV1755526252', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 16:10:52', NULL),
(193, 'INV1755528962', 14, 'Walk-in Customer', 8300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 16:56:02', NULL),
(194, 'INV1755530032', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 17:13:52', NULL),
(195, 'INV1755530183', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 17:16:23', NULL),
(196, 'INV1755533850', 13, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 18:17:30', NULL),
(197, 'INV1755537687', 13, 'Walk-in Customer', 41000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 19:21:27', NULL),
(198, 'INV1755540049', 13, 'Walk-in Customer', 13000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 20:00:49', NULL),
(199, 'INV1755543949', 13, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 21:05:49', NULL),
(200, 'INV1755544787', 13, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 21:19:47', NULL),
(201, 'INV1755546270', 13, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 21:44:30', NULL),
(202, 'INV1755546336', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 21:45:36', NULL),
(203, 'INV1755547244', 13, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 22:00:44', NULL),
(204, 'INV1755547600', 13, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-18 22:06:40', NULL),
(205, 'INV1755593304', 14, 'Walk-in Customer', 28000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-19 10:48:24', NULL),
(206, 'INV1755595829', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-19 11:30:29', NULL),
(207, 'INV1755596226', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-19 11:37:06', NULL),
(208, 'INV1755603898', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-19 13:44:58', NULL),
(209, 'INV1755612392', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-19 16:06:32', NULL),
(210, 'INV1755615903', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-19 17:05:03', NULL),
(211, 'INV1755623877', 13, 'Walk-in Customer', 25500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-19 19:17:57', NULL),
(212, 'INV1755624630', 13, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-19 19:30:30', NULL),
(213, 'INV1755632249', 13, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-19 21:37:29', NULL),
(214, 'INV1755633500', 13, 'Walk-in Customer', 25000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-19 21:58:20', NULL),
(215, 'INV1755633522', 13, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-19 21:58:42', NULL),
(216, 'INV1755633540', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-19 21:59:00', NULL),
(217, 'INV1755678448', 14, 'Walk-in Customer', 9000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-20 10:27:28', NULL),
(218, 'INV1755681336', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-20 11:15:36', NULL),
(219, 'INV1755682484', 14, 'Walk-in Customer', 9000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-20 11:34:44', NULL),
(220, 'INV1755694741', 14, 'Walk-in Customer', 8500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-20 14:59:01', NULL),
(221, 'INV1755696356', 14, 'Walk-in Customer', 7500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-20 15:25:56', NULL),
(222, 'INV1755699677', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-20 16:21:17', NULL),
(223, 'INV1755700237', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-20 16:30:37', NULL),
(224, 'INV1755701644', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-20 16:54:04', NULL),
(225, 'INV1755714598', 14, 'Walk-in Customer', 17000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-20 20:29:58', NULL),
(226, 'INV1755714757', 14, 'Walk-in Customer', 17400.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-20 20:32:37', NULL),
(227, 'INV1755714777', 14, 'Walk-in Customer', 34000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-20 20:32:57', NULL),
(228, 'INV1755714983', 14, 'Walk-in Customer', 5300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-20 20:36:23', NULL),
(229, 'INV1755715462', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-20 20:44:22', NULL),
(230, 'INV1755716513', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-20 21:01:53', NULL),
(231, 'INV1755763008', 14, 'Walk-in Customer', 22000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-21 09:56:48', NULL),
(232, 'INV1755781544', 14, 'Walk-in Customer', 14500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-21 15:05:44', NULL),
(233, 'INV1755783464', 14, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-21 15:37:44', NULL),
(234, 'INV1755789029', 14, 'Walk-in Customer', 12500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-21 17:10:29', NULL),
(235, 'INV1755789073', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-21 17:11:13', NULL),
(236, 'INV1755791206', 13, 'Walk-in Customer', 7500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-21 17:46:46', NULL),
(237, 'INV1755793970', 13, 'Walk-in Customer', 9000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-21 18:32:50', NULL),
(238, 'INV1755797752', 13, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-21 19:35:52', NULL),
(239, 'INV1755799098', 13, 'Walk-in Customer', 51000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-21 19:58:18', NULL),
(240, 'INV1755799560', 13, 'Walk-in Customer', 7500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-21 20:06:00', NULL),
(241, 'INV1755800206', 13, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-21 20:16:46', NULL),
(242, 'INV1755800231', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-21 20:17:11', NULL),
(243, 'INV1755802950', 13, 'Walk-in Customer', 33300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-21 21:02:30', NULL),
(244, 'INV1755802989', 13, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-21 21:03:09', NULL),
(245, 'INV1755805738', 13, 'Walk-in Customer', 4500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-21 21:48:58', NULL),
(246, 'INV1755805854', 13, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-21 21:50:54', NULL),
(247, 'INV1755846661', 14, 'Walk-in Customer', 29500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-22 09:11:01', NULL),
(248, 'INV1755849350', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-22 09:55:50', NULL),
(249, 'INV1755868474', 14, 'Walk-in Customer', 11500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-22 15:14:34', NULL),
(250, 'INV1755875146', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-22 17:05:46', NULL),
(251, 'INV1755875239', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-22 17:07:19', NULL),
(252, 'INV1755886201', 14, 'Walk-in Customer', 29000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-22 20:10:01', NULL),
(253, 'INV1755886367', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-22 20:12:47', NULL),
(254, 'INV1755886842', 14, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-22 20:20:42', NULL),
(255, 'INV1755887542', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-22 20:32:22', NULL),
(256, 'INV1755888057', 14, 'Walk-in Customer', 7800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-22 20:40:57', NULL),
(257, 'INV1755928820', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-23 08:00:20', NULL),
(258, 'INV1755955841', 14, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-23 15:30:41', NULL),
(259, 'INV1755956031', 14, 'Walk-in Customer', 43500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-23 15:33:51', NULL),
(260, 'INV1755956088', 14, 'Walk-in Customer', 30000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-23 15:34:48', NULL),
(261, 'INV1755962016', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-23 17:13:36', NULL),
(262, 'INV1755971864', 14, 'Walk-in Customer', 21000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-23 19:57:44', NULL),
(263, 'INV1755972086', 14, 'Walk-in Customer', 18500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-23 20:01:26', NULL),
(264, 'INV1755974289', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-23 20:38:09', NULL),
(265, 'INV1755974801', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-23 20:46:41', NULL),
(266, 'INV1755975808', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-23 21:03:28', NULL),
(267, 'INV1756061386', 13, 'Walk-in Customer', 27800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-24 20:49:46', NULL),
(268, 'INV1756061526', 13, 'Walk-in Customer', 16000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-24 20:52:06', NULL),
(269, 'INV1756063026', 13, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-24 21:17:06', NULL),
(270, 'INV1756109351', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-25 10:09:11', NULL),
(271, 'INV1756117278', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-25 12:21:18', NULL),
(272, 'INV1756123171', 14, 'Walk-in Customer', 4500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-25 13:59:31', NULL),
(273, 'INV1756130517', 14, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-25 16:01:57', NULL),
(274, 'INV1756134433', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-25 17:07:13', NULL),
(275, 'INV1756136114', 14, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-25 17:35:14', NULL),
(276, 'INV1756138837', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-25 18:20:37', NULL),
(277, 'INV1756150106', 13, 'Walk-in Customer', 63200.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-25 21:28:26', NULL),
(278, 'INV1756154173', 13, 'Walk-in Customer', 17000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-25 22:36:13', NULL),
(279, 'INV1756154305', 13, 'Walk-in Customer', 9000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-25 22:38:25', NULL),
(280, 'INV1756154729', 13, 'Walk-in Customer', 28000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-25 22:45:29', NULL),
(281, 'INV1756155195', 13, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-25 22:53:15', NULL),
(282, 'INV1756155206', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-25 22:53:26', NULL),
(283, 'INV1756155239', 13, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-25 22:53:59', NULL),
(284, 'INV1756155333', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-25 22:55:33', NULL),
(285, 'INV1756155491', 13, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-25 22:58:11', NULL),
(286, 'INV1756192270', 14, 'Walk-in Customer', 12500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-26 09:11:10', NULL),
(287, 'INV1756216780', 14, 'Walk-in Customer', 21000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-26 15:59:40', NULL),
(288, 'INV1756216932', 14, 'Walk-in Customer', 28000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-26 16:02:12', NULL),
(289, 'INV1756217484', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-26 16:11:24', NULL),
(290, 'INV1756221738', 14, 'Walk-in Customer', 4500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-26 17:22:18', NULL),
(291, 'INV1756302671', 14, 'Walk-in Customer', 8500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-27 15:51:11', NULL),
(292, 'INV1756303030', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-27 15:57:10', NULL),
(293, 'INV1756310176', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-27 17:56:16', NULL),
(294, 'INV1756320638', 14, 'Walk-in Customer', 24800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-27 20:50:38', NULL),
(295, 'INV1756364950', 14, 'Walk-in Customer', 11000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-28 09:09:10', NULL),
(296, 'INV1756381474', 14, 'Walk-in Customer', 9000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-28 13:44:34', NULL),
(297, 'INV1756381687', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-28 13:48:07', NULL),
(298, 'INV1756385456', 14, 'Walk-in Customer', 10500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-28 14:50:56', NULL),
(299, 'INV1756476712', 14, 'Walk-in Customer', 18500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-29 16:11:52', NULL),
(300, 'INV1756477443', 14, 'Walk-in Customer', 27500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-29 16:24:03', NULL),
(301, 'INV1756477593', 14, 'Walk-in Customer', 11500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-29 16:26:33', NULL),
(302, 'INV1756477946', 14, 'Walk-in Customer', 9500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-29 16:32:26', NULL),
(303, 'INV1756480415', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-29 17:13:35', NULL),
(304, 'INV1756480540', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-29 17:15:40', NULL),
(305, 'INV1756491891', 14, 'Walk-in Customer', 6500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-29 20:24:51', NULL),
(306, 'INV1756492052', 14, 'Walk-in Customer', 8500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-29 20:27:32', NULL),
(307, 'INV1756492320', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-29 20:32:00', NULL),
(308, 'INV1756492790', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-29 20:39:50', NULL),
(309, 'INV1756559086', 14, 'Walk-in Customer', 25000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-30 15:04:46', NULL),
(310, 'INV1756565526', 14, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-30 16:52:06', NULL),
(311, 'INV1756568700', 14, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-30 17:45:00', NULL),
(312, 'INV1756569700', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-30 18:01:40', NULL),
(313, 'INV1756570111', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-30 18:08:31', NULL),
(314, 'INV1756573735', 14, 'Walk-in Customer', 12000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-30 19:08:55', NULL),
(315, 'INV1756573827', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-30 19:10:27', NULL),
(316, 'INV1756577779', 14, 'Walk-in Customer', 15000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-30 20:16:19', NULL),
(317, 'INV1756649877', 13, 'Walk-in Customer', 12500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-08-31 16:17:57', NULL),
(318, 'INV1756738308', 14, 'Walk-in Customer', 20500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-01 16:51:48', NULL),
(319, 'INV1756741407', 14, 'Walk-in Customer', 13000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-01 17:43:27', NULL),
(320, 'INV1756741722', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-01 17:48:42', NULL),
(321, 'INV1756742001', 14, 'Walk-in Customer', 16000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-01 17:53:21', NULL),
(322, 'INV1756825221', 14, 'Walk-in Customer', 33000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-02 17:00:21', NULL),
(323, 'INV1756837699', 13, 'Walk-in Customer', 56900.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-02 20:28:19', NULL),
(324, 'INV1756837964', 13, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-02 20:32:44', NULL),
(325, 'INV1756842629', 13, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-02 21:50:29', NULL),
(326, 'INV1756886214', 14, 'Walk-in Customer', 0.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-03 09:56:54', NULL),
(327, 'INV1756886233', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-03 09:57:13', NULL),
(328, 'INV1756900883', 14, 'Walk-in Customer', 14000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-03 14:01:23', NULL),
(329, 'INV1756901509', 14, 'Walk-in Customer', 31000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-03 14:11:49', NULL),
(330, 'INV1756901547', 14, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-03 14:12:27', NULL),
(331, 'INV1756906770', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-03 15:39:30', NULL),
(332, 'INV1756909724', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-03 16:28:44', NULL),
(333, 'INV1756911371', 14, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-03 16:56:11', NULL),
(334, 'INV1756913858', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-03 17:37:38', NULL),
(335, 'INV1756918131', 14, 'Walk-in Customer', 15000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-03 18:48:51', NULL),
(336, 'INV1756924678', 14, 'Walk-in Customer', 16000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-03 20:37:58', NULL),
(337, 'INV1756925332', 13, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-03 20:48:52', NULL),
(338, 'INV1756925391', 13, 'Walk-in Customer', 12000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-03 20:49:51', NULL),
(339, 'INV1756926808', 14, 'Walk-in Customer', 12998.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-03 21:13:28', NULL),
(340, 'INV1756927262', 14, 'Walk-in Customer', 7500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-03 21:21:02', NULL),
(341, 'INV1756927374', 14, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-03 21:22:54', NULL),
(342, 'INV1756988077', 14, 'Walk-in Customer', 26000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-04 14:14:37', NULL),
(343, 'INV1756988421', 14, 'Walk-in Customer', 15500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-04 14:20:21', NULL),
(344, 'INV1757007187', 13, 'Walk-in Customer', 50000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-04 19:33:07', NULL),
(345, 'INV1757007249', 13, 'Walk-in Customer', 11000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-04 19:34:09', NULL),
(346, 'INV1757007468', 13, 'Walk-in Customer', 14000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-04 19:37:48', NULL),
(347, 'INV1757007634', 13, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-04 19:40:34', NULL),
(348, 'INV1757008703', 13, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-04 19:58:23', NULL),
(349, 'INV1757012720', 13, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-04 21:05:20', NULL),
(350, 'INV1757015578', 13, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-04 21:52:58', NULL),
(351, 'INV1757054686', 14, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-05 08:44:46', NULL),
(352, 'INV1757057824', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-05 09:37:04', NULL),
(353, 'INV1757062110', 14, 'Walk-in Customer', 0.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-05 10:48:30', NULL),
(354, 'INV1757068994', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-05 12:43:14', NULL),
(355, 'INV1757082074', 14, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-05 16:21:14', NULL),
(356, 'INV1757082118', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-05 16:21:58', NULL),
(357, 'INV1757085835', 14, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-05 17:23:55', NULL),
(358, 'INV1757086294', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-05 17:31:34', NULL),
(359, 'INV1757086760', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-05 17:39:20', NULL),
(360, 'INV1757100135', 14, 'Walk-in Customer', 23000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-05 21:22:15', NULL),
(361, 'INV1757100272', 14, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-05 21:24:32', NULL),
(362, 'INV1757100714', 14, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-05 21:31:54', NULL),
(363, 'INV1757146111', 13, 'Walk-in Customer', 14000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-06 10:08:31', NULL),
(364, 'INV1757159637', 13, 'Walk-in Customer', 22000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-06 13:53:57', NULL),
(365, 'INV1757159753', 13, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-06 13:55:53', NULL),
(366, 'INV1757166809', 13, 'Walk-in Customer', 13500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-06 15:53:29', NULL),
(367, 'INV1757169669', 13, 'Walk-in Customer', 13000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-06 16:41:09', NULL),
(368, 'INV1757172277', 13, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-06 17:24:37', NULL),
(369, 'INV1757186361', 13, 'Walk-in Customer', 45800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-06 21:19:21', NULL),
(370, 'INV1757186438', 13, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-06 21:20:38', NULL),
(371, 'INV1757186544', 13, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-06 21:22:24', NULL),
(372, 'INV1757186789', 13, 'charles', 4500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-06 21:26:29', NULL),
(373, 'INV1757188539', 13, 'Walk-in Customer', 15000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-06 21:55:39', NULL),
(374, 'INV1757232189', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-07 10:03:09', NULL),
(375, 'INV1757235804', 14, 'Walk-in Customer', 20000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-07 11:03:24', NULL),
(376, 'INV1757236199', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-07 11:09:59', NULL),
(377, 'INV1757255158', 14, 'Walk-in Customer', 35000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-07 16:25:58', NULL),
(378, 'INV1757260116', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-07 17:48:36', NULL),
(379, 'INV1757262263', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-07 18:24:23', NULL),
(380, 'INV1757264371', 14, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-07 18:59:31', NULL),
(381, 'INV1757264829', 14, 'Walk-in Customer', 19000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-07 19:07:09', NULL),
(382, 'INV1757267407', 14, 'Walk-in Customer', 5300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-07 19:50:07', NULL),
(383, 'INV1757268174', 14, 'Walk-in Customer', 9500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-07 20:02:54', NULL),
(384, 'INV1757268275', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-07 20:04:35', NULL),
(385, 'INV1757270187', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-07 20:36:27', NULL),
(386, 'INV1757270440', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-07 20:40:40', NULL),
(387, 'INV1757270910', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-07 20:48:30', NULL),
(388, 'INV1757271017', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-07 20:50:17', NULL),
(389, 'INV1757315068', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-08 09:04:28', NULL),
(390, 'INV1757323779', 14, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-08 11:29:39', NULL),
(391, 'INV1757325193', 14, 'Walk-in Customer', 19000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-08 11:53:13', NULL),
(392, 'INV1757336652', 14, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-08 15:04:12', NULL),
(393, 'INV1757336759', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-08 15:05:59', NULL),
(394, 'INV1757338861', 14, 'Walk-in Customer', 15500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-08 15:41:01', NULL),
(395, 'INV1757341429', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-08 16:23:49', NULL),
(396, 'INV1757350003', 13, 'Walk-in Customer', 8500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-08 18:46:43', NULL),
(397, 'INV1757352606', 13, 'Walk-in Customerre', 60000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-08 19:30:06', NULL),
(398, 'INV1757353294', 13, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-08 19:41:34', NULL),
(399, 'INV1757355737', 13, 'Walk-in Customer', 19000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-08 20:22:17', NULL),
(400, 'INV1757357594', 13, 'Walk-in Customer', 22800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-08 20:53:14', NULL),
(401, 'INV1757357911', 13, 'Walk-in Customer', 9000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-08 20:58:31', NULL),
(402, 'INV1757361389', 13, 'Walk-in Customer', 12500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-08 21:56:29', NULL),
(403, 'INV1757402712', 14, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-09 09:25:12', NULL),
(404, 'INV1757407556', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-09 10:45:56', NULL),
(405, 'INV1757415934', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-09 13:05:34', NULL),
(406, 'INV1757424271', 14, 'Walk-in Customer', 9000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-09 15:24:31', NULL),
(407, 'INV1757427421', 14, 'Walk-in Customer', 9000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-09 16:17:01', NULL),
(408, 'INV1757427799', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-09 16:23:19', NULL),
(409, 'INV1757431629', 13, 'Walk-in Customer', 25500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-09 17:27:09', NULL),
(410, 'INV1757443608', 13, 'Walk-in Customer', 22000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-09 20:46:48', NULL),
(411, 'INV1757448295', 13, 'Walk-in Customer', 15700.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-09 22:04:55', NULL),
(412, 'INV1757448338', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-09 22:05:38', NULL),
(413, 'INV1757448471', 13, 'Walk-in Customer', 2400.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-09 22:07:51', NULL),
(414, 'INV1757485295', 14, 'Walk-in Customer', 1200.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-10 08:21:35', NULL),
(415, 'INV1757495821', 14, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-10 11:17:01', NULL),
(416, 'INV1757497984', 14, 'Walk-in Customer', 11500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-10 11:53:04', NULL),
(417, 'INV1757504410', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-10 13:40:10', NULL),
(418, 'INV1757512287', 14, 'Walk-in Customer', 9500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-10 15:51:27', NULL),
(419, 'INV1757517119', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-10 17:11:59', NULL),
(420, 'INV1757519373', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-10 17:49:33', NULL),
(421, 'INV1757524874', 14, 'Walk-in Customer', 10500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-10 19:21:14', NULL),
(422, 'INV1757525754', 14, 'Walk-in Customer', 8500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-10 19:35:54', NULL),
(423, 'INV1757528911', 14, 'Walk-in Customer', 38800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-10 20:28:31', NULL),
(424, 'INV1757529032', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-10 20:30:32', NULL),
(425, 'INV1757530333', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-10 20:52:13', NULL),
(426, 'INV1757568595', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-11 07:29:55', NULL),
(427, 'INV1757575647', 14, 'Walk-in Customer', 4500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-11 09:27:27', NULL),
(428, 'INV1757577636', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-11 10:00:36', NULL),
(429, 'INV1757581412', 14, 'Walk-in Customer', 2700.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-11 11:03:32', NULL);
INSERT INTO `sales_pharm` (`id`, `invoice_number`, `user_id`, `customer_name`, `total_amount`, `discount`, `tax`, `net_amount`, `payment_method`, `transaction_id`, `date`, `notes`) VALUES
(430, 'INV1757594710', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-11 14:45:10', NULL),
(431, 'INV1757599204', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-11 16:00:04', NULL),
(432, 'INV1757602658', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-11 16:57:38', NULL),
(433, 'INV1757618101', 13, 'Walk-in Customer', 48400.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-11 21:15:01', NULL),
(434, 'INV1757618325', 13, 'charles', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-11 21:18:45', NULL),
(435, 'INV1757618363', 13, 'charles', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-11 21:19:23', NULL),
(436, 'INV1757618530', 13, 'Walk-in Customer', 3499.96, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-11 21:22:10', NULL),
(437, 'INV1757663302', 14, 'Walk-in Customer', 15500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-12 09:48:22', NULL),
(438, 'INV1757668411', 14, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-12 11:13:31', NULL),
(439, 'INV1757683501', 14, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-12 15:25:01', NULL),
(440, 'INV1757691427', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-12 17:37:07', NULL),
(441, 'INV1757691613', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-12 17:40:13', NULL),
(442, 'INV1757697337', 14, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-12 19:15:37', NULL),
(443, 'INV1757697553', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-12 19:19:13', NULL),
(444, 'INV1757698091', 14, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-12 19:28:11', NULL),
(445, 'INV1757702293', 14, 'Walk-in Customer', 3800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-12 20:38:13', NULL),
(446, 'INV1757703382', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-12 20:56:22', NULL),
(447, 'INV1757703499', 14, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-12 20:58:19', NULL),
(448, 'INV1757704003', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-12 21:06:43', NULL),
(449, 'INV1757746226', 14, 'Walk-in Customer', 26500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-13 08:50:26', NULL),
(450, 'INV1757755288', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-13 11:21:28', NULL),
(451, 'INV1757784989', 14, 'Walk-in Customer', 22000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-13 19:36:29', NULL),
(452, 'INV1757785301', 14, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-13 19:41:41', NULL),
(453, 'INV1757786041', 14, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-13 19:54:01', NULL),
(454, 'INV1757786829', 14, 'Walk-in Customer', 800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-13 20:07:09', NULL),
(455, 'INV1757789181', 14, 'Walk-in Customer', 20000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-13 20:46:21', NULL),
(456, 'INV1757789795', 14, 'Walk-in Customer', 3800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-13 20:56:35', NULL),
(457, 'INV1757928226', 14, 'Walk-in Customer', 22050.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-15 11:23:46', NULL),
(458, 'INV1757929894', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-15 11:51:34', NULL),
(459, 'INV1757934395', 14, 'Walk-in Customer', 18000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-15 13:06:35', NULL),
(460, 'INV1757938853', 14, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-15 14:20:53', NULL),
(461, 'INV1757939254', 14, 'Walk-in Customer', 9500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-15 14:27:34', NULL),
(462, 'INV1757949743', 14, 'Walk-in Customer', 23000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-15 17:22:23', NULL),
(463, 'INV1757953149', 13, 'charles', 12000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-15 18:19:09', NULL),
(464, 'INV1757953571', 13, 'Walk-in Customer', 7500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-15 18:26:11', NULL),
(465, 'INV1757953639', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-15 18:27:19', NULL),
(466, 'INV1757957680', 13, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-15 19:34:40', NULL),
(467, 'INV1757958747', 13, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-15 19:52:27', NULL),
(468, 'INV1757963086', 13, 'Walk-in Customer', 26000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-15 21:04:46', NULL),
(469, 'INV1757965817', 13, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-15 21:50:17', NULL),
(470, 'INV1757966047', 13, 'charles', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-15 21:54:07', NULL),
(471, 'INV1757966633', 13, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-15 22:03:53', NULL),
(472, 'INV1758012492', 14, 'Walk-in Customer', 13500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-16 10:48:12', NULL),
(473, 'INV1758016076', 14, 'Walk-in Customer', 9000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-16 11:47:56', NULL),
(474, 'INV1758027192', 14, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-16 14:53:12', NULL),
(475, 'INV1758028874', 14, 'Walk-in Customer', 3800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-16 15:21:14', NULL),
(476, 'INV1758032821', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-16 16:27:01', NULL),
(477, 'INV1758035787', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-16 17:16:27', NULL),
(478, 'INV1758040417', 13, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-16 18:33:37', NULL),
(479, 'INV1758045064', 13, 'Walk-in Customer', 56400.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-16 19:51:04', NULL),
(480, 'INV1758045208', 13, 'charles', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-16 19:53:28', NULL),
(481, 'INV1758046250', 13, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-16 20:10:50', NULL),
(482, 'INV1758047914', 13, 'Walk-in Customer', 16000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-16 20:38:34', NULL),
(483, 'INV1758048943', 13, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-16 20:55:43', NULL),
(484, 'INV1758049006', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-16 20:56:46', NULL),
(485, 'INV1758051042', 13, 'Walk-in Customer', 7500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-16 21:30:42', NULL),
(486, 'INV1758632381', 14, 'Walk-in Customer', 18700.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-23 14:59:41', NULL),
(487, 'INV1758634783', 14, 'Walk-in Customer', 5999.98, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-23 15:39:43', NULL),
(488, 'INV1758635593', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-23 15:53:13', NULL),
(489, 'INV1758635806', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-23 15:56:46', NULL),
(490, 'INV1758639872', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-23 17:04:32', NULL),
(491, 'INV1758639914', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-23 17:05:14', NULL),
(492, 'INV1758645357', 13, 'Walk-in Customer', 68000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-23 18:35:57', NULL),
(493, 'INV1758650551', 13, 'Walk-in Customer', 18000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-23 20:02:31', NULL),
(494, 'INV1758653405', 13, 'Walk-in Customer', 33000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-23 20:50:05', NULL),
(495, 'INV1758709099', 14, 'Walk-in Customer', 11500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-24 12:18:19', NULL),
(496, 'INV1758797249', 14, 'Walk-in Customer', 46500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-25 12:47:29', NULL),
(497, 'INV1758797343', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-25 12:49:03', NULL),
(498, 'INV1758803095', 14, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-25 14:24:55', NULL),
(499, 'INV1758811239', 14, 'Walk-in Customer', 13999.92, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-25 16:40:39', NULL),
(500, 'INV1758815412', 13, 'Walk-in Customer', 16000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-25 17:50:12', NULL),
(501, 'INV1758907633', 13, 'Walk-in Customer', 38500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-26 19:27:13', NULL),
(502, 'INV1758911222', 13, 'Walk-in Customer', 62500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-26 20:27:02', NULL),
(503, 'INV1758911286', 13, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-26 20:28:06', NULL),
(504, 'INV1758976881', 14, 'Walk-in Customer', 9500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-27 14:41:21', NULL),
(505, 'INV1758982396', 14, 'Walk-in Customer', 9000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-27 16:13:16', NULL),
(506, 'INV1758984425', 14, 'Walk-in Customer', 6500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-27 16:47:05', NULL),
(507, 'INV1758992609', 14, 'Walk-in Customer', 13500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-27 19:03:29', NULL),
(508, 'INV1758993322', 14, 'Walk-in Customer', 9000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-27 19:15:22', NULL),
(509, 'INV1758999447', 14, 'Walk-in Customer', 21700.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-27 20:57:27', NULL),
(510, 'INV1758999788', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-27 21:03:08', NULL),
(511, 'INV1759069737', 14, 'Walk-in Customer', 21000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-28 16:28:57', NULL),
(512, 'INV1759075623', 14, 'Walk-in Customer', 28900.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-28 18:07:03', NULL),
(513, 'INV1759082060', 14, 'Walk-in Customer', 11500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-28 19:54:20', NULL),
(514, 'INV1759082488', 14, 'Walk-in Customer', 7800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-28 20:01:28', NULL),
(515, 'INV1759084046', 14, 'Walk-in Customer', 15499.98, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-28 20:27:26', NULL),
(516, 'INV1759155277', 14, 'Walk-in Customer', 22500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-29 16:14:37', NULL),
(517, 'INV1759239469', 14, 'Walk-in Customer', 32100.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-30 15:37:49', NULL),
(518, 'INV1759239578', 14, 'Walk-in Customer', 10500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-30 15:39:38', NULL),
(519, 'INV1759243641', 14, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-30 16:47:21', NULL),
(520, 'INV1759247422', 13, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-30 17:50:22', NULL),
(521, 'INV1759261465', 13, 'Walk-in Customer', 12000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-09-30 21:44:25', NULL),
(522, 'INV1759314167', 14, 'Walk-in Customer', 17000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-01 12:22:47', NULL),
(523, 'INV1759327630', 14, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-01 16:07:10', NULL),
(524, 'INV1759327748', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-01 16:09:08', NULL),
(525, 'INV1759334024', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-01 17:53:44', NULL),
(526, 'INV1759334075', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-01 17:54:35', NULL),
(527, 'INV1759334843', 14, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-01 18:07:23', NULL),
(528, 'INV1759337939', 14, 'Walk-in Customer', 12000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-01 18:58:59', NULL),
(529, 'INV1759340547', 14, 'Walk-in Customer', 4500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-01 19:42:27', NULL),
(530, 'INV1759343580', 14, 'Walk-in Customer', 13800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-01 20:33:00', NULL),
(531, 'INV1759345415', 14, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-01 21:03:35', NULL),
(532, 'INV1759346159', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-01 21:15:59', NULL),
(533, 'INV1759346394', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-01 21:19:54', NULL),
(534, 'INV1759402113', 14, 'Walk-in Customer', 31500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-02 12:48:33', NULL),
(535, 'INV1759414348', 14, 'Walk-in Customer', 8500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-02 16:12:28', NULL),
(536, 'INV1759422677', 13, 'Walk-in Customer', 21000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-02 18:31:17', NULL),
(537, 'INV1759422870', 13, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-02 18:34:30', NULL),
(538, 'INV1759432636', 13, 'Walk-in Customer', 9000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-02 21:17:16', NULL),
(539, 'INV1759432698', 13, 'charles', 11500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-02 21:18:18', NULL),
(540, 'INV1759433025', 13, 'Walk-in Customer', 13600.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-02 21:23:45', NULL),
(541, 'INV1759435528', 13, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-02 22:05:28', NULL),
(542, 'INV1759435559', 13, 'Walk-in Customer', 13000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-02 22:05:59', NULL),
(543, 'INV1759435608', 13, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-02 22:06:48', NULL),
(544, 'INV1759488032', 14, 'Walk-in Customer', 25500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-03 12:40:32', NULL),
(545, 'INV1759488730', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-03 12:52:10', NULL),
(546, 'INV1759495000', 14, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-03 14:36:40', NULL),
(547, 'INV1759501963', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-03 16:32:43', NULL),
(548, 'INV1759504540', 14, 'Walk-in Customer', 11000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-03 17:15:40', NULL),
(549, 'INV1759505120', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-03 17:25:20', NULL),
(550, 'INV1759508089', 14, 'Walk-in Customer', 7500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-03 18:14:49', NULL),
(551, 'INV1759515110', 14, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-03 20:11:50', NULL),
(552, 'INV1759515901', 14, 'Walk-in Customer', 2800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-03 20:25:01', NULL),
(553, 'INV1759517873', 14, 'Walk-in Customer', 10500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-03 20:57:53', NULL),
(554, 'INV1759593699', 14, 'Walk-in Customer', 13000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-04 18:01:39', NULL),
(555, 'INV1759593733', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-04 18:02:13', NULL),
(556, 'INV1759593905', 14, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-04 18:05:05', NULL),
(557, 'INV1759595806', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-04 18:36:46', NULL),
(558, 'INV1759597170', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-04 18:59:30', NULL),
(559, 'INV1759599073', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-04 19:31:13', NULL),
(560, 'INV1759600335', 14, 'Walk-in Customer', 4400.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-04 19:52:15', NULL),
(561, 'INV1759605330', 14, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-04 21:15:30', NULL),
(562, 'INV1759605390', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-04 21:16:30', NULL),
(563, 'INV1759754845', 14, 'Walk-in Customer', 28500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-06 14:47:25', NULL),
(564, 'INV1759759228', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-06 16:00:28', NULL),
(565, 'INV1759759291', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-06 16:01:31', NULL),
(566, 'INV1759844086', 14, 'Walk-in Customer', 26500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-07 15:34:46', NULL),
(567, 'INV1759850846', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-07 17:27:26', NULL),
(568, 'INV1759851117', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-07 17:31:57', NULL),
(569, 'INV1759930546', 14, 'Walk-in Customer', 28000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-08 15:35:46', NULL),
(570, 'INV1759933192', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-08 16:19:52', NULL),
(571, 'INV1760015395', 14, 'Walk-in Customer', 14300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-09 15:09:55', NULL),
(572, 'INV1760018876', 14, 'Walk-in Customer', 6600.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-09 16:07:56', NULL),
(573, 'INV1760030137', 14, 'Walk-in Customer', 16000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-09 19:15:37', NULL),
(574, 'INV1760036596', 14, 'Walk-in Customer', 14500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-09 21:03:16', NULL),
(575, 'INV1760037285', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-09 21:14:45', NULL),
(576, 'INV1760109351', 14, 'Walk-in Customer', 43000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-10 17:15:51', NULL),
(577, 'INV1760111197', 14, 'Walk-in Customer', 2700.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-10 17:46:37', NULL),
(578, 'INV1760112202', 14, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-10 18:03:22', NULL),
(579, 'INV1760112551', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-10 18:09:11', NULL),
(580, 'INV1760114587', 14, 'Walk-in Customer', 6800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-10 18:43:07', NULL),
(581, 'INV1760117616', 14, 'Walk-in Customer', 11300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-10 19:33:36', NULL),
(582, 'INV1760122393', 14, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-10 20:53:13', NULL),
(583, 'INV1760123017', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-10 21:03:37', NULL),
(584, 'INV1760166336', 14, 'Walk-in Customer', 13500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-11 09:05:36', NULL),
(585, 'INV1760169116', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-11 09:51:56', NULL),
(586, 'INV1760169809', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-11 10:03:29', NULL),
(587, 'INV1760201426', 13, 'Walk-in Customer', 13000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-11 18:50:26', NULL),
(588, 'INV1760201903', 13, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-11 18:58:23', NULL),
(589, 'INV1760209300', 14, 'Walk-in Customer', 35400.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-11 21:01:40', NULL),
(590, 'INV1760209656', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-11 21:07:36', NULL),
(591, 'INV1760298954', 13, 'Walk-in Customer', 61100.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-12 21:55:54', NULL),
(592, 'INV1760299230', 13, 'Walk-in Customer', 30500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-12 22:00:30', NULL),
(593, 'INV1760299283', 13, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-12 22:01:23', NULL),
(594, 'INV1760363456', 14, 'Walk-in Customer', 15000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-13 15:50:56', NULL),
(595, 'INV1760451004', 14, 'Walk-in Customer', 17700.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-14 16:10:04', NULL),
(596, 'INV1760451466', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-14 16:17:46', NULL),
(597, 'INV1760451809', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-14 16:23:29', NULL),
(598, 'INV1760454022', 14, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-14 17:00:22', NULL),
(599, 'INV1760536294', 14, 'Walk-in Customer', 9700.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-15 15:51:34', NULL),
(600, 'INV1760541816', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-15 17:23:36', NULL),
(601, 'INV1760541939', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-15 17:25:39', NULL),
(602, 'INV1760547739', 14, 'Walk-in Customer', 19000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-15 19:02:19', NULL),
(603, 'INV1760550244', 14, 'Walk-in Customer', 17000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-15 19:44:04', NULL),
(604, 'INV1760550783', 14, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-15 19:53:03', NULL),
(605, 'INV1760551200', 14, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-15 20:00:00', NULL),
(606, 'INV1760553630', 14, 'Walk-in Customer', 9500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-15 20:40:30', NULL),
(607, 'INV1760625752', 14, 'Walk-in Customer', 34600.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-16 16:42:32', NULL),
(608, 'INV1760631571', 13, 'Walk-in Customer', 24000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-16 18:19:31', NULL),
(609, 'INV1760631767', 13, 'Walk-in Customer', 43000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-16 18:22:47', NULL),
(610, 'INV1760634051', 13, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-16 19:00:51', NULL),
(611, 'INV1760640350', 13, 'Walk-in Customer', 26500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-16 20:45:50', NULL),
(612, 'INV1760640537', 13, 'Walk-in Customer', 16500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-16 20:48:57', NULL),
(613, 'INV1760641029', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-16 20:57:09', NULL),
(614, 'INV1760698073', 14, 'Walk-in Customer', 26000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-17 12:47:53', NULL),
(615, 'INV1760699876', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-17 13:17:56', NULL),
(616, 'INV1760711821', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-17 16:37:01', NULL),
(617, 'INV1760712813', 14, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-17 16:53:33', NULL),
(618, 'INV1760718319', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-17 18:25:19', NULL),
(619, 'INV1760724385', 14, 'Walk-in Customer', 11500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-17 20:06:25', NULL),
(620, 'INV1760726085', 14, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-17 20:34:45', NULL),
(621, 'INV1760726494', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-17 20:41:34', NULL),
(622, 'INV1760727706', 14, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-17 21:01:46', NULL),
(623, 'INV1760728651', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-17 21:17:31', NULL),
(624, 'INV1760729233', 14, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-17 21:27:13', NULL),
(625, 'INV1760782565', 14, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-18 12:16:05', NULL),
(626, 'INV1760805712', 14, 'Walk-in Customer', 11300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-18 18:41:52', NULL),
(627, 'INV1760805825', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-18 18:43:45', NULL),
(628, 'INV1760809875', 14, 'Walk-in Customer', 24000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-18 19:51:15', NULL),
(629, 'INV1760813123', 14, 'Walk-in Customer', 23300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-18 20:45:23', NULL),
(630, 'INV1760814365', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-18 21:06:05', NULL),
(631, 'INV1760889910', 13, 'Walk-in Customer', 51300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-19 18:05:10', NULL),
(632, 'INV1760890087', 13, 'Walk-in Customer', 19500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-19 18:08:07', NULL),
(633, 'INV1760891637', 13, 'Walk-in Customer', 19500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-19 18:33:57', NULL),
(634, 'INV1760891810', 13, 'charles', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-19 18:36:50', NULL),
(635, 'INV1760900399', 13, 'Walk-in Customer', 23800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-19 20:59:59', NULL),
(636, 'INV1760900755', 13, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-19 21:05:55', NULL),
(637, 'INV1760903509', 13, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-19 21:51:49', NULL),
(638, 'INV1760949742', 14, 'Walk-in Customer', 10300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-20 10:42:22', NULL),
(639, 'INV1760962158', 14, 'Walk-in Customer', 14999.92, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-20 14:09:18', NULL),
(640, 'INV1760970680', 14, 'Walk-in Customer', 6600.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-20 16:31:20', NULL),
(641, 'INV1760975672', 14, 'Walk-in Customer', 12200.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-20 17:54:32', NULL),
(642, 'INV1760976474', 14, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-20 18:07:54', NULL),
(643, 'INV1760982006', 13, 'Walk-in Customer', 28000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-20 19:40:06', NULL),
(644, 'INV1760985672', 13, 'Walk-in Customer', 9800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-20 20:41:12', NULL),
(645, 'INV1760985691', 13, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-20 20:41:31', NULL),
(646, 'INV1760986007', 13, 'Walk-in Customer', 16500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-20 20:46:47', NULL),
(647, 'INV1761033700', 14, 'Walk-in Customer', 22300.03, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-21 10:01:40', NULL),
(648, 'INV1761034303', 14, 'Walk-in Customer', 12500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-21 10:11:43', NULL),
(649, 'INV1761041495', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-21 12:11:35', NULL),
(650, 'INV1761049604', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-21 14:26:44', NULL),
(651, 'INV1761053734', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-21 15:35:34', NULL),
(652, 'INV1761216309', 14, 'Walk-in Customer', 31000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-23 12:45:09', NULL),
(653, 'INV1761226500', 14, 'Walk-in Customer', 20500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-23 15:35:00', NULL),
(654, 'INV1761231458', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-23 16:57:38', NULL),
(655, 'INV1761231844', 13, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-23 17:04:04', NULL),
(656, 'INV1761240036', 13, 'Walk-in Customer', 31000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-23 19:20:36', NULL),
(657, 'INV1761246273', 13, 'Walk-in Customer', 66000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-23 21:04:33', NULL),
(658, 'INV1761247269', 13, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-23 21:21:09', NULL),
(659, 'INV1761247370', 13, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-23 21:22:50', NULL),
(660, 'INV1761250654', 13, 'Walk-in Customer', 4500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-23 22:17:34', NULL),
(661, 'INV1761409592', 14, 'Walk-in Customer', 51450.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-25 18:26:32', NULL),
(662, 'INV1761410242', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-25 18:37:22', NULL),
(663, 'INV1761414717', 14, 'Walk-in Customer', 23000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-25 19:51:57', NULL),
(664, 'INV1761416028', 14, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-25 20:13:48', NULL),
(665, 'INV1761417622', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-25 20:40:22', NULL),
(666, 'INV1761417820', 14, 'Walk-in Customer', 1200.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-25 20:43:40', NULL),
(667, 'INV1761418848', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-25 21:00:48', NULL),
(668, 'INV1761419153', 14, 'Walk-in Customer', 700.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-25 21:05:53', NULL),
(669, 'INV1761558691', 14, 'Walk-in Customer', 33700.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-27 10:51:31', NULL),
(670, 'INV1761566784', 14, 'Walk-in Customer', 4100.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-27 13:06:24', NULL),
(671, 'INV1761570844', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-27 14:14:04', NULL),
(672, 'INV1761581316', 13, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-27 17:08:36', NULL),
(673, 'INV1761581458', 13, 'Walk-in Customer', 19500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-27 17:10:58', NULL),
(674, 'INV1761581924', 13, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-27 17:18:44', NULL),
(675, 'INV1761583844', 13, 'Walk-in Customer', 42400.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-27 17:50:44', NULL),
(676, 'INV1761586761', 13, 'Walk-in Customer', 19000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-27 18:39:21', NULL),
(677, 'INV1761587977', 13, 'Walk-in Customer', 9500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-27 18:59:37', NULL),
(678, 'INV1761588537', 13, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-27 19:08:57', NULL),
(679, 'INV1761632174', 14, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 07:16:14', NULL),
(680, 'INV1761632287', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 07:18:07', NULL),
(681, 'INV1761640466', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 09:34:26', NULL),
(682, 'INV1761640540', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 09:35:40', NULL),
(683, 'INV1761640704', 14, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 09:38:24', NULL),
(684, 'INV1761652675', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 12:57:55', NULL),
(685, 'INV1761654727', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 13:32:07', NULL),
(686, 'INV1761658439', 14, 'Walk-in Customer', 1100.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 14:33:59', NULL),
(687, 'INV1761664102', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 16:08:22', NULL),
(688, 'INV1761665182', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 16:26:22', NULL),
(689, 'INV1761666104', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 16:41:44', NULL),
(690, 'INV1761667073', 13, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 16:57:53', NULL),
(691, 'INV1761667414', 13, 'Walk-in Customer', 23500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 17:03:34', NULL),
(692, 'INV1761667654', 13, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 17:07:34', NULL),
(693, 'INV1761670922', 13, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 18:02:02', NULL),
(694, 'INV1761675778', 13, 'Walk-in Customer', 8500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 19:22:58', NULL),
(695, 'INV1761677385', 13, 'Walk-in Customer', 17700.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 19:49:45', NULL),
(696, 'INV1761677541', 13, 'V', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 19:52:21', NULL),
(697, 'INV1761681386', 13, 'Walk-in Customer', 8500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-28 20:56:26', NULL),
(698, 'INV1761735499', 14, 'Walk-in Customer', 55899.92, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-29 11:58:19', NULL),
(699, 'INV1761751383', 14, 'Walk-in Customer', 11500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-29 16:23:03', NULL),
(700, 'INV1761764349', 14, 'Walk-in Customer', 31300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-29 19:59:09', NULL),
(701, 'INV1761764408', 14, 'Walk-in Customer', 16000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-29 20:00:08', NULL),
(702, 'INV1761764716', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-29 20:05:16', NULL),
(703, 'INV1761817841', 14, 'Walk-in Customer', 16500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-30 10:50:41', NULL),
(704, 'INV1761837302', 14, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-30 16:15:02', NULL),
(705, 'INV1761853029', 13, 'Walk-in Customer', 32000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-30 20:37:09', NULL),
(706, 'INV1761853169', 13, 'Walk-in Customer', 12500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-30 20:39:29', NULL),
(707, 'INV1761853252', 13, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-30 20:40:52', NULL),
(708, 'INV1761899892', 14, 'Walk-in Customer', 18500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-31 09:38:12', NULL),
(709, 'INV1761918542', 14, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-31 14:49:02', NULL),
(710, 'INV1761918572', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-31 14:49:32', NULL),
(711, 'INV1761918777', 14, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-31 14:52:57', NULL),
(712, 'INV1761922057', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-31 15:47:37', NULL),
(713, 'INV1761925478', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-31 16:44:38', NULL),
(714, 'INV1761927311', 14, 'Walk-in Customer', 15000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-31 17:15:11', NULL),
(715, 'INV1761940773', 14, 'Walk-in Customer', 59300.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-10-31 20:59:33', NULL),
(716, 'INV1761990825', 14, 'Walk-in Customer', 19500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 10:53:45', NULL),
(717, 'INV1761992496', 14, 'Walk-in Customer', 1200.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 11:21:36', NULL),
(718, 'INV1761992767', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 11:26:07', NULL),
(719, 'INV1761994548', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 11:55:48', NULL),
(720, 'INV1761997969', 14, 'Walk-in Customer', 9500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 12:52:49', NULL),
(721, 'INV1761998421', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 13:00:21', NULL),
(722, 'INV1762006477', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 15:14:37', NULL),
(723, 'INV1762006956', 14, 'Walk-in Customer', 2200.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 15:22:36', NULL),
(724, 'INV1762013356', 14, 'Walk-in Customer', 14499.98, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 17:09:16', NULL),
(725, 'INV1762014589', 14, 'Walk-in Customer', 11000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 17:29:49', NULL),
(726, 'INV1762015883', 14, 'Walk-in Customer', 14000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 17:51:23', NULL),
(727, 'INV1762016566', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 18:02:46', NULL),
(728, 'INV1762017048', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 18:10:48', NULL),
(729, 'INV1762020690', 14, 'Walk-in Customer', 19500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 19:11:30', NULL),
(730, 'INV1762020813', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 19:13:33', NULL),
(731, 'INV1762022084', 14, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 19:34:44', NULL),
(732, 'INV1762022378', 14, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 19:39:38', NULL),
(733, 'INV1762022954', 14, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 19:49:14', NULL),
(734, 'INV1762023438', 14, 'Walk-in Customer', 22000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 19:57:18', NULL),
(735, 'INV1762024364', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 20:12:44', NULL),
(736, 'INV1762025347', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-01 20:29:07', NULL),
(737, 'INV1762198563', 13, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-03 20:36:03', NULL),
(738, 'INV1762198673', 13, 'Walk-in Customer', 9500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-03 20:37:53', NULL),
(739, 'INV1762199537', 14, 'Walk-in Customer', 11500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-03 20:52:17', NULL),
(740, 'INV1762199755', 14, 'Walk-in Customer', 11500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-03 20:55:55', NULL),
(741, 'INV1762200031', 14, 'Walk-in Customer', 23000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-03 21:00:31', NULL),
(742, 'INV1762242559', 14, 'Walk-in Customer', 10000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-04 08:49:19', NULL),
(743, 'INV1762251100', 14, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-04 11:11:40', NULL),
(744, 'INV1762263220', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-04 14:33:40', NULL),
(745, 'INV1762266996', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-04 15:36:36', NULL),
(746, 'INV1762280348', 13, 'Walk-in Customer', 35000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-04 19:19:08', NULL),
(747, 'INV1762280571', 13, 'Walk-in Customer', 8000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-04 19:22:51', NULL),
(748, 'INV1762348427', 14, 'Walk-in Customer', 10500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-05 14:13:47', NULL),
(749, 'INV1762348738', 14, 'Walk-in Customer', 13000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-05 14:18:58', NULL),
(750, 'INV1762349031', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-05 14:23:51', NULL),
(751, 'INV1762349094', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-05 14:24:54', NULL),
(752, 'INV1762351185', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-05 14:59:45', NULL),
(753, 'INV1762353158', 14, 'Walk-in Customer', 5600.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-05 15:32:38', NULL),
(754, 'INV1762355644', 14, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-05 16:14:04', NULL),
(755, 'INV1762362800', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-05 18:13:20', NULL),
(756, 'INV1762362939', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-05 18:15:39', NULL),
(757, 'INV1762366660', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-05 19:17:40', NULL),
(758, 'INV1762367922', 14, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-05 19:38:42', NULL),
(759, 'INV1762408926', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 07:02:06', NULL),
(760, 'INV1762417391', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 09:23:11', NULL),
(761, 'INV1762419135', 14, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 09:52:15', NULL),
(762, 'INV1762422398', 14, 'Walk-in Customer', 10500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 10:46:38', NULL),
(763, 'INV1762424004', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 11:13:24', NULL),
(764, 'INV1762424973', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 11:29:33', NULL),
(765, 'INV1762434609', 14, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 14:10:09', NULL),
(766, 'INV1762437835', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 15:03:55', NULL),
(767, 'INV1762439153', 14, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 15:25:53', NULL),
(768, 'INV1762445812', 13, 'Walk-in Customer', 11800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 17:16:52', NULL),
(769, 'INV1762446063', 13, 'CHARLES', 24000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 17:21:03', NULL),
(770, 'INV1762447855', 13, 'Walk-in Customer', 14500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 17:50:55', NULL),
(771, 'INV1762450769', 13, 'Walk-in Customer', 16400.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 18:39:29', NULL),
(772, 'INV1762454746', 13, 'CHARLES', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 19:45:46', NULL),
(773, 'INV1762454985', 13, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 19:49:45', NULL),
(774, 'INV1762455493', 13, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 19:58:13', NULL),
(775, 'INV1762456904', 13, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 20:21:44', NULL),
(776, 'INV1762458194', 13, 'Walk-in Customer', 2500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-06 20:43:14', NULL),
(777, 'INV1762503047', 14, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-07 09:10:47', NULL),
(778, 'INV1762512880', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-07 11:54:40', NULL),
(779, 'INV1762525130', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-07 15:18:50', NULL),
(780, 'INV1762528630', 14, 'Walk-in Customer', 5000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-07 16:17:10', NULL),
(781, 'INV1762530992', 14, 'Walk-in Customer', 1400.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-07 16:56:32', NULL),
(782, 'INV1762533419', 14, 'Walk-in Customer', 4000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-07 17:36:59', NULL),
(783, 'INV1762536241', 14, 'Walk-in Customera', 9500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-07 18:24:01', NULL),
(784, 'INV1762536272', 14, 'Walk-in Customer', 3000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-07 18:24:32', NULL),
(785, 'INV1762539698', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-07 19:21:38', NULL),
(786, 'INV1762540623', 14, 'Walk-in Customer', 15000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-07 19:37:03', NULL),
(787, 'INV1762541363', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-07 19:49:23', NULL),
(788, 'INV1762541969', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-07 19:59:29', NULL),
(789, 'INV1762542286', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-07 20:04:46', NULL),
(790, 'INV1762542649', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-07 20:10:49', NULL),
(791, 'INV1762581641', 14, 'Walk-in Customer', 4500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-08 07:00:41', NULL),
(792, 'INV1762589058', 14, 'Walk-in Customer', 7500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-08 09:04:18', NULL),
(793, 'INV1762612835', 14, 'Walk-in Customer', 5500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-08 15:40:35', NULL),
(794, 'INV1762612934', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-08 15:42:14', NULL),
(795, 'INV1762618687', 14, 'Walk-in Customer', 2000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-08 17:18:07', NULL),
(796, 'INV1762625322', 14, 'Walk-in Customer', 16500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-08 19:08:42', NULL),
(797, 'INV1762625443', 14, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-08 19:10:43', NULL),
(798, 'INV1762625889', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-08 19:18:09', NULL),
(799, 'INV1762627214', 14, 'Walk-in Customer', 1800.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-08 19:40:14', NULL),
(800, 'INV1762627433', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-08 19:43:53', NULL),
(801, 'INV1762629135', 14, 'Walk-in Customer', 15000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-08 20:12:15', NULL),
(802, 'INV1762629233', 14, 'Walk-in Customer', 500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-08 20:13:53', NULL),
(803, 'INV1762718684', 13, 'Walk-in Customer', 48900.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-09 21:04:44', NULL),
(804, 'INV1762718883', 13, 'z', 23500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-09 21:08:03', NULL),
(805, 'INV1762718951', 13, 'Walk-in Customer', 1500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-09 21:09:11', NULL),
(806, 'INV1762719168', 13, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-09 21:12:48', NULL),
(807, 'INV1762719294', 13, 'Walk-in Customer', 7000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-09 21:14:54', NULL),
(808, 'INV1762719706', 13, 'Walk-in Customer', 3500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-09 21:21:46', NULL),
(809, 'INV1762781391', 14, 'Walk-in Customer', 6000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-10 14:29:51', NULL),
(810, 'INV1762781477', 14, 'Walk-in Customer', 22700.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-10 14:31:17', NULL),
(811, 'INV1762781549', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-10 14:32:29', NULL),
(812, 'INV1762784265', 14, 'Walk-in Customer', 11000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-10 15:17:45', NULL),
(813, 'INV1762786791', 14, 'Walk-in Customer', 1000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-10 15:59:51', NULL),
(814, 'INV1762799766', 13, 'Walk-in Customer', 17000.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-10 19:36:06', NULL),
(815, 'INV1762800262', 13, 'charles', 41500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-10 19:44:22', NULL),
(816, 'INV1762800389', 13, 'charles', 6500.00, 0.00, 0.00, 0.00, 'cash', NULL, '2025-11-10 19:46:29', NULL);

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
(34, 21, 2990, 1.00, 5000.00, 5000.00),
(35, 22, 3065, 1.00, 5000.00, 5000.00),
(36, 22, 3097, 5.00, 400.00, 2000.00),
(37, 23, 3109, 5.00, 1000.00, 5000.00),
(38, 23, 2990, 1.00, 5000.00, 5000.00),
(39, 24, 3018, 1.00, 17000.00, 17000.00),
(40, 25, 3018, 1.00, 17000.00, 17000.00),
(41, 26, 3100, 10.00, 300.00, 3000.00),
(42, 27, 2969, 5.00, 200.00, 1000.00),
(43, 28, 3107, 5.00, 200.00, 1000.00),
(44, 29, 3163, 1.00, 1500.00, 1500.00),
(45, 29, 3165, 1.00, 500.00, 500.00),
(46, 29, 3161, 10.00, 100.00, 1000.00),
(47, 29, 3159, 1.00, 500.00, 500.00),
(48, 29, 2969, 5.00, 200.00, 1000.00),
(49, 29, 3167, 5.00, 200.00, 1000.00),
(50, 29, 3155, 2.00, 500.00, 1000.00),
(51, 29, 3168, 2.00, 600.00, 1200.00),
(52, 29, 3073, 1.00, 500.00, 500.00),
(53, 29, 3169, 5.00, 3000.00, 15000.00),
(54, 29, 3176, 15.00, 200.00, 3000.00),
(55, 29, 3174, 10.00, 1000.00, 10000.00),
(56, 29, 3148, 20.00, 500.00, 10000.00),
(57, 29, 3175, 4.00, 1500.00, 6000.00),
(58, 29, 3109, 11.00, 1000.00, 11000.00),
(59, 29, 3170, 6.00, 4000.00, 24000.00),
(60, 29, 3172, 5.00, 500.00, 2500.00),
(61, 29, 3028, 10.00, 100.00, 1000.00),
(62, 30, 3180, 20.00, 7000.00, 140000.00),
(63, 30, 3179, 1.00, 7000.00, 7000.00),
(64, 31, 2968, 10.00, 50.00, 500.00),
(65, 31, 3012, 1.00, 7000.00, 7000.00),
(66, 31, 2990, 1.00, 5000.00, 5000.00),
(68, 31, 3105, 10.00, 100.00, 1000.00),
(69, 31, 3000, 2.00, 1000.00, 2000.00),
(70, 31, 3017, 1.00, 9000.00, 9000.00),
(71, 31, 2999, 2.00, 500.00, 1000.00),
(72, 32, 3161, 5.00, 100.00, 500.00),
(74, 33, 3182, 1.00, 13000.00, 13000.00),
(75, 33, 3183, 1.00, 13000.00, 13000.00),
(76, 33, 3174, 30.00, 100.00, 3000.00),
(77, 33, 3189, 20.00, 100.00, 2000.00),
(78, 33, 3188, 10.00, 50.00, 500.00),
(79, 33, 3190, 1.00, 500.00, 500.00),
(80, 33, 3191, 10.00, 100.00, 1000.00),
(84, 34, 2972, 3.00, 1000.00, 3000.00),
(85, 34, 2988, 1.00, 7500.00, 7500.00),
(86, 34, 2968, 20.00, 50.00, 1000.00),
(87, 34, 2984, 10.00, 700.00, 7000.00),
(89, 35, 3105, 10.00, 100.00, 1000.00),
(90, 36, 3002, 1.00, 2000.00, 2000.00),
(91, 37, 3011, 10.00, 600.00, 6000.00),
(92, 38, 2999, 2.00, 500.00, 1000.00),
(93, 39, 3092, 1.00, 700.00, 700.00),
(94, 39, 3188, 10.00, 50.00, 500.00),
(95, 39, 2990, 1.00, 5000.00, 5000.00),
(96, 39, 3174, 10.00, 100.00, 1000.00),
(97, 40, 3150, 1.00, 5000.00, 5000.00),
(98, 40, 3189, 10.00, 100.00, 1000.00),
(99, 41, 2968, 10.00, 50.00, 500.00),
(100, 42, 3200, 10.00, 100.00, 1000.00),
(101, 42, 3202, 1.00, 4000.00, 4000.00),
(102, 42, 3203, 2.00, 500.00, 1000.00),
(103, 42, 3204, 1.00, 2000.00, 2000.00),
(104, 42, 3205, 20.00, 50.00, 1000.00),
(105, 42, 3150, 1.00, 5000.00, 5000.00),
(106, 42, 3189, 10.00, 100.00, 1000.00),
(107, 42, 3206, 10.00, 100.00, 1000.00),
(108, 42, 3012, 1.00, 7000.00, 7000.00),
(109, 42, 3001, 1.00, 500.00, 500.00),
(110, 42, 3209, 1.00, 3500.00, 3500.00),
(111, 42, 3210, 1.00, 700.00, 700.00),
(112, 43, 3000, 2.00, 1000.00, 2000.00),
(113, 43, 2969, 10.00, 200.00, 2000.00),
(114, 43, 3202, 1.00, 4000.00, 4000.00),
(115, 43, 3212, 2.00, 2000.00, 4000.00),
(116, 44, 3000, 2.00, 1000.00, 2000.00),
(117, 44, 2969, 10.00, 200.00, 2000.00),
(118, 44, 3202, 1.00, 4000.00, 4000.00),
(119, 44, 3212, 2.00, 2000.00, 4000.00),
(120, 44, 3088, 10.00, 200.00, 2000.00),
(121, 44, 3170, 1.00, 4000.00, 4000.00),
(122, 44, 3211, 1.00, 2000.00, 2000.00),
(123, 44, 3110, 1.00, 4500.00, 4500.00),
(124, 45, 3215, 2.00, 1000.00, 2000.00),
(125, 45, 3214, 1.00, 6000.00, 6000.00),
(126, 45, 3216, 4.00, 500.00, 2000.00),
(127, 45, 3217, 10.00, 100.00, 1000.00),
(128, 45, 3195, 1.00, 1000.00, 1000.00),
(129, 45, 3213, 3.00, 1500.00, 4500.00),
(130, 46, 3219, 1.00, 5000.00, 5000.00),
(131, 46, 3218, 20.00, 50.00, 1000.00),
(132, 46, 3106, 3.00, 2000.00, 6000.00),
(133, 47, 3220, 3.00, 1000.00, 3000.00),
(134, 47, 3106, 3.00, 2000.00, 6000.00),
(135, 47, 3190, 2.00, 500.00, 1000.00),
(136, 47, 2990, 1.00, 5000.00, 5000.00),
(137, 48, 3161, 20.00, 100.00, 2000.00),
(138, 48, 3218, 20.00, 50.00, 1000.00),
(139, 48, 3211, 1.00, 2000.00, 2000.00),
(140, 48, 2999, 5.00, 500.00, 2500.00),
(141, 48, 3002, 1.00, 2000.00, 2000.00),
(142, 48, 3155, 1.00, 500.00, 500.00),
(143, 48, 3213, 5.00, 1500.00, 7500.00),
(144, 49, 3221, 10.00, 500.00, 5000.00),
(145, 49, 3224, 1.00, 7000.00, 7000.00),
(146, 49, 3222, 20.00, 50.00, 1000.00),
(147, 50, 3131, 1.00, 6000.00, 6000.00),
(148, 51, 3135, 1.00, 3000.00, 3000.00),
(149, 52, 3218, 30.00, 50.00, 1500.00),
(150, 52, 3102, 10.00, 100.00, 1000.00),
(151, 52, 3109, 5.00, 1000.00, 5000.00),
(152, 53, 3169, 1.00, 3000.00, 3000.00),
(153, 54, 3097, 10.00, 400.00, 4000.00),
(154, 54, 3232, 10.00, 100.00, 1000.00),
(155, 55, 3008, 1.00, 1500.00, 1500.00),
(156, 56, 3203, 1.00, 500.00, 500.00),
(157, 56, 3174, 10.00, 100.00, 1000.00),
(158, 57, 3241, 1.00, 10000.00, 10000.00),
(159, 57, 3127, 1.00, 5000.00, 5000.00),
(160, 58, 3155, 4.00, 500.00, 2000.00),
(161, 59, 3209, 1.00, 3500.00, 3500.00),
(162, 60, 3172, 5.00, 500.00, 2500.00),
(163, 60, 3189, 10.00, 100.00, 1000.00),
(164, 61, 2990, 1.00, 5000.00, 5000.00),
(165, 61, 3167, 10.00, 200.00, 2000.00),
(166, 61, 3200, 10.00, 100.00, 1000.00),
(167, 61, 3209, 2.00, 3500.00, 7000.00),
(168, 61, 3014, 1.00, 5000.00, 5000.00),
(169, 61, 3095, 10.00, 100.00, 1000.00),
(170, 61, 3002, 2.00, 2000.00, 4000.00),
(171, 62, 3195, 10.00, 1000.00, 10000.00),
(172, 62, 3155, 2.00, 500.00, 1000.00),
(173, 62, 3190, 2.00, 500.00, 1000.00),
(174, 63, 2968, 40.00, 50.00, 2000.00),
(175, 64, 3004, 7.00, 1000.00, 7000.00),
(176, 65, 2996, 2.00, 1000.00, 2000.00),
(177, 66, 3205, 10.00, 50.00, 500.00),
(178, 66, 3207, 10.00, 300.00, 3000.00),
(179, 66, 3150, 1.00, 5000.00, 5000.00),
(180, 66, 3000, 4.00, 1000.00, 4000.00),
(181, 66, 3190, 1.00, 500.00, 500.00),
(182, 66, 3147, 1.00, 5000.00, 5000.00),
(183, 66, 2999, 2.00, 500.00, 1000.00),
(184, 66, 3031, 1.00, 5000.00, 5000.00),
(185, 66, 3068, 1.00, 2500.00, 2500.00),
(186, 66, 3215, 1.00, 1000.00, 1000.00),
(187, 66, 2969, 10.00, 200.00, 2000.00),
(188, 66, 3211, 1.00, 2000.00, 2000.00),
(189, 66, 3189, 10.00, 100.00, 1000.00),
(190, 67, 3161, 10.00, 100.00, 1000.00),
(191, 68, 3065, 1.00, 5000.00, 5000.00),
(192, 68, 3249, 4.00, 500.00, 2000.00),
(193, 68, 3248, 4.00, 500.00, 2000.00),
(194, 68, 3250, 2.00, 500.00, 1000.00),
(195, 68, 3251, 10.00, 100.00, 1000.00),
(196, 69, 3252, 5.00, 400.00, 2000.00),
(197, 70, 3105, 20.00, 100.00, 2000.00),
(198, 70, 3124, 1.00, 2000.00, 2000.00),
(199, 71, 3230, 1.00, 4500.00, 4500.00),
(200, 71, 3190, 1.00, 500.00, 500.00),
(201, 71, 3134, 1.00, 5000.00, 5000.00),
(202, 71, 3218, 20.00, 50.00, 1000.00),
(203, 72, 3260, 1.00, 10000.00, 10000.00),
(204, 72, 3259, 2.00, 1000.00, 2000.00),
(205, 72, 3117, 4.00, 1000.00, 4000.00),
(206, 73, 3001, 2.00, 500.00, 1000.00),
(207, 73, 3170, 1.00, 4000.00, 4000.00),
(208, 74, 3261, 3.00, 500.00, 1500.00),
(209, 75, 3134, 1.00, 5000.00, 5000.00),
(210, 75, 3129, 1.00, 4000.00, 4000.00),
(211, 75, 2968, 20.00, 50.00, 1000.00),
(212, 75, 3210, 2.00, 1000.00, 2000.00),
(213, 76, 3251, 10.00, 100.00, 1000.00),
(214, 76, 3197, 5.00, 200.00, 1000.00),
(215, 76, 3161, 10.00, 100.00, 1000.00),
(216, 77, 3209, 1.00, 3500.00, 3500.00),
(217, 77, 3218, 10.00, 50.00, 500.00),
(218, 77, 3226, 1.00, 6500.00, 6500.00),
(219, 77, 3210, 1.00, 700.00, 700.00),
(220, 77, 3168, 1.00, 600.00, 600.00),
(221, 77, 3251, 5.00, 100.00, 500.00),
(222, 77, 3190, 1.00, 500.00, 500.00),
(223, 78, 2995, 1.00, 1300.00, 1300.00),
(224, 78, 2999, 2.00, 500.00, 1000.00),
(225, 78, 3238, 5.00, 200.00, 1000.00),
(226, 78, 3002, 1.00, 2000.00, 2000.00),
(227, 78, 3117, 2.00, 1000.00, 2000.00),
(228, 79, 3232, 10.00, 100.00, 1000.00),
(229, 80, 3262, 2.00, 500.00, 1000.00),
(230, 80, 3263, 20.00, 50.00, 1000.00),
(231, 80, 3264, 10.00, 100.00, 1000.00),
(232, 80, 3266, 2.00, 500.00, 1000.00),
(233, 80, 3267, 10.00, 500.00, 5000.00),
(234, 80, 3268, 10.00, 500.00, 5000.00),
(235, 80, 3265, 1.00, 4000.00, 4000.00),
(237, 82, 3188, 10.00, 50.00, 500.00),
(238, 81, 3188, 10.00, 50.00, 500.00),
(239, 83, 3267, 10.00, 500.00, 5000.00),
(240, 83, 3000, 3.00, 1000.00, 3000.00),
(241, 84, 3259, 2.00, 1000.00, 2000.00),
(242, 84, 3172, 5.00, 500.00, 2500.00),
(243, 85, 3032, 1.00, 4000.00, 4000.00),
(244, 85, 3213, 10.00, 1500.00, 15000.00),
(245, 86, 3200, 20.00, 100.00, 2000.00),
(246, 86, 2990, 1.00, 5000.00, 5000.00),
(247, 87, 3001, 2.00, 500.00, 1000.00),
(248, 87, 3161, 20.00, 100.00, 2000.00),
(249, 88, 3269, 10.00, 1000.00, 10000.00),
(257, 90, 2999, 6.00, 500.00, 3000.00),
(258, 90, 3218, 30.00, 50.00, 1500.00),
(259, 91, 3174, 10.00, 100.00, 1000.00),
(260, 92, 2995, 1.00, 1300.00, 1300.00),
(261, 92, 3266, 1.00, 500.00, 500.00),
(262, 92, 3216, 3.00, 500.00, 1500.00),
(263, 92, 3238, 5.00, 200.00, 1000.00),
(264, 93, 3205, 10.00, 50.00, 500.00),
(265, 93, 3206, 5.00, 100.00, 500.00),
(266, 93, 3259, 2.00, 1000.00, 2000.00),
(267, 93, 3068, 1.00, 2500.00, 2500.00),
(270, 94, 3274, 1.00, 1500.00, 1500.00),
(271, 94, 3272, 20.00, 200.00, 4000.00),
(272, 94, 3200, 10.00, 100.00, 1000.00),
(273, 94, 3273, 5.00, 200.00, 1000.00),
(274, 94, 3271, 12.00, 250.00, 3000.00),
(275, 95, 3174, 10.00, 100.00, 1000.00),
(276, 95, 3197, 5.00, 200.00, 1000.00),
(277, 95, 3029, 10.00, 100.00, 1000.00),
(278, 95, 2972, 2.00, 1000.00, 2000.00),
(279, 95, 3002, 1.00, 2000.00, 2000.00),
(280, 95, 3032, 1.00, 4000.00, 4000.00),
(281, 95, 3170, 5.00, 4000.00, 20000.00),
(282, 95, 3171, 5.00, 1500.00, 7500.00),
(283, 95, 3261, 1.00, 500.00, 500.00),
(284, 96, 3275, 2.00, 500.00, 1000.00),
(285, 96, 3276, 2.00, 5000.00, 10000.00),
(286, 97, 3205, 10.00, 50.00, 500.00),
(287, 97, 3249, 3.00, 500.00, 1500.00),
(288, 97, 2972, 1.00, 1000.00, 1000.00),
(289, 89, 3211, 1.00, 2000.00, 2000.00),
(290, 89, 3049, 1.00, 5000.00, 5000.00),
(291, 89, 3210, 1.00, 700.00, 700.00),
(292, 89, 2969, 10.00, 200.00, 2000.00),
(293, 89, 3042, 1.00, 7000.00, 7000.00),
(294, 89, 3145, 1.00, 2000.00, 2000.00),
(295, 98, 3200, 10.00, 100.00, 1000.00),
(296, 98, 3213, 3.00, 1500.00, 4500.00),
(297, 98, 3174, 10.00, 100.00, 1000.00),
(298, 98, 3216, 5.00, 500.00, 2500.00),
(299, 98, 3000, 10.00, 1000.00, 10000.00),
(300, 98, 3273, 10.00, 200.00, 2000.00),
(301, 98, 3197, 10.00, 200.00, 2000.00),
(302, 98, 3252, 5.00, 400.00, 2000.00),
(303, 98, 2969, 15.00, 200.00, 3000.00),
(304, 98, 2995, 1.00, 1300.00, 1300.00),
(305, 98, 3266, 1.00, 500.00, 500.00),
(306, 98, 2968, 10.00, 50.00, 500.00),
(307, 99, 3280, 1.00, 1500.00, 1500.00),
(308, 99, 3279, 10.00, 300.00, 3000.00),
(309, 99, 3123, 4.00, 1500.00, 6000.00),
(310, 99, 3278, 10.00, 400.00, 4000.00),
(311, 100, 3213, 3.00, 1500.00, 4500.00),
(312, 101, 3209, 2.00, 3500.00, 7000.00),
(313, 101, 3123, 1.00, 1500.00, 1500.00),
(314, 101, 3167, 10.00, 200.00, 2000.00),
(317, 102, 3108, 5.00, 200.00, 1000.00),
(318, 102, 2969, 5.00, 200.00, 1000.00),
(319, 103, 3000, 2.00, 1000.00, 2000.00),
(320, 103, 2990, 1.00, 5000.00, 5000.00),
(321, 103, 3026, 10.00, 700.00, 7000.00),
(322, 103, 3028, 10.00, 100.00, 1000.00),
(323, 104, 2969, 5.00, 200.00, 1000.00),
(324, 104, 3189, 10.00, 100.00, 1000.00),
(325, 104, 3155, 10.00, 500.00, 5000.00),
(326, 105, 3269, 2.00, 1500.00, 3000.00),
(327, 106, 3283, 2.00, 500.00, 1000.00),
(328, 107, 3271, 12.00, 250.00, 3000.00),
(329, 108, 3032, 1.00, 4000.00, 4000.00),
(330, 108, 3251, 10.00, 100.00, 1000.00),
(331, 109, 3269, 1.00, 1500.00, 1500.00),
(332, 110, 3241, 1.00, 10000.00, 10000.00),
(333, 111, 3002, 1.00, 2000.00, 2000.00),
(334, 111, 2995, 1.00, 1300.00, 1300.00),
(335, 111, 3266, 1.00, 500.00, 500.00),
(336, 111, 3165, 1.00, 500.00, 500.00),
(337, 111, 3159, 1.00, 500.00, 500.00),
(338, 111, 3205, 10.00, 50.00, 500.00),
(339, 111, 3220, 2.00, 1000.00, 2000.00),
(340, 112, 3002, 1.00, 2000.00, 2000.00),
(341, 112, 2994, 3.00, 2500.00, 7500.00),
(342, 112, 3211, 1.00, 2000.00, 2000.00),
(343, 113, 2972, 1.00, 1000.00, 1000.00),
(344, 113, 3131, 1.00, 6000.00, 6000.00),
(345, 113, 3275, 2.00, 600.00, 1200.00),
(346, 113, 3002, 3.00, 2000.00, 6000.00),
(347, 113, 3186, 1.00, 2000.00, 2000.00),
(348, 113, 2969, 15.00, 200.00, 3000.00),
(349, 113, 2999, 9.00, 500.00, 4500.00),
(350, 113, 3128, 1.00, 8000.00, 8000.00),
(351, 113, 3289, 1.00, 2000.00, 2000.00),
(352, 113, 3000, 2.00, 1000.00, 2000.00),
(353, 113, 3107, 10.00, 200.00, 2000.00),
(354, 113, 3155, 2.00, 500.00, 1000.00),
(355, 113, 3251, 20.00, 100.00, 2000.00),
(356, 113, 3269, 1.00, 1500.00, 1500.00),
(357, 114, 3211, 2.00, 2000.00, 4000.00),
(358, 115, 2968, 10.00, 50.00, 500.00),
(359, 116, 2968, 20.00, 50.00, 1000.00),
(360, 116, 2999, 10.00, 500.00, 5000.00),
(361, 116, 3152, 1.00, 1000.00, 1000.00),
(362, 116, 3228, 5.00, 200.00, 1000.00),
(363, 117, 2968, 10.00, 50.00, 500.00),
(364, 118, 3190, 1.00, 500.00, 500.00),
(365, 118, 2968, 20.00, 50.00, 1000.00),
(366, 118, 3187, 1.00, 2000.00, 2000.00),
(367, 118, 3252, 5.00, 400.00, 2000.00),
(368, 118, 3165, 2.00, 500.00, 1000.00),
(369, 119, 3170, 1.00, 4000.00, 4000.00),
(370, 119, 3232, 5.00, 100.00, 500.00),
(371, 119, 2969, 5.00, 200.00, 1000.00),
(372, 120, 2995, 1.00, 1300.00, 1300.00),
(373, 120, 2969, 5.00, 200.00, 1000.00),
(374, 120, 3205, 10.00, 50.00, 500.00),
(375, 120, 3151, 1.00, 2000.00, 2000.00),
(376, 120, 3269, 1.00, 1500.00, 1500.00),
(377, 121, 3210, 1.00, 700.00, 700.00),
(378, 121, 3216, 4.00, 500.00, 2000.00),
(379, 121, 3089, 1.00, 3000.00, 3000.00),
(380, 121, 3107, 10.00, 200.00, 2000.00),
(381, 122, 3289, 2.00, 2000.00, 4000.00),
(382, 122, 3124, 1.00, 2000.00, 2000.00),
(383, 122, 3128, 1.00, 8000.00, 8000.00),
(384, 122, 3286, 2.00, 5000.00, 10000.00),
(385, 123, 3206, 40.00, 100.00, 4000.00),
(386, 123, 3001, 2.00, 500.00, 1000.00),
(387, 123, 2969, 5.00, 200.00, 1000.00),
(388, 123, 3189, 10.00, 100.00, 1000.00),
(389, 123, 3269, 2.00, 1500.00, 3000.00),
(390, 123, 2995, 1.00, 1300.00, 1300.00),
(391, 123, 3029, 30.00, 100.00, 3000.00),
(392, 123, 3264, 20.00, 100.00, 2000.00),
(393, 123, 3205, 10.00, 50.00, 500.00),
(394, 123, 3259, 3.00, 1000.00, 3000.00),
(395, 123, 3002, 4.00, 2000.00, 8000.00),
(396, 123, 3031, 1.00, 5000.00, 5000.00),
(397, 123, 3155, 2.00, 500.00, 1000.00),
(398, 123, 3011, 10.00, 600.00, 6000.00),
(399, 123, 3161, 10.00, 100.00, 1000.00),
(400, 123, 3150, 1.00, 5000.00, 5000.00),
(401, 123, 3109, 3.00, 1000.00, 3000.00),
(402, 123, 2999, 2.00, 500.00, 1000.00),
(403, 123, 3218, 10.00, 50.00, 500.00),
(404, 124, 3098, 5.00, 200.00, 1000.00),
(405, 124, 3014, 1.00, 5000.00, 5000.00),
(406, 124, 3172, 10.00, 500.00, 5000.00),
(407, 125, 3001, 2.00, 500.00, 1000.00),
(408, 125, 3249, 8.00, 500.00, 4000.00),
(409, 126, 3167, 5.00, 200.00, 1000.00),
(410, 126, 2971, 2.00, 1000.00, 2000.00),
(411, 126, 3174, 20.00, 100.00, 2000.00),
(412, 127, 2996, 1.00, 1000.00, 1000.00),
(413, 127, 2968, 10.00, 50.00, 500.00),
(414, 128, 3206, 10.00, 100.00, 1000.00),
(415, 129, 2990, 1.00, 5000.00, 5000.00),
(416, 129, 3286, 1.00, 5000.00, 5000.00),
(417, 130, 3211, 1.00, 2000.00, 2000.00),
(418, 131, 3174, 10.00, 100.00, 1000.00),
(419, 132, 3273, 5.00, 200.00, 1000.00),
(420, 132, 2969, 10.00, 200.00, 2000.00),
(421, 132, 3107, 5.00, 200.00, 1000.00),
(422, 132, 3220, 1.00, 1000.00, 1000.00),
(423, 133, 2969, 20.00, 200.00, 4000.00),
(424, 134, 3240, 1.00, 500.00, 500.00),
(425, 135, 2990, 1.00, 5000.00, 5000.00),
(426, 135, 3136, 1.00, 8000.00, 8000.00),
(427, 135, 2999, 5.00, 500.00, 2500.00),
(428, 135, 2968, 10.00, 50.00, 500.00),
(429, 135, 3286, 2.00, 5000.00, 10000.00),
(430, 136, 3247, 5.00, 2000.00, 10000.00),
(431, 136, 3272, 15.00, 200.00, 3000.00),
(432, 136, 3000, 1.00, 1000.00, 1000.00),
(433, 136, 3261, 1.00, 500.00, 500.00),
(434, 137, 3161, 10.00, 100.00, 1000.00),
(435, 138, 3134, 1.00, 5000.00, 5000.00),
(436, 139, 2995, 1.00, 1300.00, 1300.00),
(437, 139, 2968, 10.00, 50.00, 500.00),
(438, 139, 3269, 2.00, 1500.00, 3000.00),
(439, 139, 3151, 1.00, 2000.00, 2000.00),
(440, 139, 2969, 5.00, 200.00, 1000.00),
(441, 140, 3241, 1.00, 10000.00, 10000.00),
(442, 141, 3001, 2.00, 500.00, 1000.00),
(443, 142, 3003, 1.00, 5000.00, 5000.00),
(444, 142, 3000, 4.00, 1000.00, 4000.00),
(445, 143, 3167, 5.00, 200.00, 1000.00),
(446, 144, 3292, 1.00, 2500.00, 2500.00),
(447, 144, 3291, 10.00, 1000.00, 10000.00),
(448, 145, 3261, 2.00, 500.00, 1000.00),
(449, 146, 3098, 5.00, 200.00, 1000.00),
(450, 146, 2971, 2.00, 1000.00, 2000.00),
(451, 147, 3107, 15.00, 200.00, 3000.00),
(457, 149, 3165, 2.00, 500.00, 1000.00),
(458, 150, 3057, 2.00, 1000.00, 2000.00),
(459, 150, 3179, 1.00, 7000.00, 7000.00),
(460, 148, 3002, 1.00, 2000.00, 2000.00),
(461, 148, 3250, 2.00, 500.00, 1000.00),
(462, 148, 3257, 1.00, 500.00, 500.00),
(463, 148, 3161, 10.00, 100.00, 1000.00),
(464, 148, 3289, 1.00, 2000.00, 2000.00),
(465, 151, 3298, 1.00, 11000.00, 11000.00),
(466, 151, 3296, 1.00, 3000.00, 3000.00),
(467, 151, 3294, 1.00, 12000.00, 12000.00),
(468, 152, 3301, 2.00, 1500.00, 3000.00),
(469, 152, 3303, 5.00, 100.00, 500.00),
(470, 152, 3302, 1.00, 500.00, 500.00),
(471, 153, 3202, 1.00, 4000.00, 4000.00),
(472, 154, 2978, 1.00, 10000.00, 10000.00),
(473, 154, 3137, 1.00, 6000.00, 6000.00),
(474, 155, 3306, 1.00, 500.00, 500.00),
(475, 155, 3258, 1.00, 2000.00, 2000.00),
(476, 155, 3304, 6.00, 1500.00, 9000.00),
(477, 155, 3280, 4.00, 1500.00, 6000.00),
(478, 155, 3254, 1.00, 2000.00, 2000.00),
(479, 155, 3076, 1.00, 3000.00, 3000.00),
(480, 156, 3269, 2.00, 1500.00, 3000.00),
(481, 156, 3049, 1.00, 5000.00, 5000.00),
(482, 156, 2979, 1.00, 23000.00, 23000.00),
(483, 156, 3205, 10.00, 50.00, 500.00),
(484, 156, 3218, 10.00, 50.00, 500.00),
(485, 157, 3280, 3.00, 1500.00, 4500.00),
(486, 157, 3000, 6.00, 1000.00, 6000.00),
(487, 157, 3057, 1.00, 1000.00, 1000.00),
(488, 158, 3307, 1.00, 3000.00, 3000.00),
(489, 159, 3029, 10.00, 100.00, 1000.00),
(490, 160, 3205, 10.00, 50.00, 500.00),
(491, 160, 3167, 5.00, 200.00, 1000.00),
(492, 160, 3000, 1.00, 1000.00, 1000.00),
(493, 160, 3250, 2.00, 500.00, 1000.00),
(494, 160, 3216, 2.00, 500.00, 1000.00),
(495, 160, 3211, 1.00, 2000.00, 2000.00),
(496, 161, 3289, 1.00, 2000.00, 2000.00),
(497, 161, 3128, 1.00, 8000.00, 8000.00),
(498, 161, 2990, 1.00, 5000.00, 5000.00),
(499, 161, 3218, 10.00, 50.00, 500.00),
(500, 161, 3251, 10.00, 100.00, 1000.00),
(501, 161, 2968, 10.00, 50.00, 500.00),
(502, 161, 3165, 1.00, 500.00, 500.00),
(503, 161, 3167, 5.00, 200.00, 1000.00),
(504, 162, 3000, 1.00, 1000.00, 1000.00),
(505, 163, 2999, 2.00, 500.00, 1000.00),
(506, 164, 3241, 1.00, 10000.00, 10000.00),
(512, 166, 3094, 0.50, 2000.00, 1000.00),
(513, 167, 3209, 1.00, 3500.00, 3500.00),
(514, 168, 3289, 1.00, 2000.00, 2000.00),
(515, 168, 3127, 1.00, 5000.00, 5000.00),
(516, 165, 3257, 1.00, 500.00, 500.00),
(517, 165, 3205, 20.00, 50.00, 1000.00),
(518, 165, 3155, 2.00, 500.00, 1000.00),
(519, 165, 3230, 1.00, 4500.00, 4500.00),
(520, 169, 3129, 1.00, 4000.00, 4000.00),
(521, 169, 2971, 1.00, 1000.00, 1000.00),
(522, 169, 3092, 2.00, 700.00, 1400.00),
(523, 169, 3098, 5.00, 200.00, 1000.00),
(524, 169, 3161, 10.00, 100.00, 1000.00),
(525, 169, 3205, 10.00, 50.00, 500.00),
(526, 169, 2968, 10.00, 50.00, 500.00),
(527, 169, 3318, 2.00, 1500.00, 3000.00),
(528, 169, 3317, 1.00, 12000.00, 12000.00),
(529, 169, 3136, 1.00, 8000.00, 8000.00),
(530, 169, 3263, 20.00, 50.00, 1000.00),
(531, 170, 3315, 3.00, 1000.00, 3000.00),
(532, 171, 3155, 6.00, 500.00, 3000.00),
(533, 171, 3250, 4.00, 500.00, 2000.00),
(534, 172, 2990, 1.00, 5000.00, 5000.00),
(535, 172, 3180, 10.00, 100.00, 1000.00),
(536, 173, 3107, 5.00, 200.00, 1000.00),
(537, 174, 3258, 1.00, 2000.00, 2000.00),
(538, 174, 3218, 10.00, 50.00, 500.00),
(539, 174, 3001, 1.00, 500.00, 500.00),
(540, 174, 3174, 10.00, 100.00, 1000.00),
(541, 174, 3180, 10.00, 100.00, 1000.00),
(542, 174, 3211, 1.00, 2000.00, 2000.00),
(543, 174, 3175, 1.00, 1500.00, 1500.00),
(544, 174, 3105, 10.00, 100.00, 1000.00),
(545, 174, 2968, 10.00, 50.00, 500.00),
(546, 175, 3271, 12.00, 250.00, 3000.00),
(547, 175, 2968, 10.00, 50.00, 500.00),
(548, 175, 3101, 10.00, 150.00, 1500.00),
(549, 175, 3094, 5.00, 200.00, 1000.00),
(550, 176, 3319, 1.00, 12000.00, 12000.00),
(551, 176, 3258, 3.00, 2000.00, 6000.00),
(552, 176, 3213, 3.00, 1500.00, 4500.00),
(553, 176, 2968, 10.00, 50.00, 500.00),
(554, 176, 3306, 1.00, 500.00, 500.00),
(555, 176, 3205, 20.00, 50.00, 1000.00),
(556, 177, 3210, 1.00, 1000.00, 1000.00),
(557, 177, 3250, 2.00, 500.00, 1000.00),
(558, 177, 3285, 2.00, 5000.00, 10000.00),
(559, 177, 3287, 1.00, 5000.00, 5000.00),
(560, 177, 3167, 10.00, 200.00, 2000.00),
(561, 177, 3314, 2.00, 5000.00, 10000.00),
(562, 177, 3294, 1.00, 12000.00, 12000.00),
(563, 177, 2999, 2.00, 500.00, 1000.00),
(564, 177, 2996, 1.00, 1000.00, 1000.00),
(565, 178, 3323, 1.00, 18000.00, 18000.00),
(566, 178, 3174, 20.00, 100.00, 2000.00),
(567, 178, 3249, 10.00, 500.00, 5000.00),
(568, 178, 3322, 1.00, 23000.00, 23000.00),
(569, 178, 2969, 10.00, 200.00, 2000.00),
(570, 178, 3180, 5.00, 100.00, 500.00),
(571, 178, 3215, 2.00, 1000.00, 2000.00),
(572, 178, 3108, 90.00, 200.00, 18000.00),
(573, 179, 3258, 5.00, 2000.00, 10000.00),
(574, 179, 3176, 15.00, 200.00, 3000.00),
(575, 179, 3219, 1.00, 2000.00, 2000.00),
(576, 180, 3165, 2.00, 500.00, 1000.00),
(577, 180, 3216, 2.00, 500.00, 1000.00),
(578, 180, 3211, 1.00, 2000.00, 2000.00),
(579, 180, 3209, 1.00, 3500.00, 3500.00),
(580, 180, 3117, 1.00, 1000.00, 1000.00),
(581, 180, 3252, 5.00, 400.00, 2000.00),
(582, 181, 3249, 2.00, 500.00, 1000.00),
(583, 182, 3294, 1.00, 12000.00, 12000.00),
(584, 182, 3150, 1.00, 4000.00, 4000.00),
(585, 183, 3001, 4.00, 500.00, 2000.00),
(586, 183, 3272, 15.00, 200.00, 3000.00),
(587, 183, 3189, 30.00, 100.00, 3000.00),
(588, 183, 3093, 20.00, 1000.00, 20000.00),
(589, 183, 2988, 1.00, 7500.00, 7500.00),
(590, 183, 3249, 10.00, 500.00, 5000.00),
(591, 183, 3256, 1.00, 7000.00, 7000.00),
(592, 183, 3167, 10.00, 200.00, 2000.00),
(593, 183, 3172, 3.00, 500.00, 1500.00),
(594, 183, 3218, 10.00, 50.00, 500.00),
(595, 184, 3271, 12.00, 250.00, 3000.00),
(596, 184, 3263, 10.00, 50.00, 500.00),
(597, 185, 2977, 1.00, 23000.00, 23000.00),
(598, 186, 3057, 1.00, 1000.00, 1000.00),
(599, 187, 3205, 10.00, 50.00, 500.00),
(600, 187, 3001, 3.00, 500.00, 1500.00),
(601, 188, 3131, 1.00, 6000.00, 6000.00),
(602, 189, 3036, 1.00, 3500.00, 3500.00),
(603, 190, 3218, 10.00, 50.00, 500.00),
(604, 190, 3206, 5.00, 100.00, 500.00),
(605, 190, 3094, 10.00, 200.00, 2000.00),
(606, 191, 3209, 1.00, 3500.00, 3500.00),
(607, 191, 3211, 1.00, 2000.00, 2000.00),
(608, 192, 3261, 2.00, 500.00, 1000.00),
(609, 192, 3211, 1.00, 2000.00, 2000.00),
(610, 193, 3205, 10.00, 50.00, 500.00),
(611, 193, 3249, 1.00, 500.00, 500.00),
(612, 193, 2972, 1.00, 1000.00, 1000.00),
(613, 193, 2995, 1.00, 1300.00, 1300.00),
(614, 193, 3259, 2.00, 1000.00, 2000.00),
(615, 193, 3247, 1.00, 2000.00, 2000.00),
(616, 193, 2969, 5.00, 200.00, 1000.00),
(617, 194, 3324, 10.00, 200.00, 2000.00),
(619, 195, 3326, 10.00, 100.00, 1000.00),
(620, 196, 3211, 1.00, 2000.00, 2000.00),
(621, 197, 3127, 1.00, 5000.00, 5000.00),
(622, 197, 3032, 1.00, 4000.00, 4000.00),
(623, 197, 3170, 7.00, 4000.00, 28000.00),
(624, 197, 3097, 10.00, 400.00, 4000.00),
(625, 198, 2990, 2.00, 5000.00, 10000.00),
(626, 198, 2968, 20.00, 50.00, 1000.00),
(627, 198, 3200, 10.00, 100.00, 1000.00),
(628, 198, 3174, 10.00, 100.00, 1000.00),
(629, 199, 3216, 2.00, 500.00, 1000.00),
(630, 199, 2971, 2.00, 1000.00, 2000.00),
(631, 199, 2968, 20.00, 50.00, 1000.00),
(632, 199, 3172, 2.00, 500.00, 1000.00),
(633, 199, 3267, 2.00, 500.00, 1000.00),
(634, 200, 3318, 3.00, 1500.00, 4500.00),
(635, 200, 3291, 1.00, 1000.00, 1000.00),
(636, 201, 3167, 5.00, 200.00, 1000.00),
(637, 201, 3127, 1.00, 5000.00, 5000.00),
(638, 202, 2968, 20.00, 50.00, 1000.00),
(639, 203, 3109, 3.00, 1000.00, 3000.00),
(640, 203, 3176, 5.00, 200.00, 1000.00),
(641, 203, 3272, 5.00, 200.00, 1000.00),
(642, 204, 3200, 10.00, 100.00, 1000.00),
(643, 204, 3190, 1.00, 500.00, 500.00),
(644, 204, 3029, 10.00, 100.00, 1000.00),
(645, 205, 3211, 2.00, 2000.00, 4000.00),
(646, 205, 3195, 1.00, 1000.00, 1000.00),
(647, 205, 3165, 2.00, 500.00, 1000.00),
(648, 205, 3315, 2.00, 1000.00, 2000.00),
(649, 205, 3147, 1.00, 5000.00, 5000.00),
(650, 205, 2999, 10.00, 500.00, 5000.00),
(651, 205, 3289, 1.00, 2000.00, 2000.00),
(652, 205, 3128, 1.00, 8000.00, 8000.00),
(653, 206, 3032, 1.00, 4000.00, 4000.00),
(654, 207, 3286, 1.00, 4000.00, 4000.00),
(655, 208, 3174, 10.00, 100.00, 1000.00),
(656, 208, 3188, 20.00, 50.00, 1000.00),
(657, 209, 2999, 2.00, 500.00, 1000.00),
(658, 210, 3190, 1.00, 500.00, 500.00),
(659, 211, 3174, 30.00, 100.00, 3000.00),
(660, 211, 3261, 3.00, 500.00, 1500.00),
(661, 211, 3206, 20.00, 100.00, 2000.00),
(662, 211, 2982, 1.00, 1500.00, 1500.00),
(663, 211, 3212, 1.00, 2000.00, 2000.00),
(664, 211, 3285, 2.00, 5000.00, 10000.00),
(665, 211, 2968, 10.00, 50.00, 500.00),
(666, 211, 3308, 10.00, 200.00, 2000.00),
(667, 211, 3192, 1.00, 2000.00, 2000.00),
(668, 211, 3161, 10.00, 100.00, 1000.00),
(669, 212, 3197, 5.00, 200.00, 1000.00),
(670, 212, 3211, 1.00, 2000.00, 2000.00),
(671, 213, 3029, 10.00, 100.00, 1000.00),
(672, 213, 3165, 2.00, 500.00, 1000.00),
(673, 214, 3274, 1.00, 1500.00, 1500.00),
(674, 214, 3327, 1.00, 4000.00, 4000.00),
(675, 214, 3014, 1.00, 5000.00, 5000.00),
(676, 214, 3328, 1.00, 8000.00, 8000.00),
(677, 214, 3029, 10.00, 100.00, 1000.00),
(678, 214, 3073, 1.00, 500.00, 500.00),
(679, 214, 3213, 2.00, 1500.00, 3000.00),
(680, 214, 3272, 5.00, 200.00, 1000.00),
(681, 214, 3189, 10.00, 100.00, 1000.00),
(682, 215, 3329, 5.00, 400.00, 2000.00),
(683, 216, 3167, 5.00, 200.00, 1000.00),
(684, 217, 3124, 2.00, 2000.00, 4000.00),
(685, 217, 3289, 2.00, 2000.00, 4000.00),
(686, 217, 2968, 20.00, 50.00, 1000.00),
(687, 218, 3066, 1.00, 3000.00, 3000.00),
(688, 218, 3108, 10.00, 200.00, 2000.00),
(689, 219, 3020, 1.00, 8000.00, 8000.00),
(690, 219, 3189, 10.00, 100.00, 1000.00),
(691, 220, 3088, 10.00, 250.00, 2500.00),
(692, 220, 3174, 10.00, 100.00, 1000.00),
(693, 220, 3308, 20.00, 200.00, 4000.00),
(694, 220, 3180, 10.00, 100.00, 1000.00),
(695, 221, 3150, 1.00, 5000.00, 5000.00),
(696, 221, 2999, 5.00, 500.00, 2500.00),
(697, 222, 3226, 1.00, 6000.00, 6000.00),
(698, 223, 3190, 2.00, 500.00, 1000.00),
(699, 223, 3263, 10.00, 50.00, 500.00),
(700, 224, 3134, 1.00, 5000.00, 5000.00),
(701, 225, 2971, 1.00, 1000.00, 1000.00),
(702, 225, 3189, 20.00, 100.00, 2000.00),
(703, 225, 3212, 1.00, 2000.00, 2000.00),
(704, 225, 2982, 1.00, 1500.00, 1500.00),
(705, 225, 3029, 10.00, 100.00, 1000.00),
(706, 225, 3186, 1.00, 2000.00, 2000.00),
(707, 225, 3254, 1.00, 2000.00, 2000.00),
(708, 225, 3147, 1.00, 5000.00, 5000.00),
(709, 225, 2968, 10.00, 50.00, 500.00),
(710, 226, 3318, 3.00, 1500.00, 4500.00),
(711, 226, 2993, 3.00, 1300.00, 3900.00),
(712, 226, 3329, 5.00, 400.00, 2000.00),
(713, 226, 3127, 1.00, 5000.00, 5000.00),
(714, 226, 3289, 1.00, 2000.00, 2000.00),
(715, 227, 3330, 2.00, 17000.00, 34000.00),
(716, 228, 2995, 1.00, 1300.00, 1300.00),
(717, 228, 3259, 1.00, 1000.00, 1000.00),
(718, 228, 3247, 1.00, 2000.00, 2000.00),
(719, 228, 2969, 5.00, 200.00, 1000.00),
(720, 229, 3218, 20.00, 50.00, 1000.00),
(721, 229, 3272, 5.00, 200.00, 1000.00),
(722, 230, 3107, 5.00, 200.00, 1000.00),
(723, 231, 2968, 20.00, 50.00, 1000.00),
(724, 231, 3205, 20.00, 50.00, 1000.00),
(725, 231, 3200, 10.00, 100.00, 1000.00),
(726, 231, 3057, 1.00, 1000.00, 1000.00),
(727, 231, 2969, 20.00, 200.00, 4000.00),
(728, 231, 3161, 20.00, 100.00, 2000.00),
(729, 231, 3261, 2.00, 500.00, 1000.00),
(730, 231, 3093, 10.00, 1000.00, 10000.00),
(731, 231, 3189, 10.00, 100.00, 1000.00),
(732, 232, 2982, 1.00, 1500.00, 1500.00),
(733, 232, 3003, 1.00, 5000.00, 5000.00),
(734, 232, 3118, 1.00, 4000.00, 4000.00),
(735, 232, 3117, 3.00, 1000.00, 3000.00),
(736, 232, 3098, 5.00, 200.00, 1000.00),
(737, 233, 3251, 10.00, 100.00, 1000.00),
(738, 233, 3161, 10.00, 100.00, 1000.00),
(739, 233, 3218, 10.00, 50.00, 500.00),
(740, 234, 3228, 10.00, 200.00, 2000.00),
(741, 234, 3304, 6.00, 1500.00, 9000.00),
(742, 234, 3280, 1.00, 1500.00, 1500.00),
(743, 235, 3345, 2.00, 500.00, 1000.00),
(744, 236, 3274, 1.00, 1500.00, 1500.00),
(745, 236, 3000, 1.00, 1000.00, 1000.00),
(746, 236, 2990, 1.00, 5000.00, 5000.00),
(747, 237, 3001, 4.00, 500.00, 2000.00),
(748, 237, 3259, 3.00, 1000.00, 3000.00),
(749, 237, 3000, 4.00, 1000.00, 4000.00),
(750, 238, 3001, 2.00, 500.00, 1000.00),
(751, 238, 3055, 1.00, 3000.00, 3000.00),
(752, 238, 3211, 2.00, 2000.00, 4000.00),
(753, 239, 3033, 1.00, 24000.00, 24000.00),
(754, 239, 3031, 1.00, 5000.00, 5000.00),
(755, 239, 3014, 1.00, 5000.00, 5000.00),
(756, 239, 3011, 10.00, 600.00, 6000.00),
(757, 239, 3029, 20.00, 100.00, 2000.00),
(758, 239, 3102, 20.00, 100.00, 2000.00),
(759, 239, 3222, 40.00, 50.00, 2000.00),
(760, 239, 3172, 10.00, 500.00, 5000.00),
(761, 240, 3349, 10.00, 600.00, 6000.00),
(762, 240, 3347, 1.00, 1500.00, 1500.00),
(763, 241, 3005, 1.00, 5000.00, 5000.00),
(764, 241, 3094, 5.00, 200.00, 1000.00),
(765, 242, 3188, 20.00, 50.00, 1000.00),
(766, 243, 3329, 30.00, 400.00, 12000.00),
(767, 243, 2968, 20.00, 50.00, 1000.00),
(768, 243, 3000, 4.00, 1000.00, 4000.00),
(769, 243, 3256, 1.00, 7000.00, 7000.00),
(770, 243, 3188, 20.00, 50.00, 1000.00),
(771, 243, 3172, 1.00, 500.00, 500.00),
(772, 243, 3218, 10.00, 50.00, 500.00),
(773, 243, 3272, 5.00, 200.00, 1000.00),
(774, 243, 3191, 10.00, 100.00, 1000.00),
(775, 243, 2995, 1.00, 1300.00, 1300.00),
(776, 243, 3247, 1.00, 2000.00, 2000.00),
(777, 243, 2972, 2.00, 1000.00, 2000.00),
(778, 244, 3259, 1.00, 1000.00, 1000.00),
(779, 244, 2969, 5.00, 200.00, 1000.00),
(780, 245, 3190, 2.00, 500.00, 1000.00),
(781, 245, 3212, 1.00, 2000.00, 2000.00),
(782, 245, 2982, 1.00, 1500.00, 1500.00),
(783, 246, 3252, 5.00, 400.00, 2000.00),
(789, 248, 3248, 6.00, 500.00, 3000.00),
(790, 249, 2969, 10.00, 200.00, 2000.00),
(791, 249, 3252, 10.00, 400.00, 4000.00),
(792, 249, 3190, 2.00, 500.00, 1000.00),
(793, 249, 3263, 10.00, 50.00, 500.00),
(794, 249, 3345, 2.00, 500.00, 1000.00),
(795, 249, 3254, 1.00, 2000.00, 2000.00),
(796, 249, 3161, 10.00, 100.00, 1000.00),
(797, 250, 3252, 10.00, 400.00, 4000.00),
(798, 250, 3045, 1.00, 2000.00, 2000.00),
(799, 251, 2968, 10.00, 50.00, 500.00),
(800, 247, 3345, 2.00, 500.00, 1000.00),
(801, 247, 2999, 5.00, 500.00, 2500.00),
(802, 247, 3041, 1.00, 8000.00, 8000.00),
(803, 247, 3252, 20.00, 400.00, 8000.00),
(804, 247, 3122, 1.00, 10000.00, 10000.00),
(805, 252, 3363, 1.00, 11000.00, 11000.00),
(806, 252, 3068, 1.00, 2500.00, 2500.00),
(807, 252, 3174, 10.00, 100.00, 1000.00),
(808, 252, 3232, 10.00, 100.00, 1000.00),
(809, 252, 3084, 1.00, 5000.00, 5000.00),
(810, 252, 3209, 1.00, 3500.00, 3500.00),
(811, 252, 2990, 1.00, 5000.00, 5000.00),
(812, 253, 3127, 1.00, 5000.00, 5000.00),
(813, 254, 3188, 10.00, 50.00, 500.00),
(814, 254, 3061, 1.00, 3000.00, 3000.00),
(815, 255, 3347, 1.00, 1500.00, 1500.00),
(816, 256, 3247, 1.00, 2000.00, 2000.00),
(817, 256, 3259, 1.00, 1000.00, 1000.00),
(818, 256, 2969, 15.00, 200.00, 3000.00),
(819, 256, 2995, 1.00, 1300.00, 1300.00),
(820, 256, 3264, 5.00, 100.00, 500.00),
(821, 257, 3101, 20.00, 150.00, 3000.00),
(822, 258, 3211, 1.00, 2000.00, 2000.00),
(823, 258, 3209, 1.00, 3500.00, 3500.00),
(824, 259, 3236, 5.00, 2500.00, 12500.00),
(825, 259, 3256, 2.00, 7000.00, 14000.00),
(826, 259, 3000, 10.00, 1000.00, 10000.00),
(827, 259, 3002, 1.00, 2000.00, 2000.00),
(828, 259, 2990, 1.00, 5000.00, 5000.00),
(829, 260, 3006, 1.00, 25000.00, 25000.00),
(830, 260, 3172, 10.00, 500.00, 5000.00),
(831, 261, 3133, 1.00, 3500.00, 3500.00),
(832, 261, 2968, 30.00, 50.00, 1500.00),
(833, 262, 3127, 1.00, 5000.00, 5000.00),
(834, 262, 3195, 3.00, 1000.00, 3000.00),
(835, 262, 3266, 4.00, 500.00, 2000.00),
(836, 262, 3170, 1.00, 4000.00, 4000.00),
(837, 262, 3168, 5.00, 600.00, 3000.00),
(838, 262, 2999, 2.00, 500.00, 1000.00),
(839, 262, 3184, 1.00, 2000.00, 2000.00),
(840, 262, 3218, 10.00, 50.00, 500.00),
(841, 262, 2968, 10.00, 50.00, 500.00),
(842, 263, 3236, 5.00, 2500.00, 12500.00),
(843, 263, 3011, 10.00, 600.00, 6000.00),
(844, 264, 3271, 4.00, 250.00, 1000.00),
(845, 264, 2968, 10.00, 50.00, 500.00),
(846, 265, 3211, 1.00, 2000.00, 2000.00),
(847, 265, 3250, 2.00, 500.00, 1000.00),
(848, 266, 3254, 1.00, 2000.00, 2000.00),
(849, 266, 3211, 1.00, 2000.00, 2000.00),
(850, 267, 3188, 20.00, 50.00, 1000.00),
(851, 267, 3198, 10.00, 100.00, 1000.00),
(852, 267, 3028, 10.00, 100.00, 1000.00),
(853, 267, 3268, 10.00, 500.00, 5000.00),
(854, 267, 3265, 1.00, 4000.00, 4000.00),
(855, 267, 3254, 2.00, 2000.00, 4000.00),
(856, 267, 2982, 2.00, 1500.00, 3000.00),
(857, 267, 3249, 4.00, 500.00, 2000.00),
(858, 267, 2995, 1.00, 1300.00, 1300.00),
(859, 267, 2969, 20.00, 200.00, 4000.00),
(860, 267, 3216, 1.00, 500.00, 500.00),
(861, 267, 3264, 10.00, 100.00, 1000.00),
(862, 268, 3161, 10.00, 100.00, 1000.00),
(863, 268, 3364, 1.00, 12000.00, 12000.00),
(864, 268, 3189, 10.00, 100.00, 1000.00),
(865, 268, 3289, 1.00, 2000.00, 2000.00),
(866, 269, 3365, 8.00, 1000.00, 8000.00),
(867, 269, 3002, 1.00, 2000.00, 2000.00),
(868, 270, 3211, 1.00, 2000.00, 2000.00),
(869, 271, 3102, 10.00, 100.00, 1000.00),
(870, 271, 3218, 10.00, 50.00, 500.00),
(871, 272, 3055, 1.00, 3000.00, 3000.00),
(872, 272, 3347, 1.00, 1500.00, 1500.00),
(873, 273, 3220, 2.00, 1000.00, 2000.00),
(874, 273, 3174, 10.00, 100.00, 1000.00),
(875, 273, 3180, 10.00, 100.00, 1000.00),
(876, 273, 3165, 1.00, 500.00, 500.00),
(877, 273, 2969, 5.00, 200.00, 1000.00),
(878, 274, 3008, 1.00, 1000.00, 1000.00),
(879, 274, 3180, 10.00, 100.00, 1000.00),
(880, 274, 3301, 2.00, 1500.00, 3000.00),
(881, 275, 3014, 1.00, 5000.00, 5000.00),
(882, 275, 2968, 10.00, 50.00, 500.00),
(883, 276, 3209, 1.00, 3500.00, 3500.00),
(884, 276, 3174, 5.00, 100.00, 500.00),
(885, 276, 3211, 1.00, 2000.00, 2000.00),
(886, 277, 2989, 1.00, 12000.00, 12000.00),
(887, 277, 2992, 5.00, 1000.00, 5000.00),
(888, 277, 3097, 5.00, 400.00, 2000.00),
(889, 277, 3001, 4.00, 500.00, 2000.00),
(890, 277, 3012, 1.00, 7000.00, 7000.00),
(891, 277, 3180, 10.00, 100.00, 1000.00),
(892, 277, 3161, 30.00, 100.00, 3000.00),
(893, 277, 3107, 20.00, 200.00, 4000.00),
(894, 277, 2969, 5.00, 200.00, 1000.00),
(895, 277, 2995, 1.00, 1300.00, 1300.00),
(896, 277, 3247, 1.00, 2000.00, 2000.00),
(897, 277, 3092, 2.00, 700.00, 1400.00),
(898, 277, 3365, 2.00, 1000.00, 2000.00),
(899, 277, 2999, 2.00, 500.00, 1000.00),
(900, 277, 3009, 10.00, 1000.00, 10000.00),
(901, 277, 3213, 5.00, 1500.00, 7500.00),
(902, 277, 3189, 10.00, 100.00, 1000.00),
(903, 278, 3258, 7.00, 2000.00, 14000.00),
(904, 278, 3001, 4.00, 500.00, 2000.00),
(905, 278, 2969, 5.00, 200.00, 1000.00),
(906, 279, 3232, 10.00, 100.00, 1000.00),
(907, 279, 3167, 20.00, 200.00, 4000.00),
(908, 279, 3308, 10.00, 300.00, 3000.00),
(909, 279, 3010, 10.00, 100.00, 1000.00),
(910, 280, 3366, 1.00, 6000.00, 6000.00),
(911, 280, 3367, 1.00, 3000.00, 3000.00),
(912, 280, 3368, 2.00, 3000.00, 6000.00),
(913, 280, 3256, 1.00, 7000.00, 7000.00),
(914, 280, 3369, 1.00, 6000.00, 6000.00),
(915, 281, 3213, 2.00, 1500.00, 3000.00),
(916, 282, 3117, 1.00, 1000.00, 1000.00),
(917, 283, 3111, 1.00, 5000.00, 5000.00),
(918, 283, 3213, 2.00, 1500.00, 3000.00),
(919, 284, 3264, 10.00, 100.00, 1000.00),
(920, 285, 3304, 2.00, 1500.00, 3000.00),
(921, 286, 3012, 1.00, 7000.00, 7000.00),
(922, 286, 3110, 1.00, 4500.00, 4500.00),
(923, 286, 3174, 10.00, 100.00, 1000.00),
(924, 287, 3152, 1.00, 1000.00, 1000.00),
(925, 287, 2990, 1.00, 5000.00, 5000.00),
(926, 287, 3252, 10.00, 400.00, 4000.00),
(927, 287, 3271, 4.00, 250.00, 1000.00),
(928, 287, 3289, 1.00, 2000.00, 2000.00),
(929, 287, 3128, 1.00, 8000.00, 8000.00),
(930, 288, 3167, 5.00, 200.00, 1000.00),
(931, 288, 3149, 2.00, 1000.00, 2000.00),
(932, 288, 3287, 1.00, 5000.00, 5000.00),
(933, 288, 3095, 10.00, 100.00, 1000.00),
(934, 288, 3330, 1.00, 17000.00, 17000.00),
(935, 288, 3174, 10.00, 100.00, 1000.00),
(936, 288, 2999, 2.00, 500.00, 1000.00),
(937, 289, 3278, 10.00, 400.00, 4000.00),
(938, 290, 3209, 1.00, 3500.00, 3500.00),
(939, 290, 3174, 10.00, 100.00, 1000.00),
(940, 291, 3218, 20.00, 50.00, 1000.00),
(941, 291, 3180, 10.00, 100.00, 1000.00),
(942, 291, 3189, 10.00, 100.00, 1000.00),
(943, 291, 2968, 10.00, 50.00, 500.00),
(944, 291, 3191, 10.00, 100.00, 1000.00),
(945, 291, 2996, 1.00, 1000.00, 1000.00),
(946, 291, 2999, 2.00, 500.00, 1000.00),
(947, 291, 3186, 1.00, 2000.00, 2000.00),
(948, 292, 3180, 5.00, 100.00, 500.00),
(949, 293, 3271, 4.00, 250.00, 1000.00),
(950, 293, 3200, 10.00, 100.00, 1000.00),
(951, 294, 3218, 10.00, 50.00, 500.00),
(952, 294, 3094, 10.00, 200.00, 2000.00),
(953, 294, 2969, 5.00, 200.00, 1000.00),
(954, 294, 2995, 1.00, 1300.00, 1300.00),
(955, 294, 3184, 1.00, 2000.00, 2000.00),
(956, 294, 2996, 1.00, 1000.00, 1000.00),
(957, 294, 3206, 20.00, 100.00, 2000.00),
(958, 294, 2989, 1.00, 12000.00, 12000.00),
(959, 294, 3211, 1.00, 2000.00, 2000.00),
(960, 294, 3180, 10.00, 100.00, 1000.00),
(961, 295, 3211, 1.00, 2000.00, 2000.00),
(962, 295, 3252, 10.00, 400.00, 4000.00),
(963, 295, 3167, 5.00, 200.00, 1000.00),
(964, 295, 2996, 2.00, 1000.00, 2000.00),
(965, 295, 2999, 4.00, 500.00, 2000.00),
(966, 296, 3213, 2.00, 1500.00, 3000.00),
(967, 296, 3174, 10.00, 100.00, 1000.00),
(968, 296, 2990, 1.00, 5000.00, 5000.00),
(969, 297, 2982, 1.00, 1500.00, 1500.00),
(970, 298, 2999, 2.00, 500.00, 1000.00),
(971, 298, 3205, 10.00, 50.00, 500.00),
(972, 298, 3209, 1.00, 3500.00, 3500.00),
(973, 298, 2971, 1.00, 1000.00, 1000.00),
(974, 298, 3151, 1.00, 2000.00, 2000.00),
(975, 298, 3292, 1.00, 2500.00, 2500.00),
(976, 299, 3290, 4.00, 2000.00, 8000.00),
(977, 299, 3276, 1.00, 5000.00, 5000.00),
(978, 299, 3117, 1.00, 1000.00, 1000.00),
(979, 299, 2986, 1.00, 3500.00, 3500.00),
(980, 299, 3167, 5.00, 200.00, 1000.00),
(981, 300, 3007, 1.00, 2500.00, 2500.00),
(982, 300, 3011, 10.00, 600.00, 6000.00),
(983, 300, 2969, 20.00, 200.00, 4000.00),
(984, 300, 3128, 1.00, 8000.00, 8000.00),
(985, 300, 3289, 1.00, 2000.00, 2000.00),
(986, 300, 3134, 1.00, 5000.00, 5000.00),
(987, 301, 3195, 1.00, 1000.00, 1000.00),
(988, 301, 3188, 10.00, 50.00, 500.00),
(989, 301, 3150, 1.00, 5000.00, 5000.00),
(990, 301, 3368, 1.00, 3000.00, 3000.00),
(991, 301, 3189, 20.00, 100.00, 2000.00),
(992, 302, 3012, 1.00, 7000.00, 7000.00),
(993, 302, 2968, 10.00, 50.00, 500.00),
(994, 302, 3174, 10.00, 100.00, 1000.00),
(995, 302, 3271, 4.00, 250.00, 1000.00),
(996, 303, 3010, 5.00, 100.00, 500.00),
(997, 304, 3301, 1.00, 1500.00, 1500.00),
(998, 305, 2971, 3.00, 1000.00, 3000.00),
(999, 305, 3345, 3.00, 500.00, 1500.00),
(1000, 305, 2999, 4.00, 500.00, 2000.00),
(1001, 306, 3100, 5.00, 300.00, 1500.00),
(1002, 306, 3200, 5.00, 100.00, 500.00),
(1003, 306, 3174, 5.00, 100.00, 500.00),
(1004, 306, 2969, 5.00, 200.00, 1000.00),
(1005, 306, 3248, 6.00, 500.00, 3000.00),
(1006, 306, 3103, 10.00, 200.00, 2000.00),
(1007, 307, 3147, 1.00, 5000.00, 5000.00),
(1008, 307, 3232, 10.00, 100.00, 1000.00),
(1009, 308, 3262, 2.00, 500.00, 1000.00),
(1010, 309, 3165, 1.00, 500.00, 500.00),
(1011, 309, 3188, 20.00, 50.00, 1000.00),
(1012, 309, 3209, 1.00, 3500.00, 3500.00),
(1013, 309, 3028, 10.00, 100.00, 1000.00),
(1014, 309, 3026, 10.00, 700.00, 7000.00),
(1015, 309, 3057, 10.00, 1000.00, 10000.00),
(1016, 309, 3206, 10.00, 100.00, 1000.00),
(1017, 309, 3153, 1.00, 1000.00, 1000.00),
(1018, 310, 3186, 1.00, 2000.00, 2000.00),
(1019, 310, 3065, 1.00, 5000.00, 5000.00),
(1020, 310, 2968, 20.00, 50.00, 1000.00),
(1021, 311, 3307, 1.00, 3000.00, 3000.00),
(1022, 311, 3032, 1.00, 4000.00, 4000.00),
(1023, 312, 3226, 1.00, 6000.00, 6000.00),
(1024, 313, 3155, 10.00, 500.00, 5000.00),
(1025, 314, 3256, 1.00, 7000.00, 7000.00),
(1026, 314, 3262, 10.00, 500.00, 5000.00),
(1027, 315, 3200, 10.00, 100.00, 1000.00),
(1028, 315, 3095, 10.00, 100.00, 1000.00),
(1029, 316, 3020, 1.00, 8000.00, 8000.00),
(1030, 316, 3174, 20.00, 100.00, 2000.00),
(1031, 316, 2990, 1.00, 5000.00, 5000.00),
(1032, 317, 3055, 1.00, 3000.00, 3000.00),
(1033, 317, 3331, 1.00, 3500.00, 3500.00),
(1034, 317, 3167, 5.00, 200.00, 1000.00),
(1035, 317, 3203, 2.00, 500.00, 1000.00),
(1036, 317, 3251, 10.00, 100.00, 1000.00),
(1037, 317, 3073, 6.00, 500.00, 3000.00),
(1038, 318, 2999, 2.00, 500.00, 1000.00),
(1039, 318, 3209, 2.00, 3500.00, 7000.00),
(1040, 318, 3188, 20.00, 50.00, 1000.00),
(1041, 318, 3226, 1.00, 6500.00, 6500.00),
(1042, 318, 3134, 1.00, 5000.00, 5000.00),
(1043, 319, 3003, 1.00, 5000.00, 5000.00),
(1044, 319, 3150, 1.00, 5000.00, 5000.00),
(1045, 319, 2996, 2.00, 1000.00, 2000.00),
(1046, 319, 3165, 2.00, 500.00, 1000.00),
(1047, 320, 3161, 10.00, 100.00, 1000.00),
(1048, 321, 3225, 1.00, 11000.00, 11000.00),
(1049, 321, 3031, 1.00, 5000.00, 5000.00),
(1050, 322, 3273, 5.00, 200.00, 1000.00),
(1051, 322, 3142, 1.00, 3000.00, 3000.00),
(1052, 322, 3037, 1.00, 3500.00, 3500.00),
(1053, 322, 3188, 10.00, 50.00, 500.00),
(1054, 322, 3251, 10.00, 100.00, 1000.00),
(1055, 322, 3271, 8.00, 250.00, 2000.00),
(1056, 322, 3345, 1.00, 500.00, 500.00),
(1057, 322, 3255, 1.00, 8000.00, 8000.00),
(1058, 322, 3147, 1.00, 5000.00, 5000.00),
(1059, 322, 3211, 1.00, 2000.00, 2000.00),
(1060, 322, 3189, 10.00, 100.00, 1000.00),
(1061, 322, 3150, 1.00, 5000.00, 5000.00),
(1062, 322, 3261, 1.00, 500.00, 500.00),
(1063, 323, 3299, 1.00, 6500.00, 6500.00),
(1064, 323, 3280, 1.00, 1500.00, 1500.00),
(1065, 323, 3213, 3.00, 1500.00, 4500.00),
(1066, 323, 3271, 24.00, 250.00, 6000.00),
(1067, 323, 3279, 5.00, 300.00, 1500.00),
(1068, 323, 3001, 6.00, 500.00, 3000.00),
(1069, 323, 3259, 14.00, 1000.00, 14000.00),
(1070, 323, 2993, 3.00, 1300.00, 3900.00),
(1071, 323, 3311, 7.00, 1000.00, 7000.00),
(1072, 323, 3256, 1.00, 7000.00, 7000.00),
(1073, 323, 3029, 10.00, 100.00, 1000.00),
(1074, 323, 3155, 2.00, 500.00, 1000.00),
(1075, 324, 3264, 10.00, 100.00, 1000.00),
(1076, 324, 3000, 6.00, 1000.00, 6000.00),
(1077, 325, 3254, 1.00, 2000.00, 2000.00),
(1078, 325, 3107, 5.00, 200.00, 1000.00),
(1083, 327, 3161, 20.00, 100.00, 2000.00),
(1084, 327, 3205, 40.00, 50.00, 2000.00),
(1085, 327, 3010, 10.00, 100.00, 1000.00),
(1086, 327, 3167, 5.00, 200.00, 1000.00),
(1087, 328, 3347, 1.00, 1500.00, 1500.00),
(1088, 328, 3068, 1.00, 2500.00, 2500.00),
(1089, 328, 3376, 4.00, 1000.00, 4000.00),
(1090, 328, 3189, 10.00, 100.00, 1000.00),
(1091, 328, 3161, 10.00, 100.00, 1000.00),
(1092, 328, 3379, 4.00, 1000.00, 4000.00),
(1093, 329, 3075, 1.00, 17000.00, 17000.00),
(1094, 329, 3290, 7.00, 2000.00, 14000.00),
(1095, 330, 3000, 10.00, 1000.00, 10000.00),
(1096, 331, 2990, 1.00, 5000.00, 5000.00),
(1097, 332, 2968, 20.00, 50.00, 1000.00),
(1098, 333, 3271, 12.00, 250.00, 3000.00),
(1099, 333, 2968, 10.00, 50.00, 500.00),
(1100, 334, 3376, 1.00, 1000.00, 1000.00),
(1101, 335, 2990, 1.00, 5000.00, 5000.00),
(1102, 335, 3000, 1.00, 1000.00, 1000.00),
(1103, 335, 3394, 10.00, 700.00, 7000.00),
(1104, 335, 2971, 2.00, 1000.00, 2000.00),
(1105, 336, 3328, 1.00, 8000.00, 8000.00),
(1106, 336, 3057, 1.00, 1000.00, 1000.00),
(1107, 336, 3029, 10.00, 100.00, 1000.00),
(1108, 336, 3366, 1.00, 6000.00, 6000.00),
(1109, 337, 2990, 1.00, 5000.00, 5000.00),
(1110, 338, 3129, 3.00, 4000.00, 12000.00),
(1111, 339, 3127, 1.00, 5000.00, 5000.00),
(1112, 339, 3218, 10.00, 50.00, 500.00),
(1113, 339, 3167, 5.00, 200.00, 1000.00),
(1114, 339, 3200, 5.00, 100.00, 500.00),
(1115, 339, 3189, 10.00, 100.00, 1000.00),
(1116, 339, 3104, 6.00, 833.00, 4998.00),
(1117, 340, 3380, 5.00, 900.00, 4500.00),
(1118, 340, 3161, 10.00, 100.00, 1000.00),
(1119, 340, 3203, 2.00, 500.00, 1000.00),
(1120, 340, 3232, 10.00, 100.00, 1000.00),
(1121, 341, 2982, 1.00, 1500.00, 1500.00),
(1122, 341, 3174, 10.00, 100.00, 1000.00),
(1123, 342, 3296, 1.00, 3000.00, 3000.00),
(1124, 342, 3211, 2.00, 2000.00, 4000.00),
(1125, 342, 3304, 2.00, 1500.00, 3000.00),
(1126, 342, 3159, 1.00, 500.00, 500.00),
(1127, 342, 3035, 1.00, 7000.00, 7000.00),
(1128, 342, 3004, 2.00, 1000.00, 2000.00),
(1129, 342, 3261, 1.00, 500.00, 500.00),
(1130, 342, 3216, 4.00, 500.00, 2000.00),
(1131, 342, 3218, 20.00, 50.00, 1000.00),
(1132, 342, 3272, 10.00, 200.00, 2000.00),
(1133, 342, 3228, 5.00, 200.00, 1000.00),
(1134, 343, 3376, 1.00, 1000.00, 1000.00),
(1135, 343, 3174, 10.00, 100.00, 1000.00),
(1136, 343, 3271, 8.00, 250.00, 2000.00),
(1137, 343, 3345, 1.00, 500.00, 500.00),
(1138, 343, 3069, 1.00, 5000.00, 5000.00),
(1139, 343, 3013, 1.00, 3000.00, 3000.00),
(1140, 343, 2969, 10.00, 200.00, 2000.00),
(1141, 343, 3161, 10.00, 100.00, 1000.00),
(1142, 344, 2969, 20.00, 200.00, 4000.00),
(1143, 344, 3215, 3.00, 1000.00, 3000.00),
(1144, 344, 3189, 20.00, 100.00, 2000.00),
(1145, 344, 3001, 6.00, 500.00, 3000.00),
(1146, 344, 3002, 1.00, 2000.00, 2000.00),
(1147, 344, 3031, 1.00, 5000.00, 5000.00),
(1148, 344, 2990, 1.00, 5000.00, 5000.00),
(1149, 344, 3097, 10.00, 400.00, 4000.00),
(1150, 344, 3395, 1.00, 17000.00, 17000.00),
(1151, 344, 3150, 1.00, 5000.00, 5000.00),
(1152, 345, 3066, 1.00, 3000.00, 3000.00),
(1153, 345, 3128, 1.00, 8000.00, 8000.00),
(1154, 346, 3180, 10.00, 100.00, 1000.00),
(1155, 346, 3005, 1.00, 5000.00, 5000.00),
(1156, 346, 3161, 10.00, 100.00, 1000.00),
(1157, 346, 3256, 1.00, 7000.00, 7000.00),
(1158, 347, 3107, 10.00, 200.00, 2000.00),
(1159, 347, 3057, 1.00, 1000.00, 1000.00),
(1160, 348, 3196, 2.00, 5000.00, 10000.00),
(1161, 349, 3117, 1.00, 1000.00, 1000.00),
(1162, 349, 3307, 1.00, 3000.00, 3000.00),
(1163, 349, 2999, 2.00, 500.00, 1000.00),
(1164, 349, 3155, 10.00, 500.00, 5000.00),
(1165, 350, 3366, 1.00, 6000.00, 6000.00),
(1166, 351, 2971, 2.00, 1000.00, 2000.00),
(1167, 351, 3165, 1.00, 500.00, 500.00),
(1168, 352, 3174, 10.00, 100.00, 1000.00),
(1169, 352, 3095, 10.00, 100.00, 1000.00),
(1171, 354, 3274, 1.00, 1500.00, 1500.00),
(1172, 355, 2999, 1.00, 500.00, 500.00),
(1173, 355, 3029, 10.00, 100.00, 1000.00),
(1174, 355, 3271, 12.00, 250.00, 3000.00),
(1175, 355, 2968, 10.00, 50.00, 500.00),
(1176, 355, 3252, 5.00, 400.00, 2000.00),
(1177, 356, 2990, 1.00, 5000.00, 5000.00),
(1178, 357, 3232, 10.00, 100.00, 1000.00),
(1179, 357, 2968, 20.00, 50.00, 1000.00),
(1180, 357, 2999, 1.00, 500.00, 500.00),
(1181, 358, 3262, 4.00, 500.00, 2000.00),
(1182, 358, 3108, 10.00, 200.00, 2000.00),
(1183, 358, 2972, 1.00, 1000.00, 1000.00),
(1184, 359, 3379, 4.00, 1000.00, 4000.00),
(1185, 360, 3328, 1.00, 8000.00, 8000.00),
(1186, 360, 3343, 2.00, 2000.00, 4000.00),
(1187, 360, 3273, 5.00, 200.00, 1000.00),
(1188, 360, 3200, 10.00, 100.00, 1000.00),
(1189, 360, 3000, 5.00, 1000.00, 5000.00),
(1190, 360, 3129, 1.00, 4000.00, 4000.00),
(1191, 361, 2982, 1.00, 1500.00, 1500.00),
(1192, 361, 3308, 5.00, 200.00, 1000.00),
(1193, 362, 3109, 4.00, 1000.00, 4000.00),
(1194, 362, 3002, 1.00, 2000.00, 2000.00),
(1195, 362, 3418, 10.00, 200.00, 2000.00),
(1196, 363, 3420, 4.00, 500.00, 2000.00),
(1197, 363, 3419, 1.00, 5000.00, 5000.00),
(1198, 363, 3365, 4.00, 1000.00, 4000.00),
(1199, 363, 3180, 10.00, 100.00, 1000.00),
(1200, 363, 3117, 2.00, 1000.00, 2000.00),
(1201, 364, 3009, 6.00, 1000.00, 6000.00),
(1202, 364, 3097, 5.00, 400.00, 2000.00),
(1203, 364, 3128, 1.00, 8000.00, 8000.00),
(1204, 364, 3289, 1.00, 2000.00, 2000.00),
(1205, 364, 3200, 10.00, 100.00, 1000.00),
(1206, 364, 3055, 1.00, 3000.00, 3000.00),
(1207, 365, 3280, 1.00, 1500.00, 1500.00),
(1208, 366, 3107, 5.00, 200.00, 1000.00),
(1209, 366, 3052, 1.00, 2500.00, 2500.00),
(1210, 366, 3195, 10.00, 1000.00, 10000.00),
(1211, 367, 3422, 1.00, 10000.00, 10000.00),
(1212, 367, 3421, 1.00, 3000.00, 3000.00),
(1213, 368, 3000, 1.00, 1000.00, 1000.00),
(1214, 368, 3211, 1.00, 2000.00, 2000.00),
(1215, 369, 2999, 5.00, 500.00, 2500.00),
(1216, 369, 3261, 2.00, 500.00, 1000.00),
(1217, 369, 3172, 2.00, 500.00, 1000.00),
(1218, 369, 3360, 1.00, 1300.00, 1300.00),
(1219, 369, 3139, 2.00, 12000.00, 24000.00),
(1220, 369, 3000, 2.00, 1000.00, 2000.00),
(1221, 369, 3315, 5.00, 1000.00, 5000.00),
(1222, 369, 3002, 2.00, 2000.00, 4000.00),
(1223, 369, 3215, 2.00, 1000.00, 2000.00),
(1224, 369, 3271, 4.00, 250.00, 1000.00),
(1225, 369, 3174, 5.00, 100.00, 500.00),
(1226, 369, 3207, 5.00, 300.00, 1500.00),
(1227, 370, 3124, 1.00, 2000.00, 2000.00),
(1228, 370, 2968, 20.00, 50.00, 1000.00),
(1229, 370, 3161, 10.00, 100.00, 1000.00),
(1230, 370, 3186, 1.00, 2000.00, 2000.00),
(1231, 371, 3285, 1.00, 5000.00, 5000.00),
(1232, 372, 3423, 1.00, 3500.00, 3500.00),
(1233, 372, 3217, 10.00, 100.00, 1000.00),
(1234, 373, 3424, 1.00, 4000.00, 4000.00),
(1235, 373, 3163, 6.00, 1500.00, 9000.00),
(1236, 373, 3029, 10.00, 100.00, 1000.00),
(1237, 373, 2969, 5.00, 200.00, 1000.00),
(1238, 374, 3065, 1.00, 5000.00, 5000.00),
(1239, 374, 3117, 1.00, 1000.00, 1000.00),
(1240, 375, 3209, 4.00, 3500.00, 14000.00),
(1241, 375, 3197, 5.00, 200.00, 1000.00),
(1242, 375, 3095, 10.00, 100.00, 1000.00),
(1243, 375, 3000, 1.00, 1000.00, 1000.00),
(1244, 375, 3315, 2.00, 1000.00, 2000.00),
(1245, 375, 3167, 5.00, 200.00, 1000.00),
(1246, 376, 3161, 20.00, 100.00, 2000.00),
(1247, 377, 2971, 1.00, 1000.00, 1000.00),
(1248, 377, 3365, 1.00, 1000.00, 1000.00),
(1249, 377, 3057, 2.00, 1000.00, 2000.00),
(1250, 377, 3297, 1.00, 25000.00, 25000.00),
(1251, 377, 3257, 1.00, 500.00, 500.00),
(1252, 377, 2999, 2.00, 500.00, 1000.00),
(1253, 377, 3124, 1.00, 2000.00, 2000.00),
(1254, 377, 3289, 1.00, 2000.00, 2000.00),
(1255, 377, 3205, 10.00, 50.00, 500.00),
(1256, 378, 3108, 5.00, 200.00, 1000.00),
(1257, 379, 3165, 2.00, 500.00, 1000.00),
(1258, 379, 2969, 5.00, 200.00, 1000.00),
(1259, 380, 3127, 1.00, 5500.00, 5500.00),
(1260, 381, 3331, 1.00, 3500.00, 3500.00),
(1261, 381, 3384, 1.00, 3500.00, 3500.00),
(1262, 381, 3289, 1.00, 2000.00, 2000.00),
(1263, 381, 3228, 5.00, 200.00, 1000.00),
(1264, 381, 3258, 4.00, 2000.00, 8000.00),
(1265, 381, 3248, 2.00, 500.00, 1000.00),
(1266, 382, 2969, 15.00, 200.00, 3000.00),
(1267, 382, 3360, 1.00, 1300.00, 1300.00),
(1268, 382, 3172, 2.00, 500.00, 1000.00),
(1269, 383, 3301, 4.00, 1500.00, 6000.00),
(1270, 383, 2986, 1.00, 3500.00, 3500.00),
(1271, 384, 3147, 1.00, 5000.00, 5000.00),
(1272, 385, 2968, 10.00, 50.00, 500.00),
(1273, 386, 3399, 10.00, 100.00, 1000.00),
(1274, 387, 2968, 20.00, 50.00, 1000.00),
(1275, 388, 3271, 4.00, 250.00, 1000.00),
(1276, 388, 2968, 10.00, 50.00, 500.00),
(1277, 389, 3167, 5.00, 200.00, 1000.00),
(1278, 389, 3218, 10.00, 50.00, 500.00),
(1279, 390, 3347, 1.00, 1500.00, 1500.00),
(1280, 390, 3153, 1.00, 1000.00, 1000.00),
(1281, 391, 3363, 1.00, 11000.00, 11000.00),
(1282, 391, 3009, 6.00, 1000.00, 6000.00),
(1283, 391, 3097, 5.00, 400.00, 2000.00),
(1284, 392, 3153, 2.00, 1000.00, 2000.00),
(1285, 392, 3403, 1.00, 5000.00, 5000.00),
(1286, 392, 3206, 10.00, 100.00, 1000.00),
(1287, 393, 3243, 2.00, 1000.00, 2000.00),
(1288, 394, 3308, 10.00, 200.00, 2000.00),
(1289, 394, 3128, 1.00, 8000.00, 8000.00),
(1290, 394, 3289, 1.00, 2000.00, 2000.00),
(1291, 394, 3002, 1.00, 2000.00, 2000.00),
(1292, 394, 3280, 1.00, 1500.00, 1500.00),
(1293, 395, 3251, 10.00, 100.00, 1000.00),
(1294, 395, 3207, 10.00, 300.00, 3000.00),
(1295, 395, 3174, 10.00, 100.00, 1000.00),
(1296, 396, 3343, 1.00, 2000.00, 2000.00),
(1297, 396, 3000, 1.00, 1000.00, 1000.00),
(1298, 396, 3280, 1.00, 1500.00, 1500.00),
(1299, 396, 3152, 1.00, 1000.00, 1000.00),
(1300, 396, 3029, 10.00, 100.00, 1000.00),
(1301, 396, 3251, 10.00, 100.00, 1000.00),
(1302, 396, 3161, 10.00, 100.00, 1000.00),
(1303, 397, 3170, 2.00, 4000.00, 8000.00),
(1304, 397, 2991, 1.00, 24000.00, 24000.00),
(1305, 397, 2985, 10.00, 2000.00, 20000.00),
(1306, 397, 3219, 1.00, 5000.00, 5000.00),
(1307, 397, 2970, 1.00, 3000.00, 3000.00),
(1308, 398, 3255, 1.00, 8000.00, 8000.00),
(1309, 399, 3094, 5.00, 200.00, 1000.00),
(1310, 399, 3264, 10.00, 100.00, 1000.00),
(1311, 399, 3205, 10.00, 50.00, 500.00),
(1312, 399, 3002, 2.00, 2000.00, 4000.00),
(1313, 399, 3280, 4.00, 1500.00, 6000.00),
(1314, 399, 3124, 1.00, 2000.00, 2000.00),
(1315, 399, 3211, 1.00, 2000.00, 2000.00),
(1316, 399, 2968, 10.00, 50.00, 500.00),
(1317, 399, 3161, 10.00, 100.00, 1000.00),
(1318, 399, 2999, 2.00, 500.00, 1000.00),
(1319, 400, 3172, 2.00, 500.00, 1000.00),
(1320, 400, 3360, 1.00, 1300.00, 1300.00),
(1321, 400, 2969, 5.00, 200.00, 1000.00),
(1322, 400, 3086, 1.00, 15000.00, 15000.00),
(1323, 400, 3213, 3.00, 1500.00, 4500.00),
(1324, 401, 3425, 1.00, 6000.00, 6000.00),
(1325, 401, 3426, 1.00, 3000.00, 3000.00),
(1326, 402, 3366, 1.00, 6000.00, 6000.00),
(1327, 402, 3243, 1.00, 1000.00, 1000.00),
(1328, 402, 3380, 5.00, 900.00, 4500.00);
INSERT INTO `sale_items_pharm` (`id`, `sale_id`, `product_id`, `quantity`, `price`, `total`) VALUES
(1329, 402, 3001, 2.00, 500.00, 1000.00),
(1330, 403, 3057, 1.00, 1000.00, 1000.00),
(1331, 403, 2982, 1.00, 1500.00, 1500.00),
(1332, 403, 3292, 1.00, 2500.00, 2500.00),
(1333, 403, 2969, 5.00, 200.00, 1000.00),
(1334, 403, 3167, 5.00, 200.00, 1000.00),
(1335, 404, 3140, 1.00, 5000.00, 5000.00),
(1336, 405, 3127, 1.00, 5000.00, 5000.00),
(1337, 406, 3186, 1.00, 2000.00, 2000.00),
(1338, 406, 3184, 1.00, 2000.00, 2000.00),
(1339, 406, 2990, 1.00, 5000.00, 5000.00),
(1340, 407, 3265, 1.00, 4000.00, 4000.00),
(1341, 407, 3268, 10.00, 500.00, 5000.00),
(1342, 408, 3165, 1.00, 500.00, 500.00),
(1343, 409, 3057, 50.00, 260.00, 13000.00),
(1344, 409, 3226, 1.00, 6500.00, 6500.00),
(1345, 409, 3245, 20.00, 300.00, 6000.00),
(1346, 410, 3109, 7.00, 1000.00, 7000.00),
(1347, 410, 2990, 2.00, 5000.00, 10000.00),
(1348, 410, 2999, 2.00, 500.00, 1000.00),
(1349, 410, 3254, 1.00, 2000.00, 2000.00),
(1350, 410, 3232, 10.00, 100.00, 1000.00),
(1351, 410, 3189, 10.00, 100.00, 1000.00),
(1352, 411, 3252, 5.00, 400.00, 2000.00),
(1353, 411, 3107, 5.00, 200.00, 1000.00),
(1354, 411, 3365, 2.00, 1000.00, 2000.00),
(1355, 411, 3092, 1.00, 700.00, 700.00),
(1356, 411, 3032, 1.00, 4000.00, 4000.00),
(1357, 411, 3366, 1.00, 6000.00, 6000.00),
(1358, 412, 3203, 2.00, 500.00, 1000.00),
(1359, 413, 3026, 2.00, 700.00, 1400.00),
(1360, 413, 3028, 10.00, 100.00, 1000.00),
(1361, 414, 3092, 1.00, 700.00, 700.00),
(1362, 414, 3283, 1.00, 500.00, 500.00),
(1363, 415, 2988, 1.00, 7500.00, 7500.00),
(1364, 415, 3263, 10.00, 50.00, 500.00),
(1365, 416, 3307, 1.00, 3000.00, 3000.00),
(1366, 416, 3029, 10.00, 100.00, 1000.00),
(1367, 416, 3194, 10.00, 150.00, 1500.00),
(1368, 416, 3369, 1.00, 6000.00, 6000.00),
(1369, 417, 3165, 1.00, 500.00, 500.00),
(1370, 417, 3189, 10.00, 100.00, 1000.00),
(1371, 418, 3263, 20.00, 50.00, 1000.00),
(1372, 418, 3152, 1.00, 1000.00, 1000.00),
(1373, 418, 3068, 1.00, 2500.00, 2500.00),
(1374, 418, 3161, 10.00, 100.00, 1000.00),
(1375, 418, 3271, 12.00, 250.00, 3000.00),
(1376, 418, 2968, 10.00, 50.00, 500.00),
(1377, 418, 3218, 10.00, 50.00, 500.00),
(1378, 419, 3274, 1.00, 1500.00, 1500.00),
(1379, 420, 3190, 2.00, 500.00, 1000.00),
(1380, 421, 3311, 10.00, 1000.00, 10000.00),
(1381, 421, 2968, 10.00, 50.00, 500.00),
(1382, 422, 3227, 1.00, 8500.00, 8500.00),
(1383, 423, 3360, 1.00, 1300.00, 1300.00),
(1384, 423, 2969, 5.00, 200.00, 1000.00),
(1385, 423, 3269, 1.00, 1500.00, 1500.00),
(1386, 423, 3287, 1.00, 5000.00, 5000.00),
(1387, 423, 3218, 10.00, 50.00, 500.00),
(1388, 423, 3102, 20.00, 100.00, 2000.00),
(1389, 423, 3112, 1.00, 3000.00, 3000.00),
(1390, 423, 3361, 1.00, 12000.00, 12000.00),
(1391, 423, 2999, 5.00, 500.00, 2500.00),
(1392, 423, 3128, 1.00, 8000.00, 8000.00),
(1393, 423, 3289, 1.00, 2000.00, 2000.00),
(1394, 424, 3051, 1.00, 5000.00, 5000.00),
(1395, 425, 3254, 1.00, 2000.00, 2000.00),
(1396, 426, 3252, 10.00, 400.00, 4000.00),
(1397, 427, 3401, 3.00, 1500.00, 4500.00),
(1398, 428, 3308, 10.00, 200.00, 2000.00),
(1399, 428, 3029, 10.00, 100.00, 1000.00),
(1400, 428, 3000, 1.00, 1000.00, 1000.00),
(1401, 428, 2969, 5.00, 200.00, 1000.00),
(1402, 429, 3252, 5.00, 400.00, 2000.00),
(1403, 429, 3092, 1.00, 700.00, 700.00),
(1404, 430, 3073, 4.00, 500.00, 2000.00),
(1405, 431, 2968, 20.00, 50.00, 1000.00),
(1406, 432, 3366, 1.00, 6000.00, 6000.00),
(1407, 433, 3171, 1.00, 1500.00, 1500.00),
(1408, 433, 3151, 1.00, 2000.00, 2000.00),
(1409, 433, 3360, 1.00, 1300.00, 1300.00),
(1410, 433, 3269, 1.00, 1500.00, 1500.00),
(1411, 433, 3170, 2.00, 4000.00, 8000.00),
(1412, 433, 2990, 1.00, 5000.00, 5000.00),
(1413, 433, 3122, 1.00, 10000.00, 10000.00),
(1414, 433, 3407, 1.00, 5000.00, 5000.00),
(1415, 433, 3195, 5.00, 1000.00, 5000.00),
(1416, 433, 3390, 3.00, 500.00, 1500.00),
(1417, 433, 3026, 3.00, 700.00, 2100.00),
(1418, 433, 3010, 10.00, 100.00, 1000.00),
(1419, 433, 3345, 2.00, 500.00, 1000.00),
(1420, 433, 3423, 1.00, 3500.00, 3500.00),
(1421, 434, 3108, 10.00, 200.00, 2000.00),
(1422, 434, 3419, 1.00, 5000.00, 5000.00),
(1423, 435, 3134, 1.00, 5000.00, 5000.00),
(1424, 436, 3180, 10.00, 100.00, 1000.00),
(1425, 436, 3271, 12.00, 208.33, 2499.96),
(1426, 437, 3364, 1.00, 12000.00, 12000.00),
(1427, 437, 3000, 1.00, 1000.00, 1000.00),
(1428, 437, 3263, 10.00, 50.00, 500.00),
(1429, 437, 3261, 2.00, 500.00, 1000.00),
(1430, 437, 3174, 10.00, 100.00, 1000.00),
(1431, 438, 3048, 1.00, 7000.00, 7000.00),
(1432, 439, 3292, 1.00, 2500.00, 2500.00),
(1433, 439, 2999, 1.00, 500.00, 500.00),
(1434, 439, 3124, 1.00, 2000.00, 2000.00),
(1435, 439, 3289, 1.00, 2000.00, 2000.00),
(1436, 440, 3343, 1.00, 2000.00, 2000.00),
(1437, 440, 3189, 10.00, 100.00, 1000.00),
(1438, 440, 3108, 5.00, 200.00, 1000.00),
(1439, 441, 3031, 1.00, 5000.00, 5000.00),
(1440, 442, 3366, 1.00, 6000.00, 6000.00),
(1441, 442, 3380, 4.00, 875.00, 3500.00),
(1442, 442, 3165, 1.00, 500.00, 500.00),
(1443, 443, 3211, 1.00, 2000.00, 2000.00),
(1444, 444, 3151, 1.00, 2000.00, 2000.00),
(1445, 444, 3218, 10.00, 50.00, 500.00),
(1446, 445, 3360, 1.00, 1300.00, 1300.00),
(1447, 445, 2969, 5.00, 200.00, 1000.00),
(1448, 445, 3269, 1.00, 1500.00, 1500.00),
(1449, 446, 3165, 1.00, 500.00, 500.00),
(1450, 447, 3285, 2.00, 5000.00, 10000.00),
(1451, 448, 2982, 1.00, 1500.00, 1500.00),
(1452, 448, 3190, 1.00, 500.00, 500.00),
(1453, 448, 3029, 10.00, 100.00, 1000.00),
(1454, 449, 2988, 1.00, 7500.00, 7500.00),
(1455, 449, 3327, 1.00, 4000.00, 4000.00),
(1456, 449, 3249, 20.00, 500.00, 10000.00),
(1457, 449, 2999, 10.00, 500.00, 5000.00),
(1458, 450, 3135, 1.00, 3000.00, 3000.00),
(1459, 451, 2999, 1.00, 500.00, 500.00),
(1460, 451, 3271, 4.00, 250.00, 1000.00),
(1461, 451, 2968, 20.00, 50.00, 1000.00),
(1462, 451, 3218, 20.00, 50.00, 1000.00),
(1463, 451, 3094, 15.00, 200.00, 3000.00),
(1464, 451, 3167, 10.00, 200.00, 2000.00),
(1465, 451, 3081, 1.00, 3500.00, 3500.00),
(1466, 451, 3152, 2.00, 1000.00, 2000.00),
(1467, 451, 3197, 15.00, 200.00, 3000.00),
(1468, 451, 3400, 1.00, 3000.00, 3000.00),
(1469, 451, 3254, 1.00, 2000.00, 2000.00),
(1470, 452, 3128, 1.00, 8000.00, 8000.00),
(1471, 452, 3289, 1.00, 2000.00, 2000.00),
(1472, 453, 3308, 10.00, 200.00, 2000.00),
(1473, 453, 2968, 10.00, 50.00, 500.00),
(1474, 454, 3380, 1.00, 800.00, 800.00),
(1475, 455, 3334, 10.00, 2000.00, 20000.00),
(1476, 456, 2969, 5.00, 200.00, 1000.00),
(1477, 456, 3360, 1.00, 1300.00, 1300.00),
(1478, 456, 3269, 1.00, 1500.00, 1500.00),
(1479, 457, 3289, 1.00, 2000.00, 2000.00),
(1480, 457, 3128, 1.00, 8000.00, 8000.00),
(1481, 457, 2990, 1.00, 5000.00, 5000.00),
(1482, 457, 3197, 10.00, 200.00, 2000.00),
(1483, 457, 2971, 1.00, 1000.00, 1000.00),
(1484, 457, 3108, 5.00, 200.00, 1000.00),
(1485, 457, 2999, 1.00, 500.00, 500.00),
(1486, 457, 3380, 3.00, 850.00, 2550.00),
(1487, 458, 3315, 1.00, 1000.00, 1000.00),
(1488, 458, 3161, 10.00, 100.00, 1000.00),
(1489, 459, 3180, 20.00, 100.00, 2000.00),
(1490, 459, 3171, 4.00, 1500.00, 6000.00),
(1491, 459, 3256, 1.00, 7000.00, 7000.00),
(1492, 459, 3218, 20.00, 50.00, 1000.00),
(1493, 459, 3189, 10.00, 100.00, 1000.00),
(1494, 459, 2971, 1.00, 1000.00, 1000.00),
(1495, 460, 3272, 10.00, 200.00, 2000.00),
(1496, 460, 3189, 10.00, 100.00, 1000.00),
(1497, 460, 3292, 1.00, 2500.00, 2500.00),
(1498, 461, 3285, 1.00, 5000.00, 5000.00),
(1499, 461, 3013, 1.00, 3000.00, 3000.00),
(1500, 461, 3347, 1.00, 1500.00, 1500.00),
(1501, 462, 3202, 1.00, 4000.00, 4000.00),
(1502, 462, 3257, 2.00, 500.00, 1000.00),
(1503, 462, 2990, 1.00, 5000.00, 5000.00),
(1504, 462, 3209, 3.00, 3500.00, 10500.00),
(1505, 462, 3174, 20.00, 100.00, 2000.00),
(1506, 462, 3205, 10.00, 50.00, 500.00),
(1507, 463, 3189, 10.00, 100.00, 1000.00),
(1508, 463, 3108, 10.00, 200.00, 2000.00),
(1509, 463, 3015, 2.00, 2000.00, 4000.00),
(1510, 463, 3049, 1.00, 5000.00, 5000.00),
(1511, 464, 3202, 1.00, 4000.00, 4000.00),
(1512, 464, 3052, 1.00, 2500.00, 2500.00),
(1513, 464, 3149, 1.00, 1000.00, 1000.00),
(1514, 465, 3195, 1.00, 1000.00, 1000.00),
(1515, 466, 3421, 1.00, 3000.00, 3000.00),
(1516, 466, 3068, 1.00, 2500.00, 2500.00),
(1517, 467, 3315, 5.00, 1000.00, 5000.00),
(1518, 468, 3360, 5.00, 1200.00, 6000.00),
(1519, 468, 2990, 1.00, 5000.00, 5000.00),
(1520, 468, 3147, 1.00, 5000.00, 5000.00),
(1521, 468, 3077, 1.00, 2000.00, 2000.00),
(1522, 468, 3001, 12.00, 500.00, 6000.00),
(1523, 468, 3189, 20.00, 100.00, 2000.00),
(1524, 469, 3285, 1.00, 5000.00, 5000.00),
(1525, 469, 3421, 1.00, 3000.00, 3000.00),
(1526, 470, 3065, 1.00, 5000.00, 5000.00),
(1527, 470, 3100, 10.00, 300.00, 3000.00),
(1528, 471, 3289, 1.00, 2000.00, 2000.00),
(1529, 472, 3226, 1.00, 6500.00, 6500.00),
(1530, 472, 3107, 10.00, 200.00, 2000.00),
(1531, 472, 3100, 10.00, 300.00, 3000.00),
(1532, 472, 3272, 10.00, 200.00, 2000.00),
(1533, 473, 3136, 1.00, 9000.00, 9000.00),
(1534, 474, 3186, 1.00, 2000.00, 2000.00),
(1535, 474, 3261, 1.00, 500.00, 500.00),
(1536, 474, 3197, 2.00, 250.00, 500.00),
(1537, 474, 2968, 10.00, 50.00, 500.00),
(1538, 475, 3269, 1.00, 1500.00, 1500.00),
(1539, 475, 2969, 5.00, 200.00, 1000.00),
(1540, 475, 2995, 1.00, 1300.00, 1300.00),
(1541, 476, 3306, 1.00, 500.00, 500.00),
(1542, 476, 3188, 10.00, 50.00, 500.00),
(1543, 477, 3343, 1.00, 2000.00, 2000.00),
(1544, 477, 2999, 2.00, 500.00, 1000.00),
(1545, 478, 3105, 10.00, 100.00, 1000.00),
(1546, 478, 3186, 1.00, 2000.00, 2000.00),
(1547, 478, 3379, 5.00, 1000.00, 5000.00),
(1548, 479, 3294, 1.00, 12000.00, 12000.00),
(1549, 479, 3001, 6.00, 500.00, 3000.00),
(1550, 479, 3161, 20.00, 100.00, 2000.00),
(1551, 479, 3218, 40.00, 50.00, 2000.00),
(1552, 479, 3188, 20.00, 50.00, 1000.00),
(1553, 479, 2995, 7.00, 1200.00, 8400.00),
(1554, 479, 3011, 30.00, 600.00, 18000.00),
(1555, 479, 3349, 10.00, 600.00, 6000.00),
(1556, 479, 3029, 20.00, 100.00, 2000.00),
(1557, 479, 3102, 20.00, 100.00, 2000.00),
(1558, 480, 3435, 1.00, 5000.00, 5000.00),
(1559, 480, 3172, 10.00, 500.00, 5000.00),
(1560, 481, 3003, 1.00, 5000.00, 5000.00),
(1561, 481, 3000, 3.00, 1000.00, 3000.00),
(1562, 482, 3000, 1.00, 1000.00, 1000.00),
(1563, 482, 3218, 20.00, 50.00, 1000.00),
(1564, 482, 3324, 10.00, 200.00, 2000.00),
(1565, 482, 3174, 20.00, 100.00, 2000.00),
(1566, 482, 3216, 5.00, 500.00, 2500.00),
(1567, 482, 2988, 1.00, 7500.00, 7500.00),
(1568, 483, 3296, 1.00, 3000.00, 3000.00),
(1569, 483, 3420, 2.00, 500.00, 1000.00),
(1570, 484, 3232, 10.00, 100.00, 1000.00),
(1571, 485, 3232, 10.00, 100.00, 1000.00),
(1572, 485, 3226, 1.00, 6500.00, 6500.00),
(1573, 486, 3205, 20.00, 50.00, 1000.00),
(1574, 486, 3165, 1.00, 500.00, 500.00),
(1575, 486, 3107, 5.00, 200.00, 1000.00),
(1576, 486, 3218, 10.00, 50.00, 500.00),
(1577, 486, 3092, 1.00, 700.00, 700.00),
(1578, 486, 3073, 1.00, 500.00, 500.00),
(1579, 486, 3211, 1.00, 2000.00, 2000.00),
(1580, 486, 2971, 2.00, 1000.00, 2000.00),
(1581, 486, 3347, 5.00, 1500.00, 7500.00),
(1582, 486, 3251, 10.00, 100.00, 1000.00),
(1583, 486, 3161, 10.00, 100.00, 1000.00),
(1584, 486, 2968, 10.00, 50.00, 500.00),
(1585, 486, 3188, 10.00, 50.00, 500.00),
(1586, 487, 3104, 6.00, 833.33, 4999.98),
(1587, 487, 2999, 2.00, 500.00, 1000.00),
(1588, 488, 3251, 20.00, 100.00, 2000.00),
(1589, 488, 3161, 10.00, 100.00, 1000.00),
(1590, 488, 3000, 1.00, 1000.00, 1000.00),
(1591, 488, 3117, 1.00, 1000.00, 1000.00),
(1592, 489, 3205, 10.00, 50.00, 500.00),
(1593, 489, 2999, 1.00, 500.00, 500.00),
(1594, 490, 3326, 10.00, 100.00, 1000.00),
(1595, 491, 3273, 5.00, 200.00, 1000.00),
(1596, 491, 3073, 1.00, 500.00, 500.00),
(1597, 492, 3439, 5.00, 7000.00, 35000.00),
(1598, 492, 3438, 2.00, 14000.00, 28000.00),
(1599, 492, 3217, 30.00, 100.00, 3000.00),
(1600, 492, 3029, 10.00, 100.00, 1000.00),
(1601, 492, 3263, 20.00, 50.00, 1000.00),
(1602, 493, 3423, 1.00, 3500.00, 3500.00),
(1603, 493, 2988, 1.00, 7500.00, 7500.00),
(1604, 493, 3107, 5.00, 200.00, 1000.00),
(1605, 493, 3431, 3.00, 2000.00, 6000.00),
(1606, 494, 3128, 1.00, 8000.00, 8000.00),
(1607, 494, 3289, 1.00, 2000.00, 2000.00),
(1608, 494, 3044, 1.00, 20000.00, 20000.00),
(1609, 494, 3192, 1.00, 2000.00, 2000.00),
(1610, 494, 3108, 5.00, 200.00, 1000.00),
(1611, 495, 3251, 10.00, 100.00, 1000.00),
(1612, 495, 3218, 20.00, 50.00, 1000.00),
(1613, 495, 3167, 10.00, 200.00, 2000.00),
(1614, 495, 3272, 5.00, 200.00, 1000.00),
(1615, 495, 3248, 2.00, 500.00, 1000.00),
(1616, 495, 3186, 1.00, 2000.00, 2000.00),
(1617, 495, 3283, 1.00, 500.00, 500.00),
(1618, 495, 3261, 2.00, 500.00, 1000.00),
(1619, 495, 3197, 5.00, 200.00, 1000.00),
(1620, 495, 2969, 5.00, 200.00, 1000.00),
(1621, 496, 3254, 1.00, 2000.00, 2000.00),
(1622, 496, 3128, 1.00, 8000.00, 8000.00),
(1623, 496, 3289, 1.00, 2000.00, 2000.00),
(1624, 496, 3379, 5.00, 1000.00, 5000.00),
(1625, 496, 3109, 7.00, 1000.00, 7000.00),
(1626, 496, 3170, 2.00, 4000.00, 8000.00),
(1627, 496, 3218, 10.00, 50.00, 500.00),
(1628, 496, 3228, 10.00, 200.00, 2000.00),
(1629, 496, 3347, 1.00, 1500.00, 1500.00),
(1630, 496, 2992, 5.00, 1000.00, 5000.00),
(1631, 496, 3189, 10.00, 100.00, 1000.00),
(1632, 496, 3301, 1.00, 1500.00, 1500.00),
(1633, 496, 3066, 1.00, 3000.00, 3000.00),
(1634, 497, 3315, 1.00, 1000.00, 1000.00),
(1635, 498, 2970, 1.00, 3000.00, 3000.00),
(1636, 498, 3256, 1.00, 7000.00, 7000.00),
(1637, 499, 3128, 1.00, 8000.00, 8000.00),
(1638, 499, 3271, 24.00, 208.33, 4999.92),
(1639, 499, 2999, 2.00, 500.00, 1000.00),
(1640, 500, 3413, 2.00, 8000.00, 16000.00),
(1641, 501, 3138, 1.00, 18000.00, 18000.00),
(1642, 501, 3190, 1.00, 500.00, 500.00),
(1643, 501, 3205, 10.00, 50.00, 500.00),
(1644, 501, 2982, 1.00, 1500.00, 1500.00),
(1645, 501, 3174, 10.00, 100.00, 1000.00),
(1646, 501, 3213, 4.00, 1500.00, 6000.00),
(1647, 501, 3180, 10.00, 100.00, 1000.00),
(1648, 501, 3161, 10.00, 100.00, 1000.00),
(1649, 501, 3207, 5.00, 300.00, 1500.00),
(1650, 501, 2968, 10.00, 50.00, 500.00),
(1651, 501, 3261, 2.00, 500.00, 1000.00),
(1652, 501, 3005, 1.00, 6000.00, 6000.00),
(1653, 502, 3025, 5.00, 4000.00, 20000.00),
(1654, 502, 3176, 15.00, 200.00, 3000.00),
(1655, 502, 3171, 5.00, 1500.00, 7500.00),
(1656, 502, 3128, 1.00, 8000.00, 8000.00),
(1657, 502, 3289, 1.00, 2000.00, 2000.00),
(1658, 502, 3127, 1.00, 5000.00, 5000.00),
(1659, 502, 3153, 1.00, 1000.00, 1000.00),
(1660, 502, 3279, 5.00, 300.00, 1500.00),
(1661, 502, 3189, 10.00, 100.00, 1000.00),
(1662, 502, 3100, 5.00, 300.00, 1500.00),
(1663, 502, 3167, 10.00, 200.00, 2000.00),
(1664, 502, 3161, 20.00, 100.00, 2000.00),
(1665, 502, 3272, 10.00, 200.00, 2000.00),
(1666, 502, 3440, 1.00, 6000.00, 6000.00),
(1667, 503, 3211, 1.00, 2000.00, 2000.00),
(1668, 504, 2969, 10.00, 200.00, 2000.00),
(1669, 504, 3232, 10.00, 100.00, 1000.00),
(1670, 504, 3418, 5.00, 200.00, 1000.00),
(1671, 504, 2968, 10.00, 50.00, 500.00),
(1672, 504, 3261, 1.00, 500.00, 500.00),
(1673, 504, 3217, 10.00, 100.00, 1000.00),
(1674, 504, 3000, 1.00, 1000.00, 1000.00),
(1675, 504, 3068, 1.00, 2500.00, 2500.00),
(1676, 505, 3153, 2.00, 1000.00, 2000.00),
(1677, 505, 3211, 1.00, 2000.00, 2000.00),
(1678, 505, 3287, 1.00, 5000.00, 5000.00),
(1679, 506, 3202, 1.00, 4000.00, 4000.00),
(1680, 506, 3189, 10.00, 100.00, 1000.00),
(1681, 506, 2969, 5.00, 200.00, 1000.00),
(1682, 506, 3263, 10.00, 50.00, 500.00),
(1683, 507, 2999, 2.00, 500.00, 1000.00),
(1684, 507, 3272, 5.00, 200.00, 1000.00),
(1685, 507, 3251, 10.00, 100.00, 1000.00),
(1686, 507, 3171, 7.00, 1500.00, 10500.00),
(1687, 508, 3213, 1.00, 1500.00, 1500.00),
(1688, 508, 2999, 5.00, 500.00, 2500.00),
(1689, 508, 2990, 1.00, 5000.00, 5000.00),
(1690, 509, 3168, 4.00, 600.00, 2400.00),
(1691, 509, 3345, 2.00, 500.00, 1000.00),
(1692, 509, 3269, 1.00, 1500.00, 1500.00),
(1693, 509, 2995, 1.00, 1300.00, 1300.00),
(1694, 509, 3349, 5.00, 600.00, 3000.00),
(1695, 509, 3011, 5.00, 600.00, 3000.00),
(1696, 509, 3222, 10.00, 50.00, 500.00),
(1697, 509, 3172, 10.00, 500.00, 5000.00),
(1698, 509, 3029, 20.00, 100.00, 2000.00),
(1699, 509, 3102, 20.00, 100.00, 2000.00),
(1700, 510, 2982, 2.00, 1500.00, 3000.00),
(1701, 511, 3211, 1.00, 2000.00, 2000.00),
(1702, 511, 3251, 10.00, 100.00, 1000.00),
(1703, 511, 3218, 20.00, 50.00, 1000.00),
(1704, 511, 3161, 10.00, 100.00, 1000.00),
(1705, 511, 3110, 1.00, 4500.00, 4500.00),
(1706, 511, 2968, 10.00, 50.00, 500.00),
(1707, 511, 2990, 2.00, 5000.00, 10000.00),
(1708, 511, 2999, 2.00, 500.00, 1000.00),
(1709, 512, 3168, 4.00, 600.00, 2400.00),
(1710, 512, 3197, 5.00, 200.00, 1000.00),
(1711, 512, 3268, 10.00, 500.00, 5000.00),
(1712, 512, 3245, 10.00, 400.00, 4000.00),
(1713, 512, 3220, 12.00, 1000.00, 12000.00),
(1714, 512, 3100, 15.00, 300.00, 4500.00),
(1715, 513, 2982, 1.00, 1500.00, 1500.00),
(1716, 513, 3174, 20.00, 100.00, 2000.00),
(1717, 513, 3265, 1.00, 4000.00, 4000.00),
(1718, 513, 3368, 1.00, 3000.00, 3000.00),
(1719, 513, 3232, 10.00, 100.00, 1000.00),
(1720, 514, 2995, 1.00, 1300.00, 1300.00),
(1721, 514, 3269, 1.00, 1500.00, 1500.00),
(1722, 514, 2990, 1.00, 5000.00, 5000.00),
(1723, 515, 3359, 1.00, 7000.00, 7000.00),
(1724, 515, 3368, 1.00, 3000.00, 3000.00),
(1725, 515, 3104, 6.00, 833.33, 4999.98),
(1726, 515, 3205, 10.00, 50.00, 500.00),
(1727, 516, 3165, 6.00, 500.00, 3000.00),
(1728, 516, 2968, 50.00, 50.00, 2500.00),
(1729, 516, 3248, 2.00, 500.00, 1000.00),
(1730, 516, 3002, 1.00, 2000.00, 2000.00),
(1731, 516, 3161, 10.00, 100.00, 1000.00),
(1732, 516, 3147, 1.00, 5000.00, 5000.00),
(1733, 516, 3254, 1.00, 2000.00, 2000.00),
(1734, 516, 3148, 4.00, 500.00, 2000.00),
(1735, 516, 2999, 2.00, 500.00, 1000.00),
(1736, 516, 3094, 5.00, 200.00, 1000.00),
(1737, 516, 3000, 2.00, 1000.00, 2000.00),
(1738, 517, 3414, 1.00, 6000.00, 6000.00),
(1739, 517, 2968, 10.00, 50.00, 500.00),
(1740, 517, 3168, 1.00, 600.00, 600.00),
(1741, 517, 3137, 1.00, 6000.00, 6000.00),
(1742, 517, 3021, 1.00, 9000.00, 9000.00),
(1743, 517, 2990, 1.00, 5000.00, 5000.00),
(1744, 517, 3301, 2.00, 1500.00, 3000.00),
(1745, 517, 3251, 10.00, 100.00, 1000.00),
(1746, 517, 3161, 10.00, 100.00, 1000.00),
(1747, 518, 2999, 2.00, 500.00, 1000.00),
(1748, 518, 3205, 10.00, 50.00, 500.00),
(1749, 518, 3094, 10.00, 200.00, 2000.00),
(1750, 518, 3000, 3.00, 1000.00, 3000.00),
(1751, 518, 2969, 10.00, 200.00, 2000.00),
(1752, 518, 3167, 10.00, 200.00, 2000.00),
(1753, 519, 3128, 1.00, 8000.00, 8000.00),
(1754, 520, 3000, 1.00, 1000.00, 1000.00),
(1755, 520, 3280, 1.00, 1500.00, 1500.00),
(1756, 521, 3129, 1.00, 4000.00, 4000.00),
(1757, 521, 2968, 20.00, 50.00, 1000.00),
(1758, 521, 2990, 1.00, 5000.00, 5000.00),
(1759, 521, 3211, 1.00, 2000.00, 2000.00),
(1760, 522, 3057, 1.00, 1000.00, 1000.00),
(1761, 522, 3161, 10.00, 100.00, 1000.00),
(1762, 522, 3218, 10.00, 50.00, 500.00),
(1763, 522, 3251, 10.00, 100.00, 1000.00),
(1764, 522, 3273, 15.00, 200.00, 3000.00),
(1765, 522, 3159, 1.00, 500.00, 500.00),
(1766, 522, 3414, 1.00, 6000.00, 6000.00),
(1767, 522, 3188, 10.00, 50.00, 500.00),
(1768, 522, 3180, 10.00, 100.00, 1000.00),
(1769, 522, 3205, 10.00, 50.00, 500.00),
(1770, 522, 3206, 20.00, 100.00, 2000.00),
(1771, 523, 3301, 2.00, 1500.00, 3000.00),
(1772, 523, 3180, 10.00, 100.00, 1000.00),
(1773, 523, 3076, 1.00, 3500.00, 3500.00),
(1774, 523, 3216, 5.00, 500.00, 2500.00),
(1775, 524, 3261, 1.00, 500.00, 500.00),
(1776, 525, 3312, 10.00, 100.00, 1000.00),
(1777, 525, 3161, 20.00, 100.00, 2000.00),
(1778, 525, 3343, 1.00, 2000.00, 2000.00),
(1779, 526, 2997, 1.00, 4000.00, 4000.00),
(1780, 527, 3127, 1.00, 5500.00, 5500.00),
(1781, 528, 3108, 5.00, 200.00, 1000.00),
(1782, 528, 3048, 1.00, 7000.00, 7000.00),
(1783, 528, 3290, 2.00, 2000.00, 4000.00),
(1784, 529, 3068, 1.00, 2500.00, 2500.00),
(1785, 529, 3216, 4.00, 500.00, 2000.00),
(1786, 530, 2995, 1.00, 1300.00, 1300.00),
(1787, 530, 3269, 1.00, 1500.00, 1500.00),
(1788, 530, 3128, 1.00, 8000.00, 8000.00),
(1789, 530, 3289, 1.00, 2000.00, 2000.00),
(1790, 530, 2968, 20.00, 50.00, 1000.00),
(1791, 531, 2982, 3.00, 1500.00, 4500.00),
(1792, 531, 3098, 5.00, 200.00, 1000.00),
(1793, 532, 3211, 1.00, 2000.00, 2000.00),
(1794, 532, 3218, 20.00, 50.00, 1000.00),
(1795, 533, 3188, 10.00, 50.00, 500.00),
(1796, 533, 2968, 10.00, 50.00, 500.00),
(1797, 534, 3098, 5.00, 200.00, 1000.00),
(1798, 534, 3232, 10.00, 100.00, 1000.00),
(1799, 534, 3205, 10.00, 50.00, 500.00),
(1800, 534, 3094, 5.00, 200.00, 1000.00),
(1801, 534, 2990, 1.00, 5000.00, 5000.00),
(1802, 534, 3013, 1.00, 3000.00, 3000.00),
(1803, 534, 3256, 1.00, 7000.00, 7000.00),
(1804, 534, 3285, 1.00, 5000.00, 5000.00),
(1805, 534, 3329, 20.00, 400.00, 8000.00),
(1806, 535, 2968, 10.00, 50.00, 500.00),
(1807, 535, 3128, 1.00, 8000.00, 8000.00),
(1808, 536, 3015, 4.00, 2000.00, 8000.00),
(1809, 536, 3379, 6.00, 1000.00, 6000.00),
(1810, 536, 3359, 1.00, 7000.00, 7000.00),
(1811, 537, 3249, 4.00, 500.00, 2000.00),
(1812, 537, 3200, 10.00, 100.00, 1000.00),
(1813, 537, 3000, 1.00, 1000.00, 1000.00),
(1814, 537, 3189, 10.00, 100.00, 1000.00),
(1815, 538, 3149, 1.00, 1000.00, 1000.00),
(1816, 538, 3406, 2.00, 2000.00, 4000.00),
(1817, 538, 2982, 1.00, 1500.00, 1500.00),
(1818, 538, 3211, 1.00, 2000.00, 2000.00),
(1819, 538, 3165, 1.00, 500.00, 500.00),
(1820, 539, 3311, 1.00, 1000.00, 1000.00),
(1821, 539, 3318, 1.00, 1500.00, 1500.00),
(1822, 539, 3247, 1.00, 2000.00, 2000.00),
(1823, 539, 3003, 1.00, 5000.00, 5000.00),
(1824, 539, 3180, 20.00, 100.00, 2000.00),
(1825, 540, 3441, 1.00, 10000.00, 10000.00),
(1826, 540, 3188, 20.00, 50.00, 1000.00),
(1827, 540, 2993, 2.00, 1300.00, 2600.00),
(1828, 541, 2968, 40.00, 50.00, 2000.00),
(1829, 542, 3290, 5.00, 2000.00, 10000.00),
(1830, 542, 3176, 15.00, 200.00, 3000.00),
(1831, 543, 3414, 1.00, 6000.00, 6000.00),
(1832, 544, 3161, 30.00, 100.00, 3000.00),
(1833, 544, 3209, 1.00, 3500.00, 3500.00),
(1834, 544, 2982, 1.00, 1500.00, 1500.00),
(1835, 544, 2990, 1.00, 5000.00, 5000.00),
(1836, 544, 3262, 2.00, 500.00, 1000.00),
(1837, 544, 3289, 1.00, 2000.00, 2000.00),
(1838, 544, 3331, 1.00, 3500.00, 3500.00),
(1839, 544, 3211, 2.00, 2000.00, 4000.00),
(1840, 544, 2968, 20.00, 50.00, 1000.00),
(1841, 544, 3218, 10.00, 50.00, 500.00),
(1842, 544, 3188, 10.00, 50.00, 500.00),
(1843, 545, 3301, 2.00, 1500.00, 3000.00),
(1844, 545, 3289, 1.00, 2000.00, 2000.00),
(1845, 546, 2999, 2.00, 500.00, 1000.00),
(1846, 546, 3179, 1.00, 7000.00, 7000.00),
(1847, 547, 2969, 5.00, 200.00, 1000.00),
(1848, 547, 2968, 20.00, 50.00, 1000.00),
(1849, 547, 3251, 10.00, 100.00, 1000.00),
(1850, 548, 3249, 4.00, 500.00, 2000.00),
(1851, 548, 3418, 20.00, 200.00, 4000.00),
(1852, 548, 3167, 10.00, 200.00, 2000.00),
(1853, 548, 3218, 10.00, 50.00, 500.00),
(1854, 548, 3216, 5.00, 500.00, 2500.00),
(1855, 549, 3218, 20.00, 50.00, 1000.00),
(1856, 549, 2969, 10.00, 200.00, 2000.00),
(1857, 550, 3290, 2.00, 2000.00, 4000.00),
(1858, 550, 3088, 10.00, 250.00, 2500.00),
(1859, 550, 3263, 20.00, 50.00, 1000.00),
(1860, 551, 3331, 1.00, 3500.00, 3500.00),
(1861, 551, 3192, 1.00, 2000.00, 2000.00),
(1862, 552, 2995, 1.00, 1300.00, 1300.00),
(1863, 552, 3269, 1.00, 1500.00, 1500.00),
(1864, 553, 3328, 1.00, 8000.00, 8000.00),
(1865, 553, 3216, 5.00, 500.00, 2500.00),
(1866, 554, 3057, 1.00, 1000.00, 1000.00),
(1867, 554, 3261, 1.00, 500.00, 500.00),
(1868, 554, 3307, 1.00, 3000.00, 3000.00),
(1869, 554, 2999, 1.00, 500.00, 500.00),
(1870, 554, 3197, 5.00, 200.00, 1000.00),
(1871, 554, 3308, 10.00, 200.00, 2000.00),
(1872, 554, 3065, 1.00, 5000.00, 5000.00),
(1873, 555, 3000, 1.00, 1000.00, 1000.00),
(1874, 556, 3211, 1.00, 2000.00, 2000.00),
(1875, 556, 3261, 1.00, 500.00, 500.00),
(1876, 557, 3262, 2.00, 500.00, 1000.00),
(1877, 557, 3011, 5.00, 600.00, 3000.00),
(1878, 557, 3278, 5.00, 400.00, 2000.00),
(1879, 558, 3192, 2.00, 2000.00, 4000.00),
(1880, 558, 3189, 10.00, 100.00, 1000.00),
(1881, 559, 3329, 10.00, 400.00, 4000.00),
(1882, 560, 3186, 1.00, 2000.00, 2000.00),
(1883, 560, 3010, 10.00, 100.00, 1000.00),
(1884, 560, 3092, 2.00, 700.00, 1400.00),
(1885, 561, 3347, 2.00, 1500.00, 3000.00),
(1886, 561, 3258, 2.00, 2000.00, 4000.00),
(1887, 562, 3165, 2.00, 500.00, 1000.00),
(1888, 563, 3338, 1.00, 14000.00, 14000.00),
(1889, 563, 3216, 3.00, 500.00, 1500.00),
(1890, 563, 3110, 1.00, 4500.00, 4500.00),
(1891, 563, 3261, 2.00, 500.00, 1000.00),
(1892, 563, 3218, 20.00, 50.00, 1000.00),
(1893, 563, 3190, 1.00, 500.00, 500.00),
(1894, 563, 3161, 10.00, 100.00, 1000.00),
(1895, 563, 2969, 10.00, 200.00, 2000.00),
(1896, 563, 3205, 10.00, 50.00, 500.00),
(1897, 563, 3165, 1.00, 500.00, 500.00),
(1898, 563, 3211, 1.00, 2000.00, 2000.00),
(1899, 564, 3251, 10.00, 100.00, 1000.00),
(1900, 564, 3165, 1.00, 500.00, 500.00),
(1901, 565, 3094, 5.00, 200.00, 1000.00),
(1902, 566, 3093, 10.00, 1000.00, 10000.00),
(1903, 566, 2969, 10.00, 200.00, 2000.00),
(1904, 566, 3186, 1.00, 2000.00, 2000.00),
(1905, 566, 2999, 1.00, 500.00, 500.00),
(1906, 566, 3147, 1.00, 5000.00, 5000.00),
(1907, 566, 3014, 1.00, 5000.00, 5000.00),
(1908, 566, 3152, 1.00, 1000.00, 1000.00),
(1909, 566, 3153, 1.00, 1000.00, 1000.00),
(1910, 567, 3172, 4.00, 500.00, 2000.00),
(1911, 568, 3057, 1.00, 1000.00, 1000.00),
(1912, 569, 3249, 6.00, 500.00, 3000.00),
(1913, 569, 3261, 2.00, 500.00, 1000.00),
(1914, 569, 3065, 1.00, 5000.00, 5000.00),
(1915, 569, 3165, 10.00, 500.00, 5000.00),
(1916, 569, 3392, 10.00, 100.00, 1000.00),
(1917, 569, 3094, 5.00, 200.00, 1000.00),
(1918, 569, 3128, 1.00, 8000.00, 8000.00),
(1919, 569, 3000, 2.00, 1000.00, 2000.00),
(1920, 569, 2969, 10.00, 200.00, 2000.00),
(1921, 570, 3117, 1.00, 1000.00, 1000.00),
(1922, 570, 3205, 10.00, 50.00, 500.00),
(1923, 571, 3188, 20.00, 50.00, 1000.00),
(1924, 571, 3285, 1.00, 5000.00, 5000.00),
(1925, 571, 3031, 1.00, 5000.00, 5000.00),
(1926, 571, 3203, 1.00, 500.00, 500.00),
(1927, 571, 3159, 2.00, 500.00, 1000.00),
(1928, 571, 3168, 3.00, 600.00, 1800.00),
(1929, 572, 3247, 2.00, 2000.00, 4000.00),
(1930, 572, 2995, 2.00, 1300.00, 2600.00),
(1931, 573, 3278, 5.00, 400.00, 2000.00),
(1932, 573, 3226, 1.00, 6500.00, 6500.00),
(1933, 573, 3275, 10.00, 600.00, 6000.00),
(1934, 573, 3261, 1.00, 500.00, 500.00),
(1935, 573, 3190, 2.00, 500.00, 1000.00),
(1936, 574, 3013, 1.00, 3000.00, 3000.00),
(1937, 574, 3167, 5.00, 200.00, 1000.00),
(1938, 574, 2969, 5.00, 200.00, 1000.00),
(1939, 574, 3402, 1.00, 7500.00, 7500.00),
(1940, 574, 2971, 2.00, 1000.00, 2000.00),
(1941, 575, 3276, 1.00, 5000.00, 5000.00),
(1942, 576, 3163, 3.00, 1500.00, 4500.00),
(1943, 576, 3079, 1.00, 2500.00, 2500.00),
(1944, 576, 3347, 2.00, 1500.00, 3000.00),
(1945, 576, 3258, 2.00, 2000.00, 4000.00),
(1946, 576, 2968, 40.00, 50.00, 2000.00),
(1947, 576, 3149, 1.00, 1000.00, 1000.00),
(1948, 576, 3167, 5.00, 200.00, 1000.00),
(1949, 576, 3362, 1.00, 7000.00, 7000.00),
(1950, 576, 3252, 20.00, 400.00, 8000.00),
(1951, 576, 3041, 1.00, 8000.00, 8000.00),
(1952, 576, 3379, 2.00, 1000.00, 2000.00),
(1953, 577, 3261, 1.00, 500.00, 500.00),
(1954, 577, 3232, 10.00, 100.00, 1000.00),
(1955, 577, 2999, 2.00, 600.00, 1200.00),
(1956, 578, 3068, 1.00, 2500.00, 2500.00),
(1957, 579, 3200, 20.00, 100.00, 2000.00),
(1958, 579, 3161, 20.00, 100.00, 2000.00),
(1959, 580, 3028, 10.00, 100.00, 1000.00),
(1960, 580, 3026, 2.00, 700.00, 1400.00),
(1961, 580, 2995, 3.00, 1300.00, 3900.00),
(1962, 580, 3263, 10.00, 50.00, 500.00),
(1963, 581, 3168, 8.00, 600.00, 4800.00),
(1964, 581, 3127, 1.00, 5000.00, 5000.00),
(1965, 581, 2968, 10.00, 50.00, 500.00),
(1966, 581, 3152, 1.00, 1000.00, 1000.00),
(1967, 582, 3192, 1.00, 2000.00, 2000.00),
(1968, 582, 3189, 10.00, 100.00, 1000.00),
(1969, 582, 3368, 1.00, 3000.00, 3000.00),
(1970, 582, 3108, 10.00, 200.00, 2000.00),
(1971, 582, 3211, 1.00, 2000.00, 2000.00),
(1972, 583, 3010, 10.00, 100.00, 1000.00),
(1973, 584, 3003, 1.00, 5000.00, 5000.00),
(1974, 584, 3218, 10.00, 50.00, 500.00),
(1975, 584, 2968, 10.00, 50.00, 500.00),
(1976, 584, 2986, 1.00, 3500.00, 3500.00),
(1977, 584, 3152, 2.00, 1000.00, 2000.00),
(1978, 584, 3324, 10.00, 200.00, 2000.00),
(1979, 585, 3289, 1.00, 2000.00, 2000.00),
(1980, 586, 2971, 1.00, 1000.00, 1000.00),
(1981, 587, 3258, 1.00, 2000.00, 2000.00),
(1982, 587, 3218, 10.00, 100.00, 1000.00),
(1983, 587, 3379, 3.00, 1000.00, 3000.00),
(1984, 587, 3109, 7.00, 1000.00, 7000.00),
(1985, 588, 3442, 2.00, 2000.00, 4000.00),
(1986, 589, 3001, 2.00, 500.00, 1000.00),
(1987, 589, 3167, 5.00, 200.00, 1000.00),
(1988, 589, 3165, 2.00, 500.00, 1000.00),
(1989, 589, 3147, 1.00, 5000.00, 5000.00),
(1990, 589, 3203, 1.00, 500.00, 500.00),
(1991, 589, 2968, 10.00, 50.00, 500.00),
(1992, 589, 3258, 2.00, 2000.00, 4000.00),
(1993, 589, 3273, 10.00, 200.00, 2000.00),
(1994, 589, 2969, 10.00, 200.00, 2000.00),
(1995, 589, 2999, 4.00, 600.00, 2400.00),
(1996, 589, 3049, 1.00, 5000.00, 5000.00),
(1997, 589, 2986, 1.00, 3500.00, 3500.00),
(1998, 589, 3002, 1.00, 2000.00, 2000.00),
(1999, 589, 2990, 1.00, 5000.00, 5000.00),
(2000, 589, 3263, 10.00, 50.00, 500.00),
(2001, 590, 3269, 1.00, 1500.00, 1500.00),
(2002, 591, 3000, 3.00, 1000.00, 3000.00),
(2003, 591, 3200, 10.00, 100.00, 1000.00),
(2004, 591, 2969, 15.00, 200.00, 3000.00),
(2005, 591, 3218, 20.00, 50.00, 1000.00),
(2006, 591, 3167, 10.00, 200.00, 2000.00),
(2007, 591, 3026, 3.00, 700.00, 2100.00),
(2008, 591, 3170, 5.00, 4000.00, 20000.00),
(2009, 591, 3124, 4.00, 2000.00, 8000.00),
(2010, 591, 3186, 1.00, 2000.00, 2000.00),
(2011, 591, 3421, 1.00, 3000.00, 3000.00),
(2012, 591, 2990, 1.00, 5000.00, 5000.00),
(2013, 591, 3336, 1.00, 7000.00, 7000.00),
(2014, 591, 3161, 10.00, 100.00, 1000.00),
(2015, 591, 3205, 10.00, 50.00, 500.00),
(2016, 591, 3188, 10.00, 50.00, 500.00),
(2017, 591, 3192, 1.00, 2000.00, 2000.00),
(2018, 592, 3444, 1.00, 9000.00, 9000.00),
(2019, 592, 3443, 1.00, 19000.00, 19000.00),
(2020, 592, 3068, 1.00, 2500.00, 2500.00),
(2021, 593, 3261, 1.00, 500.00, 500.00),
(2022, 594, 3220, 1.00, 1000.00, 1000.00),
(2023, 594, 3167, 5.00, 200.00, 1000.00),
(2024, 594, 3073, 2.00, 500.00, 1000.00),
(2025, 594, 3211, 1.00, 2000.00, 2000.00),
(2026, 594, 3261, 1.00, 500.00, 500.00),
(2027, 594, 3165, 1.00, 500.00, 500.00),
(2028, 594, 3014, 1.00, 5000.00, 5000.00),
(2029, 594, 3189, 10.00, 100.00, 1000.00),
(2030, 594, 3105, 10.00, 100.00, 1000.00),
(2031, 594, 3249, 4.00, 500.00, 2000.00),
(2032, 595, 3167, 5.00, 200.00, 1000.00),
(2033, 595, 2969, 5.00, 200.00, 1000.00),
(2034, 595, 3289, 1.00, 2000.00, 2000.00),
(2035, 595, 3152, 1.00, 1000.00, 1000.00),
(2036, 595, 3373, 1.00, 1500.00, 1500.00),
(2037, 595, 2999, 2.00, 600.00, 1200.00),
(2038, 595, 3058, 1.00, 5000.00, 5000.00),
(2039, 595, 3287, 1.00, 5000.00, 5000.00),
(2040, 596, 3220, 6.00, 1000.00, 6000.00),
(2041, 597, 3421, 1.00, 3000.00, 3000.00),
(2042, 598, 3172, 6.00, 500.00, 3000.00),
(2043, 598, 3188, 10.00, 50.00, 500.00),
(2044, 599, 3165, 1.00, 500.00, 500.00),
(2045, 599, 2999, 2.00, 600.00, 1200.00),
(2046, 599, 3315, 1.00, 1000.00, 1000.00),
(2047, 599, 3088, 20.00, 250.00, 5000.00),
(2048, 599, 3205, 20.00, 50.00, 1000.00),
(2049, 599, 3200, 10.00, 100.00, 1000.00),
(2050, 600, 3240, 2.00, 500.00, 1000.00),
(2051, 600, 3202, 1.00, 4000.00, 4000.00),
(2052, 601, 3165, 1.00, 500.00, 500.00),
(2053, 602, 3261, 2.00, 500.00, 1000.00),
(2054, 602, 3123, 1.00, 1500.00, 1500.00),
(2055, 602, 3127, 1.00, 5000.00, 5000.00),
(2056, 602, 3188, 10.00, 50.00, 500.00),
(2057, 602, 3265, 1.00, 4000.00, 4000.00),
(2058, 602, 3195, 7.00, 1000.00, 7000.00),
(2059, 603, 3032, 1.00, 4000.00, 4000.00),
(2060, 603, 3272, 10.00, 200.00, 2000.00),
(2061, 603, 3228, 5.00, 200.00, 1000.00),
(2062, 603, 3248, 2.00, 500.00, 1000.00),
(2063, 603, 3336, 1.00, 7000.00, 7000.00),
(2064, 603, 3189, 10.00, 100.00, 1000.00),
(2065, 603, 3180, 10.00, 100.00, 1000.00),
(2066, 604, 3269, 2.00, 1500.00, 3000.00),
(2067, 604, 3189, 10.00, 100.00, 1000.00),
(2068, 604, 2969, 5.00, 200.00, 1000.00),
(2069, 604, 3251, 5.00, 100.00, 500.00),
(2070, 605, 3002, 1.00, 2000.00, 2000.00),
(2071, 605, 3269, 1.00, 1500.00, 1500.00),
(2072, 606, 3211, 1.00, 2000.00, 2000.00),
(2073, 606, 3186, 1.00, 2000.00, 2000.00),
(2074, 606, 2990, 1.00, 5000.00, 5000.00),
(2075, 606, 2968, 10.00, 50.00, 500.00),
(2076, 607, 3136, 1.00, 9000.00, 9000.00),
(2077, 607, 3205, 10.00, 50.00, 500.00),
(2078, 607, 3304, 1.00, 1500.00, 1500.00),
(2079, 607, 3165, 2.00, 500.00, 1000.00),
(2080, 607, 3163, 2.00, 1500.00, 3000.00),
(2081, 607, 2999, 1.00, 600.00, 600.00),
(2082, 607, 3000, 2.00, 1000.00, 2000.00),
(2083, 607, 3109, 5.00, 1000.00, 5000.00),
(2084, 607, 3362, 1.00, 7000.00, 7000.00),
(2085, 607, 3180, 10.00, 100.00, 1000.00),
(2086, 607, 3170, 1.00, 4000.00, 4000.00),
(2087, 608, 2991, 1.00, 24000.00, 24000.00),
(2088, 609, 3093, 10.00, 1000.00, 10000.00),
(2089, 609, 2988, 1.00, 7500.00, 7500.00),
(2090, 609, 3174, 30.00, 100.00, 3000.00),
(2091, 609, 3389, 1.00, 15000.00, 15000.00),
(2092, 609, 2968, 10.00, 50.00, 500.00),
(2093, 609, 3188, 10.00, 50.00, 500.00),
(2094, 609, 3273, 5.00, 200.00, 1000.00),
(2095, 609, 3232, 10.00, 100.00, 1000.00),
(2096, 609, 2969, 10.00, 200.00, 2000.00),
(2097, 609, 3222, 20.00, 50.00, 1000.00),
(2098, 609, 3194, 10.00, 150.00, 1500.00),
(2099, 610, 3124, 1.00, 2000.00, 2000.00),
(2100, 610, 3123, 1.00, 1500.00, 1500.00),
(2101, 610, 3211, 1.00, 2000.00, 2000.00),
(2102, 611, 3003, 1.00, 5000.00, 5000.00),
(2103, 611, 3260, 1.00, 10000.00, 10000.00),
(2104, 611, 3002, 3.00, 2000.00, 6000.00),
(2105, 611, 3101, 10.00, 150.00, 1500.00),
(2106, 611, 3206, 10.00, 100.00, 1000.00),
(2107, 611, 3275, 5.00, 600.00, 3000.00),
(2108, 612, 3289, 1.00, 2000.00, 2000.00),
(2109, 612, 3128, 1.00, 8000.00, 8000.00),
(2110, 612, 3257, 1.00, 500.00, 500.00),
(2111, 612, 3168, 10.00, 600.00, 6000.00),
(2112, 613, 3000, 1.00, 1000.00, 1000.00),
(2113, 614, 3129, 1.00, 4000.00, 4000.00),
(2114, 614, 3209, 1.00, 3500.00, 3500.00),
(2115, 614, 2971, 1.00, 1000.00, 1000.00),
(2116, 614, 3161, 10.00, 100.00, 1000.00),
(2117, 614, 3100, 10.00, 300.00, 3000.00),
(2118, 614, 3315, 2.00, 1000.00, 2000.00),
(2119, 614, 2982, 1.00, 1500.00, 1500.00),
(2120, 614, 3445, 20.00, 100.00, 2000.00),
(2121, 614, 3347, 4.00, 1500.00, 6000.00),
(2122, 614, 3272, 10.00, 200.00, 2000.00),
(2123, 615, 3069, 1.00, 5000.00, 5000.00),
(2124, 616, 3251, 5.00, 100.00, 500.00),
(2125, 616, 3218, 10.00, 50.00, 500.00),
(2126, 616, 3376, 2.00, 1000.00, 2000.00),
(2127, 616, 3174, 10.00, 100.00, 1000.00),
(2128, 617, 3434, 1.00, 8000.00, 8000.00),
(2129, 618, 3188, 10.00, 50.00, 500.00),
(2130, 618, 3261, 2.00, 500.00, 1000.00),
(2131, 619, 3165, 1.00, 500.00, 500.00),
(2132, 619, 3261, 1.00, 500.00, 500.00),
(2133, 619, 3133, 1.00, 3500.00, 3500.00),
(2134, 619, 2990, 1.00, 5000.00, 5000.00),
(2135, 619, 3205, 10.00, 50.00, 500.00),
(2136, 619, 2968, 10.00, 50.00, 500.00),
(2137, 619, 3445, 10.00, 100.00, 1000.00),
(2138, 620, 3118, 1.00, 4000.00, 4000.00),
(2139, 620, 3269, 1.00, 1500.00, 1500.00),
(2140, 621, 3376, 2.00, 1000.00, 2000.00),
(2141, 621, 3174, 10.00, 100.00, 1000.00),
(2142, 622, 3029, 10.00, 100.00, 1000.00),
(2143, 622, 2982, 1.00, 1500.00, 1500.00),
(2144, 622, 3009, 1.00, 1000.00, 1000.00),
(2145, 623, 3249, 6.00, 500.00, 3000.00),
(2146, 624, 3117, 2.00, 1000.00, 2000.00),
(2147, 624, 3000, 1.00, 1000.00, 1000.00),
(2148, 624, 3240, 1.00, 500.00, 500.00),
(2149, 625, 2982, 1.00, 1500.00, 1500.00),
(2150, 625, 3009, 1.00, 1000.00, 1000.00),
(2151, 625, 3209, 1.00, 3500.00, 3500.00),
(2152, 625, 3211, 1.00, 2000.00, 2000.00),
(2153, 626, 3280, 2.00, 1500.00, 3000.00),
(2154, 626, 3269, 1.00, 1500.00, 1500.00),
(2155, 626, 3161, 10.00, 100.00, 1000.00),
(2156, 626, 3257, 2.00, 500.00, 1000.00),
(2157, 626, 3200, 10.00, 100.00, 1000.00),
(2158, 626, 2999, 3.00, 600.00, 1800.00),
(2159, 626, 3261, 2.00, 500.00, 1000.00),
(2160, 626, 3165, 2.00, 500.00, 1000.00),
(2161, 627, 2968, 10.00, 50.00, 500.00),
(2162, 627, 3205, 10.00, 50.00, 500.00),
(2163, 628, 3228, 10.00, 200.00, 2000.00),
(2164, 628, 3445, 10.00, 100.00, 1000.00),
(2165, 628, 3272, 10.00, 200.00, 2000.00),
(2166, 628, 3190, 1.00, 500.00, 500.00),
(2167, 628, 3000, 1.00, 1000.00, 1000.00),
(2168, 628, 3105, 10.00, 100.00, 1000.00),
(2169, 628, 2968, 10.00, 50.00, 500.00),
(2170, 628, 3220, 14.00, 1000.00, 14000.00),
(2171, 628, 3189, 20.00, 100.00, 2000.00),
(2172, 629, 3128, 1.00, 8000.00, 8000.00),
(2173, 629, 3289, 1.00, 2000.00, 2000.00),
(2174, 629, 3204, 1.00, 2000.00, 2000.00),
(2175, 629, 3167, 5.00, 200.00, 1000.00),
(2176, 629, 3195, 1.00, 1000.00, 1000.00),
(2177, 629, 2995, 1.00, 1300.00, 1300.00),
(2178, 629, 2969, 5.00, 200.00, 1000.00),
(2179, 629, 3150, 1.00, 5000.00, 5000.00),
(2180, 629, 3189, 10.00, 100.00, 1000.00),
(2181, 629, 3273, 5.00, 200.00, 1000.00),
(2182, 630, 3343, 1.00, 2000.00, 2000.00),
(2183, 631, 3433, 10.00, 2500.00, 25000.00),
(2184, 631, 3167, 5.00, 200.00, 1000.00),
(2185, 631, 3269, 4.00, 1500.00, 6000.00),
(2186, 631, 2999, 2.00, 500.00, 1000.00),
(2187, 631, 3247, 1.00, 2000.00, 2000.00),
(2188, 631, 2995, 7.00, 1300.00, 9100.00),
(2189, 631, 2994, 1.00, 2500.00, 2500.00),
(2190, 631, 3394, 1.00, 700.00, 700.00),
(2191, 631, 3188, 20.00, 50.00, 1000.00),
(2192, 631, 3228, 10.00, 200.00, 2000.00),
(2193, 631, 3000, 1.00, 1000.00, 1000.00),
(2194, 632, 3438, 1.00, 14000.00, 14000.00),
(2195, 632, 3127, 1.00, 5500.00, 5500.00),
(2196, 633, 2990, 1.00, 5000.00, 5000.00),
(2197, 633, 3211, 1.00, 2000.00, 2000.00),
(2198, 633, 3161, 20.00, 100.00, 2000.00),
(2199, 633, 3251, 10.00, 100.00, 1000.00),
(2200, 633, 2988, 1.00, 7500.00, 7500.00),
(2201, 633, 3094, 10.00, 200.00, 2000.00),
(2202, 634, 3211, 1.00, 2000.00, 2000.00),
(2203, 635, 2999, 5.00, 600.00, 3000.00),
(2204, 635, 3200, 10.00, 100.00, 1000.00),
(2205, 635, 3011, 8.00, 600.00, 4800.00),
(2206, 635, 3186, 1.00, 2000.00, 2000.00),
(2207, 635, 3150, 1.00, 5000.00, 5000.00),
(2208, 635, 3010, 10.00, 100.00, 1000.00),
(2209, 635, 2997, 1.00, 5000.00, 5000.00),
(2210, 635, 2969, 5.00, 200.00, 1000.00),
(2211, 635, 3167, 5.00, 200.00, 1000.00),
(2212, 636, 3094, 5.00, 200.00, 1000.00),
(2213, 636, 2968, 20.00, 50.00, 1000.00),
(2214, 637, 3204, 1.00, 2000.00, 2000.00),
(2215, 637, 3347, 2.00, 1500.00, 3000.00),
(2216, 638, 3066, 1.00, 3000.00, 3000.00),
(2217, 638, 2999, 3.00, 600.00, 1800.00),
(2218, 638, 3205, 30.00, 50.00, 1500.00),
(2219, 638, 3249, 4.00, 500.00, 2000.00),
(2220, 638, 3108, 10.00, 200.00, 2000.00),
(2221, 639, 3271, 24.00, 208.33, 4999.92),
(2222, 639, 3311, 10.00, 1000.00, 10000.00),
(2223, 640, 2999, 1.00, 600.00, 600.00),
(2224, 640, 2971, 1.00, 1000.00, 1000.00),
(2225, 640, 2982, 1.00, 1500.00, 1500.00),
(2226, 640, 3209, 1.00, 3500.00, 3500.00),
(2227, 641, 3368, 1.00, 3000.00, 3000.00),
(2228, 641, 3094, 10.00, 200.00, 2000.00),
(2229, 641, 3161, 10.00, 100.00, 1000.00),
(2230, 641, 2993, 4.00, 1300.00, 5200.00),
(2231, 641, 3029, 10.00, 100.00, 1000.00),
(2232, 642, 3127, 1.00, 5000.00, 5000.00),
(2233, 642, 3216, 10.00, 500.00, 5000.00),
(2234, 643, 3031, 1.00, 5000.00, 5000.00),
(2235, 643, 3200, 10.00, 100.00, 1000.00),
(2236, 643, 3171, 5.00, 1500.00, 7500.00),
(2237, 643, 3205, 20.00, 50.00, 1000.00),
(2238, 643, 3418, 5.00, 200.00, 1000.00),
(2239, 643, 3094, 5.00, 200.00, 1000.00),
(2240, 643, 2968, 30.00, 50.00, 1500.00),
(2241, 643, 3315, 1.00, 1000.00, 1000.00),
(2242, 643, 3097, 15.00, 400.00, 6000.00),
(2243, 643, 3447, 1.00, 3000.00, 3000.00),
(2244, 644, 3001, 4.00, 500.00, 2000.00),
(2245, 644, 3435, 1.00, 5000.00, 5000.00),
(2246, 644, 3452, 1.00, 1500.00, 1500.00),
(2247, 644, 2995, 1.00, 1300.00, 1300.00),
(2248, 645, 3147, 1.00, 5000.00, 5000.00),
(2249, 646, 3453, 1.00, 5000.00, 5000.00),
(2250, 646, 3254, 1.00, 2000.00, 2000.00),
(2251, 646, 3292, 1.00, 2500.00, 2500.00),
(2252, 646, 3362, 1.00, 7000.00, 7000.00),
(2253, 647, 3418, 7.00, 214.29, 1500.03),
(2254, 647, 3174, 10.00, 100.00, 1000.00),
(2255, 647, 3104, 3.00, 1000.00, 3000.00),
(2256, 647, 2969, 15.00, 200.00, 3000.00),
(2257, 647, 3218, 20.00, 50.00, 1000.00),
(2258, 647, 3010, 10.00, 100.00, 1000.00),
(2259, 647, 3442, 4.00, 1750.00, 7000.00),
(2260, 647, 2999, 8.00, 600.00, 4800.00),
(2261, 648, 3263, 10.00, 50.00, 500.00),
(2262, 648, 3446, 3.00, 2500.00, 7500.00),
(2263, 648, 3240, 2.00, 500.00, 1000.00),
(2264, 648, 3209, 1.00, 3500.00, 3500.00),
(2266, 650, 2997, 1.00, 5000.00, 5000.00),
(2267, 651, 2968, 10.00, 50.00, 500.00),
(2268, 651, 3105, 10.00, 100.00, 1000.00),
(2269, 652, 3220, 1.00, 1000.00, 1000.00),
(2270, 652, 2982, 1.00, 1500.00, 1500.00),
(2271, 652, 3107, 5.00, 200.00, 1000.00),
(2272, 652, 3009, 1.00, 1000.00, 1000.00),
(2273, 652, 2969, 10.00, 200.00, 2000.00),
(2274, 652, 3279, 5.00, 300.00, 1500.00),
(2275, 652, 3172, 7.00, 500.00, 3500.00),
(2276, 652, 3232, 10.00, 100.00, 1000.00),
(2277, 652, 3211, 1.00, 2000.00, 2000.00),
(2278, 652, 3132, 1.00, 2500.00, 2500.00),
(2279, 652, 3031, 1.00, 5000.00, 5000.00),
(2280, 652, 3070, 1.00, 9000.00, 9000.00),
(2281, 653, 3273, 10.00, 200.00, 2000.00),
(2282, 653, 3148, 2.00, 500.00, 1000.00),
(2283, 653, 3318, 5.00, 1500.00, 7500.00),
(2284, 653, 3224, 1.00, 7000.00, 7000.00),
(2285, 653, 3200, 10.00, 100.00, 1000.00),
(2286, 653, 3418, 5.00, 200.00, 1000.00),
(2287, 653, 3216, 2.00, 500.00, 1000.00),
(2288, 654, 3165, 2.00, 500.00, 1000.00),
(2289, 655, 3211, 1.00, 2000.00, 2000.00),
(2291, 656, 3421, 2.00, 3000.00, 6000.00),
(2292, 656, 3172, 10.00, 500.00, 5000.00),
(2293, 656, 3011, 10.00, 600.00, 6000.00),
(2294, 656, 3102, 20.00, 100.00, 2000.00),
(2295, 656, 3001, 4.00, 500.00, 2000.00),
(2296, 656, 3249, 10.00, 500.00, 5000.00),
(2297, 656, 3264, 10.00, 100.00, 1000.00),
(2298, 657, 2995, 10.00, 1200.00, 12000.00),
(2299, 657, 2968, 10.00, 50.00, 500.00),
(2300, 657, 2998, 1.00, 5000.00, 5000.00),
(2301, 657, 2992, 24.00, 1000.00, 24000.00),
(2302, 657, 3097, 20.00, 400.00, 8000.00),
(2303, 657, 3251, 10.00, 100.00, 1000.00),
(2304, 657, 2969, 10.00, 200.00, 2000.00),
(2305, 657, 3188, 20.00, 50.00, 1000.00),
(2306, 657, 3360, 5.00, 1300.00, 6500.00),
(2307, 657, 3388, 5.00, 1200.00, 6000.00),
(2308, 658, 3454, 2.00, 1500.00, 3000.00),
(2309, 659, 2999, 5.00, 600.00, 3000.00),
(2310, 660, 3001, 2.00, 500.00, 1000.00),
(2311, 660, 3186, 1.00, 2000.00, 2000.00),
(2312, 660, 2982, 1.00, 1500.00, 1500.00),
(2313, 661, 3211, 1.00, 2000.00, 2000.00),
(2314, 661, 3000, 2.00, 1000.00, 2000.00),
(2315, 661, 3330, 1.00, 17000.00, 17000.00),
(2316, 661, 3088, 10.00, 250.00, 2500.00),
(2317, 661, 3003, 1.00, 5000.00, 5000.00),
(2318, 661, 3216, 3.00, 500.00, 1500.00),
(2319, 661, 3206, 10.00, 100.00, 1000.00),
(2320, 661, 3306, 1.00, 500.00, 500.00),
(2321, 661, 3254, 1.00, 2000.00, 2000.00),
(2322, 661, 3423, 1.00, 3500.00, 3500.00),
(2323, 661, 3124, 1.00, 2000.00, 2000.00),
(2324, 661, 3218, 20.00, 50.00, 1000.00),
(2325, 661, 3186, 1.00, 2000.00, 2000.00),
(2326, 661, 3189, 20.00, 100.00, 2000.00),
(2327, 661, 3205, 20.00, 50.00, 1000.00),
(2328, 661, 3174, 10.00, 100.00, 1000.00),
(2329, 661, 3315, 1.00, 1000.00, 1000.00),
(2330, 661, 2971, 2.00, 1000.00, 2000.00),
(2331, 661, 3092, 2.00, 700.00, 1400.00),
(2332, 661, 3008, 0.70, 1500.00, 1050.00),
(2333, 662, 3088, 20.00, 250.00, 5000.00),
(2334, 663, 3189, 10.00, 100.00, 1000.00),
(2335, 663, 3216, 4.00, 500.00, 2000.00),
(2336, 663, 3405, 1.00, 17000.00, 17000.00),
(2337, 663, 3262, 4.00, 500.00, 2000.00),
(2338, 663, 3174, 10.00, 100.00, 1000.00),
(2339, 664, 3107, 5.00, 200.00, 1000.00),
(2340, 664, 3205, 10.00, 50.00, 500.00),
(2341, 664, 3000, 1.00, 1000.00, 1000.00),
(2342, 664, 3249, 2.00, 500.00, 1000.00),
(2343, 665, 3188, 10.00, 50.00, 500.00),
(2344, 665, 3105, 10.00, 100.00, 1000.00),
(2345, 666, 2968, 10.00, 50.00, 500.00),
(2346, 666, 3092, 1.00, 700.00, 700.00),
(2347, 667, 3218, 10.00, 50.00, 500.00),
(2348, 667, 3209, 1.00, 3500.00, 3500.00),
(2349, 668, 3092, 1.00, 700.00, 700.00),
(2350, 669, 3029, 10.00, 100.00, 1000.00),
(2351, 669, 3068, 1.00, 2500.00, 2500.00),
(2352, 669, 2999, 2.00, 600.00, 1200.00),
(2353, 669, 3074, 1.00, 25000.00, 25000.00),
(2354, 669, 3205, 40.00, 50.00, 2000.00),
(2355, 669, 3273, 10.00, 200.00, 2000.00),
(2356, 670, 2999, 1.00, 600.00, 600.00),
(2357, 670, 2968, 10.00, 50.00, 500.00),
(2358, 670, 3180, 10.00, 100.00, 1000.00),
(2359, 670, 3211, 1.00, 2000.00, 2000.00),
(2360, 671, 3197, 15.00, 200.00, 3000.00),
(2361, 672, 3268, 4.00, 500.00, 2000.00),
(2362, 672, 3167, 5.00, 200.00, 1000.00),
(2363, 672, 3253, 2.00, 2000.00, 4000.00),
(2364, 673, 3280, 1.00, 1500.00, 1500.00),
(2365, 673, 2992, 3.00, 1000.00, 3000.00),
(2366, 673, 3455, 1.00, 15000.00, 15000.00),
(2367, 674, 3289, 1.00, 2000.00, 2000.00),
(2368, 674, 3127, 1.00, 5000.00, 5000.00),
(2369, 675, 3435, 1.00, 5000.00, 5000.00),
(2370, 675, 3280, 10.00, 1500.00, 15000.00),
(2371, 675, 3354, 10.00, 1500.00, 15000.00),
(2372, 675, 3302, 10.00, 500.00, 5000.00),
(2373, 675, 3011, 4.00, 600.00, 2400.00),
(2374, 676, 2992, 10.00, 1000.00, 10000.00),
(2375, 676, 3180, 10.00, 100.00, 1000.00),
(2376, 676, 3188, 20.00, 50.00, 1000.00),
(2377, 676, 3000, 2.00, 1000.00, 2000.00),
(2378, 676, 3203, 2.00, 500.00, 1000.00),
(2379, 676, 3097, 10.00, 400.00, 4000.00),
(2380, 677, 3213, 5.00, 1500.00, 7500.00),
(2381, 677, 3001, 4.00, 500.00, 2000.00),
(2382, 678, 3127, 1.00, 5000.00, 5000.00),
(2383, 679, 3248, 4.00, 500.00, 2000.00),
(2384, 679, 3155, 10.00, 500.00, 5000.00),
(2385, 680, 2982, 1.00, 1500.00, 1500.00),
(2386, 681, 3283, 1.00, 500.00, 500.00),
(2387, 682, 3073, 1.00, 500.00, 500.00),
(2388, 682, 3445, 10.00, 100.00, 1000.00),
(2389, 683, 3073, 1.00, 500.00, 500.00),
(2390, 683, 3445, 10.00, 100.00, 1000.00),
(2391, 683, 3272, 5.00, 200.00, 1000.00),
(2392, 684, 3197, 5.00, 200.00, 1000.00),
(2393, 684, 3095, 10.00, 100.00, 1000.00),
(2394, 684, 3264, 10.00, 100.00, 1000.00),
(2395, 685, 3285, 1.00, 5000.00, 5000.00),
(2396, 686, 2999, 1.00, 600.00, 600.00),
(2397, 686, 3205, 10.00, 50.00, 500.00),
(2398, 687, 3174, 20.00, 100.00, 2000.00),
(2399, 687, 3188, 20.00, 50.00, 1000.00),
(2400, 688, 3414, 1.00, 6000.00, 6000.00),
(2401, 689, 3400, 1.00, 3000.00, 3000.00),
(2402, 690, 3347, 2.00, 1500.00, 3000.00),
(2403, 690, 3456, 4.00, 1000.00, 4000.00),
(2404, 691, 3189, 20.00, 100.00, 2000.00),
(2405, 691, 3457, 1.00, 7000.00, 7000.00),
(2406, 691, 3418, 5.00, 200.00, 1000.00),
(2407, 691, 3218, 10.00, 50.00, 500.00),
(2408, 691, 3107, 5.00, 200.00, 1000.00),
(2409, 691, 3197, 5.00, 200.00, 1000.00),
(2410, 691, 3261, 2.00, 500.00, 1000.00),
(2411, 691, 3165, 2.00, 500.00, 1000.00),
(2412, 691, 3268, 10.00, 500.00, 5000.00),
(2413, 691, 3245, 10.00, 400.00, 4000.00),
(2414, 692, 2999, 5.00, 600.00, 3000.00),
(2415, 692, 2969, 10.00, 200.00, 2000.00),
(2416, 693, 3289, 1.00, 2000.00, 2000.00),
(2417, 693, 3218, 10.00, 50.00, 500.00),
(2418, 693, 3251, 10.00, 100.00, 1000.00),
(2419, 694, 3272, 5.00, 200.00, 1000.00),
(2420, 694, 3097, 5.00, 400.00, 2000.00),
(2421, 694, 3109, 3.00, 1000.00, 3000.00),
(2422, 694, 3123, 1.00, 1500.00, 1500.00),
(2423, 694, 3167, 5.00, 200.00, 1000.00),
(2424, 695, 3215, 7.00, 1000.00, 7000.00),
(2425, 695, 3174, 20.00, 100.00, 2000.00),
(2426, 695, 3170, 1.00, 4000.00, 4000.00),
(2427, 695, 3109, 1.00, 1000.00, 1000.00),
(2428, 695, 3318, 2.00, 1500.00, 3000.00),
(2429, 695, 3394, 1.00, 700.00, 700.00),
(2430, 696, 3458, 2.00, 500.00, 1000.00),
(2431, 696, 3254, 1.00, 2000.00, 2000.00),
(2432, 697, 3205, 20.00, 50.00, 1000.00),
(2433, 697, 3299, 1.00, 7500.00, 7500.00),
(2434, 698, 3109, 5.00, 1000.00, 5000.00),
(2435, 698, 2982, 2.00, 1500.00, 3000.00),
(2436, 698, 3029, 10.00, 100.00, 1000.00),
(2437, 698, 3005, 1.00, 6000.00, 6000.00),
(2438, 698, 3218, 10.00, 50.00, 500.00),
(2439, 698, 3174, 10.00, 100.00, 1000.00),
(2440, 698, 3211, 1.00, 2000.00, 2000.00),
(2441, 698, 3326, 10.00, 100.00, 1000.00),
(2442, 698, 3271, 24.00, 208.33, 4999.92),
(2443, 698, 2968, 30.00, 50.00, 1500.00),
(2444, 698, 3292, 1.00, 2500.00, 2500.00),
(2445, 698, 3365, 4.00, 1000.00, 4000.00),
(2446, 698, 3315, 4.00, 1000.00, 4000.00),
(2447, 698, 3092, 2.00, 700.00, 1400.00),
(2448, 698, 3050, 1.00, 18000.00, 18000.00),
(2449, 699, 3252, 10.00, 400.00, 4000.00),
(2450, 699, 3165, 2.00, 500.00, 1000.00),
(2451, 699, 3031, 1.00, 5000.00, 5000.00),
(2452, 699, 3269, 1.00, 1500.00, 1500.00),
(2453, 700, 3165, 2.00, 500.00, 1000.00),
(2454, 700, 3220, 1.00, 1000.00, 1000.00),
(2455, 700, 2982, 1.00, 1500.00, 1500.00),
(2456, 700, 3274, 1.00, 1500.00, 1500.00),
(2457, 700, 2999, 1.00, 600.00, 600.00),
(2458, 700, 3161, 10.00, 100.00, 1000.00),
(2459, 700, 3188, 10.00, 50.00, 500.00),
(2460, 700, 3414, 1.00, 6000.00, 6000.00),
(2461, 700, 3168, 2.00, 600.00, 1200.00),
(2462, 700, 3170, 1.00, 4000.00, 4000.00),
(2463, 700, 3109, 1.00, 1000.00, 1000.00),
(2464, 700, 3263, 10.00, 50.00, 500.00),
(2465, 700, 3000, 1.00, 1000.00, 1000.00),
(2466, 700, 3261, 1.00, 500.00, 500.00),
(2467, 700, 3315, 4.00, 1000.00, 4000.00),
(2468, 700, 3047, 1.00, 6000.00, 6000.00),
(2469, 701, 3379, 5.00, 1000.00, 5000.00),
(2470, 701, 3459, 10.00, 100.00, 1000.00),
(2471, 701, 3094, 15.00, 200.00, 3000.00),
(2472, 701, 3460, 4.00, 500.00, 2000.00),
(2473, 701, 3069, 1.00, 5000.00, 5000.00),
(2474, 702, 3107, 5.00, 200.00, 1000.00),
(2475, 702, 3205, 10.00, 50.00, 500.00),
(2476, 703, 3254, 1.00, 2000.00, 2000.00),
(2477, 703, 3261, 2.00, 500.00, 1000.00),
(2478, 703, 2968, 20.00, 50.00, 1000.00),
(2479, 703, 3097, 5.00, 400.00, 2000.00),
(2480, 703, 3445, 10.00, 100.00, 1000.00),
(2481, 703, 3268, 10.00, 500.00, 5000.00),
(2482, 703, 3109, 1.00, 1000.00, 1000.00),
(2483, 703, 3272, 5.00, 200.00, 1000.00),
(2484, 703, 3007, 1.00, 2500.00, 2500.00),
(2485, 704, 3159, 2.00, 500.00, 1000.00),
(2486, 704, 3205, 20.00, 50.00, 1000.00),
(2487, 704, 3174, 40.00, 100.00, 4000.00),
(2488, 704, 3445, 10.00, 100.00, 1000.00),
(2489, 705, 3330, 1.00, 17000.00, 17000.00),
(2490, 705, 2990, 3.00, 5000.00, 15000.00),
(2491, 706, 2968, 40.00, 50.00, 2000.00),
(2492, 706, 3261, 1.00, 500.00, 500.00),
(2493, 706, 3152, 2.00, 1000.00, 2000.00),
(2494, 706, 3272, 10.00, 200.00, 2000.00),
(2495, 706, 3189, 10.00, 100.00, 1000.00),
(2496, 706, 3418, 10.00, 200.00, 2000.00),
(2497, 706, 2969, 10.00, 200.00, 2000.00),
(2498, 706, 3232, 10.00, 100.00, 1000.00),
(2499, 707, 3458, 2.00, 500.00, 1000.00),
(2500, 707, 3124, 1.00, 2000.00, 2000.00),
(2501, 708, 3128, 1.00, 8000.00, 8000.00),
(2502, 708, 3289, 1.00, 2000.00, 2000.00),
(2503, 708, 3268, 10.00, 500.00, 5000.00),
(2504, 708, 2982, 1.00, 1500.00, 1500.00),
(2505, 708, 3124, 1.00, 2000.00, 2000.00),
(2506, 709, 3273, 5.00, 200.00, 1000.00),
(2507, 709, 2990, 1.00, 5000.00, 5000.00),
(2508, 709, 3189, 10.00, 100.00, 1000.00),
(2509, 710, 3269, 1.00, 1500.00, 1500.00),
(2510, 710, 3280, 1.00, 1500.00, 1500.00),
(2511, 711, 3037, 1.00, 3500.00, 3500.00),
(2512, 712, 3220, 1.00, 1000.00, 1000.00),
(2513, 713, 3189, 10.00, 100.00, 1000.00),
(2514, 714, 3150, 2.00, 5000.00, 10000.00),
(2515, 714, 3368, 1.00, 3000.00, 3000.00),
(2516, 714, 3268, 4.00, 500.00, 2000.00),
(2517, 715, 3280, 2.00, 1500.00, 3000.00),
(2518, 715, 3269, 2.00, 1500.00, 3000.00),
(2519, 715, 3308, 50.00, 200.00, 10000.00),
(2520, 715, 2969, 5.00, 200.00, 1000.00),
(2521, 715, 3001, 4.00, 500.00, 2000.00),
(2522, 715, 3400, 1.00, 3000.00, 3000.00),
(2523, 715, 3461, 20.00, 100.00, 2000.00),
(2524, 715, 3205, 10.00, 50.00, 500.00),
(2525, 715, 3192, 1.00, 2000.00, 2000.00),
(2526, 715, 3000, 4.00, 1000.00, 4000.00),
(2527, 715, 3200, 10.00, 100.00, 1000.00),
(2528, 715, 3250, 2.00, 500.00, 1000.00),
(2529, 715, 3174, 10.00, 100.00, 1000.00),
(2530, 715, 3048, 1.00, 7000.00, 7000.00),
(2531, 715, 3248, 2.00, 500.00, 1000.00),
(2532, 715, 3168, 3.00, 600.00, 1800.00),
(2533, 715, 3237, 4.00, 250.00, 1000.00),
(2534, 715, 3186, 2.00, 2000.00, 4000.00),
(2535, 715, 3315, 2.00, 1000.00, 2000.00),
(2536, 715, 3272, 10.00, 200.00, 2000.00),
(2537, 715, 3016, 1.00, 2000.00, 2000.00),
(2538, 715, 3109, 4.00, 1000.00, 4000.00),
(2539, 715, 3218, 20.00, 50.00, 1000.00),
(2540, 716, 3334, 6.00, 2000.00, 12000.00),
(2541, 716, 2968, 10.00, 50.00, 500.00),
(2542, 716, 3289, 3.00, 2000.00, 6000.00),
(2543, 716, 3249, 2.00, 500.00, 1000.00),
(2544, 717, 3168, 2.00, 600.00, 1200.00),
(2545, 718, 3147, 1.00, 5000.00, 5000.00),
(2546, 719, 3000, 1.00, 1000.00, 1000.00),
(2547, 719, 2969, 5.00, 200.00, 1000.00),
(2548, 720, 3168, 10.00, 600.00, 6000.00),
(2549, 720, 2982, 2.00, 1500.00, 3000.00),
(2550, 720, 2968, 10.00, 50.00, 500.00),
(2551, 721, 3186, 1.00, 2000.00, 2000.00),
(2552, 722, 3165, 2.00, 500.00, 1000.00),
(2553, 723, 3168, 2.00, 600.00, 1200.00),
(2554, 723, 3108, 5.00, 200.00, 1000.00),
(2555, 724, 3165, 13.00, 500.00, 6500.00),
(2556, 724, 3104, 6.00, 833.33, 4999.98),
(2557, 724, 3189, 30.00, 100.00, 3000.00),
(2558, 725, 3029, 10.00, 100.00, 1000.00);
INSERT INTO `sale_items_pharm` (`id`, `sale_id`, `product_id`, `quantity`, `price`, `total`) VALUES
(2559, 725, 3285, 2.00, 5000.00, 10000.00),
(2560, 726, 3128, 1.00, 8000.00, 8000.00),
(2561, 726, 3289, 1.00, 2000.00, 2000.00),
(2562, 726, 3108, 5.00, 200.00, 1000.00),
(2563, 726, 3307, 1.00, 3000.00, 3000.00),
(2564, 727, 3197, 2.00, 250.00, 500.00),
(2565, 728, 3289, 1.00, 2000.00, 2000.00),
(2566, 729, 3083, 1.00, 5000.00, 5000.00),
(2567, 729, 3364, 1.00, 12000.00, 12000.00),
(2568, 729, 3205, 10.00, 50.00, 500.00),
(2569, 729, 3105, 10.00, 100.00, 1000.00),
(2570, 729, 3149, 1.00, 1000.00, 1000.00),
(2571, 730, 2990, 1.00, 5000.00, 5000.00),
(2572, 731, 3192, 2.00, 2000.00, 4000.00),
(2573, 731, 2999, 5.00, 600.00, 3000.00),
(2574, 732, 3452, 1.00, 1500.00, 1500.00),
(2575, 733, 2970, 1.00, 3000.00, 3000.00),
(2576, 733, 3347, 1.00, 1500.00, 1500.00),
(2577, 733, 3073, 2.00, 500.00, 1000.00),
(2578, 734, 3280, 10.00, 1500.00, 15000.00),
(2579, 734, 3061, 1.00, 3500.00, 3500.00),
(2580, 734, 3076, 1.00, 3500.00, 3500.00),
(2581, 735, 3118, 1.00, 4000.00, 4000.00),
(2582, 736, 3343, 1.00, 2000.00, 2000.00),
(2583, 736, 3124, 1.00, 2000.00, 2000.00),
(2584, 737, 3003, 1.00, 5000.00, 5000.00),
(2585, 737, 3001, 1.00, 500.00, 500.00),
(2586, 738, 3001, 3.00, 500.00, 1500.00),
(2587, 738, 3011, 5.00, 600.00, 3000.00),
(2588, 738, 3349, 5.00, 600.00, 3000.00),
(2589, 738, 3029, 10.00, 100.00, 1000.00),
(2590, 738, 3102, 10.00, 100.00, 1000.00),
(2591, 739, 3159, 2.00, 500.00, 1000.00),
(2592, 739, 3172, 5.00, 500.00, 2500.00),
(2593, 739, 2969, 5.00, 200.00, 1000.00),
(2594, 739, 3109, 2.00, 1000.00, 2000.00),
(2595, 739, 3272, 10.00, 200.00, 2000.00),
(2596, 739, 3456, 2.00, 1000.00, 2000.00),
(2597, 739, 3233, 1.00, 1000.00, 1000.00),
(2598, 740, 3222, 20.00, 50.00, 1000.00),
(2599, 740, 2970, 1.00, 3000.00, 3000.00),
(2600, 740, 3261, 1.00, 500.00, 500.00),
(2601, 740, 3117, 1.00, 1000.00, 1000.00),
(2602, 740, 2995, 5.00, 1200.00, 6000.00),
(2603, 741, 3161, 20.00, 100.00, 2000.00),
(2604, 741, 3137, 1.00, 6000.00, 6000.00),
(2605, 741, 2990, 1.00, 5000.00, 5000.00),
(2606, 741, 3306, 1.00, 500.00, 500.00),
(2607, 741, 3000, 1.00, 1000.00, 1000.00),
(2608, 741, 3029, 10.00, 100.00, 1000.00),
(2609, 741, 3192, 1.00, 2000.00, 2000.00),
(2610, 741, 3197, 5.00, 200.00, 1000.00),
(2611, 741, 3167, 10.00, 200.00, 2000.00),
(2612, 741, 3251, 10.00, 100.00, 1000.00),
(2613, 741, 2968, 30.00, 50.00, 1500.00),
(2614, 742, 3456, 2.00, 1000.00, 2000.00),
(2615, 742, 3000, 1.00, 1000.00, 1000.00),
(2616, 742, 3418, 5.00, 200.00, 1000.00),
(2617, 742, 3174, 10.00, 100.00, 1000.00),
(2618, 742, 2996, 1.00, 1000.00, 1000.00),
(2619, 742, 3271, 4.00, 250.00, 1000.00),
(2620, 742, 3154, 1.00, 2000.00, 2000.00),
(2621, 742, 2968, 20.00, 50.00, 1000.00),
(2622, 743, 3161, 10.00, 100.00, 1000.00),
(2623, 743, 3222, 30.00, 50.00, 1500.00),
(2624, 744, 3094, 10.00, 200.00, 2000.00),
(2625, 745, 3124, 1.00, 2000.00, 2000.00),
(2626, 746, 3214, 1.00, 6000.00, 6000.00),
(2627, 746, 3209, 2.00, 3500.00, 7000.00),
(2628, 746, 3165, 2.00, 500.00, 1000.00),
(2629, 746, 3261, 2.00, 500.00, 1000.00),
(2630, 746, 3232, 10.00, 100.00, 1000.00),
(2631, 746, 2969, 10.00, 200.00, 2000.00),
(2632, 746, 3049, 1.00, 5000.00, 5000.00),
(2633, 746, 3430, 2.00, 6000.00, 12000.00),
(2634, 747, 3462, 1.00, 7000.00, 7000.00),
(2635, 747, 3200, 10.00, 100.00, 1000.00),
(2636, 748, 3141, 1.00, 4000.00, 4000.00),
(2637, 748, 3068, 1.00, 2500.00, 2500.00),
(2638, 748, 3186, 1.00, 2000.00, 2000.00),
(2639, 748, 3220, 1.00, 1000.00, 1000.00),
(2640, 748, 3251, 10.00, 100.00, 1000.00),
(2641, 749, 3167, 5.00, 200.00, 1000.00),
(2642, 749, 3211, 1.00, 2000.00, 2000.00),
(2643, 749, 3132, 1.00, 2500.00, 2500.00),
(2644, 749, 3134, 1.00, 5000.00, 5000.00),
(2645, 749, 3283, 1.00, 500.00, 500.00),
(2646, 749, 2996, 2.00, 1000.00, 2000.00),
(2647, 750, 3271, 12.00, 250.00, 3000.00),
(2648, 750, 2968, 20.00, 50.00, 1000.00),
(2649, 751, 3290, 2.00, 2000.00, 4000.00),
(2650, 751, 3109, 2.00, 1000.00, 2000.00),
(2651, 752, 3191, 10.00, 100.00, 1000.00),
(2652, 753, 3168, 1.00, 600.00, 600.00),
(2653, 753, 3379, 5.00, 1000.00, 5000.00),
(2654, 754, 3261, 1.00, 500.00, 500.00),
(2655, 754, 3418, 10.00, 200.00, 2000.00),
(2656, 755, 3180, 10.00, 100.00, 1000.00),
(2657, 756, 3165, 2.00, 500.00, 1000.00),
(2658, 757, 3251, 10.00, 100.00, 1000.00),
(2659, 758, 3127, 1.00, 5500.00, 5500.00),
(2660, 759, 3216, 5.00, 500.00, 2500.00),
(2661, 759, 3068, 1.00, 2500.00, 2500.00),
(2662, 760, 3108, 10.00, 200.00, 2000.00),
(2663, 761, 3023, 1.00, 3500.00, 3500.00),
(2664, 762, 3355, 1.00, 5000.00, 5000.00),
(2665, 762, 3218, 10.00, 50.00, 500.00),
(2666, 762, 3295, 4.00, 500.00, 2000.00),
(2667, 762, 3105, 10.00, 100.00, 1000.00),
(2668, 762, 3117, 1.00, 1000.00, 1000.00),
(2669, 762, 3312, 10.00, 100.00, 1000.00),
(2670, 763, 3289, 2.00, 2000.00, 4000.00),
(2671, 764, 3124, 1.00, 2000.00, 2000.00),
(2672, 765, 3002, 1.00, 2000.00, 2000.00),
(2673, 765, 2982, 1.00, 1500.00, 1500.00),
(2674, 766, 3051, 1.00, 5000.00, 5000.00),
(2675, 767, 3216, 1.00, 500.00, 500.00),
(2676, 767, 3365, 2.00, 1000.00, 2000.00),
(2677, 768, 3068, 1.00, 2500.00, 2500.00),
(2678, 768, 3174, 10.00, 100.00, 1000.00),
(2679, 768, 3232, 10.00, 100.00, 1000.00),
(2680, 768, 2999, 1.00, 600.00, 600.00),
(2681, 768, 2995, 1.00, 1200.00, 1200.00),
(2682, 768, 3172, 1.00, 500.00, 500.00),
(2683, 768, 3268, 10.00, 500.00, 5000.00),
(2684, 769, 3473, 1.00, 15000.00, 15000.00),
(2685, 769, 3434, 1.00, 9000.00, 9000.00),
(2686, 770, 2992, 10.00, 1000.00, 10000.00),
(2687, 770, 3474, 6.00, 500.00, 3000.00),
(2688, 770, 3189, 10.00, 100.00, 1000.00),
(2689, 770, 3165, 1.00, 500.00, 500.00),
(2690, 771, 2990, 1.00, 5000.00, 5000.00),
(2691, 771, 3273, 5.00, 200.00, 1000.00),
(2692, 771, 3200, 10.00, 100.00, 1000.00),
(2693, 771, 3165, 1.00, 500.00, 500.00),
(2694, 771, 3474, 4.00, 500.00, 2000.00),
(2695, 771, 2995, 2.00, 1200.00, 2400.00),
(2696, 771, 3102, 10.00, 100.00, 1000.00),
(2697, 771, 3026, 5.00, 700.00, 3500.00),
(2698, 772, 3002, 1.00, 2000.00, 2000.00),
(2699, 772, 3211, 1.00, 2000.00, 2000.00),
(2700, 773, 3213, 2.00, 1500.00, 3000.00),
(2701, 774, 3100, 10.00, 300.00, 3000.00),
(2702, 774, 3189, 10.00, 100.00, 1000.00),
(2703, 774, 3203, 2.00, 500.00, 1000.00),
(2704, 775, 3430, 1.00, 6000.00, 6000.00),
(2705, 776, 2982, 1.00, 1500.00, 1500.00),
(2706, 776, 3251, 10.00, 100.00, 1000.00),
(2707, 777, 3211, 1.00, 2000.00, 2000.00),
(2708, 777, 3161, 20.00, 100.00, 2000.00),
(2709, 777, 3000, 1.00, 1000.00, 1000.00),
(2710, 777, 3045, 1.00, 2000.00, 2000.00),
(2711, 778, 3161, 10.00, 100.00, 1000.00),
(2712, 778, 3273, 10.00, 200.00, 2000.00),
(2713, 779, 3167, 5.00, 200.00, 1000.00),
(2714, 779, 3421, 1.00, 3000.00, 3000.00),
(2715, 779, 3174, 10.00, 100.00, 1000.00),
(2716, 780, 2990, 1.00, 5000.00, 5000.00),
(2717, 781, 3092, 2.00, 700.00, 1400.00),
(2718, 782, 3421, 1.00, 3000.00, 3000.00),
(2719, 782, 2971, 1.00, 1000.00, 1000.00),
(2720, 783, 3289, 2.00, 2000.00, 4000.00),
(2721, 783, 3127, 1.00, 5500.00, 5500.00),
(2722, 784, 3109, 1.00, 1000.00, 1000.00),
(2723, 784, 3290, 1.00, 2000.00, 2000.00),
(2724, 785, 3107, 5.00, 200.00, 1000.00),
(2725, 786, 3430, 1.00, 6000.00, 6000.00),
(2726, 786, 3189, 10.00, 100.00, 1000.00),
(2727, 786, 2990, 1.00, 5000.00, 5000.00),
(2728, 786, 3204, 1.00, 2000.00, 2000.00),
(2729, 786, 3180, 10.00, 100.00, 1000.00),
(2730, 787, 2968, 20.00, 50.00, 1000.00),
(2731, 788, 3147, 1.00, 5000.00, 5000.00),
(2732, 788, 3250, 2.00, 500.00, 1000.00),
(2733, 789, 3289, 1.00, 2000.00, 2000.00),
(2734, 790, 3209, 1.00, 3500.00, 3500.00),
(2735, 790, 2982, 1.00, 1500.00, 1500.00),
(2736, 790, 3107, 5.00, 200.00, 1000.00),
(2737, 791, 2982, 1.00, 1500.00, 1500.00),
(2738, 791, 3174, 10.00, 100.00, 1000.00),
(2739, 791, 2996, 1.00, 1000.00, 1000.00),
(2740, 791, 3107, 5.00, 200.00, 1000.00),
(2741, 792, 3256, 1.00, 7000.00, 7000.00),
(2742, 792, 3218, 10.00, 50.00, 500.00),
(2743, 793, 3254, 1.00, 2000.00, 2000.00),
(2744, 793, 3188, 10.00, 50.00, 500.00),
(2745, 793, 3251, 10.00, 100.00, 1000.00),
(2746, 793, 3000, 1.00, 1000.00, 1000.00),
(2747, 793, 2969, 5.00, 200.00, 1000.00),
(2748, 794, 3174, 10.00, 100.00, 1000.00),
(2749, 795, 3290, 1.00, 2000.00, 2000.00),
(2750, 796, 3020, 1.00, 8000.00, 8000.00),
(2751, 796, 2968, 30.00, 50.00, 1500.00),
(2752, 796, 3152, 1.00, 1000.00, 1000.00),
(2753, 796, 2969, 5.00, 200.00, 1000.00),
(2754, 796, 3155, 6.00, 500.00, 3000.00),
(2755, 796, 3268, 2.00, 500.00, 1000.00),
(2756, 796, 3251, 10.00, 100.00, 1000.00),
(2757, 797, 3445, 30.00, 100.00, 3000.00),
(2758, 797, 3161, 30.00, 100.00, 3000.00),
(2759, 797, 3459, 10.00, 100.00, 1000.00),
(2760, 798, 3345, 2.00, 500.00, 1000.00),
(2761, 799, 2999, 3.00, 600.00, 1800.00),
(2762, 800, 3376, 1.00, 1000.00, 1000.00),
(2763, 801, 3448, 10.00, 100.00, 1000.00),
(2764, 801, 2982, 2.00, 1500.00, 3000.00),
(2765, 801, 3445, 10.00, 100.00, 1000.00),
(2766, 801, 3435, 2.00, 5000.00, 10000.00),
(2767, 802, 2968, 10.00, 50.00, 500.00),
(2768, 803, 2990, 2.00, 5000.00, 10000.00),
(2769, 803, 3147, 1.00, 5000.00, 5000.00),
(2770, 803, 2995, 7.00, 1200.00, 8400.00),
(2771, 803, 3171, 2.00, 1500.00, 3000.00),
(2772, 803, 2968, 40.00, 50.00, 2000.00),
(2773, 803, 3001, 6.00, 500.00, 3000.00),
(2774, 803, 2982, 1.00, 1500.00, 1500.00),
(2775, 803, 3172, 12.00, 500.00, 6000.00),
(2776, 803, 3249, 6.00, 500.00, 3000.00),
(2777, 803, 3418, 5.00, 200.00, 1000.00),
(2778, 803, 2969, 10.00, 200.00, 2000.00),
(2779, 803, 3123, 1.00, 2000.00, 2000.00),
(2780, 803, 3289, 1.00, 2000.00, 2000.00),
(2781, 804, 3409, 1.00, 1000.00, 1000.00),
(2782, 804, 3254, 1.00, 2000.00, 2000.00),
(2783, 804, 3209, 2.00, 3500.00, 7000.00),
(2784, 804, 3009, 10.00, 1000.00, 10000.00),
(2785, 804, 3392, 10.00, 100.00, 1000.00),
(2786, 804, 3218, 30.00, 50.00, 1500.00),
(2787, 804, 3180, 10.00, 100.00, 1000.00),
(2788, 805, 3008, 1.00, 1500.00, 1500.00),
(2789, 806, 3216, 2.00, 500.00, 1000.00),
(2790, 807, 3299, 1.00, 7000.00, 7000.00),
(2791, 808, 3107, 5.00, 200.00, 1000.00),
(2792, 808, 3254, 1.00, 2000.00, 2000.00),
(2793, 808, 2968, 10.00, 50.00, 500.00),
(2794, 809, 3008, 5.00, 200.00, 1000.00),
(2795, 809, 3272, 10.00, 200.00, 2000.00),
(2796, 809, 3108, 5.00, 200.00, 1000.00),
(2797, 809, 3249, 4.00, 500.00, 2000.00),
(2798, 810, 3007, 1.00, 2500.00, 2500.00),
(2799, 810, 2988, 1.00, 7500.00, 7500.00),
(2800, 810, 3241, 1.00, 10000.00, 10000.00),
(2801, 810, 2969, 5.00, 200.00, 1000.00),
(2802, 810, 3345, 1.00, 500.00, 500.00),
(2803, 810, 2999, 2.00, 600.00, 1200.00),
(2804, 811, 3200, 10.00, 100.00, 1000.00),
(2805, 812, 3347, 6.00, 1500.00, 9000.00),
(2806, 812, 3252, 5.00, 400.00, 2000.00),
(2807, 813, 3272, 5.00, 200.00, 1000.00),
(2808, 814, 3209, 2.00, 3500.00, 7000.00),
(2809, 814, 3174, 10.00, 100.00, 1000.00),
(2810, 814, 3272, 5.00, 200.00, 1000.00),
(2811, 814, 3109, 5.00, 1000.00, 5000.00),
(2812, 814, 3176, 15.00, 200.00, 3000.00),
(2813, 815, 3209, 3.00, 3500.00, 10500.00),
(2814, 815, 3000, 2.00, 1000.00, 2000.00),
(2815, 815, 3275, 5.00, 600.00, 3000.00),
(2816, 815, 3418, 5.00, 200.00, 1000.00),
(2817, 815, 3211, 1.00, 2000.00, 2000.00),
(2818, 815, 3117, 1.00, 1000.00, 1000.00),
(2819, 815, 2998, 1.00, 5000.00, 5000.00),
(2820, 815, 3011, 5.00, 600.00, 3000.00),
(2821, 815, 3349, 5.00, 600.00, 3000.00),
(2822, 815, 3222, 20.00, 50.00, 1000.00),
(2823, 815, 3102, 10.00, 100.00, 1000.00),
(2824, 815, 2995, 5.00, 1300.00, 6500.00),
(2825, 815, 3172, 5.00, 500.00, 2500.00),
(2826, 816, 3133, 1.00, 3500.00, 3500.00),
(2827, 816, 2971, 3.00, 1000.00, 3000.00);

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
(6, 'EmmanuelNoel', 'aVlDM1p1Ym1RQWpyK0laMUREN25QQT09OjoMsG0rdxp+X5PA5NjRI0D7', 'admin', 'System Admin', 'admin@noel.com', '+2567000000000', '2025-07-11 20:05:40', '2025-09-09 21:36:54', 1),
(13, 'Administrator', 'RGJxUmdld20yTHljbjd1ZGxVWUZjZz09OjqyhnkJZMP/0G0URMRJ9ez3', 'admin', 'Charles', 'Charishealth@gmail.com', '0775480232', '2025-07-17 17:11:00', '2025-11-10 21:34:16', 1),
(14, 'Dispenser1', 'VVpOM296Vk15NnJqQzdmUTlPdUM3Zz09Ojoa46dzHh5dXeDlBmgCK3he', 'pharmacist', 'Gloria Namukisa', 'gloriabecky01@gmail.com', '0700228344', '2025-07-23 17:51:51', '2025-11-10 17:59:12', 1);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=199;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3475;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=817;

--
-- AUTO_INCREMENT for table `sale_items_pharm`
--
ALTER TABLE `sale_items_pharm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2828;

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
