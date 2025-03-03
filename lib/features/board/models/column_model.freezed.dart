// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'column_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ColumnModel _$ColumnModelFromJson(Map<String, dynamic> json) {
  return _ColumnModel.fromJson(json);
}

/// @nodoc
mixin _$ColumnModel {
  @HiveField(0)
  int get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(2)
  int get order => throw _privateConstructorUsedError;
  @HiveField(3)
  List<TaskModel> get tasks => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ColumnModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ColumnModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ColumnModelCopyWith<ColumnModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ColumnModelCopyWith<$Res> {
  factory $ColumnModelCopyWith(
          ColumnModel value, $Res Function(ColumnModel) then) =
      _$ColumnModelCopyWithImpl<$Res, ColumnModel>;
  @useResult
  $Res call(
      {@HiveField(0) int id,
      @HiveField(1) String title,
      @HiveField(2) int order,
      @HiveField(3) List<TaskModel> tasks,
      @HiveField(4) DateTime? createdAt,
      @HiveField(5) DateTime? updatedAt});
}

/// @nodoc
class _$ColumnModelCopyWithImpl<$Res, $Val extends ColumnModel>
    implements $ColumnModelCopyWith<$Res> {
  _$ColumnModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ColumnModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? order = null,
    Object? tasks = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<TaskModel>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ColumnModelImplCopyWith<$Res>
    implements $ColumnModelCopyWith<$Res> {
  factory _$$ColumnModelImplCopyWith(
          _$ColumnModelImpl value, $Res Function(_$ColumnModelImpl) then) =
      __$$ColumnModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int id,
      @HiveField(1) String title,
      @HiveField(2) int order,
      @HiveField(3) List<TaskModel> tasks,
      @HiveField(4) DateTime? createdAt,
      @HiveField(5) DateTime? updatedAt});
}

/// @nodoc
class __$$ColumnModelImplCopyWithImpl<$Res>
    extends _$ColumnModelCopyWithImpl<$Res, _$ColumnModelImpl>
    implements _$$ColumnModelImplCopyWith<$Res> {
  __$$ColumnModelImplCopyWithImpl(
      _$ColumnModelImpl _value, $Res Function(_$ColumnModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ColumnModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? order = null,
    Object? tasks = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ColumnModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      tasks: null == tasks
          ? _value._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<TaskModel>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ColumnModelImpl implements _ColumnModel {
  const _$ColumnModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(2) required this.order,
      @HiveField(3) final List<TaskModel> tasks = const [],
      @HiveField(4) this.createdAt,
      @HiveField(5) this.updatedAt})
      : _tasks = tasks;

  factory _$ColumnModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ColumnModelImplFromJson(json);

  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final int order;
  final List<TaskModel> _tasks;
  @override
  @JsonKey()
  @HiveField(3)
  List<TaskModel> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  @override
  @HiveField(4)
  final DateTime? createdAt;
  @override
  @HiveField(5)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ColumnModel(id: $id, title: $title, order: $order, tasks: $tasks, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ColumnModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.order, order) || other.order == order) &&
            const DeepCollectionEquality().equals(other._tasks, _tasks) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, order,
      const DeepCollectionEquality().hash(_tasks), createdAt, updatedAt);

  /// Create a copy of ColumnModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ColumnModelImplCopyWith<_$ColumnModelImpl> get copyWith =>
      __$$ColumnModelImplCopyWithImpl<_$ColumnModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ColumnModelImplToJson(
      this,
    );
  }
}

abstract class _ColumnModel implements ColumnModel {
  const factory _ColumnModel(
      {@HiveField(0) required final int id,
      @HiveField(1) required final String title,
      @HiveField(2) required final int order,
      @HiveField(3) final List<TaskModel> tasks,
      @HiveField(4) final DateTime? createdAt,
      @HiveField(5) final DateTime? updatedAt}) = _$ColumnModelImpl;

  factory _ColumnModel.fromJson(Map<String, dynamic> json) =
      _$ColumnModelImpl.fromJson;

  @override
  @HiveField(0)
  int get id;
  @override
  @HiveField(1)
  String get title;
  @override
  @HiveField(2)
  int get order;
  @override
  @HiveField(3)
  List<TaskModel> get tasks;
  @override
  @HiveField(4)
  DateTime? get createdAt;
  @override
  @HiveField(5)
  DateTime? get updatedAt;

  /// Create a copy of ColumnModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ColumnModelImplCopyWith<_$ColumnModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
