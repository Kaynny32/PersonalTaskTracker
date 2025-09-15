import 'package:flutter/material.dart';

class BodyHome extends StatefulWidget {
  const BodyHome({super.key});

  @override
  State<BodyHome> createState() => _BodyHomeState();
}

class _BodyHomeState extends State<BodyHome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.transparent,
        child: Align(
          alignment: AlignmentGeometry.bottomCenter,
          child: SingleChildScrollView(
            child: Column(
              children: [
                
              ],
            ),
          ),
        )
                  
      )
    );
  }
}