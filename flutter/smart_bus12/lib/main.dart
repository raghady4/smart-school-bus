import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import 'package:smart_bus/add_student/bloc/add_student_cubit.dart';
import 'package:smart_bus/add_student/presentation/auth_add_student.dart';
import 'package:smart_bus/add_student/server/add_student_server.dart';
import 'package:smart_bus/admin_page/bloc/admin_page_cubit.dart';
import 'package:smart_bus/admin_page/server/admin_page_server.dart';
import 'package:smart_bus/driver_page/bloc/driver_cubit.dart';
import 'package:smart_bus/driver_page/server/driver_server.dart';
import 'package:smart_bus/get_school_bus_area/bloc/get_all_cubit.dart';
import 'package:smart_bus/get_school_bus_area/server/get_all.dart';
import 'package:smart_bus/get_students/get_student_bloc/get_studetns_cubit.dart';
import 'package:smart_bus/get_students/server/get_student_server.dart';
import 'package:smart_bus/login/presentation/logout_page.dart';

import 'login/presentation/register.dart';
import 'login/bloc/login_cubit.dart';
import 'login/server/login_server.dart';
import 'notification/bloc/notification_cubit.dart';
import 'notification/server/notification_server.dart';
import 'notification/presentation/notification_page.dart';

import 'page1.dart';
import 'page4.dart';
import 'page5.dart';
import 'get_students/presentation/students_page.dart';
import 'package:smart_bus/page6.dart' as page6;
import 'package:smart_bus/page9.dart' as page9;
import 'package:smart_bus/page12.dart' as page12;

import 'services/local_notifications_service.dart';
import 'firebase_options.dart';

/// معالجة الإشعارات في الخلفية
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var logger = Logger();
  logger.i("📥 Background message: ${message.notification?.title}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("✅ التطبيق بدأ");

  // Firebase Init
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Shared Preferences
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString("auth_token");
  final String? name = prefs.getString("name");
  final String? role = prefs.getString("role");

  const String baseUrl = 'http://192.168.186.176:8000/api';

  final loginServer = LoginServer(baseUrl: baseUrl);
  final addStudentServer = AddStudentServer(baseUrl: baseUrl);
  final notificationServer = NotificationServer(baseUrl: baseUrl);

  await LocalNotificationService.init();

  runApp(
    ProviderScope(
      child: SmartBusApp(
        loginServer: loginServer,
        addStudentServer: addStudentServer,
        notificationServer: notificationServer,
        isLoggedIn: token != null && name != null && role != null,
        name: name,
        role: role,
      ),
    ),
  );
}

class SmartBusApp extends StatelessWidget {
  final LoginServer loginServer;
  final AddStudentServer addStudentServer;
  final NotificationServer notificationServer;
  final bool isLoggedIn;
  final String? name;
  final String? role;

  const SmartBusApp({
    super.key,
    required this.loginServer,
    required this.addStudentServer,
    required this.notificationServer,
    required this.isLoggedIn,
    this.name,
    this.role,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit(loginServer)),
        BlocProvider(
          create: (_) =>
              NotificationCubit(notificationServer)..registerFcmToken(),
        ),
        BlocProvider(
          create: (_) => GetStudentCubit(
            GetStudentServer(baseUrl: 'http://192.168.186.176:8000/api'),
          ),
        ),
        BlocProvider(
          create: (_) => AddStudentCubit(
            AddStudentServer(baseUrl: 'http://192.168.186.176:8000/api'),
          ),
        ),
        BlocProvider(
          create: (_) => GetAllCubit(
            GetSchoolBusAreaServer(baseUrl: 'http://192.168.186.176:8000/api'),
          ),
        ),

        BlocProvider(
          create: (_) => DriverCubit(
            DriverServer(baseUrl: 'http://192.168.186.176:8000/api'),
          ),
        ),
        BlocProvider(
          create: (_) => AdminSchoolCubit(
            AdminSchoolServer(baseUrl: 'http://192.168.186.176:8000/api'),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Bus',
        theme: ThemeData(fontFamily: 'Cairo'),
        home: isLoggedIn
            ? (role == 'ولي الأمر'
                  ? HomePage(name: name!, role: role!)
                  : ActivationWaitingPage(name: '', role: ''))
            : Page1(),
        routes: {
          '/page1': (_) => Page1(),
          '/register': (_) => Register(),
          '/page4': (_) => HomePage(name: name ?? '', role: role ?? ''),
          '/page5': (_) => ActivationWaitingPage(name: '', role: ''),
          '/page6': (_) => const page6.MyApp(),
          '/page7': (_) => NotificationPage(),
          '/page8': (_) => CloudScreen(),
          '/page9': (_) => page9.MyApp(),
          '/page10': (_) => const StudentsPage(),
          '/page11': (_) => const AuthAddStudent(),
          '/page12': (_) => page12.MyApp(),
          '/add-student': (_) => const AuthAddStudent(),
        },
        builder: (context, child) {
          ErrorWidget.builder = (FlutterErrorDetails details) {
            return Center(child: Text("❌ ${details.exceptionAsString()}"));
          };
          return child!;
        },
      ),
    );
  }
}
