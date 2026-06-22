import 'package:flutter/material.dart';
import '../models/task.dart';
import '../theme/tide_colors.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) => AnimatedScale(
        scale: task.isDone ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 250),
        child: GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? TideColors.darkCard
                  : TideColors.lightCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TideColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: TideColors.primary,
                      width: 2,
                    ),
                    color: task.isDone
                        ? const Color(0xFF22C55E)
                        : Colors.transparent,
                    boxShadow: task.isDone
                        ? [
                            BoxShadow(
                              color: const Color(0xFF22C55E)
                                  .withValues(alpha: 0.4),
                              blurRadius: 12,
                            ),
                          ]
                        : [],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: task.isDone
                        ? const Icon(
                            Icons.check,
                            key: ValueKey('done'),
                            size: 16,
                            color: Colors.white,
                          )
                        : const SizedBox(
                            key: ValueKey('empty'),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          color: task.isDone
                              ? (Theme.of(context).brightness == Brightness.dark
                                  ? TideColors.darkMuted
                                  : TideColors.lightMuted)
                              : (Theme.of(context).brightness == Brightness.dark
                                  ? TideColors.darkInk
                                  : TideColors.lightInk),
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      if (task.dueDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '📅 ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: task.dueDate!.isBefore(DateTime.now())
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: TideColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        task.category,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: task.priorityColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
}
