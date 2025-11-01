import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController emailController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      final isNotEmpty = emailController.text.isNotEmpty;
      if (isNotEmpty != isButtonEnabled) {
        setState(() {
          isButtonEnabled = isNotEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void onRestorePressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال طلب استعادة كلمة المرور'),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // حجم الشاشة
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xff9bd1e5),
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            // الموضع العلوي للصندوق كنسبة من ارتفاع الشاشة مع تعديل بسيط
            final double topOfBox = constraints.maxHeight * 0.35;

            return Stack(
              children: [
                Positioned(
                  top: screenHeight * 0.05, // بدل 35px صار نسبة
                  right: screenWidth * 0.05, // بدل 20px صار نسبة
                  child: Image.asset(
                    'assets/images/cloud.png',
                    width: screenWidth * 0.25, // حجم النسبي حسب عرض الشاشة
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.18, // بدل 130px صار نسبة
                  left: screenWidth * 0.05,
                  child: Image.asset(
                    'assets/images/cloud.png',
                    width: screenWidth * 0.20,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.13,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'استعادة كلمة المرور',
                      style: TextStyle(
                        color: const Color(0xff487e93),
                        fontSize: screenWidth * 0.09, // حجم الخط نسبة لعرض الشاشة
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: topOfBox,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff8bbed1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      // هنا عم نستخدم padding نسبي للعرض وارتفاع مرن أقل لكي يناسب أغلب الشاشات
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                        vertical: screenHeight * 0.13,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: emailController,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              hintText: 'البريد الإلكتروني',
                              hintStyle: TextStyle(
                                color: const Color(0xFF9BD1E5),
                                fontSize: screenWidth * 0.04,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          InkWell(
                            onTap: isButtonEnabled ? onRestorePressed : null,
                            borderRadius: BorderRadius.circular(40),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: isButtonEnabled
                                    ? const Color(0xff487e93)
                                    : const Color(0xff487e93).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'استعادة الكلمة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.045,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: topOfBox - screenHeight * 0.14, // بدل 115px نسبة
                  right: screenWidth * 0.015,
                  child: Image.asset(
                    'assets/images/sticker.webp',
                    width: screenWidth * 0.32,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}