import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_bus/login/bloc/login_cubit.dart';
import 'package:smart_bus/page1.dart';

// تأكد إنك تستورد دالة showLogoutConfirmationSheet من مكانها الصحيح:

class CloudScreen extends StatelessWidget {
  final List<String> cloudImages = [
    'assets/images/cloud.png',
    'assets/images/cloud.png',
    'assets/images/cloud.png',
    'assets/images/cloud.png',
  ];

  final String circleImage = 'assets/images/boy.webp';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFCFE8FC),
      body: Stack(
        children: [
          // شريط علوي
          Positioned(
            top: screenHeight * 0.05,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Icon(
                  Icons.settings,
                  color: Color(0xFF649BC9),
                  size: screenWidth * 0.07,
                ),
                SizedBox(width: screenWidth * 0.02),
                Flexible(
                  child: Text(
                    'حافلة المدرسة الذكية',
                    style: TextStyle(
                      color: Color(0xFF649BC9),
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // غيوم علوية
          Positioned(
            top: screenHeight * 0.12,
            left: -screenWidth * 0.2,
            child: Image.asset(
              cloudImages[0],
              width: screenWidth * 0.5,
              color: Color(0xFFB7DCEF),
            ),
          ),
          Positioned(
            top: screenHeight * 0.12,
            right: -screenWidth * 0.2,
            child: Image.asset(
              cloudImages[1],
              width: screenWidth * 0.5,
              color: Color(0xFFB7DCEF),
            ),
          ),

          // صورة دائرية
          Positioned(
            top: screenHeight * 0.18,
            left: screenWidth / 2 - (screenWidth * 0.15),
            child: Container(
              width: screenWidth * 0.3,
              height: screenWidth * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.007),
                  child: Image.asset(circleImage, fit: BoxFit.contain),
                ),
              ),
            ),
          ),

          // الغيمة الوسطى
          Positioned(
            top: screenHeight * 0.4,
            left: screenWidth * 0.3,
            child: ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  cloudImages[2],
                  width: screenWidth * 0.3,
                  color: Color(0xFFB7DCEF),
                ),
              ),
            ),
          ),

          // الصندوق الأبيض الرئيسي
          Positioned(
            top: screenHeight * 0.48,
            left: -screenWidth * 0.05,
            right: screenWidth * 0.08,
            bottom: screenHeight * 0.13,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),

          // العنوان "الإعدادات"
          Positioned(
            top: screenHeight * 0.5,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'الإعدادات',
                style: TextStyle(
                  color: Color(0xFF649BC9),
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // خيار: تغيير اللغة
          Positioned(
            top: screenHeight * 0.56,
            left: 0,
            right: 0,
            child: _buildSettingsRow(
              context,
              icon: Icons.language,
              label: 'تغيير اللغة',
              trailingIcon: Icons.arrow_forward_ios,
            ),
          ),

          // خيار: الإشعارات
          Positioned(
            top: screenHeight * 0.64,
            left: 0,
            right: 0,
            child: _buildSettingsRow(
              context,
              icon: Icons.notifications,
              label: 'الإشعارات',
              trailingIcon: Icons.toggle_on,
              trailingIconSize: 40,
            ),
          ),

          // خيار: معلومات الحساب + تسجيل الخروج
          Positioned(
            top: screenHeight * 0.72,
            left: 0,
            right: 0,
            child: Column(
              children: [
                _buildSettingsRow(
                  context,
                  icon: Icons.person,
                  label: 'معلومات الحساب',
                  trailingIcon: Icons.arrow_forward_ios,
                ),
                SizedBox(height: screenHeight * 0.015),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Divider(color: Colors.grey[300], thickness: 1),
                ),
                SizedBox(height: screenHeight * 0.0001),

                // هنا عدلنا النص إلى زر قابل للنقر:
                GestureDetector(
                  onTap: () {
                    showLogoutConfirmationSheet(context);
                  },
                  child: Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // غيمة أسفل اليسار
          Positioned(
            bottom: -screenHeight * 0.02,
            left: screenWidth * 0.01,
            child: Image.asset(
              cloudImages[3],
              width: screenWidth * 0.4,
              color: Color(0xFFB7DCEF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required IconData trailingIcon,
    double trailingIconSize = 24,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(trailingIcon, color: Color(0xFF649BC9), size: trailingIconSize),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.07),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: screenWidth * 0.13,
            height: screenWidth * 0.13,
            decoration: BoxDecoration(
              color: Color(0xFFCFE8F6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Icon(
                icon,
                color: Color(0xFF649BC9),
                size: screenWidth * 0.07,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showLogoutConfirmationSheet(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.all(screenWidth * 0.06),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'هل أنت متأكد من تسجيل الخروج؟',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // إغلاق الـ BottomSheet
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                    ),
                    child: Text('إلغاء', style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // إغلاق الـ BottomSheet
                      context.read<LoginCubit>().logout();
                      // الانتقال لصفحة تسجيل الدخول أو الصفحة الرئيسية حسب مشروعك:
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => Page1()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF649BC9),
                    ),
                    child: Text(
                      'تسجيل الخروج',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
