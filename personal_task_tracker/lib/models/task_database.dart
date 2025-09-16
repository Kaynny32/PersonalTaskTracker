import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:personal_task_tracker/models/task.dart';
import 'package:path_provider/path_provider.dart';

class TaskDatabase extends ChangeNotifier {
  static Isar? _isar;
  final List<Task> currentTasks = [];

  // Singleton pattern
  static final TaskDatabase _instance = TaskDatabase._internal();
  factory TaskDatabase() => _instance;
  TaskDatabase._internal();

  // Геттер для доступа к isar
  static Isar get isar {
    if (_isar == null || !_isar!.isOpen) {
      throw Exception('Database not initialized. Call TaskDatabase.initialize() first.');
    }
    return _isar!;
  }

  // Инициализация базы данных
  static Future<void> initialize() async {
    if (_isar != null && _isar!.isOpen) return;
    
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [TaskSchema], 
      directory: dir.path,
      inspector: true,
    );
  }

  void _checkInitialization() {
    if (_isar == null || !_isar!.isOpen) {
      throw Exception('Database not initialized. Call TaskDatabase.initialize() first.');
    }
  }

  // Добавление задачи
  Future<void> addTask({
    required String title,
    required String description,
    bool isCompleted = false,
    TaskStatus status = TaskStatus.pending,
    required int priority,
    DateTime? dueDate,
  }) async {
    _checkInitialization();

    final newTask = Task(
      title: title,
      description: description,
      isCompleted: isCompleted,
      status: status,
      createdAt: DateTime.now(),
      priority: priority,
      dueDate: dueDate,
      completedAt: null,
    );

    await isar.writeTxn(() async {
      await isar.tasks.put(newTask);
    });
    await fetchTasks();
  }

  // Получение всех задач
  Future<void> fetchTasks() async {
    _checkInitialization();
    final fetchedTasks = await isar.tasks.where().findAll();
    currentTasks.clear();
    currentTasks.addAll(fetchedTasks);
    notifyListeners();
  }

  // Обновление задачи
  Future<void> updateTask(Task task) async {
    _checkInitialization();
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
    await fetchTasks();
  }

  // Удаление задачи
  Future<void> deleteTask(int id) async {
    _checkInitialization();
    await isar.writeTxn(() async {
      await isar.tasks.delete(id);
    });
    await fetchTasks();
  }

  // Дополнительные методы
  Future<Task?> getTaskById(int id) async {
    _checkInitialization();
    return await isar.tasks.get(id);
  }

  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    _checkInitialization();
    return await isar.tasks.filter().statusEqualTo(status).findAll();
  }

  Future<int> getTaskCount() async {
    _checkInitialization();
    return await isar.tasks.count();
  }
}