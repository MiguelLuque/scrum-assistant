import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrum_assistant/data/local/hive_adapters.dart';
import 'package:scrum_assistant/env/env.dart';
import 'package:scrum_assistant/features/board/screens/board_screen.dart';
import 'package:scrum_assistant/features/board/providers/board_persistence_provider.dart';
import 'package:scrum_assistant/features/splash/screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Hive for local persistence
  await HiveService.initialize();

  // Initialize OpenAI API
  OpenAI.apiKey = Env.apiKey;

  // Run the app
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
    // Initialize the board persistence provider to load data at startup
    ref.watch(boardPersistenceNotifierProvider);

    return MaterialApp(
      title: 'Scrum Assistant',
      theme: AppTheme.light,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
