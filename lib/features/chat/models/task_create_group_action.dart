import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scrum_assistant/features/board/models/task_model.dart';

part 'task_create_group_action.freezed.dart';
part 'task_create_group_action.g.dart';

@freezed
class TaskCreateGroupAction with _$TaskCreateGroupAction {
  const factory TaskCreateGroupAction({
    required List<TaskModel> tasks,
  }) = _TaskCreateGroupAction;

  factory TaskCreateGroupAction.fromJson(Map<String, dynamic> json) =>
      _$TaskCreateGroupActionFromJson(json);
}
