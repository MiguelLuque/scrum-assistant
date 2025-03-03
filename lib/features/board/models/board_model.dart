import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'column_model.dart';

part 'board_model.freezed.dart';
part 'board_model.g.dart';

@freezed
@HiveType(typeId: 3)
class BoardModel with _$BoardModel {
  const factory BoardModel({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required List<ColumnModel> columns,
    @HiveField(3) @Default(false) bool isArchived,
    @HiveField(4) DateTime? createdAt,
    @HiveField(5) DateTime? updatedAt,
  }) = _BoardModel;

  factory BoardModel.fromJson(Map<String, dynamic> json) =>
      _$BoardModelFromJson(json);
}
