import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scrum_assistant/features/changelog/models/changelog_entry.dart';

part 'changelog_provider.g.dart';

@Riverpod(keepAlive: true)
class ChangelogNotifier extends _$ChangelogNotifier {
  @override
  List<ChangelogEntry> build() {
    return [];
  }

  void addEntry(String action, Map<String, dynamic> data) {
    print('Adding changelog entry: $action with data: $data');
    final newEntry = ChangelogEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      action: action,
      data: data,
    );

    state = [...state, newEntry];
    print('Changelog state: ${state.map((entry) => entry.toJson()).toList()}');
  }

  String getChangelogAsJson() {
    return jsonEncode(state.map((entry) => entry.toJson()).toList());
  }
}
