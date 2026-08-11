import 'package:flutter/material.dart';
import 'package:wallet/pages/taskes/model/task_enums.dart';

class TaskPriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool compact;

  const TaskPriorityBadge({super.key, required this.priority, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final color = priority.color;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(priority.icon, size: compact ? 10 : 12, color: color),
          const SizedBox(width: 4),
          Text(
            priority.label,
            style: TextStyle(
              fontSize: compact ? 10 : 11,
              color: color,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo-Bold',
            ),
          ),
        ],
      ),
    );
  }
}
