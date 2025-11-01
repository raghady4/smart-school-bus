import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_state.dart';
import '../server/notification_server.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationServer server;

  NotificationCubit(this.server) : super(NotificationInitial());

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    try {
      final notifications = await server.getNotifications();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> registerFcmToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? token = await messaging.getToken();
      if (token != null) {
        await server.registerFcmToken(token);
        print('✅ FCM token registered: $token');
      } else {
        print('⚠️ FCM token is null');
      }
    } catch (e) {
      print('❌ Failed to register token: $e');
      emit(NotificationError('faild ${e.toString()}'));
    }
  }
}
