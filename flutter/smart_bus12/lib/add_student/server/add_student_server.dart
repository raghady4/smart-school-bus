import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddStudentServer {
  final String baseUrl;

  AddStudentServer({required this.baseUrl}) {
    print("🔗 AddStudentServer using baseUrl: $baseUrl");
  }
  Future<bool> addStudent({
    required String name,
    required String address,
    required String nfcLogsId,
    required String schoolId,
    required String areaId,
    String? busId,
  }) async {
    try {
      print("here are students");
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        print("🚨 لم يتم العثور على التوكين. تأكد من تسجيل الدخول أولًا.");
        return false;
      }
      print("tokenn $token");
      Map<String, dynamic> data2 = {
        "address": address,
        "full_name": name,
        "area_id": areaId,
        "school_id": schoolId,
        "nfc_logs_id": nfcLogsId,
        "bus_id": busId,
      };

      final response2 = await http.post(
        Uri.parse('$baseUrl/student'),
        body: data2,

        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      // var request = http.MultipartRequest(
      //   'POST',
      //   Uri.parse('http:// 192.168.186.176:8000/api/student'),
      // );

      // request.headers['Authorization'] = 'Bearer $token';
      // request.headers['Accept'] = 'application/json';

      // request.fields['full_name'] = name;
      // request.fields['address'] = address;
      // request.fields['nfc_logs_id'] = nfcLogsId;
      // request.fields['parent_id'] = parentId.toString();
      // request.fields['school_id'] = schoolId.toString();
      // if (busId != null) request.fields['bus_id'] = busId.toString();

      // request.files.add(
      //   await http.MultipartFile.fromPath('photo', imageFile.path),
      // );

      // var streamedResponse = await request.send();
      // var response = await http.Response.fromStream(streamedResponse);

      print('📨 Response status: ${response2.statusCode}');
      print('📨 Response body: ${response2.body}');

      return response2.statusCode == 200 || response2.statusCode == 201;
    } catch (e) {
      print('❌ Exception in addStudent: $e');
      return false;
    }
  }

  Future<bool> deleteStudent({required String studentId}) async {
    try {
      print("here are students");
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        print("🚨 لم يتم العثور على التوكين. تأكد من تسجيل الدخول أولًا.");
        return false;
      }
      print("tokenn $token");

      final response2 = await http.delete(
        Uri.parse('$baseUrl/student/$studentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('📨 Response status: ${response2.statusCode}');
      print('📨 Response body: ${response2.body}');

      return response2.statusCode == 200 || response2.statusCode == 201;
    } catch (e) {
      print('❌ Exception in addStudent: $e');
      return false;
    }
  }
}
