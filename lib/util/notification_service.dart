import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  InitializationSettings? initializationSettings;
  AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
      'remind_if_main', 'location reminder', channelDescription: '',
      importance: Importance.high, priority: Priority.high, sound: RawResourceAndroidNotificationSound('buddy'),
    playSound: true,);

  NotificationDetails? platformChannelSpecifics;

  int id = 0;

  NotificationService() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

    initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings!);
    platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  }

  notify(String title, String body) {
    return flutterLocalNotificationsPlugin.show(
        id, title, body, platformChannelSpecifics);
    //id++;
  }
}

NotificationService notificationService = NotificationService();