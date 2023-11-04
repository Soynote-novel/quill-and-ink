import 'package:flutter/material.dart';
import 'package:flutter_bootstrap5/flutter_bootstrap5.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soynote/page/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "soynote",
      home: const HomePage(title: 'Soynote'),
      onGenerateRoute: (RouteSettings settings) {
          switch(settings.name) {
            case '/home':
            case '/':
              return MyCustomRoute(
                builder: (_) => const HomePage(title: 'Soynote'),
                settings: settings,
              );
          }
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
