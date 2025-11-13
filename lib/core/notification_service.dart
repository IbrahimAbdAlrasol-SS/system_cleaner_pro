import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  void startListening(Function(Map<String, dynamic>) onNotification) {
    // هذه وظيفة محاكاة - ستحتاج لإضافة كود حقيقي لمراقبة الإشعارات
    _simulateNotifications(onNotification);
  }

  void _simulateNotifications(Function(Map<String, dynamic>) onNotification) {
    // محاكاة استقبال إشعارات (استبدل هذا بالكود الحقيقي)
    Future.delayed(Duration(seconds: 10), () {
      onNotification({
        'app': 'WhatsApp',
        'time': DateTime.now().toString(),
        'content': 'New message from John'
      });
    });
  }

  Future<void> showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'system_cleaner_channel',
      'System Optimizer',
      channelDescription: 'System optimization notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      0,
      title,
      body,
      details,
    );
  }
}