import 'package:freezed_annotation/freezed_annotation.dart';

part 'changelog_entry.freezed.dart';
part 'changelog_entry.g.dart';

@freezed
class ChangelogEntry with _$ChangelogEntry {
  const factory ChangelogEntry({
    required String id,
    required DateTime timestamp,
    required String action,
    required Map<String, dynamic> data,
  }) = _ChangelogEntry;

  factory ChangelogEntry.fromJson(Map<String, dynamic> json) =>
      _$ChangelogEntryFromJson(json);
} 