import '../models/board_model.dart';
import '../models/column_model.dart';
import '../models/task_model.dart';

class BoardRepository {
  final List<BoardModel> _boards = [];

  Future<List<BoardModel>> getBoards() async => _boards;

  Future<BoardModel> createBoard(String title) async {
    final board = BoardModel(
      id: DateTime.now().toString(),
      title: title,
      columns: [],
    );
    _boards.add(board);
    return board;
  }

  Future<ColumnModel> createColumn(String boardId, String title, int order) async {
    return ColumnModel(
      id: DateTime.now().toString(),
      title: title,
      order: order,
    );
  }

  Future<TaskModel> createTask(TaskModel task) async {
    return task.copyWith(id: DateTime.now().toString());
  }

  Future<void> updateTaskColumn(String taskId, String columnId) async {}

  Future<void> deleteTask(String taskId) async {}
}
