import 'package:flutter/material.dart';
import 'package:scrum_assistant/theme/app_theme.dart';

class EdgeScrollIndicator extends StatelessWidget {
  const EdgeScrollIndicator({
    super.key,
    required this.isLeft,
    required this.isVisible,
  });

  final bool isLeft;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: 40,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isLeft ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
          color: AppTheme.primaryColor,
          size: 24,
        ),
      ),
    );
  }
}
