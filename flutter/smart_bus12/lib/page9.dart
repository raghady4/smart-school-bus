import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        home: ChatBotPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  int selectedQuestionIndex = -1;

  final List<Map<String, String>> questions = [
    {'question': 'كيف يمكنني تتبع موقع الحافلة؟', 'answer': 'يمكنك تتبع موقع الحافلة من خلال تطبيق الهاتف المخصص الذي يوفر خريطة مباشرة للحافلة.'},
    {'question': 'كيف اتأكد أن ابني صعد إلى الحافلة؟', 'answer': 'ستحصل على اشعار فوري عبر التطبيق بمجرد صعود الطالب إلى الحافلة باستخدام نظام التعرف على الهوية'},
    {'question': 'هل النظام يوفر اشعارات عند وصول الحافلة؟', 'answer': 'نعم،يرسل النظام اشعارات عند اقتراب الحافلة من نقطة التوقف وعند وصولها'},
    {'question': 'ماذا يحدث إذا نسي الطالب الخروج من الحافلة؟', 'answer': 'توجد حساسات داخل الحافلة تتحقق من خلوها من الطلاب عند انتهاء الرحلة، وستصدر إنذار إذا وجد أي شخص داخلها.'},
    {'question': 'كيف يتم الحفاظ على أمان بياناتي الشخصية؟', 'answer': 'جميع البيانات مشفرة ومحمية وفقًا لأعلى معايير الأمان لضمان الخصوصية.'},
    {'question': 'ماذا أفعل إذا فات الطالب الحافلة؟', 'answer': 'يمكنك الاتصال بالسائق من خلال التطبيق.'},
    {'question': 'هل يمكنني رؤية سجل رحلات ابني؟', 'answer': 'نعم، يحتوي التطبيق على تقارير مفصلة عن مواعيد صعود ونزول الطالب.'},
    {'question': 'ماذا أفعل إذا واجهت مشكلة في التطبيق؟', 'answer': 'يمكنك التواصل مع فريق الدعم الفني عبر التطبيق لحل أي مشكلة.'},
    {'question': 'ما هي تكلفة الاشتراك لكل طالب؟', 'answer': 'تكلفة الاشتراك الفصلي هي 300 ، وتكلفة الاشتراك الشهري هي 120.'},
    {'question': 'هل هناك خصم عند تسجيل أكثر من طالب من نفس العائلة؟', 'answer': 'نعم، هناك خصم خاص للأشقاء المسجلين في نفس الحافلة. مقداره 30٪ لأحد الشقيقين.'},
    {'question': 'هل يمكنني التسجيل الآن أم أن المقاعد ممتلئة؟', 'answer': 'يعتمد الأمر على توفر المقاعد. يمكنك التواصل مع الإدارة للتحقق من توفر الأماكن.'},
    {'question': 'كيف يمكنني التسجيل في الخدمة؟', 'answer': 'يمكنك التسجيل من خلال تعبئة استمارة إلكترونية عبر التطبيق أو زيارة مكتب الإدارة المدرسية.'},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFDF8E6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: screenHeight * 0.08),
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_back, color: Color(0xFF183B5E)),
                    Text(
                      'بوت الدردشة',
                      style: TextStyle(
                        color: Color(0xFF183B5E),
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Opacity(
                      opacity: 0.0,
                      child: Icon(Icons.arrow_back),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.1),

              // Welcome box and image
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: screenWidth * 0.8,
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: Color(0xFFE4F2F4),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      'مرحبا! كيف يمكنني\nمساعدتك اليوم؟',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF183B5E),
                        fontSize: screenWidth * 0.045,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -screenWidth * 0.30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        'assets/images/sticker7.webp',
                        width: screenWidth * 0.3,
                        height: screenWidth * 0.3,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.06),

              // Questions list
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: List.generate(questions.length, (index) {
                    bool isSelected = selectedQuestionIndex == index;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedQuestionIndex = isSelected ? -1 : index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
                            padding: EdgeInsets.all(screenWidth * 0.035),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: screenWidth * 0.05,
                                  height: screenWidth * 0.05,
                                  margin: EdgeInsets.only(left: screenWidth * 0.03),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Color(0xFF183B5E) : Colors.transparent,
                                    border: Border.all(color: Color(0xFF183B5E)),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    questions[index]['question']!,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Color(0xFF183B5E),
                                      fontSize: screenWidth * 0.04,
                                      ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02, vertical: screenHeight * 0.006),
                            padding: EdgeInsets.all(screenWidth * 0.035),
                            decoration: BoxDecoration(
                              color: Color(0xFFE4F2F4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              questions[index]['answer']!,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFF183B5E),
                                fontSize: screenWidth * 0.038,
                                height: 1.4,
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}