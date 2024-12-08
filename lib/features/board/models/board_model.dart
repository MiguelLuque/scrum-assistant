import 'package:freezed_annotation/freezed_annotation.dart';
import 'column_model.dart';

part 'board_model.freezed.dart';
part 'board_model.g.dart';

@freezed
class BoardModel with _$BoardModel {
  const factory BoardModel({
    required String id,
    required String title,
    required List<ColumnModel> columns,
    @Default(false) bool isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BoardModel;

  factory BoardModel.fromJson(Map<String, dynamic> json) =>
      _$BoardModelFromJson(json);
} 