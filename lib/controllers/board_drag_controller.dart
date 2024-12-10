import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrum_assistant/features/board/models/task_model.dart';

class BoardDragController extends ChangeNotifier {
  TaskModel? _draggedTask;
  int? _sourceColumnIndex;

  TaskModel? get draggedTask => _draggedTask;
  int? get sourceColumnIndex => _sourceColumnIndex;

  void startDrag(TaskModel task, int columnIndex) {
    _draggedTask = task;
    _sourceColumnIndex = columnIndex;
    notifyListeners();
  }

  void updateDrag(TaskModel task, int columnIndex) {
    _draggedTask = task;
    _sourceColumnIndex = columnIndex;
    notifyListeners();
  }

  void endDrag() {
    _draggedTask = null;
    _sourceColumnIndex = null;
    notifyListeners();
  }
}

final boardDragControllerProvider = ChangeNotifierProvider<BoardDragController>((ref) {
  return BoardDragController();
});
