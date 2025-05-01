import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    // Set local timezone correctly
    final String currentTimeZone = DateTime.now().timeZoneName;
    try {
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('Asia/Kolkata')); // Fallback timezone
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        print("iOS Notification Received: $title, $body");
      },
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings);

    // Request notification permissions for Android 13+ and iOS
    await _requestNotificationPermissions();
  }

  Future<void> _requestNotificationPermissions() async {
    // Check if we're on Android 13+ and request permission
    if (await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission() ??
        false) {
      print("Android 13+ notification permission granted");
    }

    // Request iOS permission
    final bool? iosGranted = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (iosGranted != null && iosGranted) {
      print("iOS notification permission granted");
    } else {
      print("iOS notification permission denied");
    }
  }

  /// Send an instant notification with title and subtitle/body
  Future<void> sendNotification({
    required String title,
    required String subtitle,
  }) async {
    try {
      await _notificationsPlugin.show(
        0,
        title,
        subtitle,
        _notificationDetails(),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error showing notification: $e");
      }
    }
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'default_channel',
        'General Notifications',
        channelDescription: 'Channel for immediate notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }
}
