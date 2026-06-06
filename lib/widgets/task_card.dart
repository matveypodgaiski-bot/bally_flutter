import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isEditMode;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool doneToday;
  final bool showDeleteButton;
  final bool isDragging;

  const TaskCard({
    super.key,
    required this.task,
    required this.isEditMode,
    required this.onTap,
    required this.onDelete,
    this.doneToday = false,
    this.showDeleteButton = false,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isEditMode) {
      // В режиме редактирования - просто карточка с кнопкой удаления
      return Card(
        key: ValueKey(task.id),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
        color: doneToday ? const Color(0xFFEF9A9A) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  task.name,
                  style: TextStyle(
                    fontSize: 24,
                    color: doneToday
                        ? const Color(0xFFC62828)
                        : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (showDeleteButton)
                IconButton(
                  icon: const Icon(Icons.delete, color: Color(0xFFD32F2F)),
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      );
    } else {
      // В обычном режиме - InkWell для клика
      return Card(
        key: ValueKey(task.id),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
        color: doneToday ? const Color(0xFFEF9A9A) : Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    task.name,
                    style: TextStyle(
                      fontSize: 24,
                      color: doneToday
                          ? const Color(0xFFC62828)
                          : const Color(0xFF43A047),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  doneToday ? 'Отменить' : '+${task.points}',
                  style: TextStyle(
                    fontSize: 22,
                    color: doneToday
                        ? const Color(0xFFC62828)
                        : const Color(0xFF389E13),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
