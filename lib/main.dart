// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:soynote/controllers/app_controller.dart';

import 'package:flutter/material.dart';
import 'package:soynote/page/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final AppController c = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "soynote",
      home: Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
          future: c.initialize(),
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
              return const HomePage(title: 'Soynote');
            } else if(snapshot.hasError) {
              return const Center(child: Text("Failed to initialize"));
            } else {
              return const Center(child: Text("initializing..."));
            }
          }
        )
      ),
      onGenerateRoute: (RouteSettings settings) {
          switch(settings.name) {
            case '/home':
            case '/':
              return MyCustomRoute(
                builder: (_) => const HomePage(title: 'Soynote'),
                settings: settings,
              );
          }
          return null;
      },
    );
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({required WidgetBuilder builder, required RouteSettings settings})
    : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}
