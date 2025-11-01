import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
class AesServiceFlutter {
  // المفتاح لازم يكون 32 بايت (AES-256)
  static final _key = encrypt.Key.fromUtf8('12345678901234567890123456789012');
  // الـ IV لازم يكون 16 بايت
  static final _iv = encrypt.IV.fromUtf8('1234567890123456');

  static String encryptData(Map<String, dynamic> data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
    final jsonString = jsonEncode(data);
    final encrypted = encrypter.encrypt(jsonString, iv: _iv);
    return encrypted.base64; // النص النهائي (Base64)
  }
}