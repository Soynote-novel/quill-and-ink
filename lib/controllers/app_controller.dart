import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:soynote/firebase_options.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  final Rxn<RemoteMessage> message = Rxn<RemoteMessage>();

  Future<bool> initialize() async {
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

    final fcmToken = await FirebaseMessaging.instance.getToken();
    
    print("$fcmToken");
    

    FirebaseMessaging.onMessage.listen((RemoteMessage rm) {
      message.value = rm;
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

    return true;
  }
}