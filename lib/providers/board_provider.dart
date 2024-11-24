import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/column_model.dart';
import '../models/task_model.dart';

part 'board_provider.g.dart';

@riverpod
class BoardNotifier extends _$BoardNotifier {
  @override
  List<ColumnModel> build() {
    return [
      ColumnModel(
        id: '1',
        title: 'To Do',
        tasks: [
          TaskModel(
            id: '1',
            title: 'Implement Authentication',
            description: 'Add user login and registration',
            columnId: '1',
          ),
          TaskModel(
            id: '2',
            title: 'Design Dashboard',
            description: 'Create wireframes for main dashboard',
            columnId: '1',
          ),
        ],
      ),
      const ColumnModel(
        id: '2',
        title: 'In Progress',
        tasks: [
          TaskModel(
            id: '3',
            title: 'Setup CI/CD',
            description: 'Configure GitHub Actions workflow',
            columnId: '2',
          ),
        ],
      ),
      const ColumnModel(
        id: '3',
        title: 'Done',
        tasks: [
          TaskModel(
            id: '4',
            title: 'Project Setup',
            description: 'Initialize Flutter project with dependencies',
            columnId: '3',
          ),
        ],
      ),
    ];
  }

  void moveTask(String fromColumnId, String toColumnId, TaskModel task) {
    print(
        'Moving task ${task.title} from column $fromColumnId to column $toColumnId');

    state = state.map((column) {
      if (column.id == fromColumnId) {
        print('Removing task ${task.title} from column $fromColumnId');
        return column.copyWith(
          tasks: column.tasks.where((t) => t.id != task.id).toList(),
        );
      }
      if (column.id == toColumnId) {
        print('Adding task ${task.title} to column $toColumnId');
        final updatedTask = task.copyWith(columnId: toColumnId);
        return column.copyWith(
          tasks: [...column.tasks, updatedTask],
        );
      }
      return column;
    }).toList();

    print('Task moved successfully.');
  }

  void addTask(String columnId, String title, String? description) {
    print('Adding task $title to column $columnId');
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
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
  }

  void reorderTasks(String columnId, int oldIndex, int newIndex) {
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
    String toColumnId,
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
}
