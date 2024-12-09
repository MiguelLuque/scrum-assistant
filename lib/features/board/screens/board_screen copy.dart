// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:scrum_assistant/theme/app_theme.dart';
// import 'package:scrum_assistant/widgets/kanban_column.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import '../providers/board_provider.dart';

// class BoardScreen2 extends HookConsumerWidget {
//   const BoardScreen2({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final columns = ref.watch(boardNotifierProvider);
//     print('Columns loaded: ${columns.map((c) => c.title).toList()}');
//     final pageController = usePageController();
//     final isDragging = useState(false);
//     final dragPosition = useState<Offset?>(null);

//     final columnKeys = useMemoized(
//         () => List<GlobalKey>.generate(columns.length, (_) => GlobalKey()),
//         [columns]);

//     return Container(
//       decoration: AppTheme.backgroundDecoration,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           backgroundColor: AppTheme.surfaceColor.withOpacity(0.9),
//           title: const Text('Kanban Board'),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.add),
//               onPressed: () {
//                 // TODO: Implement add task dialog
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.chat),
//               onPressed: () {
//                 // Navigator.of(context).push(
//                 //   MaterialPageRoute(
//                 //     builder: (context) => const ChatScreen(),
//                 //   ),
//                 // );
//               },
//             ),
//           ],
//         ),
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 Expanded(
//                   child: PageView.builder(
//                     controller: pageController,
//                     physics: isDragging.value
//                         ? const NeverScrollableScrollPhysics()
//                         : const AlwaysScrollableScrollPhysics(),
//                     itemCount: columns.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: EdgeInsets.all(AppTheme.spacing_md),
//                         child: KanbanColumnWidget(
//                           key: columnKeys[index],
//                           column: columns[index],
//                           onDragStarted: () {
//                             isDragging.value = true;
//                             dragPosition.value = null;
//                           },
//                           onDragEnded: () {
//                             isDragging.value = false;
//                             dragPosition.value = null;
//                           },
//                           onDragUpdate: (details) {
//                             if (!isDragging.value) return;
//                             dragPosition.value = details.globalPosition;
//                             _handlePageDrag(
//                               context,
//                               details.globalPosition,
//                               pageController,
//                               ref,
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(bottom: AppTheme.spacing_lg),
//                   child: SmoothPageIndicator(
//                     controller: pageController,
//                     count: columns.length,
//                     effect: WormEffect(
//                       dotHeight: 8,
//                       dotWidth: 8,
//                       type: WormType.thin,
//                       activeDotColor: AppTheme.primaryColor,
//                       dotColor: AppTheme.surfaceColor.withOpacity(0.3),
//                       spacing: 8,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             if (isDragging.value)
//               Positioned.fill(
//                 child: Stack(
//                   children: [
//                     IgnorePointer(
//                       child: Container(
//                         color: Colors.black.withOpacity(0.1),
//                       ),
//                     ),
//                     Builder(
//                       builder: (context) {
//                         final screenWidth = MediaQuery.of(context).size.width;
//                         return Row(
//                           children: [
//                             _buildEdgeIndicator(
//                               isLeft: true,
//                               isVisible: dragPosition.value != null &&
//                                   dragPosition.value!.dx < screenWidth * 0.15,
//                             ),
//                             const Spacer(),
//                             _buildEdgeIndicator(
//                               isLeft: false,
//                               isVisible: dragPosition.value != null &&
//                                   dragPosition.value!.dx > screenWidth * 0.85,
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handlePageDrag(
//     BuildContext context,
//     Offset position,
//     PageController controller,
//     WidgetRef ref,
//   ) async {
//     if (!controller.hasClients) return;

//     final screenWidth = MediaQuery.of(context).size.width;
//     final edgeThreshold = screenWidth * 0.15;
//     final currentPage = controller.page?.round() ?? 0;
//     final columns = ref.read(boardNotifierProvider);
//     final maxPage = columns.length - 1;

//     const animationDuration = Duration(milliseconds: 600);
//     const navigationDelay = Duration(milliseconds: 500);

//     DateTime? lastNavigationTime;

//     try {
//       if (lastNavigationTime != null &&
//           DateTime.now().difference(lastNavigationTime!) < navigationDelay) {
//         return;
//       }

//       if (position.dx < edgeThreshold && currentPage > 0) {
//         print('Moving left from page $currentPage');
//         lastNavigationTime = DateTime.now();
//         await controller.animateToPage(
//           currentPage - 1,
//           duration: animationDuration,
//           curve: Curves.easeInOut,
//         );
//       } else if (position.dx > (screenWidth - edgeThreshold) &&
//           currentPage < maxPage) {
//         print('Moving right from page $currentPage');
//         lastNavigationTime = DateTime.now();
//         await controller.animateToPage(
//           currentPage + 1,
//           duration: animationDuration,
//           curve: Curves.easeInOut,
//         );
//       }
//     } catch (e) {
//       print('Error during page animation: $e');
//     }
//   }

//   Widget _buildEdgeIndicator({required bool isLeft, required bool isVisible}) {
//     return AnimatedOpacity(
//       opacity: isVisible ? 1.0 : 0.0,
//       duration: const Duration(milliseconds: 200),
//       child: Container(
//         width: 40,
//         margin: const EdgeInsets.all(8),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: AppTheme.primaryColor.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(
//           isLeft ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
//           color: AppTheme.primaryColor,
//           size: 24,
//         ),
//       ),
//     );
//   }
// }
