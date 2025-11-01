import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reset_password_cubit.dart';
import '../bloc/reset_password_state.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final tokenController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إعادة تعيين كلمة المرور')),
      body: BlocProvider(
        create: (_) => ResetPasswordCubit(),
        child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              // ممكن ترجعي المستخدم إلى صفحة تسجيل الدخول
              // Navigator.pop(context);
            } else if (state is ResetPasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Text('البريد الإلكتروني: ${widget.email}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: tokenController,
                    decoration: const InputDecoration(labelText: 'رمز الاستعادة'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'كلمة المرور الجديدة'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'تأكيد كلمة المرور'),
                  ),
                  const SizedBox(height: 20),
                  if (state is ResetPasswordLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed: () {
                        final token = tokenController.text.trim();
                        final password = passwordController.text.trim();
                        final confirmPassword =
                            confirmPasswordController.text.trim();

                        if (token.isEmpty ||
                            password.isEmpty ||
                            confirmPassword.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('يرجى تعبئة جميع الحقول')),
                          );
                          return;
                        }

                        context.read<ResetPasswordCubit>().resetPassword(
                              email: widget.email,
                              token: token,
                              password: password,
                              confirmPassword: confirmPassword,
                            );
                      },
                      child: const Text('تأكيد إعادة التعيين'),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
