import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
@HiveType(typeId: 1)
class TaskModel with _$TaskModel {
  const factory TaskModel({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) String? description,
    @HiveField(3) DateTime? dueDate,
    @HiveField(4) @Default([]) List<String> labels,
    @HiveField(5) required int columnId,
    @HiveField(6) @Default(false) bool isCompleted,
    @HiveField(7) DateTime? createdAt,
    @HiveField(8) DateTime? updatedAt,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
}
