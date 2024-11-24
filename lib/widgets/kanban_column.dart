import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/board_provider.dart';
import '../models/column_model.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import 'task_card.dart';

class KanbanColumnWidget extends HookConsumerWidget {
  final ColumnModel column;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragEnded;
  final void Function(DragUpdateDetails)? onDragUpdate;

  const KanbanColumnWidget({
    super.key,
    required this.column,
    this.onDragStarted,
    this.onDragEnded,
    this.onDragUpdate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: AppTheme.columnWidth,
      margin: EdgeInsets.all(AppTheme.columnSpacing),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius_md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          _buildInsertTarget(ref, -1), // Target inicial
                          ...List.generate(column.tasks.length, (index) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildDraggableTask(column.tasks[index]),
                                _buildInsertTarget(ref, index),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(AppTheme.spacing_md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            column.title,
            style: AppTheme.columnHeaderStyle,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${column.tasks.length}',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsertTarget(WidgetRef ref, int index) {
    return DragTarget<TaskModel>(
      builder: (context, candidateData, rejectedData) {
        final isActive = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: isActive ? 80 : 8,
          margin: EdgeInsets.symmetric(
            vertical: isActive ? 8.0 : 2.0,
            horizontal: isActive ? 8.0 : 0.0,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.primaryColor.withOpacity(0.1)
                : Colors.transparent,
            border: Border.all(
              color: isActive ? AppTheme.primaryColor : Colors.transparent,
              width: 2,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.circular(AppTheme.borderRadius_md),
          ),
          child: isActive
              ? SizedBox.expand(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: 24,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Drop here',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : null,
        );
      },
      onWillAccept: (task) => true,
      onAccept: (task) {
        final newIndex = index + 1;
        if (task.columnId == column.id) {
          final oldIndex = column.tasks.indexWhere((t) => t.id == task.id);
          if (oldIndex != -1) {
            ref.read(boardNotifierProvider.notifier).reorderTasks(
                  column.id,
                  oldIndex,
                  newIndex > oldIndex ? newIndex - 1 : newIndex,
                );
          }
        } else {
          ref.read(boardNotifierProvider.notifier).moveTaskToPosition(
                task.columnId,
                column.id,
                task,
                newIndex,
              );
        }
        onDragEnded?.call();
      },
    );
  }

  Widget _buildDraggableTask(TaskModel task) {
    return LongPressDraggable<TaskModel>(
      data: task,
      delay: const Duration(milliseconds: 300),
      hapticFeedbackOnStart: true,
      onDragStarted: onDragStarted,
      onDragEnd: (_) => onDragEnded?.call(),
      onDragCompleted: onDragEnded,
      onDraggableCanceled: (_, __) => onDragEnded?.call(),
      onDragUpdate: onDragUpdate,
      feedback: Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius_md),
        child: SizedBox(
          width: AppTheme.columnWidth - (AppTheme.columnSpacing * 2),
          child: TaskCard(task: task),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: TaskCard(task: task),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: TaskCard(task: task),
        ),
      ),
    );
  }
}
