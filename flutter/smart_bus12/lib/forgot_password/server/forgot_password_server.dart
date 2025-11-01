import 'package:dio/dio.dart';

class ForgotPasswordServer {
  static final Dio _dio = Dio();
  static const String _baseUrl = 'http://192.168.186.176:8000';

  static Future<String> sendResetEmail({required String email}) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/api/forgot-password',
        data: {'email': email},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data']['message'] ?? 'تم إرسال الرابط بنجاح';
      } else {
        throw Exception(response.data['message'] ?? 'فشل في إرسال الرابط');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'خطأ من الخادم');
    } catch (_) {
      throw Exception('حدث خطأ غير متوقع');
    }
  }
}
