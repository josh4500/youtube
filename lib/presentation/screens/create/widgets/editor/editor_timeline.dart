import 'package:flutter/material.dart';
import 'package:youtube_clone/core/utils/normalization.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../notifications/editor_notification.dart';
import 'element.dart';

class EditorTimeline extends StatefulWidget {
  const EditorTimeline({super.key});

  @override
  State<EditorTimeline> createState() => _EditorTimelineState();
}

class _EditorTimelineState extends State<EditorTimeline> {
  final ValueNotifier<Alignment> alignment = ValueNotifier<Alignment>(
    Alignment.centerLeft,
  );
  @override
  void dispose() {
    alignment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elements = context.provide<List<TextElement>>();
    return ColoredBox(
      color: const Color(0xFF212121),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white10,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: AlwaysStoppedAnimation(0),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        CloseTimelineNotification().dispatch(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'DONE',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 0, thickness: 1.5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              child: Stack(
                children: [
                  InterimProgressIndicator(
                    width: .5,
                    alignment: alignment,
                  ),
                  ScrollConfiguration(
                    behavior: const OverScrollGlowBehavior(
                      color: Colors.black12,
                    ),
                    child: ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.white10,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: ImageFromAsset.textOption14,
                          );
                        }
                        final element = elements[index - 1];
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 6,
                            bottom: 4,
                          ),
                          child: SizedBox(
                            height: 32,
                            child: Trimmer(
                              borderLines: false,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 20,
                                ),
                                width: double.infinity,
                                color: element.style.color ?? Colors.white,
                                child: Text(
                                  element.text,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: elements.length + 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 0, thickness: 1.5),
          LayoutBuilder(
            builder: (
              BuildContext context,
              BoxConstraints constraints,
            ) {
              return GestureDetector(
                onHorizontalDragStart: (DragStartDetails details) {
                  // TODO(josh4500): Pause player
                },
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  alignment.value = Alignment(
                    (details.localPosition.dx / constraints.maxWidth)
                        .normalizeRange(-1, 1),
                    0,
                  );
                },
                onHorizontalDragEnd: (DragEndDetails details) {
                  // TODO(josh4500): Pause player
                },
                onHorizontalDragCancel: () {
                  // TODO(josh4500): Pause player
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 24,
                  ),
                  child: SizedBox(
                    height: 72,
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 64,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        InterimProgressIndicator(
                          width: 6,
                          alignment: alignment,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class InterimProgressIndicator extends StatelessWidget {
  const InterimProgressIndicator({
    super.key,
    required this.width,
    required this.alignment,
  });

  final double width;

  final ValueNotifier<Alignment> alignment;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: alignment,
      builder: (BuildContext context, Widget? childWidget) {
        return Align(alignment: alignment.value, child: childWidget);
      },
      child: Container(
        width: width,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(width),
        ),
      ),
    );
  }
}
