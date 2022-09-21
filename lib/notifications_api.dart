import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class NotificationApi {
  static final notifications = FlutterLocalNotificationsPlugin();
  static final notificaitonClicks = BehaviorSubject<String?>();

  Future<void> setup() async {
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSetting = DarwinInitializationSettings();

    const initSettings =
        InitializationSettings(android: androidSetting, iOS: iosSetting);

    await notifications
        .initialize(initSettings,
            onDidReceiveNotificationResponse: (details) async =>
                notificaitonClicks.add(details.payload),
            onDidReceiveBackgroundNotificationResponse: (details) async =>
                notificaitonClicks.add(details.payload))
        .then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      notifications.show(id, title, body, await getNotificationDetails(),
          payload: payload);

  static Future scheduleNotification(
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

  static Future getNotificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          channelDescription: 'channel description',
          importance: Importance.max,
        ),
        iOS: DarwinNotificationDetails());
  }
}
