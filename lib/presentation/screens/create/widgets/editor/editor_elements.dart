import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/theme/styles/app_color.dart';
import 'package:youtube_clone/presentation/widgets/animated_visibility.dart';

import '../notifications/editor_notification.dart';
import 'element.dart';

class EditorElements extends StatefulWidget {
  const EditorElements({super.key});

  @override
  State<EditorElements> createState() => _EditorElementsState();
}

class _EditorElementsState extends State<EditorElements> {
  final hitNotifier = ValueNotifier(DragHit());
  final ValueNotifier<bool> draggingNotifier = ValueNotifier(false);
  final ValueNotifier<bool> hitDeleteNotifier = ValueNotifier(false);

  @override
  void dispose() {
    hitNotifier.dispose();
    super.dispose();
  }

  bool handleEditorNotification(EditorNotification notification) {
    if (notification is DragHitNotification) {
      hitNotifier.value = notification.hit;
      draggingNotifier.value = notification.dragging;
      hitDeleteNotifier.value = notification.hitDelete;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final elementsNotifier =
        context.provide<ValueNotifier<List<VideoElementData>>>();
    return NotificationListener<EditorNotification>(
      onNotification: handleEditorNotification,
      child: ListenableBuilder(
        listenable: elementsNotifier,
        builder: (BuildContext context, Widget? childWidget) {
          return Stack(
            fit: StackFit.expand,
            children: [
              LayoutBuilder(
                builder: (
                  BuildContext context,
                  BoxConstraints constraints,
                ) {
                  return ValueListenableBuilder(
                    valueListenable: hitNotifier,
                    builder: (
                      BuildContext context,
                      DragHit hit,
                      Widget? childWidget,
                    ) {
                      return CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: DragLinesPainter(hit: hit),
                      );
                    },
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: elementsNotifier,
                builder: (
                  BuildContext context,
                  List<VideoElementData> elements,
                  Widget? childWidget,
                ) {
                  return Stack(
                    children: [
                      for (int i = 0; i < elements.length; i++)
                        ValueListenableBuilder(
                          key: ValueKey(elements[i].id),
                          valueListenable: draggingNotifier,
                          builder: (
                            BuildContext context,
                            bool dragging,
                            Widget? childWidget,
                          ) {
                            return Opacity(
                              opacity: dragging && i != elements.length - 1
                                  ? 0.2
                                  : 1,
                              child: childWidget,
                            );
                          },
                          child: ModelBinding(
                            model: elementsNotifier.value[i],
                            child: const VideoElement(),
                          ),
                        ),
                    ],
                  );
                },
              ),
              ListenableBuilder(
                listenable: Listenable.merge([
                  draggingNotifier,
                  hitDeleteNotifier,
                ]),
                builder: (
                  BuildContext context,
                  Widget? _,
                ) {
                  return AnimatedValuedVisibility(
                    visible: draggingNotifier.value,
                    duration: Durations.short3,
                    alignment: Alignment.bottomCenter,
                    child: Transform.scale(
                      scale: hitDeleteNotifier.value ? 1.13 : 1,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: hitDeleteNotifier.value
                              ? AppPalette.red
                              : Colors.black12,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: AppPalette.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class DragLinesPainter extends CustomPainter {
  DragLinesPainter({required this.hit});
  final DragHit hit;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    const double spacing = 14.0;
    // Draw lines based on the drag position
    if (hit.hitTop) {
      canvas.drawLine(
        const Offset(0, spacing * 4),
        Offset(size.width, spacing * 4),
        paint,
      );
    }
    if (hit.hitLeft) {
      // Left
      canvas.drawLine(
        const Offset(spacing, 0),
        Offset(spacing, size.height),
        paint,
      );
    }
    if (hit.hitRight) {
      // Right
      canvas.drawLine(
        Offset(size.width - spacing, 0),
        Offset(size.width - spacing, size.height),
        paint,
      );
    }
    if (hit.hitBottom) {
      // Bottom
      canvas.drawLine(
        Offset(0, size.height - spacing * 4),
        Offset(size.width, size.height - spacing * 4),
        paint,
      );
    }
    if (hit.hitXCenter) {
      // Center-X
      canvas.drawLine(
        Offset(size.width / 2, spacing / 2),
        Offset(size.width / 2, size.height - spacing / 2),
        paint,
      );
    }
    if (hit.hitYCenter) {
      // Center-Y
      canvas.drawLine(
        Offset(spacing / 2, size.height / 2),
        Offset(size.width - spacing / 2, size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
