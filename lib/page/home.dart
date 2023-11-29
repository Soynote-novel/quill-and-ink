import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      drawer: Drawer(
        backgroundColor: primaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.greenAccent),
              child: Text('Menus')
            ),
            ListTile(
              title: const Text('home'),
              // ignore: unnecessary_const
              onTap: () {
                Get.toNamed('/');
              }
            )
          ],
        )
      ),
      body: Container()
    );
  }
}