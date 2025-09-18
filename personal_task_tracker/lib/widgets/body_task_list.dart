import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personal_task_tracker/widgets/task_card.dart';
import 'package:personal_task_tracker/widgets/popap_widget_add_task.dart';
import 'package:personal_task_tracker/models/task_database.dart';
import 'package:personal_task_tracker/models/task.dart';

class BodyTaskList extends StatefulWidget {
  const BodyTaskList({super.key});

  @override
  State<BodyTaskList> createState() => _BodyTaskListState();
}

class _BodyTaskListState extends State<BodyTaskList> {
  bool _showPopup = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final taskDatabase = Provider.of<TaskDatabase>(context, listen: false);
    await taskDatabase.fetchTasks();
    setState(() {
      _isLoading = false;
    });
  }

  void _showAddTaskPopup() {
    setState(() {
      _showPopup = true;
    });
  }

  void _hideAddTaskPopup() {
    setState(() {
      _showPopup = false;
    });
  }

  // Функция для обработки добавленной задачи
  Future<void> _handleTaskAdded(Task newTask) async {
    final taskDatabase = Provider.of<TaskDatabase>(context, listen: false);
    
    try {
      await taskDatabase.addTask(
        title: newTask.title,
        description: newTask.description,
        isCompleted: newTask.isCompleted,
        status: newTask.status,
        priority: newTask.priority,
        dueDate: newTask.dueDate,
      );
      
      // Автоматически обновляется через ChangeNotifier
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error $e')),
      );
    }
  }

  // Функция для обработки редактирования задачи
  Future<void> _handleTaskEdited(Task updatedTask) async {
    final taskDatabase = Provider.of<TaskDatabase>(context, listen: false);
    
    try {
      await taskDatabase.updateTask(
        idTask: updatedTask.id,
        title: updatedTask.title,
        description: updatedTask.description,
        isCompleted: updatedTask.isCompleted,
        status: updatedTask.status,
        priority: updatedTask.priority,
        dueDate: updatedTask.dueDate,
        completedAt: updatedTask.completedAt,
      );
      
      // Автоматически обновляется через ChangeNotifier
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating task: $e')),
      );
    }
  }

  // Функция для обработки удаления задачи
  Future<void> _handleTaskDeleted(String taskId) async {
    final taskDatabase = Provider.of<TaskDatabase>(context, listen: false);
    
    try {
      await taskDatabase.deleteTask(int.parse(taskId));
      
      // Автоматически обновляется через ChangeNotifier
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                // Add Task Block
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Center(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.blue[900]),
                                ),
                                onPressed: _showAddTaskPopup,
                                child: const Text(
                                  'Add Task',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          // List Task Block
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 450,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: _isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : Align(
                                    alignment: Alignment.topCenter,
                                    child: Consumer<TaskDatabase>(
                                      builder: (context, taskDatabase, child) {
                                        return SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 10),
                                              // Отображаем задачи из базы данных
                                              ...taskDatabase.currentTasks.map((task) => TaskCard(
                                                    task: task,
                                                    onEdit: _handleTaskEdited,
                                                    onDelete: _handleTaskDeleted,
                                                  )).toList(),
                                              if (taskDatabase.currentTasks.isEmpty)
                                                const Padding(
                                                  padding: EdgeInsets.all(20.0),
                                                  child: Text(
                                                    'No tasks yet\nClick "Add Task" to create your first task!',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Отдельный виджет попапа
        if (_showPopup)
          PopapWidgetAddTask(
            hideAddTaskPopup: _hideAddTaskPopup,
            onTaskAdded: _handleTaskAdded,
          ),
      ],
    );
  }
}