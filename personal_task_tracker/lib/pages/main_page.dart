import 'dart:ui';
//Pages
import 'package:flutter/material.dart';
import 'package:personal_task_tracker/widgets/body_home.dart';
import 'package:personal_task_tracker/widgets/body_task_list.dart';
import 'package:personal_task_tracker/widgets/body_statistics_task.dart';
import 'package:personal_task_tracker/widgets/body_settings.dart';

//Widgets
import 'package:personal_task_tracker/widgets/bottomNavigationBar_custom_widget.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentPageIndex = 0;
  late List<Widget> _pages;

  void _onTabChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _pages = [
      BodyHome(),
      BodyStatisticsTask(),
      BodyTaskList(),
      BodySettings(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Фон
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF360033),Color(0xFF0b8793)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          
          // Blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.transparent),
          ),
          
          // Основной контент
          _pages[_currentPageIndex],
          
          // Навигационная панель
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomnavigationbarCustomWidget(currentIndex: _currentPageIndex,onTabChanged: _onTabChanged,),
          ),
        ],
      ),
    );
  }
}