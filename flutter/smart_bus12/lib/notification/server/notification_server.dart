import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationServer {
  final String baseUrl;

  NotificationServer({required this.baseUrl});

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  Future<List<dynamic>> getNotifications() async {
    final token = await _getToken();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("🔹 Status code: ${response.statusCode}");
      print("🔹 Body: ${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Exception during getNotifications: $e");
      throw Exception('Request failed: $e');
    }
  }

  Future<void> registerFcmToken(String tokenValue) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/save-fcm-token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'token': tokenValue}),
    );
    if (response.statusCode != 200) {
      print(
        "❌ Error registering FCM token: ${response.statusCode} ${response.body}",
      );
      throw Exception('Failed to register FCM token');
    }
  }
}
