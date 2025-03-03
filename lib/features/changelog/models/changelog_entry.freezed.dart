// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'changelog_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChangelogEntry _$ChangelogEntryFromJson(Map<String, dynamic> json) {
  return _ChangelogEntry.fromJson(json);
}

/// @nodoc
mixin _$ChangelogEntry {
  String get id => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;

  /// Serializes this ChangelogEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChangelogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChangelogEntryCopyWith<ChangelogEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangelogEntryCopyWith<$Res> {
  factory $ChangelogEntryCopyWith(
          ChangelogEntry value, $Res Function(ChangelogEntry) then) =
      _$ChangelogEntryCopyWithImpl<$Res, ChangelogEntry>;
  @useResult
  $Res call(
      {String id,
      DateTime timestamp,
      String action,
      Map<String, dynamic> data});
}

/// @nodoc
class _$ChangelogEntryCopyWithImpl<$Res, $Val extends ChangelogEntry>
    implements $ChangelogEntryCopyWith<$Res> {
  _$ChangelogEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChangelogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? action = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChangelogEntryImplCopyWith<$Res>
    implements $ChangelogEntryCopyWith<$Res> {
  factory _$$ChangelogEntryImplCopyWith(_$ChangelogEntryImpl value,
          $Res Function(_$ChangelogEntryImpl) then) =
      __$$ChangelogEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime timestamp,
      String action,
      Map<String, dynamic> data});
}

/// @nodoc
class __$$ChangelogEntryImplCopyWithImpl<$Res>
    extends _$ChangelogEntryCopyWithImpl<$Res, _$ChangelogEntryImpl>
    implements _$$ChangelogEntryImplCopyWith<$Res> {
  __$$ChangelogEntryImplCopyWithImpl(
      _$ChangelogEntryImpl _value, $Res Function(_$ChangelogEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChangelogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? action = null,
    Object? data = null,
  }) {
    return _then(_$ChangelogEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChangelogEntryImpl implements _ChangelogEntry {
  const _$ChangelogEntryImpl(
      {required this.id,
      required this.timestamp,
      required this.action,
      required final Map<String, dynamic> data})
      : _data = data;

  factory _$ChangelogEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChangelogEntryImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime timestamp;
  @override
  final String action;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  String toString() {
    return 'ChangelogEntry(id: $id, timestamp: $timestamp, action: $action, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangelogEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.action, action) || other.action == action) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, timestamp, action,
      const DeepCollectionEquality().hash(_data));

  /// Create a copy of ChangelogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangelogEntryImplCopyWith<_$ChangelogEntryImpl> get copyWith =>
      __$$ChangelogEntryImplCopyWithImpl<_$ChangelogEntryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChangelogEntryImplToJson(
      this,
    );
  }
}

abstract class _ChangelogEntry implements ChangelogEntry {
  const factory _ChangelogEntry(
      {required final String id,
      required final DateTime timestamp,
      required final String action,
      required final Map<String, dynamic> data}) = _$ChangelogEntryImpl;

  factory _ChangelogEntry.fromJson(Map<String, dynamic> json) =
      _$ChangelogEntryImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get timestamp;
  @override
  String get action;
  @override
  Map<String, dynamic> get data;

  /// Create a copy of ChangelogEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangelogEntryImplCopyWith<_$ChangelogEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
