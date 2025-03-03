import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'task_model.dart';

part 'column_model.freezed.dart';
part 'column_model.g.dart';

@freezed
@HiveType(typeId: 2)
class ColumnModel with _$ColumnModel {
  const factory ColumnModel({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) required int order,
    @HiveField(3) @Default([]) List<TaskModel> tasks,
    @HiveField(4) DateTime? createdAt,
    @HiveField(5) DateTime? updatedAt,
  }) = _ColumnModel;

  factory ColumnModel.fromJson(Map<String, dynamic> json) =>
      _$ColumnModelFromJson(json);
}
