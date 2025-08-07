<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

$timeout_duration = 900; 

if (isset($_SESSION['last_activity']) && (time() - $_SESSION['last_activity']) > $timeout_duration) {
    session_unset();
    session_destroy();
    header("Location: /pharmacy_system/login.php?timeout=1");
    exit();
}

$_SESSION['last_activity'] = time();

require_once 'db.php';

class Auth {
    private $db;
    private $key = 'd15a5f6e8c3b7a9d2f4e1c8b7a3d6f5e9c2b8a7d4f6e3c9a8b5d2f1e4c7b6a9';

    public function __construct($db) {
        $this->db = $db;
    }
public function login($username, $password) {
    $user = $this->db->query("SELECT * FROM users_pharm WHERE username = ?", [$username]);
    
    // Path to your log file
    $logFile = "C:/Users/User/Desktop/test.txt";
    
    // Start logging attempt
    // file_put_contents($logFile, "Login Attempt at " . date('Y-m-d H:i:s') . PHP_EOL, FILE_APPEND);
    // file_put_contents($logFile, "Entered Username: $username" . PHP_EOL, FILE_APPEND);
    // file_put_contents($logFile, "Entered Password: $password" . PHP_EOL, FILE_APPEND);
    
    if (!$user || empty($user)) {
        // file_put_contents($logFile, "Result: User not found in DB" . PHP_EOL . PHP_EOL, FILE_APPEND);
        return false;
    }

    $user = $user[0];

    try {
        $decrypted_password = $this->decrypt($user['password']);

        // file_put_contents($logFile, "Decrypted Password from DB: $decrypted_password" . PHP_EOL, FILE_APPEND);

        if ($password === $decrypted_password) {
            // file_put_contents($logFile, "Result: Login successful" . PHP_EOL . PHP_EOL, FILE_APPEND);

            $_SESSION['user_id'] = $user['id'];
            $_SESSION['username'] = $user['username'];
            $_SESSION['role'] = $user['role'];
            $_SESSION['full_name'] = $user['full_name'];

            $this->db->execute("UPDATE users_pharm SET last_login = NOW() WHERE id = ?", [$user['id']]);
            return true;
        } else {
            // file_put_contents($logFile, "Result: Password mismatch" . PHP_EOL . PHP_EOL, FILE_APPEND);
        }
    } catch (Exception $e) {
        // file_put_contents($logFile, "Decryption error: " . $e->getMessage() . PHP_EOL . PHP_EOL, FILE_APPEND);
    }

    return false;
}


    public function createUser($username, $password, $role, $full_name, $email, $phone) {
        $encrypted_password = $this->encrypt($password);
        
        return $this->db->insert('users', [
            'username' => $username,
            'password' => $encrypted_password,
            'role' => $role,
            'full_name' => $full_name,
            'email' => $email,
            'phone' => $phone,
            'created_at' => date('Y-m-d H:i:s')
        ]);
    }

    public function logout() {
        session_destroy();
        header("Location: /pharmacy_system/login.php");
        exit();
    }

    public function isLoggedIn() {
        return isset($_SESSION['user_id']);
    }

    public function isAdmin() {
        return $this->isLoggedIn() && $_SESSION['role'] === 'admin';
    }

    public function isPharmacist() {
        return $this->isLoggedIn() && $_SESSION['role'] === 'pharmacist';
    }

    public function encrypt($data) {
        $iv = openssl_random_pseudo_bytes(openssl_cipher_iv_length('AES-256-CBC'));
        if ($iv === false) {
            throw new Exception("IV generation failed");
        }
        
        $encrypted = openssl_encrypt($data, 'AES-256-CBC', $this->key, 0, $iv);
        if ($encrypted === false) {
            throw new Exception("Encryption failed");
        }
        
        return base64_encode($encrypted . '::' . $iv);
    }

    public function decrypt($data) {
        $parts = explode('::', base64_decode($data), 2);
        if (count($parts) != 2) {
            throw new Exception("Invalid encrypted data format");
        }
        
        list($encrypted_data, $iv) = $parts;
        $decrypted = openssl_decrypt($encrypted_data, 'AES-256-CBC', $this->key, 0, $iv);
        if ($decrypted === false) {
            throw new Exception("Decryption failed");
        }
        
        return $decrypted;
    }

    public function changePassword($user_id, $new_password) {
        $encrypted_password = $this->encrypt($new_password);
        return $this->db->execute(
            "UPDATE users_pharm SET password = ? WHERE id = ?",
            [$encrypted_password, $user_id]
        );
    }
}

$auth = new Auth($db);

function requireLogin() {
    global $auth;
    if (!$auth->isLoggedIn()) {
        $_SESSION['redirect_url'] = $_SERVER['REQUEST_URI'];
        $_SESSION['error'] = "Please login to access this page";
        header("Location: /pharmacy_system/login.php");
        exit();
    }
}

function requireAdmin() {
    global $auth;
    requireLogin();
    if (!$auth->isAdmin()) {
        $_SESSION['error'] = "Access denied - Administrator privileges required";
        header("Location: sales.php");
        exit();
    }
}

function requirePharmacist() {
    global $auth;
    requireLogin();
    if (!$auth->isPharmacist() && !$auth->isAdmin()) {
        $_SESSION['error'] = "Access denied - Pharmacist privileges required";
        header("Location: index.php");
        exit();
    }
}