import 'package:flutter/material.dart';
import 'package:smart_bus/login/presentation/login_page.dart';
// صفحة تسجيل الدخول

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    print("page1 is started");
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/bus.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: screenHeight * 0.18,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  "الحافلة المدرسية",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.09,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "الذكية",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.09,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.07,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.15,
                    vertical: screenHeight * 0.018,
                  ),
                ),
                child: Text(
                  "ابدأ",
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
