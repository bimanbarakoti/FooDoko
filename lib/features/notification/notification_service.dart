import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
  }

  static Future showOrderPlaced({String? title, String? body}) async {
    const androidDetails = AndroidNotificationDetails(
      'order_channel',
      'Order Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await _plugin.show(0, title ?? 'Order Placed', body ?? 'Your order is being prepared', details);
  }
}
