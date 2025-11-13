<?php
require_once 'includes/database.php';

if ($_POST['id']) {
    $db->execute("UPDATE drug_notifications SET is_read = TRUE WHERE id = ?", [$_POST['id']]);
    echo "OK";
}
?>