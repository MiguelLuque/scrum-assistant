import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrum_assistant/providers/GlobalDragController.dart';
import 'package:scrum_assistant/providers/board_provider.dart';
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
    return DragTarget<TaskModel>(
      builder: (context, candidateData, rejectedData) {
        // Cambia el color del borde si hay datos entrantes
        final isActive = candidateData.isNotEmpty;
        return Container(
          width: AppTheme.columnWidth,
          margin: EdgeInsets.all(AppTheme.columnSpacing),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius_md),
            border: Border.all(
              color: isActive ? AppTheme.primaryColor : Colors.transparent,
              width: 2,
            ),
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
              Expanded(child: _buildTaskList(ref)),
              _buildDropTarget(
                  ref), // No cambies la lógica del drop target aquí
            ],
          ),
        );
      },
      onWillAcceptWithDetails: (task) {
        print(
            'Checking if task ${task.data.title} can be dropped into column ${column.id}');
        return task.data.columnId !=
            column.id; // Solo aceptar si viene de otra columna
      },
      onAcceptWithDetails: (task) {
        print('Task ${task.data.title} dropped into column ${column.id}');
        ref.read(boardNotifierProvider.notifier).moveTask(
              task.data.columnId,
              column.id,
              task.data,
            );
      },
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

  Widget _buildTaskList(WidgetRef ref) {
    return ReorderableListView.builder(
      padding: EdgeInsets.all(AppTheme.spacing_sm),
      itemCount: column.tasks.length,
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        ref.read(boardNotifierProvider.notifier).reorderTasks(
              column.id,
              oldIndex,
              newIndex,
            );
      },
      itemBuilder: (context, index) {
        final task = column.tasks[index];
        return KeyedSubtree(
          key: ValueKey(task.id),
          child: _buildDraggableTask(task, ref),
        );
      },
    );
  }

  Widget _buildDraggableTask(TaskModel task, WidgetRef ref) {
    return Draggable<TaskModel>(
      data: task,
      onDragStarted: () {
        ref.read(globalDragControllerProvider.notifier).startDrag(task);
        onDragStarted?.call();
      },
      onDragEnd: (_) {
        ref.read(globalDragControllerProvider.notifier).endDrag();
        onDragEnded?.call();
      },
      onDragUpdate: (details) {
        // Notifica la posición global del arrastre
        onDragUpdate?.call(details);
      },
      feedback: Material(
        elevation: AppTheme.elevation_md,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius_md),
        child: Container(
          width: AppTheme.columnWidth - (AppTheme.columnSpacing * 2),
          child: TaskCard(task: task),
        ),
      ),
      childWhenDragging: TaskCard(task: task),
      child: TaskCard(task: task),
    );
  }

  Widget _buildDropTarget(WidgetRef ref) {
    final draggedTask = ref.watch(globalDragControllerProvider);

    return DragTarget<TaskModel>(
      builder: (context, candidateData, rejectedData) {
        final isActive =
            draggedTask != null && draggedTask.columnId != column.id;

        return Container(
          height: 80,
          margin: EdgeInsets.all(AppTheme.spacing_sm),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.dragTargetColor
                : AppTheme.dragTargetColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppTheme.borderRadius_md),
            border: Border.all(
              color:
                  isActive ? AppTheme.primaryColor : AppTheme.dragTargetColor,
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.add_task,
              color: isActive
                  ? AppTheme.primaryColor
                  : AppTheme.primaryColor.withOpacity(0.5),
            ),
          ),
        );
      },
      onWillAcceptWithDetails: (_) {
        return draggedTask != null && draggedTask.columnId != column.id;
      },
      onAcceptWithDetails: (_) {
        if (draggedTask != null) {
          ref.read(boardNotifierProvider.notifier).moveTask(
                draggedTask.columnId,
                column.id,
                draggedTask,
              );
          ref.read(globalDragControllerProvider.notifier).endDrag();
        }
      },
    );
  }
}
