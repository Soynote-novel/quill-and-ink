// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:soynote/firebase_options.dart';
import 'package:soynote/page/home.dart';

const primaryColor = Colors.lightGreen;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);

  print("Handling a background message: ${message.messageId}");
}


/// Initialize the [FlutterLocalNotificationPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if(isFlutterLocalNotificationsInitialized) {
    return;
  }

  channel = const AndroidNotificationChannel(
    "soynote_channel", "soynote notification",
    importance: Importance.max
  );
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(channel);
  
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"), iOS: DarwinInitializationSettings()
    )
  );

  // ignore: unused_local_variable
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'soynote_channel', 
            'soynote alert channel',
            icon: 'launch_background'
          )
        )
      );
    }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );

  // ignore: unused_local_variable
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  // ignore: unused_local_variable
  final fcmToken = await messaging.getToken(vapidKey: 'BPcv5jKHuUvatdSnyldzC-JQqGNzwgweMSrtxoC4FmEQ3rZ-gW7Scatk9HPT9oCII1xnh8R-pTmGe5er17qgbOk');
  print(fcmToken);

  runApp(const MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "soynote",
      theme: ThemeData(
        primaryColor: primaryColor
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomePage())
      ],
    );
  }
}
