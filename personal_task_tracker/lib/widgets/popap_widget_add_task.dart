import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:personal_task_tracker/models/task.dart';

class PopapWidgetAddTask extends StatefulWidget {
  final VoidCallback hideAddTaskPopup;
  final Function(Task) onTaskAdded;
  
  const PopapWidgetAddTask({
    super.key,
    required this.hideAddTaskPopup,
    required this.onTaskAdded,
  });

  @override
  State<PopapWidgetAddTask> createState() => _PopapWidgetAddTaskState();
}

class _PopapWidgetAddTaskState extends State<PopapWidgetAddTask> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _dueDate;
  TaskStatus _status = TaskStatus.pending;
  int _priority = 1; // Средний приоритет по умолчанию

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _addTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter task title')),
      );
      return;
    }

    final newTask = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      isCompleted: false,
      status: _status,
      createdAt: DateTime.now(),
      priority: _priority,
      dueDate: _dueDate,
      completedAt: null,
    );

    widget.onTaskAdded(newTask); // Передаем задачу в callback
    
    // Очищаем поля
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _dueDate = null;
      _status = TaskStatus.pending;
      _priority = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.hideAddTaskPopup,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF360033), Color(0xFF0b8793)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add Task',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        
                        const SizedBox(height: 20),

                        // Название задачи
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title*',
                            labelStyle: TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),

                        const SizedBox(height: 15),

                        // Описание
                        TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          maxLines: 3,
                          style: TextStyle(color: Colors.white),
                        ),

                        const SizedBox(height: 15),

                        // Статус
                        DropdownButtonFormField<TaskStatus>(
                          value: _status,
                          decoration: InputDecoration(
                            labelText: 'Status',
                            labelStyle: TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          dropdownColor: const Color(0xFF360033),
                          style: TextStyle(color: Colors.white),
                          items: TaskStatus.values.map((status) {
                            return DropdownMenuItem<TaskStatus>(
                              value: status,
                              child: Text(
                                _getStatusText(status),
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _status = value!;
                            });
                          },
                        ),

                        const SizedBox(height: 15),

                        // Приоритет
                        DropdownButtonFormField<int>(
                          value: _priority,
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            labelStyle: TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          dropdownColor: const Color(0xFF360033),
                          style: TextStyle(color: Colors.white),
                          items: [
                            DropdownMenuItem(
                              value: 0,
                              child: Text('Low', style: TextStyle(color: Colors.white)),
                            ),
                            DropdownMenuItem(
                              value: 1,
                              child: Text('Medium', style: TextStyle(color: Colors.white)),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text('High', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _priority = value!;
                            });
                          },
                        ),

                        const SizedBox(height: 15),

                        // Дата выполнения
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _selectDueDate(context),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.white70),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  _dueDate == null
                                      ? 'Select due date'
                                      : 'Due: ${_dueDate!.toString().split(' ')[0]}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            if (_dueDate != null)
                              IconButton(
                                icon: Icon(Icons.clear, color: Colors.white70),
                                onPressed: () {
                                  setState(() {
                                    _dueDate = null;
                                  });
                                },
                              ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Кнопки
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: widget.hideAddTaskPopup,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                                foregroundColor: MaterialStateProperty.all(Colors.black),
                              ),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: _addTask,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue[900]),
                              ),
                              child: const Text(
                                'Add',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.archived:
        return 'Archived';
    }
  }
}