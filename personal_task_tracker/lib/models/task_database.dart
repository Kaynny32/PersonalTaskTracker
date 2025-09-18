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

  // Добавление задачи (ИСПРАВЛЕНО: убрано обязательное поле idTask)
  Future<void> addTask({
    required String title,
    required String description,
    bool isCompleted = false,
    TaskStatus status = TaskStatus.pending,
    required int priority,
    DateTime? dueDate,
  }) async {
    _checkInitialization();

    // Генерируем уникальный idTask на основе времени
    final idTask = DateTime.now().millisecondsSinceEpoch;

    final newTask = Task(
      idTask: idTask,
      title: title,
      description: description,
      isCompleted: isCompleted,
      status: status,
      createdAt: DateTime.now(),
      priority: priority,
      dueDate: dueDate,
      completedAt: isCompleted ? DateTime.now() : null,
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

  // Обновление задачи (ИСПРАВЛЕНО: синхронизация isCompleted и completedAt)
  Future<void> updateTask(Task task) async {
    _checkInitialization();
    
    // Обновляем completedAt в зависимости от статуса выполнения
    final updatedTask = Task(
      idTask: task.idTask,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      status: task.status,
      createdAt: task.createdAt,
      priority: task.priority,
      dueDate: task.dueDate,
      completedAt: task.isCompleted 
        ? (task.completedAt ?? DateTime.now()) 
        : null,
    );

    await isar.writeTxn(() async {
      await isar.tasks.put(updatedTask);
    });
    await fetchTasks();
  }

  // Удаление задачи по Isar ID (не idTask)
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

  // Новый метод для поиска задачи по idTask
  Future<Task?> getTaskByIdTask(int idTask) async {
    _checkInitialization();
    return await isar.tasks.filter().idTaskEqualTo(idTask).findFirst();
  }
}