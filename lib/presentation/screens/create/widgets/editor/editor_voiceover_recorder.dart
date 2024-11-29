import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets/sheet_drag_indicator.dart';

import '../record_button.dart';

class EditorVoiceoverRecorder extends StatefulWidget {
  const EditorVoiceoverRecorder({super.key});

  @override
  State<EditorVoiceoverRecorder> createState() =>
      _EditorVoiceoverRecorderState();
}

class _EditorVoiceoverRecorderState extends State<EditorVoiceoverRecorder>
    with TickerProviderStateMixin {
  final recordingNotifier = ValueNotifier<bool>(false);
  final dragRecordNotifier = ValueNotifier<bool>(false);
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void dispose() {
    recordingNotifier.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: ColoredBox(
        color: const Color(0xFF212121),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const SheetDragIndicator(),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Voiceover',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: context.pop,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(YTIcons.check_outlined),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 12,
              ),
              child: Stack(
                children: [
                  Transform.translate(
                    offset: const Offset(0, 4),
                    child: LinearProgressIndicator(
                      minHeight: 38,
                      color: AppPalette.red,
                      value: 0,
                      borderRadius: BorderRadius.circular(8),
                      backgroundColor: Colors.white10,
                    ),
                  ),
                  Container(
                    width: 5,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap or hold to record audio',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListenableBuilder(
                  listenable: Listenable.merge(
                    [recordingNotifier],
                  ),
                  builder: (
                    BuildContext context,
                    Widget? _,
                  ) {
                    if (recordingNotifier.value) {
                      return const SizedBox();
                    }
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(YTIcons.undo_arrow, size: 24),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 32),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: handleTapRecord,
                  onLongPress: handleLongPressRecord,
                  onLongPressEnd: handleLongPressEndRecord,
                  child: ListenableBuilder(
                    listenable: Listenable.merge(
                      [dragRecordNotifier, recordingNotifier],
                    ),
                    builder: (
                      BuildContext context,
                      Widget? _,
                    ) {
                      final bool recording = recordingNotifier.value;
                      final bool dragging = dragRecordNotifier.value;
                      final sizeAnimation = CurvedAnimation(
                        parent: controller,
                        curve: Curves.easeInCubic,
                      );
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          RecordDragButton(
                            animation: sizeAnimation,
                            isRecording: recording,
                            isDragging: dragging,
                          ),
                          RecordButton(
                            isRecording: recording && !dragging,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 32),
                ListenableBuilder(
                  listenable: Listenable.merge(
                    [recordingNotifier],
                  ),
                  builder: (
                    BuildContext context,
                    Widget? _,
                  ) {
                    if (recordingNotifier.value) {
                      return const SizedBox();
                    }
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(YTIcons.redo_arrow, size: 24),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }

  void handleLongPressEndRecord(LongPressEndDetails details) {
    dragRecordNotifier.value = recordingNotifier.value = false;
    controller.reverse(from: .8);
  }

  void handleLongPressRecord() {
    recordingNotifier.value = dragRecordNotifier.value = true;
    controller.repeat(min: .8, max: 1, reverse: true);
  }

  void handleTapRecord() {
    final isRecording = !recordingNotifier.value;
    recordingNotifier.value = !recordingNotifier.value;
    isRecording ? controller.forward(from: .7) : controller.reverse(from: .7);
  }
}
