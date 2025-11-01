import 'package:flutter/material.dart';
import 'package:smart_bus/login/presentation/logout_page.dart';
import 'package:smart_bus/notification/presentation/notification_page.dart';
import 'page9.dart'; // صفحة بوت الدردشة
import 'get_students/presentation/students_page.dart'; // صفحة الطلاب
import 'payments.dart'; // رابط لواجهة الدفع
import 'map.dart'; // ✅ استدعاء صفحة الخريطة

class HomePage extends StatelessWidget {
  final String name;
  final String role;

  const HomePage({required this.name, required this.role, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان
              Row(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.05,
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.person, color: const Color(0xFF2A5B93)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.15),
                      child: Text(
                        'الصفحة الرئيسية',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: screenWidth * 0.07,
                          color: const Color(0xFF2A5B93),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              // الصورة والاسم والدور
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.03),
                    child: CircleAvatar(
                      radius: screenWidth * 0.13,
                      backgroundColor: const Color(0xFFFFFAE5),
                      child: ClipOval(
                        child: SizedBox(
                          width: screenWidth * 0.22,
                          height: screenWidth * 0.24,
                          child: Image.asset(
                            'assets/images/sticker_4.webp',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2A5B93),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        role,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              // صناديق + صورة
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationPage(),
                              ),
                            );
                          },
                          child: buildBox(Icons.notifications, 'الإشعارات'),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatBotPage(),
                              ),
                            );
                          },
                          child: buildBox(Icons.emoji_emotions, 'الدردشة'),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CloudScreen(),
                              ),
                            );
                          },
                          child: buildBox(Icons.settings, 'الإعدادات'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/bus4.jpg',
                      width: screenWidth * 0.38,
                      height: screenHeight * 0.25,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // صندوق الدعم الفني، عن التطبيق، تسجيل الخروج
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('الدعم الفني'),
                            content: const Text(
                              'لمعرفة المزيد أو الاستفسارات عليك التواصل على الرقم التالي:\n0998544154',
                              textAlign: TextAlign.right,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('حسناً'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: buildSupportRow('الدعم الفني', Icons.message),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('عن التطبيق'),
                            content: const Text(
                              'هذا التطبيق مخصص لتسهيل التواصل بين الطلاب والمعلمين، ويتيح إمكانية الاطلاع على الإشعارات، إرسال الاستفسارات، استخدام بوت دردشة للمساعدة، بالإضافة إلى إدارة الإعدادات بشكل سلس وآمن.\n\nهدفنا هو تحسين تجربة المستخدم وتوفير بيئة تعليمية تفاعلية وسهلة الاستخدام.',
                              textAlign: TextAlign.right,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('حسناً'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: buildSupportRow('عن التطبيق', Icons.help_outline),
                    ),
                    const SizedBox(height: 30),
                    buildSupportRow('تسجيل الخروج', Icons.logout),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // ✅ الشريط السفلي المعدل
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFAE5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildIconWithText(Icons.home, 'الرئيسية'),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DriverMapPage(), // ✅ فتح صفحة الخريطة
                          ),
                        );
                      },
                      child: buildIconWithText(Icons.map, 'الخريطة'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StudentsPage(),
                          ),
                        );
                      },
                      child: buildIconWithText(Icons.person_add, 'إضافة طالب'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentPage(),
                          ),
                        );
                      },
                      child: buildIconWithText(Icons.payment, 'الدفع'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // بناء صندوق نصي وأيقونة
  static Widget buildBox(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2A5B93)),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2A5B93),
            ),
          ),
        ],
      ),
    );
  } // صف للدعم الفني، عن التطبيق، تسجيل الخروج

  static Widget buildSupportRow(String text, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey[500]),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2A5B93),
              ),
            ),
          ],
        ),
        Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.grey[500]),
      ],
    );
  }

  // الأيقونة مع النص (لأسفل الشاشة)
  static Widget buildIconWithText(IconData icon, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF2A5B93), size: 30),
        const SizedBox(height: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2A5B93),
          ),
        ),
      ],
    );
  }
}
