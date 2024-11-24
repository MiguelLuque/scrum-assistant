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
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<TaskModel> get tasks => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ColumnModelCopyWith<ColumnModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ColumnModelCopyWith<$Res> {
  factory $ColumnModelCopyWith(
          ColumnModel value, $Res Function(ColumnModel) then) =
      _$ColumnModelCopyWithImpl<$Res, ColumnModel>;
  @useResult
  $Res call({String id, String title, List<TaskModel> tasks});
}

/// @nodoc
class _$ColumnModelCopyWithImpl<$Res, $Val extends ColumnModel>
    implements $ColumnModelCopyWith<$Res> {
  _$ColumnModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? tasks = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<TaskModel>,
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
  $Res call({String id, String title, List<TaskModel> tasks});
}

/// @nodoc
class __$$ColumnModelImplCopyWithImpl<$Res>
    extends _$ColumnModelCopyWithImpl<$Res, _$ColumnModelImpl>
    implements _$$ColumnModelImplCopyWith<$Res> {
  __$$ColumnModelImplCopyWithImpl(
      _$ColumnModelImpl _value, $Res Function(_$ColumnModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? tasks = null,
  }) {
    return _then(_$ColumnModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      tasks: null == tasks
          ? _value._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<TaskModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ColumnModelImpl implements _ColumnModel {
  const _$ColumnModelImpl(
      {required this.id,
      required this.title,
      final List<TaskModel> tasks = const []})
      : _tasks = tasks;

  factory _$ColumnModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ColumnModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  final List<TaskModel> _tasks;
  @override
  @JsonKey()
  List<TaskModel> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  @override
  String toString() {
    return 'ColumnModel(id: $id, title: $title, tasks: $tasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ColumnModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._tasks, _tasks));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, const DeepCollectionEquality().hash(_tasks));

  @JsonKey(ignore: true)
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
      {required final String id,
      required final String title,
      final List<TaskModel> tasks}) = _$ColumnModelImpl;

  factory _ColumnModel.fromJson(Map<String, dynamic> json) =
      _$ColumnModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  List<TaskModel> get tasks;
  @override
  @JsonKey(ignore: true)
  _$$ColumnModelImplCopyWith<_$ColumnModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
