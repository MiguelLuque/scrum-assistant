import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrum_assistant/controllers/board_drag_controller.dart';
import 'package:scrum_assistant/features/board/models/column_model.dart';
import 'package:scrum_assistant/features/board/models/task_model.dart';
import 'package:scrum_assistant/features/board/providers/board_provider.dart';
import 'package:scrum_assistant/features/board/screens/add_task_screen.dart';
import 'package:scrum_assistant/theme/app_theme.dart';
import 'task_card.dart';
import 'add_task_dialog.dart';

class KanbanColumnWidget extends ConsumerWidget {
  final ColumnModel column;

  const KanbanColumnWidget({
    super.key,
    required this.column,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columns = ref.watch(boardNotifierProvider);
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
          _buildHeader(context),
          Expanded(
            child: ReorderableListView.builder(
              padding: EdgeInsets.all(AppTheme.spacing_md),
              itemCount: column.tasks.length,
              onReorder: (oldIndex, newIndex) {
                ref.read(boardNotifierProvider.notifier).reorderTasks(
                      column.id,
                      oldIndex,
                      newIndex,
                    );
              },
              itemBuilder: (context, index) {
                final task = column.tasks[index];
                return ReorderableDragStartListener(
                  key: ValueKey(task.id),
                  index: index,
                  child: LongPressDraggable<TaskModel>(
                    data: task,
                    delay: const Duration(milliseconds: 300),
                    feedback: SizedBox(
                      width: AppTheme.columnWidth - (AppTheme.spacing_md * 2),
                      child: Material(
                        child: TaskCard(task: task),
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.5,
                      child: TaskCard(task: task),
                    ),
                    onDragStarted: () {
                      ref.read(boardDragControllerProvider).startDrag(
                            task,
                            columns.indexOf(column),
                          );
                    },
                    onDragEnd: (details) {
                      ref.read(boardDragControllerProvider).endDrag();
                    },
                    child: TaskCard(task: task),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppTheme.spacing_md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            column.title,
            style: AppTheme.columnHeaderStyle,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskScreen(columnId: column.id),
                    ),
                  );
                },
                tooltip: 'Add Task',
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
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
