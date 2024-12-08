import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrum_assistant/features/board/models/column_model.dart';
import 'package:scrum_assistant/features/board/models/task_model.dart';
import 'package:scrum_assistant/features/board/providers/board_provider.dart';

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
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildInsertTarget(ref, -1), // Target inicial
                  ...List.generate(column.tasks.length, (index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDraggableTask(column.tasks[index], ref),
                        _buildInsertTarget(ref, index),
                      ],
                    );
                  }),
                ],
              ),
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
        return TweenAnimationBuilder<double>(
          duration:
              const Duration(milliseconds: 150), // Duración de la animación
          tween: Tween(begin: 0.0, end: isActive ? 1.0 : 0.0),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Container(
              height: lerpDouble(
                  16, 100, value), // Interpolación suave de la altura
              margin: EdgeInsets.symmetric(
                vertical:
                    lerpDouble(4, 8, value)!, // Interpolación de los márgenes
              ),
              decoration: BoxDecoration(
                color: Color.lerp(
                  Colors.transparent,
                  AppTheme.primaryColor.withOpacity(0.2),
                  value,
                ),
                border: Border.all(
                  color: Color.lerp(
                    Colors.transparent,
                    AppTheme.primaryColor,
                    value,
                  )!,
                  width: lerpDouble(1, 3, value)!,
                ),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius_md),
              ),
              child: value > 0
                  ? Opacity(
                      opacity: value,
                      child: Center(
                        child: Icon(
                          Icons.add_circle,
                          size: lerpDouble(0, 28, value),
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    )
                  : null,
            );
          },
        );
      },
      onWillAccept: (task) {
        // Agregamos un pequeño delay antes de rechazar el drop
        return true;
      },
      onLeave: (task) {
        // Opcional: puedes agregar un pequeño delay aquí también
        Future.delayed(const Duration(milliseconds: 100), () {
          // Cualquier limpieza necesaria
        });
      },
      onAcceptWithDetails: (task) {
        final newIndex = index + 1;
        if (task.data.columnId == column.id) {
          final oldIndex = column.tasks.indexWhere((t) => t.id == task.data.id);
          if (oldIndex != -1) {
            ref.read(boardNotifierProvider.notifier).reorderTasks(
                  column.id,
                  oldIndex,
                  newIndex > oldIndex ? newIndex - 1 : newIndex,
                );
          }
        } else {
          ref.read(boardNotifierProvider.notifier).moveTaskToPosition(
                task.data.columnId,
                column.id,
                task.data,
                newIndex,
              );
        }
        onDragEnded?.call();
      },
    );
  }

  Widget _buildDraggableTask(TaskModel task, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Mayor separación
      child: LongPressDraggable<TaskModel>(
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
          child: TaskCard(task: task),
        ),
      ),
    );
  }
}
