import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class NotificationApi {
  final notifications = FlutterLocalNotificationsPlugin();
  final notificaitonClicks = BehaviorSubject<String?>();
  final androidSetting = AndroidInitializationSettings('logo');


   setup() async {
    InitializationSettings initSettings =
        InitializationSettings(android: androidSetting);

    await notifications
        .initialize(initSettings)
        .then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

  showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      await notifications.show(id, title, body, await getNotificationDetails(),
          payload: payload);

   scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledDate}) async {
    tzData.initializeTimeZones();
    notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        await getNotificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  getNotificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          channelDescription: 'channel description',
          importance: Importance.max,
        ),
       );
  }
}