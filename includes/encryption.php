<?php
class Encryption {
    private $key;
    private $cipher = "AES-256-CBC";
    private $options = OPENSSL_RAW_DATA;
    private $iv_length;
    
    public function __construct($key) {
        if (strlen($key) < 32) {
            throw new Exception("Encryption key must be at least 32 characters long");
        }
        $this->key = hash('sha256', $key, true);
        $this->iv_length = openssl_cipher_iv_length($this->cipher);
    }
    
    public function encrypt($data) {
        $iv = openssl_random_pseudo_bytes($this->iv_length);
        $encrypted = openssl_encrypt($data, $this->cipher, $this->key, $this->options, $iv);
        return base64_encode($iv . $encrypted);
    }
    
    public function decrypt($data) {
        $data = base64_decode($data);
        $iv = substr($data, 0, $this->iv_length);
        $encrypted = substr($data, $this->iv_length);
        return openssl_decrypt($encrypted, $this->cipher, $this->key, $this->options, $iv);
    }
    
    public static function generateKey($length = 32) {
        return bin2hex(random_bytes($length));
    }
}