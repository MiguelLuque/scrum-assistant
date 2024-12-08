import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:scrum_assistant/theme/app_theme.dart';
import 'package:scrum_assistant/widgets/kanban_column.dart';

import '../providers/board_provider.dart';

class BoardScreen extends HookConsumerWidget {
  const BoardScreen({super.key});

  static const double _scrollThreshold = 150.0;
  static const double _baseScrollAmount = 60.0;
  static const Duration _scrollInterval = Duration(milliseconds: 8);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columns = ref.watch(boardNotifierProvider);
    final isDragging = useState(false);
    final scrollController = useScrollController();
    final dragPosition = useState<Offset?>(null);
    final autoScrollTimer = useState<Timer?>(null);
    final lastScrollDirection = useState<double>(0);

    void stopAutoScroll() {
      autoScrollTimer.value?.cancel();
      autoScrollTimer.value = null;
      dragPosition.value = null;
      lastScrollDirection.value = 0;
    }

    void startAutoScroll(DragUpdateDetails details) {
      dragPosition.value = details.globalPosition;
      
      if (autoScrollTimer.value != null) return;

      autoScrollTimer.value = Timer.periodic(
        _scrollInterval,
        (_) {
          if (!scrollController.hasClients || dragPosition.value == null) return;

          final position = dragPosition.value!.dx;
          final screenWidth = MediaQuery.of(context).size.width;
          double scrollAmount = 0;

          if (position < _scrollThreshold && scrollController.offset > 0) {
            scrollAmount = -_baseScrollAmount;
            lastScrollDirection.value = -1;
          } else if (position > screenWidth - _scrollThreshold && 
                     scrollController.offset < scrollController.position.maxScrollExtent) {
            scrollAmount = _baseScrollAmount;
            lastScrollDirection.value = 1;
          } else if (lastScrollDirection.value != 0) {
            scrollAmount = _baseScrollAmount * lastScrollDirection.value * 0.5;
          }

          final targetOffset = scrollController.offset + scrollAmount;
          if (targetOffset >= 0 && 
              targetOffset <= scrollController.position.maxScrollExtent) {
            scrollController.jumpTo(targetOffset);
          } else {
            lastScrollDirection.value = 0;
          }
        },
      );
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background_img.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppTheme.surfaceColor.withOpacity(0.9),
          title: const Text('Kanban Board'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // TODO: Implement add task dialog
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: columns.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: KanbanColumnWidget(
                      column: columns[index],
                      onDragStarted: () => isDragging.value = true,
                      onDragEnded: () {
                        isDragging.value = false;
                        stopAutoScroll();
                      },
                      onDragUpdate: (details) {
                        if (!isDragging.value) return;
                        
                        final screenWidth = MediaQuery.of(context).size.width;
                        final position = details.globalPosition.dx;
                        
                        dragPosition.value = details.globalPosition;
                        startAutoScroll(details);
                      },
                    ),
                  ),
                );
              },
            ),
            if (isDragging.value)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
