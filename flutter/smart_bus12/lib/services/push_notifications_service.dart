import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smart_bus/services/local_notifications_service.dart';
import 'package:smart_bus/notification/server/notification_server.dart';

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static late NotificationServer notificationServer;

  static Future<void> init(NotificationServer server) async {
    notificationServer = server;

    await messaging.requestPermission();

    String? token = await messaging.getToken();
    if (token != null) {
      log('🔥 FCM Token: $token');
      await _sendTokenToServer(token);
    }

    messaging.onTokenRefresh.listen((token) async {
      log('🔄 Token refreshed: $token');
      await _sendTokenToServer(token);
    });

    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((message) {
      log('📥 FG: ${message.notification?.title ?? 'No title'}');
      LocalNotificationService.showBasicNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('📲 Opened App: ${message.notification?.title ?? 'No title'}');
    });

    await messaging.subscribeToTopic('all');
    log('✅ Subscribed to topic: all');
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log('📥 BG: ${message.notification?.title ?? 'No title'}');
    LocalNotificationService.showBasicNotification(message); // عرض الإشعار بالخلفية
  }

  static Future<void> _sendTokenToServer(String token) async {
    try {
      await notificationServer.registerFcmToken(token);
      log('✅ Token sent to server');
    } catch (e) {
      log('❌ Failed to send token: $e');
    }
  }
}