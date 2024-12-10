import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrum_assistant/controllers/board_drag_controller.dart';
import 'package:scrum_assistant/features/chat/widgets/chat_bottom_sheet.dart';
import 'package:scrum_assistant/theme/app_theme.dart';
import 'package:scrum_assistant/widgets/kanban_column.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../providers/board_provider.dart';
import '../models/task_model.dart';
import '../widgets/board/edge_scroll_indicator.dart';

class BoardScreen extends ConsumerWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columns = ref.watch(boardNotifierProvider);
    final pageController = PageController();

    return Container(
      decoration: AppTheme.backgroundDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: AppTheme.surfaceColor.withOpacity(0.9),
            title: const Text('Kanban Board'),
            actions: [
              IconButton(
                icon: const Icon(Icons.auto_awesome_sharp),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const ChatBottomSheet(),
                  );
                },
              ),
            ]),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    controller: pageController,
                    itemCount: columns.length,
                    itemBuilder: (context, index) {
                      return DragTarget<TaskModel>(
                        onAcceptWithDetails: (details) {
                          ref.read(boardNotifierProvider.notifier).moveTask(
                                details.data,
                                ref
                                    .read(boardDragControllerProvider)
                                    .sourceColumnIndex!,
                                index,
                              );
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Padding(
                            padding: EdgeInsets.all(AppTheme.spacing_md),
                            child: KanbanColumnWidget(
                              column: columns[index],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  EdgeScrollIndicator(
                    onLeftEdgeReached: () {
                      if (pageController.page! > 0) {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    onRightEdgeReached: () {
                      if (pageController.page! < columns.length - 1) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: AppTheme.spacing_lg),
              child: SmoothPageIndicator(
                controller: pageController,
                count: columns.length,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  type: WormType.thin,
                  activeDotColor: AppTheme.primaryColor,
                  dotColor: AppTheme.surfaceColor.withOpacity(0.3),
                  spacing: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
