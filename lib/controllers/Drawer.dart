// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soynote/main.dart';

Drawer getDrawer() {
  return Drawer(
    backgroundColor: primaryColor,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.greenAccent),
          child: Text('Menus')
        ),
        ListTile(
          title: const Text('Home'),
          // ignore: unnecessary_const
          onTap: () {
            Get.toNamed('/');
          }
        ),
        ListTile(
          title: const Text('test1'),
          // ignore: unnecessary_const
          onTap: () {
            Get.toNamed('/test1');
          }
        )
      ],
    )
  );
}