<?php
require_once 'includes/db.php';
require_once 'includes/auth.php';

$db = new Database();
$auth = new Auth($db);

$admin_data = [
    'username' => 'EmmanuelNoel',
    'password' => 'Nsambya@2024',
    'role' => 'admin',
    'full_name' => 'System Admin',
    'email' => 'admin@noel.com',
    'phone' => '+256700000000'
];

$encrypted_password = $auth->encrypt($admin_data['password']);

try {
    $db->insert('users', [
        'username' => $admin_data['username'],
        'password' => $encrypted_password,
        'role' => $admin_data['role'],
        'full_name' => $admin_data['full_name'],
        'email' => $admin_data['email'],
        'phone' => $admin_data['phone'],
        'created_at' => date('Y-m-d H:i:s')
    ]);

    echo "Admin created successfully!<br>";
    echo "Username: <strong>{$admin_data['username']}</strong><br>";
    echo "Password: <strong>{$admin_data['password']}</strong><br>";
    echo "<b style='color:red'>Delete this file after running.</b>";

} catch (Exception $e) {
    echo "Failed: " . $e->getMessage();
}
