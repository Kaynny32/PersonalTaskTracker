import 'package:flutter/material.dart';
import 'package:personal_task_tracker/models/task_database.dart';
import 'package:personal_task_tracker/pages/main_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализируем базу данных
  await TaskDatabase.initialize();
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskDatabase(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Task Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}