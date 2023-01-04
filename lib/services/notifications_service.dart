import 'package:bar2_banzeen/services/users_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsService {
  Future<void> registerNotifications() async {
    FirebaseMessaging.instance.requestPermission();

    final fcmToken = await FirebaseMessaging.instance.getToken();
    await UsersService().updateUserToken(fcmToken!);
    print(fcmToken);
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      UsersService().updateUserToken(newToken);
    });
  }
}
