// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'column_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColumnModelAdapter extends TypeAdapter<ColumnModel> {
  @override
  final int typeId = 2;

  @override
  ColumnModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ColumnModel(
      id: fields[0] as int,
      title: fields[1] as String,
      order: fields[2] as int,
      tasks: (fields[3] as List).cast<TaskModel>(),
      createdAt: fields[4] as DateTime?,
      updatedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ColumnModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.order)
      ..writeByte(3)
      ..write(obj.tasks)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColumnModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ColumnModelImpl _$$ColumnModelImplFromJson(Map<String, dynamic> json) =>
    _$ColumnModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      order: (json['order'] as num).toInt(),
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ColumnModelImplToJson(_$ColumnModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'order': instance.order,
      'tasks': instance.tasks,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
