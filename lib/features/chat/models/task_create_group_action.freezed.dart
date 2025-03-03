// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_create_group_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskCreateGroupAction _$TaskCreateGroupActionFromJson(
    Map<String, dynamic> json) {
  return _TaskCreateGroupAction.fromJson(json);
}

/// @nodoc
mixin _$TaskCreateGroupAction {
  List<TaskModel> get tasks => throw _privateConstructorUsedError;

  /// Serializes this TaskCreateGroupAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskCreateGroupAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCreateGroupActionCopyWith<TaskCreateGroupAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCreateGroupActionCopyWith<$Res> {
  factory $TaskCreateGroupActionCopyWith(TaskCreateGroupAction value,
          $Res Function(TaskCreateGroupAction) then) =
      _$TaskCreateGroupActionCopyWithImpl<$Res, TaskCreateGroupAction>;
  @useResult
  $Res call({List<TaskModel> tasks});
}

/// @nodoc
class _$TaskCreateGroupActionCopyWithImpl<$Res,
        $Val extends TaskCreateGroupAction>
    implements $TaskCreateGroupActionCopyWith<$Res> {
  _$TaskCreateGroupActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskCreateGroupAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tasks = null,
  }) {
    return _then(_value.copyWith(
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<TaskModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskCreateGroupActionImplCopyWith<$Res>
    implements $TaskCreateGroupActionCopyWith<$Res> {
  factory _$$TaskCreateGroupActionImplCopyWith(
          _$TaskCreateGroupActionImpl value,
          $Res Function(_$TaskCreateGroupActionImpl) then) =
      __$$TaskCreateGroupActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TaskModel> tasks});
}

/// @nodoc
class __$$TaskCreateGroupActionImplCopyWithImpl<$Res>
    extends _$TaskCreateGroupActionCopyWithImpl<$Res,
        _$TaskCreateGroupActionImpl>
    implements _$$TaskCreateGroupActionImplCopyWith<$Res> {
  __$$TaskCreateGroupActionImplCopyWithImpl(_$TaskCreateGroupActionImpl _value,
      $Res Function(_$TaskCreateGroupActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskCreateGroupAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tasks = null,
  }) {
    return _then(_$TaskCreateGroupActionImpl(
      tasks: null == tasks
          ? _value._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<TaskModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskCreateGroupActionImpl implements _TaskCreateGroupAction {
  const _$TaskCreateGroupActionImpl({required final List<TaskModel> tasks})
      : _tasks = tasks;

  factory _$TaskCreateGroupActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskCreateGroupActionImplFromJson(json);

  final List<TaskModel> _tasks;
  @override
  List<TaskModel> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  @override
  String toString() {
    return 'TaskCreateGroupAction(tasks: $tasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskCreateGroupActionImpl &&
            const DeepCollectionEquality().equals(other._tasks, _tasks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_tasks));

  /// Create a copy of TaskCreateGroupAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskCreateGroupActionImplCopyWith<_$TaskCreateGroupActionImpl>
      get copyWith => __$$TaskCreateGroupActionImplCopyWithImpl<
          _$TaskCreateGroupActionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskCreateGroupActionImplToJson(
      this,
    );
  }
}

abstract class _TaskCreateGroupAction implements TaskCreateGroupAction {
  const factory _TaskCreateGroupAction({required final List<TaskModel> tasks}) =
      _$TaskCreateGroupActionImpl;

  factory _TaskCreateGroupAction.fromJson(Map<String, dynamic> json) =
      _$TaskCreateGroupActionImpl.fromJson;

  @override
  List<TaskModel> get tasks;

  /// Create a copy of TaskCreateGroupAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskCreateGroupActionImplCopyWith<_$TaskCreateGroupActionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
