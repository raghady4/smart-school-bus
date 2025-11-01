import 'package:dio/dio.dart';

class ResetPasswordServer {
  static final Dio _dio = Dio();

  static Future<String> resetPassword({
    required String email,
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _dio.post(
        'http://192.168.186.176:8000/api/reset-password',
        data: {
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': confirmPassword,
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['message'] ?? 'تم تغيير كلمة المرور';
      } else {
        throw Exception(response.data['message'] ?? 'فشل العملية');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'خطأ من الخادم');
    } catch (_) {
      throw Exception('حدث خطأ غير متوقع');
    }
  }
}
