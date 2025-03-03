import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrum_assistant/data/local/hive_adapters.dart';
import 'package:scrum_assistant/env/env.dart';
import 'package:scrum_assistant/features/board/screens/board_screen.dart';
import 'package:scrum_assistant/features/board/providers/board_persistence_provider.dart';
import 'theme/app_theme.dart';

void main() async {
  // Aseguramos que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos Hive para la persistencia local
  await HiveService.initialize();

  OpenAI.apiKey = Env.apiKey;
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Inicializar el proveedor de persistencia para cargar datos al inicio
    ref.watch(boardPersistenceNotifierProvider);

    return MaterialApp(
      title: 'Scrum Assistant',
      theme: AppTheme.light,
      home: const BoardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
