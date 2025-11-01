import 'package:flutter/material.dart';
import 'page1.dart'; // شاشة البداية

class ActivationWaitingPage extends StatelessWidget {
  final String name;
  final String role;
 ActivationWaitingPage({required this.name, required this.role, super.key});


  final Color backgroundColor = const Color(0xFF9BD1E5);
  final Color boxColor = const Color(0xFF8BBED1);
  final Color textColor = const Color(0xFF487E93);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final screenWidth = constraints.maxWidth;
          return Stack(
            children: [
              Positioned(
                top: screenHeight * 0.04,
                right: screenWidth * 0.05,
                child: Image.asset(
                  'assets/images/cloud.png',
                  width: screenWidth * 0.25,
                ),
              ),
              Positioned(
                top: screenHeight * 0.18,
                left: screenWidth * 0.05,
                child: Image.asset(
                  'assets/images/cloud.png',
                  width: screenWidth * 0.20,
                ),
              ),
              Positioned(
                top: screenHeight * 0.13,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'انتظار التفعيل',
                    style: TextStyle(
                      fontSize: screenWidth * 0.1,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.35,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.20,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    'assets/images/sticker6.webp',
                    width: screenWidth * 0.4,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.55,
                left: screenWidth * 0.08,
                right: screenWidth * 0.08,
                child: Text(
                  'سيتم التواصل معك خلال مدة أقصاها 48 ساعة "غير متضمنة العطل الرسمية" لإجراء المقابلة وإعلامك بالنتيجة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                top: screenHeight * 0.80,
                left: screenWidth * 0.1,
                right: screenWidth * 0.1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Page1()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff487e93),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        'العودة لشاشة البداية',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
}
