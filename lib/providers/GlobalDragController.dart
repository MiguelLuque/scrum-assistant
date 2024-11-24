import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';

class GlobalDragController extends StateNotifier<TaskModel?> {
  GlobalDragController() : super(null);

  void startDrag(TaskModel task) {
    print('Start dragging task: ${task.title}');
    state = task;
  }

  void endDrag() {
    print('End dragging');
    state = null;
  }
}

// Crea un provider para el controlador
final globalDragControllerProvider =
    StateNotifierProvider<GlobalDragController, TaskModel?>(
  (ref) => GlobalDragController(),
);
