import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'models/businessLayer/apiHelper.dart';
import 'models/businessLayer/global.dart' as global;
import 'models/localNotificationModel.dart';
import 'provider/local_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/style.dart';
import 'utils/local_notifications.dart';
import 'l10n/l10n.dart';
import 'networking/my_http_client.dart';

/// ------------------------------------------------------------
/// 🔥 BACKGROUND HANDLER (MUST BE TOP-LEVEL)
/// ------------------------------------------------------------
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 Background Message: ${message.messageId}');
}

/// ------------------------------------------------------------
/// 🔥 NOTIFICATION CHANNEL (ANDROID)
/// ------------------------------------------------------------
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'Used for important notifications',
  importance: Importance.high,
  playSound: true,
);

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  HttpOverrides.global = MyHttpOverrides();

  runApp(const App());
}

/// ------------------------------------------------------------
/// 🔥 APP ROOT
/// ------------------------------------------------------------
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    super.initState();
    setupFCM();
  }

  /// ------------------------------------------------------------
  /// 🔔 FCM SETUP
  /// ------------------------------------------------------------
  Future<void> setupFCM() async {
    late APIHelper apiHelper;
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      apiHelper = new APIHelper();

      print("Token"+token);
      await apiHelper.saveFcmToken(token);
    }
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Android init
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('ic_notification');

    /// iOS init
    const DarwinInitializationSettings iosInit =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings =
    InitializationSettings(android: androidInit, iOS: iosInit);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );

    /// Create channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Request permission
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    /// Get token

    /// FOREGROUND
    FirebaseMessaging.onMessage.listen(showForegroundNotification);

    /// APP OPEN FROM BACKGROUND
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotificationTap);

    /// APP OPEN FROM TERMINATED
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleNotificationTap(initialMessage);
    }

    /// TOKEN REFRESH
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("🔁 FCM Token Refreshed: $newToken");
    });
  }

  /// ------------------------------------------------------------
  /// 🔔 FOREGROUND NOTIFICATION
  /// ------------------------------------------------------------
  Future<void> showForegroundNotification(RemoteMessage message) async {
    if (message.notification == null) return;

    final String title = message.notification!.title ?? '';
    final String body = message.notification!.body ?? '';

    NotificationDetails notificationDetails;

    /// IMAGE SUPPORT
    if (Platform.isAndroid &&
        message.notification?.android?.imageUrl != null) {
      final String imagePath =
      await _downloadAndSaveFile(message.notification!.android!.imageUrl!);

      final BigPictureStyleInformation bigPicture =
      BigPictureStyleInformation(
        FilePathAndroidBitmap(imagePath),
        contentTitle: title,
        summaryText: body,
      );

      notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          styleInformation: bigPicture,
          icon: 'ic_notification',
        ),
      );
    } else {
      notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'ic_notification',
        ),
        iOS: const DarwinNotificationDetails(),
      );
    }

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  /// ------------------------------------------------------------
  /// 🔔 NOTIFICATION TAP HANDLER
  /// ------------------------------------------------------------
  void handleNotificationTap(RemoteMessage message) {
    print("📲 Notification Clicked: ${message.data}");

    if (message.data['type'] == 'order') {
      Get.to(() => SplashScreen(
        analytics: analytics,
        observer: observer,
      ));
    }
  }

  void onNotificationTap(NotificationResponse response) {
    print("📲 Local Notification Clicked");
  }

  /// ------------------------------------------------------------
  /// 🔽 IMAGE DOWNLOAD
  /// ------------------------------------------------------------
  Future<String> _downloadAndSaveFile(String url) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';

    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    return filePath;
  }

  /// ------------------------------------------------------------
  /// 🔥 UI
  /// ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [observer],
        title: "Khet Se",
        locale: Get.deviceLocale,
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: ThemeUtils.defaultAppThemeData,
        darkTheme: ThemeUtils.darkAppThemData,
        home: SplashScreen(
          analytics: analytics,
          observer: observer,
        ),
      ),
    );
  }
}
