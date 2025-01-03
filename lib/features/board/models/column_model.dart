import 'package:freezed_annotation/freezed_annotation.dart';
import 'task_model.dart';

part 'column_model.freezed.dart';
part 'column_model.g.dart';

@freezed
class ColumnModel with _$ColumnModel {
  const factory ColumnModel({
    required int id,
    required String title,
    required int order,
    @Default([]) List<TaskModel> tasks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ColumnModel;

  factory ColumnModel.fromJson(Map<String, dynamic> json) =>
      _$ColumnModelFromJson(json);
}
