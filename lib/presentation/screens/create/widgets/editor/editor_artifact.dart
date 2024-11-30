import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/theme/styles/app_color.dart';

import '../notifications/editor_notification.dart';
import 'artifacts/artifact.dart';

class EditorArtifact extends StatefulWidget {
  const EditorArtifact({super.key, required this.data});
  final ValueNotifier<List<ArtifactData>> data;

  @override
  State<EditorArtifact> createState() => _EditorArtifactState();
}

class _EditorArtifactState extends State<EditorArtifact> {
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

      if (notification.hitDelete && !notification.dragging) {
        // TODO(josh4500): Handle delete
        hitDeleteNotifier.value = false;
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<EditorNotification>(
      onNotification: handleEditorNotification,
      child: ListenableBuilder(
        listenable: widget.data,
        builder: (BuildContext context, Widget? childWidget) {
          return Stack(
            fit: StackFit.expand,
            children: [
              childWidget ?? const SizedBox(),
              for (final artifactData in widget.data.value)
                ModelBinding(
                  model: artifactData,
                  child: const Artifact(),
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
                  if (draggingNotifier.value == false) {
                    return const SizedBox();
                  }
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete,
                        color: hitDeleteNotifier.value
                            ? AppPalette.red
                            : AppPalette.white,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
        child: LayoutBuilder(
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
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    const double spacing = 12.0;
    // Draw lines based on the drag position
    if (hit.hitTop) {
      canvas.drawLine(
        const Offset(0, spacing),
        Offset(size.width - spacing, spacing),
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
        Offset(0, size.height - spacing),
        Offset(size.width, size.height - spacing),
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
