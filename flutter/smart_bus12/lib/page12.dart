import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFD7EDF8),
        resizeToAvoidBottomInset: false, // يمنع تحرك الشاشة مع الكيبورد
        body: Container(
          margin: EdgeInsets.only(
            top: 40,
            bottom: 40,
            right: 20,
            left: 20,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFE9F6FC),
            borderRadius: BorderRadius.circular(12),
          ),
          width: double.infinity,
          height: 800,
          child: Stack(
            children: [
              // الصندوق الأبيض (الثالث)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 160,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 50),

                      // الاسم الثلاثي
                      Text(
                        'الاسم الثلاثي',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade500, width: 1.5),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // موقع الطفل
                      Text(
                        'موقع الطفل',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade500, width: 1.5),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // موقع المدرسة
                      Text(
                        'موقع المدرسة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade500, width: 1.5),
                          ),
                        ),
                      ),

                      Spacer(), // لدفع زر الحفظ للأسفل

                      // زر الحفظ
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // تنفيذ عند الضغط
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD7EDF8),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'حفظ',
                            style: TextStyle(
                              color: Color(0xFF003366),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // نص تعديل الطالب
              Positioned(
                top: 170,
                left: 110,
                child: Text(
                  'تعديل الطالب',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003366),
                  ),
                ),
              ),

              // الدائرة
              Positioned(
                top: 40,
                left: 130,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE9F6FC),
                    border: Border.all(
                      color: Color(0xFFD7EDF8),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}