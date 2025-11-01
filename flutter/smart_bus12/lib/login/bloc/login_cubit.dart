import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'login_state.dart';
import '../server/login_server.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.loginServer) : super(LoginInitial());

  final LoginServer loginServer;

  // ✅ تسجيل الدخول
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      final result = await loginServer.login(email: email, password: password);
      print("✅ تسجيل الدخول تم بنجاح: $result");

      final token = result['token'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('name', result['name']);
        await prefs.setString('role', result['role']);
        print("🔐 تم تخزين التوكين وبيانات المستخدم");
      } else {
        print("⚠️ لم يتم العثور على التوكين في الرد!");
      }

      emit(
        LoginSuccess(
          name: result['name'],
          role: result['role'],
          fullName: null,
        ),
      );
    } catch (e) {
      print("❌ فشل الاتصال أو المعالجة: $e");

      String errorMessage;

      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          errorMessage = data['message'];
        } else if (data is String) {
          errorMessage = data;
        } else {
          errorMessage = 'حدث خطأ أثناء الاتصال بالسيرفر';
        }
      } else {
        errorMessage = e.toString();
      }

      emit(LoginFailure(error: errorMessage));
    }
  }

  // ✅ تسجيل مستخدم جديد
  Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    try {
      emit(LoginLoading());
      print("📤 هنا الكيوبت: تسجيل مستخدم جديد");

      final result = await loginServer.register(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
        role: role,
      );

      print("📥 Register API response: $result");

      // ✅ تحقق إذا في success
      final success = result['success'].toString() == 'true';

      if (success) {
        final user = result['data']['data'];
        print("✅ Registration Success - User: ${user}");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', user['full_name']);
        await prefs.setString('role', user['role']);

        // emit(
        //   LoginSuccess(
        //     name: user['full_name'],
        //     role: user['role'],
        //     fullName: null,
        //   ),
        // );

        if (success) {
          final user = result['data']['data'];
          final message = result['message'] ?? '';

          if (message.contains("verify your email")) {
            // 🚫 ما نسجلو كـ LoginSuccess
            emit(
              LoginFailure(
                error:
                    "تم إنشاء الحساب. تحقق من بريدك الإلكتروني قبل تسجيل الدخول.",
              ),
            );
            return {
              'success': true,
              'verify_required': true,
              'message': message,
            };
          } else {
            // ✅ تسجيل دخول عادي
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('name', user['full_name']);
            await prefs.setString('role', user['role']);

            emit(
              LoginSuccess(
                name: user['full_name'],
                role: user['role'],
                fullName: null,
              ),
            );

            return {'success': true, 'user': user};
          }
        }

        return {'success': true, 'user': user};
      } else {
        // ❌ فشل التسجيل - رجع أخطاء
        final errorMessage = result['message'] ?? 'حدث خطأ غير معروف';
        final details = result['data']['data'] ?? {}; // ممكن يحوي أخطاء الحقول

        print("❌ REGISTER VALIDATION ERRORS: $details");

        emit(LoginFailure(error: errorMessage));
        return {'success': false, 'errors': errorMessage, 'details': details};
      }
    } on DioException catch (e) {
      final error = e.response?.data['message'] ?? 'حدث خطأ غير متوقع';
      print('❌ REGISTER ERROR: $error');
      emit(LoginFailure(error: error));
      return {
        'success': false,
        'errors': error,
        'details': e.response?.data['data'] ?? {},
      };
    } catch (e) {
      print('❌ REGISTER UNKNOWN ERROR: $e');
      emit(LoginFailure(error: e.toString()));
      return {'success': false, 'errors': e.toString()};
    }
  }

  // ✅ تحقق البريد
  Future<void> verifyEmail(String id, String hash) async {
    emit(LoginLoading());
    try {
      final response = await Dio().get(
        '${loginServer.baseUrl}/email/verify/$id/$hash',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final token = data['token'];
          final user = data['user'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setString('name', user['full_name']);
          await prefs.setString('role', user['role']);

          emit(
            LoginSuccess(
              name: user['full_name'],
              role: user['role'],
              fullName: null,
            ),
          );
        } else {
          emit(EmailVerifiedFailure());
        }
      } else {
        emit(EmailVerifiedFailure());
      }
    } catch (e) {
      emit(EmailVerifiedFailure());
    }
  }

  // ✅ تسجيل الخروج
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('name');
      await prefs.remove('role');
      emit(LoginInitial());
    } catch (e) {
      emit(LoginFailure(error: 'فشل تسجيل الخروج'));
    }
  }
}
