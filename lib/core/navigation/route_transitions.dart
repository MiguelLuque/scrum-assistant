import 'package:flutter/material.dart';

/// Custom page route transitions for the app
class AppRouteTransitions {
  /// Creates a fade transition route
  static Route<T> fadeTransition<T>({
    required Widget page,
    String? routeName,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      settings: routeName != null ? RouteSettings(name: routeName) : null,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// Creates a slide transition route
  static Route<T> slideTransition<T>({
    required Widget page,
    String? routeName,
    Duration duration = const Duration(milliseconds: 300),
    SlideDirection direction = SlideDirection.right,
  }) {
    return PageRouteBuilder<T>(
      settings: routeName != null ? RouteSettings(name: routeName) : null,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = _getBeginOffset(direction);
        const end = Offset.zero;

        final tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// Creates a scale transition route
  static Route<T> scaleTransition<T>({
    required Widget page,
    String? routeName,
    Duration duration = const Duration(milliseconds: 300),
    Alignment alignment = Alignment.center,
  }) {
    return PageRouteBuilder<T>(
      settings: routeName != null ? RouteSettings(name: routeName) : null,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          alignment: alignment,
          scale: animation.drive(
            Tween(begin: 0.8, end: 1.0)
                .chain(CurveTween(curve: Curves.easeOutBack)),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }

  /// Creates a combined fade and slide transition route
  static Route<T> fadeSlideTransition<T>({
    required Widget page,
    String? routeName,
    Duration duration = const Duration(milliseconds: 300),
    SlideDirection direction = SlideDirection.right,
  }) {
    return PageRouteBuilder<T>(
      settings: routeName != null ? RouteSettings(name: routeName) : null,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = _getBeginOffset(direction);
        const end = Offset.zero;

        final slideTween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeOutCubic));

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(slideTween),
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }

  /// Helper method to get the begin offset based on the slide direction
  static Offset _getBeginOffset(SlideDirection direction) {
    switch (direction) {
      case SlideDirection.right:
        return const Offset(1.0, 0.0);
      case SlideDirection.left:
        return const Offset(-1.0, 0.0);
      case SlideDirection.up:
        return const Offset(0.0, -1.0);
      case SlideDirection.down:
        return const Offset(0.0, 1.0);
    }
  }
}

/// Enum for slide transition directions
enum SlideDirection {
  right,
  left,
  up,
  down,
}
