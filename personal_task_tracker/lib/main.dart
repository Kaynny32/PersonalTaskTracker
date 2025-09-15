import 'package:flutter/material.dart';
import 'package:personal_task_tracker/pages/main_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/main_page',
    routes: {
      '/main_page':(context) => MainPage(),
    },
  ));
}
