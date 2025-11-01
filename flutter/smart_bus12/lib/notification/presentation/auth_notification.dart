import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../server/notification_server.dart';

class AuthNotification extends StatefulWidget {
  final NotificationServer server;

  AuthNotification({required this.server});

  @override
  _AuthNotificationState createState() => _AuthNotificationState();
}

class _AuthNotificationState extends State<AuthNotification> {
  @override
  void initState() {
    super.initState();
    registerFcmToken();
  }

  void registerFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();

    if (token != null) {
      // ابعت التوكن للباك لتخزينه
      await widget.server.registerFcmToken(token);
      print('FCM token registered: $token');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FCM test")),
      body: Center(child: Text("app initialized")),
    ); // فقط تسجيل التوكن عند بداية التطبيق
  }
}
