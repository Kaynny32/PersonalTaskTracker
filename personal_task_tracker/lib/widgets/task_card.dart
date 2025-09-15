import 'package:flutter/material.dart';


class TaskCard extends StatefulWidget {
  final String name;
  final String status;

  const TaskCard(
    {
      super.key,
      required this.name,
      required this.status,
    }
  );

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),                      
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: AnimatedExpansionTile(
          leading: Icon(Icons.work, color: Colors.white, size: 30),
          title: Text(widget.name, 
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 1
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Center(child: Text(widget.status,style: TextStyle(color: Colors.white,fontSize: 20),),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedExpansionTile extends StatefulWidget {
  final Widget leading;
  final Widget title;
  final List<Widget> children;

  const AnimatedExpansionTile({
    required this.leading,
    required this.title,
    required this.children,
    super.key,
  });

  @override
  State<AnimatedExpansionTile> createState() => _AnimatedExpansionTileState();
}

class _AnimatedExpansionTileState extends State<AnimatedExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      trailing: RotationTransition(
        turns: AlwaysStoppedAnimation(_isExpanded ? 0.5 : 0.0),
        child: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 25),
      ),
      leading: widget.leading,
      title: widget.title,
      backgroundColor: Colors.grey.shade600,
      collapsedBackgroundColor: Colors.grey.shade400,
      onExpansionChanged: (expanded) {
        setState(() {
          _isExpanded = expanded;
        });
      },
      children: widget.children,
    );
  }
}