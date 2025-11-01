import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_bus/login/bloc/login_cubit.dart';
import 'package:smart_bus/login/bloc/login_state.dart';
import 'package:smart_bus/page4.dart';
import 'package:smart_bus/page5.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFBEE9F6),
  //     body: BlocConsumer<LoginCubit, LoginState>(
  //       listener: (context, state) {
  //         if (state is LoginSuccess) {
  //           print("✅ REGISTER SUCCESS — ROLE: ${state.role}");
  //           print("here22 RegisterSuccess page");
            
  //  if (state.role == 'parent') {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (_) => HomePage(name: state.name, role: state.role),
  //             ),
  //           );
  //         }
  //         if (state.role == 'driver') {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (_) =>
  //                   ActivationWaitingPage(name: state.name, role: state.role),
  //             ),
  //           );
  //         }

  //         if (state.role == 'admin') {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (_) => ActivationWaitingPage(name: state.name, role: state.role),
  //             ),
  //           );
  //         }
  //           Navigator.of(context, rootNavigator: true).pop(); // 👈 مهم جداً

  //           if (selectedRole == 'ولي الأمر') {
  //             print("here22 parent page");
  //             Future.delayed(Duration(milliseconds: 200), () {
  //               Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (_) =>
  //                       HomePage(name: state.name, role: state.role),
  //                 ),
  //                 (route) => false,
  //               );
  //             });
  //           }
  //            else {
  //             print("here22 activation page");
  //             Navigator.pushAndRemoveUntil(
  //               context,
  //               MaterialPageRoute(builder: (_) => ActivationWaitingPage(name: '', role: '',)),
  //               (route) => false,
  //             );
  //           }
  //         }

  //         if (state is LoginLoading) {
  //           print("here22 RegisterLoading page");
  //           showDialog(
  //             context: context,
  //             builder: (_) => const Center(child: CircularProgressIndicator()),
  //             barrierDismissible: false,
  //           );
  //         }
  //         //   else {
  //         //   Navigator.of(context, rootNavigator: true).pop(); // Close loading
  //         // }
  //         if (state is LoginFailure) {
  //           print("here22 RegisterError page");
  //           Navigator.pop(context); // Close loading
  //           // Navigator.push(
  //           //   context,
  //           //   MaterialPageRoute(
  //           //     builder: (_) =>
  //           //         ResetPasswordPage(email: emailController.text.trim()),
  //           //   ),
  //           // );
  //         }
  //       },

body: BlocConsumer<LoginCubit, LoginState>(
  listener: (context, state) {
    if (state is LoginSuccess) {
      print("✅ REGISTER SUCCESS — ROLE: ${state.role}");
      print("here22 RegisterSuccess page");

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
                ActivationWaitingPage(name: state.name, role: state.role),
          ),
        );
      }

      if (state.role == 'admin') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ActivationWaitingPage(name: state.name, role: state.role),
          ),
        );
      }
      Navigator.of(context, rootNavigator: true).pop(); // 👈 مهم جداً

      if (selectedRole == 'ولي الأمر') {
        print("here22 parent page");
        Future.delayed(const Duration(milliseconds: 200), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(name: state.name, role: state.role),
            ),
            (route) => false,
          );
        });
      } else {
        print("here22 activation page");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => ActivationWaitingPage(name: '', role: '',)),
          (route) => false,
        );
      }
    }

    if (state is LoginLoading) {
      print("here22 RegisterLoading page");
      showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
    }

    if (state is LoginFailure) {
      print("here22 RegisterError page");
      Navigator.pop(context); // Close loading
    }

    // ✅ إضافات خاصة بالتحقق من الإيميل
    if (state is EmailVerifiedSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تفعيل البريد الإلكتروني بنجاح ✅')),
      );
    }

    if (state is EmailVerifiedFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تفعيل البريد الإلكتروني ❌')),
      );
    }
  },



        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.07,
                  right: screenWidth * 0.15,
                  bottom: screenHeight * 0.02,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'إنشاء حساب',
                    style: TextStyle(
                      fontSize: screenWidth * 0.12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF487E93),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF9BD1E5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.07,
                    vertical: screenHeight * 0.04,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildTextField('الاسم الثلاثي', nameController),
                        SizedBox(height: screenHeight * 0.025),
                        buildTextField('البريد الإلكتروني', emailController),
                        SizedBox(height: screenHeight * 0.025),
                        buildTextField(
                          'كلمة المرور',
                          passwordController,
                          obscure: true,
                        ),
                        SizedBox(height: screenHeight * 0.025),
                        buildTextField(
                          'رقم الهاتف',
                          phoneController,
                          isNumber: true,
                        ),
                        SizedBox(height: screenHeight * 0.025),
                        buildRoleSelector(),
                        SizedBox(height: screenHeight * 0.03),
                        ElevatedButton(
                          onPressed: () {
                            if (nameController.text.isEmpty ||
                                emailController.text.isEmpty ||
                                passwordController.text.isEmpty ||
                                phoneController.text.isEmpty ||
                                selectedRole == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'يرجى ملء كل الحقول واختيار نوع المستخدم',
                                  ),
                                ),
                              );
                              return;
                            }
                            if (phoneController.text.trim().length != 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'رقم الهاتف يجب أن يحتوي على 10 أرقام بالضبط',
                                  ),
                                ),
                              );
                              return;
                            }
                            print(
                              "🔷 SENDING REGISTER REQUEST WITH ROLE: $selectedRole",
                            );
                            context.read<LoginCubit>().registerUser(
                              fullName: nameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              phone: phoneController.text.trim(),
                              role: selectedRole == 'ولي الأمر'
                                  ? 'parent'
                                  : selectedRole == 'قائد الحافلة'
                                  ? 'driver'
                                  : 'admin',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF487E93),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02,
                              horizontal: screenWidth * 0.25,
                            ),
                          ),
                          child: Text(
                            'إنشاء حساب',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'لديك حساب؟ تسجيل الدخول',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.04,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildTextField(
    String hint,
    TextEditingController controller, {
    bool obscure = false,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF72B6CE)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildRoleSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildRoleItem('ولي الأمر', 'assets/images/sticker5.webp'),
        buildRoleItem('قائد الحافلة', 'assets/images/sticker_driver.webp'),
        buildRoleItem('الإدارة المدرسية', 'assets/images/sticker3.webp'),
      ],
    );
  }

  Widget buildRoleItem(String title, String imagePath) {
    bool isSelected = selectedRole == title;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedRole = title;
            });
          },
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF487E93) : Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : const Color(0xFF72B6CE),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
