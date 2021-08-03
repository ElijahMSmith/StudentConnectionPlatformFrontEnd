import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();

  // android and ios notification details set up
  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
          'channel id', 'channel name', 'channel description',
          importance: Importance.max),
      iOS: IOSNotificationDetails(),
    );
  }

  // initialize settings for both iOS and Android
  static Future init({bool initScheduled = false}) async {
    final androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOSSettings = IOSInitializationSettings();
    final settings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);

    await _notifications.initialize(settings,
        onSelectNotification: (String payload) async {
      onNotifications.add(payload);
    });
  }

  // notification info set up to show the client
  static Future showNotification({
    int id = 0,
    String title,
    String body,
    String payload,
  }) async {
    return _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
  }

  static Future showScheduledDailyNotification(
      {int id = 0,
      String title,
      String body,
      String payload,
      @required Time time}) async {
    return _notifications.zonedSchedule(
      id,
      title,
      body,
      _scheduleDaily(time),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future showScheduledWeeklyNotification(
      {int id = 0,
      String title,
      String body,
      String payload,
      @required Time time}) async {
    return _notifications.zonedSchedule(
      id,
      title,
      body,
      _scheduleWeekly(time, days: [DateTime.monday, DateTime.tuesday]),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  static tz.TZDateTime _scheduleDaily(Time time) {
    // make sure the current time value is scheduled for the next day if that value has already passes today.
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        // get schedule day values
        time.hour,
        time.minute,
        time.second);

    return scheduleDate.isBefore(now)
        ? scheduleDate.add(Duration(days: 1))
        : scheduleDate;
  }

  static tz.TZDateTime _scheduleWeekly(Time time, {@required List<int> days}) {
    tz.TZDateTime scheduleDate = _scheduleDaily(time);

    for (; !days.contains(scheduleDate.weekday);)
      scheduleDate.add(Duration(days: 1));

    return scheduleDate;
  }
}
