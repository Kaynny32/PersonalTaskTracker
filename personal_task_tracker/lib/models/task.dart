import 'package:isar/isar.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;
  @Index()
  late int idTask;
  
  @Index()
  late String title;

  late String description;

  @Index()
  late bool isCompleted;

  @enumerated
  late TaskStatus status;
  
  @Index()
  late DateTime createdAt;
  
  DateTime? dueDate;
  DateTime? completedAt;
  
  @Index()
  late int priority; // 0: низкий, 1: средний, 2: высокий

  // Добавьте конструктор для удобства
  Task({
    required this.idTask,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.status,
    required this.createdAt,
    required this.priority,
    this.dueDate,
    this.completedAt,
  });
}

enum TaskStatus {
  pending,     // Ожидает
  inProgress,  // В процессе
  completed,   // Завершена
  archived     // В архиве
}