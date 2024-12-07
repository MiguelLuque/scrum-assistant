import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scrum_assistant/models/column_model.dart';

part 'board_model.freezed.dart';
part 'board_model.g.dart';

@freezed
class BoardModel with _$BoardModel {
  factory BoardModel({
    required String id,
    required String name,
    required List<ColumnModel> columns,
  }) = _BoardModel;

  factory BoardModel.fromJson(Map<String, dynamic> json) =>
      _$BoardModelFromJson(json);
}
