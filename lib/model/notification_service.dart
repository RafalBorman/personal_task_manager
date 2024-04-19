import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    var warsaw = tz.getLocation('Europe/Warsaw');
    tz.setLocalLocation(warsaw);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> showTimedNotification(int id, String name, String description,
      DateTime scheduledNotificationDateTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        name,
        description,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        NotificationDetails(
            android: AndroidNotificationDetails(
                'channel $id', 'your channel name $id',
                channelDescription: 'your channel description $id')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelTimedNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
