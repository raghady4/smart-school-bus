import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_bus/login/presentation/register.dart';
import 'package:smart_bus/forgot_password/presentation/forgot_password_page.dart';
import 'package:smart_bus/login/bloc/login_cubit.dart';
import 'package:smart_bus/login/bloc/login_state.dart';
import 'package:smart_bus/driver_page/presentation/page13.dart';
import 'package:smart_bus/admin_page/presentation/page14.dart';
import 'package:smart_bus/page4.dart';
import 'package:smart_bus/page5.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  void _navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Register()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
          Navigator.of(context, rootNavigator: true).pop(); // Close loading
        }
        if (state is LoginSuccess) {
          print("here223 login success");
          if (state.role == 'parent') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HomePage(name: state.name, role: state.role),
              ),
            );
          }
          if (state.role == 'driver') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    DriverScreen(name: state.name, role: state.role),
              ),
            );
          }

          if (state.role == 'admin') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AdminScreen(name: state.name, role: state.role),
              ),
            );
          }
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Container(color: const Color(0xFFBEE9F6)),
              Positioned(
                top: screenHeight * 0.05,
                right: screenWidth * 0.05,
                child: Image.asset(
                  'assets/images/cloud.png',
                  width: screenWidth * 0.25,
                ),
              ),
              Positioned(
                top: screenHeight * 0.20,
                left: screenWidth * 0.08,
                child: Image.asset(
                  'assets/images/cloud.png',
                  width: screenWidth * 0.2,
                ),
              ),
              Positioned(
                top: screenHeight * 0.13,
                left: screenWidth * 0.15,
                child: Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    fontSize: screenWidth * 0.1,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF487E93),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.26,
                right: screenWidth * 0.02,
                child: Image.asset(
                  'assets/images/sticker.webp',
                  width: screenWidth * 0.45,
                ),
              ),
              Positioned(
                top: screenHeight * 0.45,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF9BD1E5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.03,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'البريد الإلكتروني',
                            hintStyle: const TextStyle(
                              color: Color(0xFF72B6CE),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.025),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'كلمة المرور',
                            hintStyle: const TextStyle(
                              color: Color(0xFF72B6CE),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              context.read<LoginCubit>().login(
                                email: email,
                                password: password,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF487E93),
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            child: Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage(),
                                ),
                              );
                            },
                            child: Text(
                              'نسيت كلمة المرور؟',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Center(
                          child: GestureDetector(
                            onTap: () => _navigateToSignUp(context),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(fontSize: screenWidth * 0.04),
                                children: const [
                                  TextSpan(
                                    text: 'ليس لديك حساب؟ ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: 'إنشاء حساب',
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
