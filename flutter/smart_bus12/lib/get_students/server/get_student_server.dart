import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:io';

class GetStudentServer {
    final String baseUrl;

  GetStudentServer({required this.baseUrl}) {
    print("🔗 GetStudentServer using baseUrl: $baseUrl");
  }
  
 Future<Map<String , dynamic>> getMyStudents() async {
    try {
      print("here are getMyStudents");
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        print("🚨 لم يتم العثور على التوكين. تأكد من تسجيل الدخول أولًا.");
        return  {'success': false, 'message': 'لا يوجد توكين'};
      }
      print("tokenn $token");
      final response2 = await http.get(
        Uri.parse('$baseUrl/my-students'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('📥 REGISTER RESPONSE: ${response2.body}');
      final jsonResponse = jsonDecode(response2.body);
      return {
        'success': true,
        'data': jsonResponse['data'],
      'message': jsonResponse['message'],
      };
    } on DioException catch (e) {
      print('❌ REGISTER ERROR: ${e.response?.data}');
      return {
        'success': false,
        'errors': e.response?.data['message'] ?? 'حدث خطأ غير متوقع',
        'details': e.response?.data['data'] ?? {},
      };
    } catch (e) {
      print('❌ Unknown registration error: $e');
      return {'success': false, 'errors': 'فشل الاتصال بالسيرفر'};
    }
  }

}
