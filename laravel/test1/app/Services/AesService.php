<?php
namespace App\Services;

use Exception;

class AesService
{
    public static function decrypt($encryptedBase64)
    {
        $cipher = "AES-256-CBC";
        $key = env('AES_KEY');
        $iv  = env('AES_IV');

        $encrypted = base64_decode($encryptedBase64);

        $decrypted = openssl_decrypt($encrypted, $cipher, $key, OPENSSL_RAW_DATA, $iv);

        if ($decrypted === false) {
            throw new Exception("AES Decryption failed");
        }

        return json_decode($decrypted, true);
    }
 public static function encrypt($data)
    {
        $cipher = "AES-256-CBC";
        $key = env('AES_KEY');
        $iv  = env('AES_IV');

        $jsonData = json_encode($data);

        $encrypted = openssl_encrypt($jsonData, $cipher, $key, OPENSSL_RAW_DATA, $iv);

        if ($encrypted === false) {
            throw new Exception("AES Encryption failed");
        }

        return base64_encode($encrypted);
    }




}

// namespace App\Services;

// use Illuminate\Support\Facades\Crypt;

// class AesService
// {
//     public static function encrypt($plainText)
//     {
//         return Crypt::encryptString($plainText); // يستخدم AES-256-CBC مع APP_KEY
//     }

//     public static function decrypt($encryptedText)
//     {
//         return Crypt::decryptString($encryptedText);
//     }
// }
