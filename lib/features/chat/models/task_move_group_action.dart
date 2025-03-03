import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_move_group_action.freezed.dart';
part 'task_move_group_action.g.dart';

@freezed
class TaskMoveGroupAction with _$TaskMoveGroupAction {
  const factory TaskMoveGroupAction({
    required List<int> taskIds,
    required int destinationColumnId,
  }) = _TaskMoveGroupAction;

  factory TaskMoveGroupAction.fromJson(Map<String, dynamic> json) =>
      _$TaskMoveGroupActionFromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'taskIds': taskIds,
      'destinationColumnId': destinationColumnId,
    };
  }
}
