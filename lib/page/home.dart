import 'package:flutter/material.dart';
import 'package:soynote/controllers/Drawer.dart';
import 'package:soynote/main.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Soynote",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.black)
        ),
        backgroundColor: primaryColor
      ),
      drawer: getDrawer(),
      body: const Center(
          child: Text(
            'Hello World',
            style: TextStyle(fontSize: 24.0),
          ),
        ),
    );
  }
}