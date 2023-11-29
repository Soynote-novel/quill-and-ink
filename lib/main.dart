// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:soynote/firebase_options.dart';
import 'package:soynote/page/home.dart';

const primaryColor = Colors.lightGreen;

void main() async {
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );

  // ignore: unused_local_variable
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // ignore: unused_local_variable
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true
  );

  // ignore: unused_local_variable
  const AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
    "soynote_channel", "soynote notification",
    importance: Importance.max
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"), iOS: DarwinInitializationSettings()
    )
  );

  final fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: 'BPcv5jKHuUvatdSnyldzC-JQqGNzwgweMSrtxoC4FmEQ3rZ-gW7Scatk9HPT9oCII1xnh8R-pTmGe5er17qgbOk');
  
  print("$fcmToken");
  

  FirebaseMessaging.onMessage.listen((RemoteMessage rm) {
    RemoteNotification? notification = rm.notification;
    AndroidNotification? android = rm.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        0,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'soynote_channel', 
            'soynote alert channel',
          )
        )
      );
    }

  });

  WidgetsFlutterBinding.ensureInitialized();

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

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
