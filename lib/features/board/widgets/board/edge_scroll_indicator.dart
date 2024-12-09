import 'dart:async';
import 'package:flutter/material.dart';

class EdgeScrollIndicator extends StatefulWidget {
  final VoidCallback onLeftEdgeReached;
  final VoidCallback onRightEdgeReached;

  const EdgeScrollIndicator({
    super.key,
    required this.onLeftEdgeReached,
    required this.onRightEdgeReached,
  });

  @override
  _EdgeScrollIndicatorState createState() => _EdgeScrollIndicatorState();
}

class _EdgeScrollIndicatorState extends State<EdgeScrollIndicator> {
  Timer? _leftScrollTimer;
  Timer? _rightScrollTimer;

  void _startLeftScrollTimer() {
    _leftScrollTimer = Timer.periodic(
      const Duration(milliseconds: 200),
      (_) => widget.onLeftEdgeReached(),
    );
  }

  void _startRightScrollTimer() {
    _rightScrollTimer = Timer.periodic(
      const Duration(milliseconds: 200),
      (_) => widget.onRightEdgeReached(),
    );
  }

  void _stopLeftScrollTimer() {
    _leftScrollTimer?.cancel();
    _leftScrollTimer = null;
  }

  void _stopRightScrollTimer() {
    _rightScrollTimer?.cancel();
    _rightScrollTimer = null;
  }

  @override
  void dispose() {
    _stopLeftScrollTimer();
    _stopRightScrollTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: DragTarget(
            onAcceptWithDetails: (_) {},
            onLeave: (_) => _stopLeftScrollTimer(),
            builder: (context, candidateData, rejectedData) {
              return GestureDetector(
                onTap: () => widget.onLeftEdgeReached(),
                child: Container(
                  width: 50,
                  color: Colors.transparent,
                ),
              );
            },
            onWillAcceptWithDetails: (_) {
              _startLeftScrollTimer();
              return false;
            },
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: DragTarget(
            onAcceptWithDetails: (_) {},
            onLeave: (_) => _stopRightScrollTimer(),
            builder: (context, candidateData, rejectedData) {
              return GestureDetector(
                onTap: () => widget.onRightEdgeReached(),
                child: Container(
                  width: 50,
                  color: Colors.transparent,
                ),
              );
            },
            onWillAcceptWithDetails: (_) {
              _startRightScrollTimer();
              return false;
            },
          ),
        ),
      ],
    );
  }
}
