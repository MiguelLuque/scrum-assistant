import 'package:flutter/material.dart';
import 'package:scrum_assistant/features/board/models/task_model.dart';
import '../theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(AppTheme.cardSpacing),
      decoration: AppTheme.taskCardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Implement task details view
            print('Task tapped');
          },
          borderRadius: BorderRadius.circular(AppTheme.borderRadius_md),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing_md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme),
                if (task.description != null) ...[
                  const SizedBox(height: AppTheme.spacing_sm),
                  _buildDescription(theme),
                ],
                if (task.labels.isNotEmpty) ...[
                  const SizedBox(height: AppTheme.spacing_sm),
                  _buildLabels(theme),
                ],
                const SizedBox(height: AppTheme.spacing_md),
                _buildFooter(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            task.title,
            style: theme.textTheme.titleMedium?.copyWith(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted
                  ? theme.textTheme.titleMedium?.color?.withOpacity(0.7)
                  : null,
            ),
          ),
        ),
        if (task.isCompleted)
          Icon(
            Icons.check_circle,
            color: theme.colorScheme.primary,
            size: 20,
          ),
      ],
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      task.description!,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildLabels(ThemeData theme) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: task.labels.map((label) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Row(
      children: [
        if (task.dueDate != null) ...[
          Icon(
            Icons.calendar_today_outlined,
            size: 16,
            color: _getDueDateColor(theme, task.dueDate!),
          ),
          const SizedBox(width: 4),
          Text(
            _formatDueDate(task.dueDate!),
            style: theme.textTheme.bodySmall?.copyWith(
              color: _getDueDateColor(theme, task.dueDate!),
            ),
          ),
        ],
        const Spacer(),
        _buildAssigneeAvatar(theme),
      ],
    );
  }

  Widget _buildAssigneeAvatar(ThemeData theme) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: theme.colorScheme.primary,
      child: Icon(
        Icons.person,
        size: 16,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }

  Color _getDueDateColor(ThemeData theme, DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.inDays < 0) {
      return theme.colorScheme.error;
    } else if (difference.inDays == 0) {
      return theme.colorScheme.tertiary;
    } else if (difference.inDays <= 2) {
      return theme.colorScheme.secondary;
    } else {
      return theme.colorScheme.onSurfaceVariant;
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays == -1) {
      return 'Yesterday';
    } else if (difference.inDays > 0 && difference.inDays < 7) {
      return '${difference.inDays} days';
    } else if (difference.inDays < 0 && difference.inDays > -7) {
      return '${-difference.inDays} days ago';
    } else {
      return '${dueDate.day}/${dueDate.month}/${dueDate.year}';
    }
  }
}
