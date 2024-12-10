import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrum_assistant/env/env.dart';
import 'package:scrum_assistant/features/board/screens/board_screen.dart';
import 'theme/app_theme.dart';

void main() {
  OpenAI.apiKey = Env.apiKey;
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Kanban Board',
      theme: AppTheme.light,
      home: const BoardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
