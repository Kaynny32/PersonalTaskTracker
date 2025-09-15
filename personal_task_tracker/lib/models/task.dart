import 'package:isar/isar.dart';

part 'task.g.dart';

@collection
class Task {
  Id id =Isar.autoIncrement;
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
}

enum TaskStatus {
  pending,     // Ожидает
  inProgress,  // В процессе
  completed,   // Завершена
  archived     // В архиве
}