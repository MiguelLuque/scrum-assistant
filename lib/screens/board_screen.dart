import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:scrum_assistant/models/column_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../providers/board_provider.dart';
import '../widgets/kanban_column.dart';
import '../theme/app_theme.dart';

class BoardScreen extends HookConsumerWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columns = ref.watch(boardNotifierProvider);
    print('Columns loaded: ${columns.map((c) => c.title).toList()}');
    final pageController = usePageController();
    final isDragging = useState(false);
    final dragPosition = useState<Offset?>(null);

    final columnKeys = useMemoized(
        () => List<GlobalKey>.generate(columns.length, (_) => GlobalKey()),
        [columns]);

    return Container(
      decoration: AppTheme.backgroundDecoration,
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
            Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: pageController,
                    children: List.generate(columns.length, (index) {
                      return Padding(
                        padding: EdgeInsets.all(AppTheme.spacing_md),
                        child: KanbanColumnWidget(
                          key: columnKeys[index],
                          column: columns[index],
                          onDragStarted: () => isDragging.value = true,
                          onDragEnded: () => isDragging.value = false,
                          onDragUpdate: (details) {
                            dragPosition.value = details.globalPosition;
                            _handlePageDrag(
                              context,
                              details.globalPosition,
                              pageController,
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ),
                Container(
                  color: AppTheme.surfaceColor.withOpacity(0.9),
                  padding: EdgeInsets.only(bottom: AppTheme.spacing_lg),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: columns.length,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      type: WormType.thin,
                      activeDotColor: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            if (isDragging.value)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: true, // Ignora eventos táctiles en esta capa
                  child: Opacity(
                    opacity: 0.1, // Ajusta la opacidad si es necesario
                    child: Container(
                      color: Colors
                          .black, // Puede ser un fondo oscuro si es requerido
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handlePageDrag(
    BuildContext context,
    Offset position,
    PageController controller,
  ) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final edgeThreshold = screenWidth * 0.1; // 10% del ancho de la pantalla

    if (position.dx < edgeThreshold && controller.page! > 0) {
      await controller.previousPage(
        duration: AppTheme.quickAnimation,
        curve: Curves.easeOut,
      );
    } else if (position.dx > screenWidth - edgeThreshold &&
        controller.page! < controller.positions.length - 1) {
      await controller.nextPage(
        duration: AppTheme.quickAnimation,
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildDragTargetOverlay(
    BuildContext context,
    List<ColumnModel> columns,
    PageController controller,
    Offset? dragPosition,
  ) {
    if (dragPosition == null) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final isNearLeftEdge = dragPosition.dx < screenWidth * 0.1;
    final isNearRightEdge = dragPosition.dx > screenWidth * 0.9;

    return Container(
      color: Colors.black.withOpacity(0.1),
      child: Row(
        children: [
          AnimatedOpacity(
            duration: AppTheme.quickAnimation,
            opacity: isNearLeftEdge ? 1.0 : 0.0,
            child: Container(
              width: 40,
              margin: EdgeInsets.all(AppTheme.spacing_md),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius_md),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const Spacer(),
          AnimatedOpacity(
            duration: AppTheme.quickAnimation,
            opacity: isNearRightEdge ? 1.0 : 0.0,
            child: Container(
              width: 40,
              margin: EdgeInsets.all(AppTheme.spacing_md),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius_md),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
