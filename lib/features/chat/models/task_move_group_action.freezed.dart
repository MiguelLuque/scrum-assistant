// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_move_group_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskMoveGroupAction _$TaskMoveGroupActionFromJson(Map<String, dynamic> json) {
  return _TaskMoveGroupAction.fromJson(json);
}

/// @nodoc
mixin _$TaskMoveGroupAction {
  List<int> get taskIds => throw _privateConstructorUsedError;
  int get destinationColumnId => throw _privateConstructorUsedError;

  /// Serializes this TaskMoveGroupAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskMoveGroupAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskMoveGroupActionCopyWith<TaskMoveGroupAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskMoveGroupActionCopyWith<$Res> {
  factory $TaskMoveGroupActionCopyWith(
          TaskMoveGroupAction value, $Res Function(TaskMoveGroupAction) then) =
      _$TaskMoveGroupActionCopyWithImpl<$Res, TaskMoveGroupAction>;
  @useResult
  $Res call({List<int> taskIds, int destinationColumnId});
}

/// @nodoc
class _$TaskMoveGroupActionCopyWithImpl<$Res, $Val extends TaskMoveGroupAction>
    implements $TaskMoveGroupActionCopyWith<$Res> {
  _$TaskMoveGroupActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskMoveGroupAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskIds = null,
    Object? destinationColumnId = null,
  }) {
    return _then(_value.copyWith(
      taskIds: null == taskIds
          ? _value.taskIds
          : taskIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      destinationColumnId: null == destinationColumnId
          ? _value.destinationColumnId
          : destinationColumnId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskMoveGroupActionImplCopyWith<$Res>
    implements $TaskMoveGroupActionCopyWith<$Res> {
  factory _$$TaskMoveGroupActionImplCopyWith(_$TaskMoveGroupActionImpl value,
          $Res Function(_$TaskMoveGroupActionImpl) then) =
      __$$TaskMoveGroupActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<int> taskIds, int destinationColumnId});
}

/// @nodoc
class __$$TaskMoveGroupActionImplCopyWithImpl<$Res>
    extends _$TaskMoveGroupActionCopyWithImpl<$Res, _$TaskMoveGroupActionImpl>
    implements _$$TaskMoveGroupActionImplCopyWith<$Res> {
  __$$TaskMoveGroupActionImplCopyWithImpl(_$TaskMoveGroupActionImpl _value,
      $Res Function(_$TaskMoveGroupActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskMoveGroupAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskIds = null,
    Object? destinationColumnId = null,
  }) {
    return _then(_$TaskMoveGroupActionImpl(
      taskIds: null == taskIds
          ? _value._taskIds
          : taskIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      destinationColumnId: null == destinationColumnId
          ? _value.destinationColumnId
          : destinationColumnId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskMoveGroupActionImpl implements _TaskMoveGroupAction {
  const _$TaskMoveGroupActionImpl(
      {required final List<int> taskIds, required this.destinationColumnId})
      : _taskIds = taskIds;

  factory _$TaskMoveGroupActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskMoveGroupActionImplFromJson(json);

  final List<int> _taskIds;
  @override
  List<int> get taskIds {
    if (_taskIds is EqualUnmodifiableListView) return _taskIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taskIds);
  }

  @override
  final int destinationColumnId;

  @override
  String toString() {
    return 'TaskMoveGroupAction(taskIds: $taskIds, destinationColumnId: $destinationColumnId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskMoveGroupActionImpl &&
            const DeepCollectionEquality().equals(other._taskIds, _taskIds) &&
            (identical(other.destinationColumnId, destinationColumnId) ||
                other.destinationColumnId == destinationColumnId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_taskIds), destinationColumnId);

  /// Create a copy of TaskMoveGroupAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskMoveGroupActionImplCopyWith<_$TaskMoveGroupActionImpl> get copyWith =>
      __$$TaskMoveGroupActionImplCopyWithImpl<_$TaskMoveGroupActionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskMoveGroupActionImplToJson(
      this,
    );
  }
}

abstract class _TaskMoveGroupAction implements TaskMoveGroupAction {
  const factory _TaskMoveGroupAction(
      {required final List<int> taskIds,
      required final int destinationColumnId}) = _$TaskMoveGroupActionImpl;

  factory _TaskMoveGroupAction.fromJson(Map<String, dynamic> json) =
      _$TaskMoveGroupActionImpl.fromJson;

  @override
  List<int> get taskIds;
  @override
  int get destinationColumnId;

  /// Create a copy of TaskMoveGroupAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskMoveGroupActionImplCopyWith<_$TaskMoveGroupActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
