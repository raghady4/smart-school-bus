import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static final StreamController<NotificationResponse> streamController =
      StreamController();

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onBackgroundTap,
    );
  }

  static void onTap(NotificationResponse response) {
    streamController.add(response);
  }

  static void onBackgroundTap(NotificationResponse response) {
    streamController.add(response);
  }

  static Future<void> showBasicNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'smart_bus_channel',
      'Smart Bus Notifications',
      channelDescription: 'Channel for Smart Bus app notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      0,
      message.notification?.title ?? 'إشعار',
      message.notification?.body ?? '',
      notificationDetails,
    );
  }
}
