import 'dart:ui';

import 'package:flutter/material.dart';

class BottomnavigationbarCustomWidget extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabChanged;

  const BottomnavigationbarCustomWidget({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  State<BottomnavigationbarCustomWidget> createState() => _BottomnavigationbarCustomWidgetState();
}

class _BottomnavigationbarCustomWidgetState extends State<BottomnavigationbarCustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              //border: Border.all(color: Colors.black.withAlpha(75), width: 2),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: () => widget.onTabChanged(0),
                    icon: Icon(Icons.home),
                    color: widget.currentIndex == 0 ? Color(0xFF360033) : Colors.white,
                    iconSize: 30,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () => widget.onTabChanged(1),
                    icon: Icon(Icons.task_alt_outlined),
                    color: widget.currentIndex == 1 ? Color(0xFF360033) : Colors.white,
                    iconSize: 30,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () => widget.onTabChanged(2),
                    icon: Icon(Icons.list_rounded),
                    color: widget.currentIndex == 2 ? Color(0xFF360033) : Colors.white,
                    iconSize: 30,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () => widget.onTabChanged(3),
                    icon: Icon(Icons.settings),
                    color: widget.currentIndex == 3 ? Color(0xFF360033) : Colors.white,
                    iconSize: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}