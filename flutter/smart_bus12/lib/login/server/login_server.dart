import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_bus/login/server/aes.dart';

class LoginServer {
  final String baseUrl;
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10), // ⏱️ مهلة الاتصال
      receiveTimeout: const Duration(seconds: 15), // ⏳ مهلة استلام الرد
      sendTimeout: const Duration(seconds: 10), // ⌛ مهلة إرسال البيانات
    ),
  );

  LoginServer({required this.baseUrl}) {
    print("🔗 LoginServer using baseUrl: $baseUrl");
  }

  Future<void> storeToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("access_token", accessToken);
  }

  Future<void> storeAdminId(String adminId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("adminId", adminId);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print("🔄 نحنا داخل try وعم نرسل البيانات...");
      final response = await _dio.post(
        '$baseUrl/login',
        data: {'email': email, 'password': password},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'ngrok-skip-browser-warning': 'true',
          },
        ),
      );

      print("📥 Response Data: ${response.data}");

      final data = response.data;

      if (data is Map &&
          response.statusCode == 200 &&
          data['success'] == true) {
        final token = data['data']['token'];
        final user = data['data']['user'];

        await storeToken(token);

        await storeAdminId(data['data']['user']['user_id'].toString());

        return {
          'name': user['full_name'] ?? 'user',
          'role': user['role'],
          'token': token,
        };
      } else {
        throw Exception(
          data is Map ? data['message'] : 'فشل غير متوقع في تسجيل الدخول',
        );
      }
    } on DioException catch (e) {
      print("❌ DioException: ${e.response?.data}");
      throw Exception(e.response?.data['message'] ?? 'تعذر الاتصال بالخادم');
    } catch (e) {
      print("❌ Unknown error: $e");
      throw Exception('حدث خطأ أثناء تسجيل الدخول');
    }
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    try {
      Map<String, dynamic> data2 = {
        'full_name': fullName,
        'email': email,
        'password': password,
        'c_password': password,
        'phone': phone,
        'role': role,
        'is_active': false,
      };

      String encryptedPayload = AesServiceFlutter.encryptData(data2);
      print("🔒 Data Encrypted: $encryptedPayload");

      final response = await _dio.post(
        '$baseUrl/register',
        data: {"data": encryptedPayload},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'ngrok-skip-browser-warning': 'true',
          },
        ),
      );

      print('📥 REGISTER RESPONSE: ${response.data}');

      return {
        'success': true,
        'data': response.data['data'],
        'message': response.data['message'],
      };
    } on DioException catch (e) {
      print('❌ REGISTER ERROR: ${e.response?.data}');
      print('❌ DioException Type: ${e.type}');
      print('❌ DioException Message: ${e.message}');

      String errorMsg = 'حدث خطأ غير متوقع';
      Map<String, dynamic> errorDetails = {};

      if (e.response != null) {
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          errorMsg = data['message'] ?? errorMsg;
          errorDetails = data['errors'] ?? data;
        } else if (data is String) {
          errorMsg = data;
        }
      } else {
        // مثلاً لو السيرفر ما عم يرد أبداً أو الاتصال مقطوع
        errorMsg = 'تعذر الوصول إلى الخادم. تحقق من الاتصال بالإنترنت.';
      }

      return {'success': false, 'errors': errorMsg, 'details': errorDetails};
    } catch (e) {
      print('❌ Unknown registration error: $e');
      return {
        'success': false,
        'errors': 'فشل الاتصال بالسيرفر',
        'details': {},
      };
    }
  }
}
