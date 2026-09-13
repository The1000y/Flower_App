import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/main.dart';

class FirebaseNotifcation {
  //create instanse of fbm
  static final _firebasemessage = FirebaseMessaging.instance;

  static void intialfireNotfication() async {
    _firebasemessage.requestPermission(alert: true, badge: true, sound: true);
    try {
      final token = await _firebasemessage.getToken();
      print(token);
    } catch (e) {
      print('Error getting FCM Token: $e');
    }
    handelbackground();
  }

  static void handelmessage(RemoteMessage? message) {
    if (message == null) return;
    navkey.currentState!.pushNamed(Routes.notification, arguments: message);
  }

  static Future<void> handelbackground() async {
    FirebaseMessaging.instance.getInitialMessage().then(handelmessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handelmessage);
  }
}
