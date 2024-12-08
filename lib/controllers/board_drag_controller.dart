import 'package:flutter/material.dart';

class BoardDragController {
  DateTime? _lastNavigationTime;
  static const _animationDuration = Duration(milliseconds: 600);
  static const _navigationDelay = Duration(milliseconds: 500);

  Future<void> handlePageDrag({
    required BuildContext context,
    required Offset position,
    required PageController controller,
    required int maxPage,
  }) async {
    if (!controller.hasClients) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final edgeThreshold = screenWidth * 0.15;
    final currentPage = controller.page?.round() ?? 0;

    try {
      if (_lastNavigationTime != null &&
          DateTime.now().difference(_lastNavigationTime!) < _navigationDelay) {
        return;
      }

      if (position.dx < edgeThreshold && currentPage > 0) {
        _lastNavigationTime = DateTime.now();
        await controller.animateToPage(
          currentPage - 1,
          duration: _animationDuration,
          curve: Curves.easeInOut,
        );
      } else if (position.dx > (screenWidth - edgeThreshold) &&
          currentPage < maxPage) {
        _lastNavigationTime = DateTime.now();
        await controller.animateToPage(
          currentPage + 1,
          duration: _animationDuration,
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      debugPrint('Error during page animation: $e');
    }
  }
} 