import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scrum_assistant/features/changelog/providers/changelog_provider.dart';
import '../models/column_model.dart';
import '../models/task_model.dart';
import 'dart:convert';

part 'board_provider.g.dart';

@riverpod
class BoardNotifier extends _$BoardNotifier {
  @override
  List<ColumnModel> build() {
    return [
      ColumnModel(
        id: 1,
        title: 'To Do',
        tasks: [
          TaskModel(
            id: 1,
            title: 'task 1',
            description: 'Add user login and registration',
            columnId: 1,
          ),
          TaskModel(
            id: 2,
            title: 'task 2',
            description: 'Create wireframes for main dashboard',
            columnId: 1,
          ),
        ],
        order: 1,
      ),
      const ColumnModel(
        id: 2,
        title: 'In Progress',
        tasks: [
          TaskModel(
            id: 3,
            title: 'task 3',
            description: 'Configure GitHub Actions workflow',
            columnId: 2,
          ),
        ],
        order: 2,
      ),
      const ColumnModel(
        id: 3,
        title: 'Done',
        tasks: [
          TaskModel(
            id: 4,
            title: 'task 4',
            description: 'Initialize Flutter project with dependencies',
            columnId: 3,
          ),
        ],
        order: 3,
      ),
    ];
  }

  void moveTask(TaskModel task, int sourceColumnId, int destinationColumnId) {
    print(
        'Moving task ${task.title} from column $sourceColumnId to column $destinationColumnId');

    if (sourceColumnId == destinationColumnId) {
      return;
    }
    state = state.map((column) {
      if (column.id == sourceColumnId) {
        print('Removing task ${task.title} from column $sourceColumnId');
        return column.copyWith(
          tasks: column.tasks.where((t) => t.id != task.id).toList(),
        );
      }
      if (column.id == destinationColumnId) {
        print('Adding task ${task.title} to column $destinationColumnId');
        final updatedTask = task.copyWith(columnId: destinationColumnId);
        return column.copyWith(
          tasks: [...column.tasks, updatedTask],
        );
      }
      return column;
    }).toList();

    print('Task moved successfully.');

    ref.read(changelogNotifierProvider.notifier).addEntry(
      'moveTask',
      {
        'taskId': task.id,
        'sourceColumnId': sourceColumnId,
        'destinationColumnId': destinationColumnId,
      },
    );
  }

  void addTask(int columnId, String title, String? description) {
    print('Adding task $title to column $columnId');
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toInt(),
      title: title,
      description: description,
      columnId: columnId,
    );

    state = state.map((column) {
      if (column.id == columnId) {
        return column.copyWith(
          tasks: [...column.tasks, newTask],
        );
      }
      return column;
    }).toList();

    print('Task $title added successfully.');

    ref.read(changelogNotifierProvider.notifier).addEntry(
      'addTask',
      {
        'columnId': columnId,
        'title': title,
        'description': description,
      },
    );
  }

  void deleteTask(String columnId, String taskId) {
    print('Deleting task $taskId from column $columnId');
    state = state.map((column) {
      if (column.id == columnId) {
        return column.copyWith(
          tasks: column.tasks.where((task) => task.id != taskId).toList(),
        );
      }
      return column;
    }).toList();

    print('Task $taskId deleted successfully.');

    ref.read(changelogNotifierProvider.notifier).addEntry(
      'deleteTask',
      {
        'columnId': columnId,
        'taskId': taskId,
      },
    );
  }

  void reorderTasks(int columnId, int oldIndex, int newIndex) {
    state = state.map((column) {
      if (column.id == columnId) {
        final tasks = List<TaskModel>.from(column.tasks);

        if (oldIndex < 0 ||
            oldIndex >= tasks.length ||
            newIndex < 0 ||
            newIndex >= tasks.length) {
          print('Invalid reorder indices: $oldIndex -> $newIndex');
          return column;
        }

        final task = tasks.removeAt(oldIndex);
        tasks.insert(newIndex, task);

        print('Reordered task in column $columnId: $oldIndex -> $newIndex');
        return column.copyWith(tasks: tasks);
      }
      return column;
    }).toList();
  }

  void moveTaskToPosition(
    String fromColumnId,
    int toColumnId,
    TaskModel task,
    int newIndex,
  ) {
    state = state.map((column) {
      if (column.id == fromColumnId) {
        return column.copyWith(
          tasks: column.tasks.where((t) => t.id != task.id).toList(),
        );
      }
      if (column.id == toColumnId) {
        final updatedTask = task.copyWith(columnId: toColumnId);
        final newTasks = List<TaskModel>.from(column.tasks);
        newTasks.insert(newIndex, updatedTask);
        return column.copyWith(tasks: newTasks);
      }
      return column;
    }).toList();
  }

  String getBoardAsJson() {
    return jsonEncode(state.map((column) => column.toJson()).toList());
  }

  void moveTaskToColumn(
      int taskId, int sourceColumnId, int destinationColumnId) {
    final task = state
        .firstWhere((column) => column.id == sourceColumnId)
        .tasks
        .firstWhere((task) => task.id == taskId);

    moveTask(task, sourceColumnId, destinationColumnId);
  }
}
