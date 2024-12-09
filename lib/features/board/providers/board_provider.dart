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

  void moveTask(
      TaskModel task, int sourceColumnIndex, int destinationColumnIndex) {
    print(
        'Moving task ${task.title} from column $sourceColumnIndex to column $destinationColumnIndex');

    if (sourceColumnIndex == destinationColumnIndex) {
      return;
    }
    state = state.map((column) {
      if (column.id == state[sourceColumnIndex].id) {
        print('Removing task ${task.title} from column $sourceColumnIndex');
        return column.copyWith(
          tasks: column.tasks.where((t) => t.id != task.id).toList(),
        );
      }
      if (column.id == state[destinationColumnIndex].id) {
        print('Adding task ${task.title} to column $destinationColumnIndex');
        final updatedTask = task.copyWith(columnId: destinationColumnIndex);
        return column.copyWith(
          tasks: [...column.tasks, updatedTask],
        );
      }
      return column;
    }).toList();

    print('Task moved successfully.');
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
}
