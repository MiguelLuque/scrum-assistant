import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_initialization_provider.g.dart';

/// States for the app initialization process
enum AppInitializationState {
  initializing,
  initialized,
  error,
}

/// Provider that handles the app initialization process
@riverpod
class AppInitialization extends _$AppInitialization {
  @override
  FutureOr<AppInitializationState> build() async {
    return _initializeApp();
  }

  /// Initialize all required app services and data
  Future<AppInitializationState> _initializeApp() async {
    try {
      // Simulate initialization delay (in a real app, you would have actual initialization tasks)
      // For example: loading user preferences, checking authentication, etc.
      await Future.delayed(const Duration(seconds: 2));

      // You can add more initialization logic here:
      // - Check for first run
      // - Load user preferences
      // - Initialize other services
      // - Check for updates

      return AppInitializationState.initialized;
    } catch (e) {
      // Log the error
      print('Error initializing app: $e');
      return AppInitializationState.error;
    }
  }

  /// Retry initialization if it failed
  Future<void> retryInitialization() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_initializeApp);
  }
}
