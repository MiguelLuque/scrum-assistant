import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:scrum_assistant/core/navigation/route_transitions.dart';
import 'package:scrum_assistant/features/board/screens/board_screen.dart';
import 'package:scrum_assistant/features/splash/providers/app_initialization_provider.dart';

/// A splash screen that displays when the app is starting up.
/// It shows the app logo and name with animations.
class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initializationState = ref.watch(appInitializationProvider);

    // Use a hook to handle navigation after initialization
    useEffect(() {
      if (initializationState.valueOrNull ==
          AppInitializationState.initialized) {
        // Navigate to the main screen after initialization is complete
        Future.microtask(() {
          Navigator.of(context).pushReplacement(
            AppRouteTransitions.fadeTransition(
              page: const BoardScreen(),
              routeName: 'board_screen',
              duration: const Duration(milliseconds: 500),
            ),
          );
        });
      }
      return null;
    }, [initializationState.valueOrNull]);

    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_img.jpg'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Animated app bar with version
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'v1.0.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 800.ms, duration: 400.ms),

              // Main content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App logo
                      const _SplashLogo(),

                      const SizedBox(height: 24),

                      // App name
                      Text(
                        'Scrum Assistant',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 400.ms)
                          .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 600.ms,
                              curve: Curves.easeOutQuad),

                      const SizedBox(height: 8),

                      // App tagline
                      Text(
                        'Your agile development companion',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ).animate().fadeIn(duration: 600.ms, delay: 600.ms),
                    ],
                  ),
                ),
              ),

              // Bottom section with loading indicator or error
              Padding(
                padding: const EdgeInsets.only(bottom: 48.0),
                child: initializationState.when(
                  data: (_) => const _LoadingIndicator(isComplete: true),
                  loading: () => const _LoadingIndicator(),
                  error: (error, stack) => _ErrorMessage(
                    onRetry: () => ref
                        .read(appInitializationProvider.notifier)
                        .retryInitialization(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The app logo widget with animation
class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.dashboard_customize_rounded,
          size: 64,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 500.ms,
          curve: Curves.easeOutBack,
        )
        .fadeIn(duration: 300.ms);
  }
}

/// A custom loading indicator for the splash screen
class _LoadingIndicator extends StatelessWidget {
  final bool isComplete;

  const _LoadingIndicator({this.isComplete = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 160,
      child: Column(
        children: [
          if (isComplete)
            // Show checkmark when loading is complete
            Icon(
              Icons.check_circle_outline,
              color: theme.colorScheme.primary,
              size: 28,
            ).animate().scale(
                  duration: 300.ms,
                  curve: Curves.easeOutBack,
                )
          else
            // Show progress indicator when loading
            LinearProgressIndicator(
              backgroundColor: theme.colorScheme.surfaceVariant,
              color: theme.colorScheme.primary,
            ),

          const SizedBox(height: 8),

          // Loading text
          Text(
            isComplete ? 'Ready!' : 'Loading...',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms, duration: 400.ms);
  }
}

/// Error message widget with retry button
class _ErrorMessage extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorMessage({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          Icons.error_outline_rounded,
          size: 48,
          color: theme.colorScheme.error,
        ),
        const SizedBox(height: 16),
        Text(
          'Failed to initialize app',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}
