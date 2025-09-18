import 'package:flutter/material.dart';
import 'package:personal_task_tracker/models/task.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final Function(Task) onEdit;
  final Function(String) onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _getCardGradient(widget.task.priority),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              AnimatedExpansionTile(
                leading: _getPriorityIcon(widget.task.priority),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(widget.task.createdAt),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                    if (widget.task.dueDate != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Due: ${_formatDate(widget.task.dueDate!)}',
                        style: TextStyle(
                          color: _getDueDateColor(widget.task.dueDate!),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.task.description.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Description:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.task.description,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        
                        // Статус и приоритет
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatusChip(widget.task.status),
                            _buildPriorityChip(widget.task.priority),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Даты
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Created: ${_formatDateTime(widget.task.createdAt)}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                            if (widget.task.dueDate != null)
                              Text(
                                'Due: ${_formatDateTime(widget.task.dueDate!)}',
                                style: TextStyle(
                                  color: _getDueDateColor(widget.task.dueDate!),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            if (widget.task.completedAt != null)
                              Text(
                                'Completed: ${_formatDateTime(widget.task.completedAt!)}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Кнопки редактирования и удаления
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Кнопка редактирования
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.white.withOpacity(0.7)),
                      onPressed: () => _showEditDialog(context),
                    ),
                    
                    // Кнопка удаления
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.white.withOpacity(0.7)),
                      onPressed: () => _showDeleteConfirmation(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Диалог редактирования задачи
  void _showEditDialog(BuildContext context) {
    final titleController = TextEditingController(text: widget.task.title);
    final descriptionController = TextEditingController(text: widget.task.description);
    DateTime? dueDate = widget.task.dueDate;
    int priority = widget.task.priority;
    TaskStatus status = widget.task.status;
    bool isCompleted = widget.task.isCompleted;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Чекбокс выполнения
                    CheckboxListTile(
                      title: const Text('Completed'),
                      value: isCompleted,
                      onChanged: (value) {
                        setState(() {
                          isCompleted = value!;
                          if (isCompleted) {
                            status = TaskStatus.completed;
                          } else {
                            status = TaskStatus.pending;
                          }
                        });
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Выбор приоритета
                    DropdownButtonFormField<int>(
                      value: priority,
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('Low')),
                        DropdownMenuItem(value: 1, child: Text('Medium')),
                        DropdownMenuItem(value: 2, child: Text('High')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          priority = value!;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Priority'),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Выбор статуса
                    DropdownButtonFormField<TaskStatus>(
                      value: status,
                      items: const [
                        DropdownMenuItem(value: TaskStatus.pending, child: Text('Pending')),
                        DropdownMenuItem(value: TaskStatus.inProgress, child: Text('In Progress')),
                        DropdownMenuItem(value: TaskStatus.completed, child: Text('Completed')),
                        DropdownMenuItem(value: TaskStatus.archived, child: Text('Archived')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          status = value!;
                          isCompleted = (status == TaskStatus.completed);
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Status'),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Выбор даты выполнения
                    Row(
                      children: [
                        const Text('Due Date: '),
                        TextButton(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: dueDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                dueDate = selectedDate;
                              });
                            }
                          },
                          child: Text(
                            dueDate != null 
                              ? _formatDate(dueDate!) 
                              : 'Select Date',
                          ),
                        ),
                        if (dueDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                dueDate = null;
                              });
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final updatedTask = Task(
                      idTask: widget.task.idTask,
                      title: titleController.text,
                      description: descriptionController.text,
                      isCompleted: isCompleted,
                      status: status,
                      createdAt: widget.task.createdAt,
                      priority: priority,
                      dueDate: dueDate,
                      completedAt: status == TaskStatus.completed 
                        ? DateTime.now() 
                        : widget.task.completedAt,
                    );
                    
                    widget.onEdit(updatedTask);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Подтверждение удаления
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "${widget.task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onDelete(widget.task.id.toString());
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  List<Color> _getCardGradient(int priority) {
    switch (priority) {
      case 2: // High
        return [const Color(0xFFD32F2F), const Color(0xFFB71C1C)];
      case 1: // Medium
        return [const Color(0xFF0b8793), const Color(0xFF360033)];
      case 0: // Low
      default:
        return [const Color(0xFF4CAF50), const Color(0xFF2E7D32)];
    }
  }

  Widget _getPriorityIcon(int priority) {
    IconData icon;
    Color color;
    
    switch (priority) {
      case 2: // High
        icon = Icons.error;
        color = Colors.red;
        break;
      case 1: // Medium
        icon = Icons.warning;
        color = Colors.orange;
        break;
      case 0: // Low
      default:
        icon = Icons.info;
        color = Colors.green;
        break;
    }
    
    return Icon(icon, color: color, size: 28);
  }

  Widget _buildStatusChip(TaskStatus status) {
    final (text, color) = _getStatusInfo(status);
    return Chip(
      label: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildPriorityChip(int priority) {
    final (text, color) = _getPriorityInfo(priority);
    return Chip(
      label: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      visualDensity: VisualDensity.compact,
    );
  }

  (String, Color) _getStatusInfo(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return ('Pending', Colors.blue);
      case TaskStatus.inProgress:
        return ('In Progress', Colors.orange);
      case TaskStatus.completed:
        return ('Completed', Colors.green);
      case TaskStatus.archived:
        return ('Archived', Colors.grey);
    }
  }

  (String, Color) _getPriorityInfo(int priority) {
    switch (priority) {
      case 2:
        return ('High', Colors.red);
      case 1:
        return ('Medium', Colors.orange);
      case 0:
      default:
        return ('Low', Colors.green);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color _getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    
    if (dueDate.isBefore(now)) {
      return Colors.red; // Просрочено
    } else if (difference.inDays <= 1) {
      return Colors.orange; // Скоро истекает
    } else {
      return Colors.white.withOpacity(0.8); // Нормальное время
    }
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
        child: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 25),
      ),
      leading: widget.leading,
      title: widget.title,
      backgroundColor: Colors.black.withOpacity(0.2),
      collapsedBackgroundColor: Colors.transparent,
      onExpansionChanged: (expanded) {
        setState(() {
          _isExpanded = expanded;
        });
      },
      children: widget.children,
    );
  }
}