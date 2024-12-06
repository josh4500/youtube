import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:record/record.dart';
import 'package:youtube_clone/core/utils/normalization.dart';
import 'package:youtube_clone/infrastructure.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';
import 'package:youtube_clone/presentation/widgets/sheet_drag_indicator.dart';

import '../../provider/current_voice_recording_state.dart';
import '../../provider/voice_over_state.dart';
import '../record_button.dart';
import 'editor_timeline.dart';

class EditorVoiceoverRecorder extends ConsumerStatefulWidget {
  const EditorVoiceoverRecorder({super.key});

  @override
  ConsumerState<EditorVoiceoverRecorder> createState() =>
      _EditorVoiceoverRecorderState();
}

class _EditorVoiceoverRecorderState
    extends ConsumerState<EditorVoiceoverRecorder>
    with TickerProviderStateMixin {
  final recorder = AudioRecorder();

  final recordingNotifier = ValueNotifier<bool>(false);
  final enabledRecordNotifier = ValueNotifier<bool>(true);
  final dragRecordNotifier = ValueNotifier<bool>(false);
  final dragProgressNotifier = ValueNotifier<bool>(false);

  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  final ValueNotifier<Alignment> progress = ValueNotifier<Alignment>(
    Alignment.centerLeft,
  );

  Duration _startDuration = Duration.zero;

  @override
  void dispose() {
    progress.dispose();
    recorder.dispose();
    recordingNotifier.dispose();
    controller.dispose();
    super.dispose();
  }

  void handleLongPressEndRecord(LongPressEndDetails details) {
    if (!enabledRecordNotifier.value) return;

    dragRecordNotifier.value = recordingNotifier.value = false;
    controller.reverse(from: .8);
    _stopRecording();
  }

  void handleLongPressRecord() {
    if (!enabledRecordNotifier.value) return;

    recordingNotifier.value = dragRecordNotifier.value = true;
    controller.repeat(min: .8, max: 1, reverse: true);
    _startRecording();
  }

  void handleTapRecord() {
    if (!enabledRecordNotifier.value) return;

    final isRecording = !recordingNotifier.value;
    recordingNotifier.value = !recordingNotifier.value;
    isRecording ? controller.forward(from: .7) : controller.reverse(from: .7);
    isRecording ? _startRecording() : _stopRecording();
  }

  Future<void> _startRecording() async {
    final dir = FileSystemService.instance.cacheDirectory;
    if (dir != null && await recorder.hasPermission()) {
      // await recorder.start(
      //   const RecordConfig(),
      //   path: '${dir.path}/1',
      // );

      // if (_startDuration > Duration.zero) {
      //   _startDuration += Duration(seconds: 1);
      // }
      ref.read(currentVoiceRecordingProvider.notifier).startRecording(
        _startDuration, // TODO(josh4500): Pass where to start
        (VoiceRecording recording) {
          final voiceRecording = ref.read(voiceOverStateProvider);
          _startDuration = recording.range.end;

          final tDuration = voiceRecording.recordDuration.inMilliseconds;
          final value = _startDuration.inMilliseconds / tDuration;
          _setProgressValue(value);

          final nextEndDuration = _startDuration + Duration(milliseconds: 100);
          bool autoStop = false;
          autoStop = nextEndDuration >= voiceRecording.recordDuration;

          if (!autoStop) {
            for (final recoding in voiceRecording.recordings) {
              recoding as VoiceRecording;

              if (nextEndDuration >= recoding.range.start &&
                  nextEndDuration < recoding.range.end) {
                autoStop = true;
                break;
              }
            }
          }
          if (autoStop) {
            _stopRecording();
            _onAutoStopRecording();
            // Any cause for auto stopping should result in disabling recorder
            enabledRecordNotifier.value = false;
          }
        },
      );
    }
  }

  Future<void> _stopRecording() async {
    // recorder.stop();
    ref.read(currentVoiceRecordingProvider.notifier).stopRecording();
    final recording = ref.read(currentVoiceRecordingProvider);
    ref.read(voiceOverStateProvider.notifier).addRecording(recording);
    _startDuration = recording.range.end;
  }

  Future<void> _onAutoStopRecording() async {
    recordingNotifier.value = false;
    controller.reverse(from: .7);
  }

  void handleTap(TapDownDetails details, BoxConstraints constraints) {
    final value = (details.localPosition.dx / constraints.maxWidth).clamp(
      0.0,
      1.0,
    );
    _setProgressValue(value);
    _setStartDuration(value);
  }

  void handleDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    // TODO(josh4500): Update player position/duration
    final value = (details.localPosition.dx / constraints.maxWidth).clamp(
      0.0,
      1.0,
    );
    _setProgressValue(value);
    _setStartDuration(value);
  }

  void _setProgressValue(double value) {
    progress.value = Alignment(value.normalizeRange(-1, 1), 0);
  }

  /// [value] is progress value
  void _setStartDuration(double value) {
    final state = ref.read(voiceOverStateProvider);

    final tDuration = state.recordDuration.inMilliseconds;
    _startDuration = Duration(milliseconds: (tDuration * value).ceil());
    bool enableRecord = true;
    if (_startDuration >= state.recordDuration) {
      enableRecord = false;
    }

    for (final recoding in state.recordings) {
      recoding as VoiceRecording;
      if (_startDuration.isBetween(recoding.range)) {
        enableRecord = false;
        break;
      }
    }

    if (enableRecord != enabledRecordNotifier.value) {
      HapticFeedback.lightImpact();
    }

    enabledRecordNotifier.value = enableRecord;
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
            LayoutBuilder(
              builder: (
                BuildContext context,
                BoxConstraints constraints,
              ) {
                return GestureDetector(
                  onTapDown: (details) => handleTap(
                    details,
                    constraints,
                  ),
                  onHorizontalDragStart: (DragStartDetails details) {
                    dragProgressNotifier.value = true;
                    // TODO(josh4500): Set DurationRange
                  },
                  onHorizontalDragUpdate: (details) => handleDragUpdate(
                    details,
                    constraints,
                  ),
                  onHorizontalDragEnd: (DragEndDetails details) {
                    dragProgressNotifier.value = false;
                    // TODO(josh4500): Set DurationRange
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 12,
                    ),
                    child: SizedBox(
                      height: 48,
                      child: Stack(
                        children: [
                          RepaintBoundary(
                            child: const VoiceRecordingProgress(),
                          ),
                          InterimProgressIndicator(
                            width: 6,
                            alignment: progress,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder(
              valueListenable: dragProgressNotifier,
              builder: (
                BuildContext context,
                bool dragging,
                Widget? _,
              ) {
                return AnimatedValuedVisibility(
                  visible: !dragging,
                  alignment: Alignment.center,
                  keepAlive: true,
                  child: const Text(
                    'Tap or hold to record audio',
                    style: TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final state = ref.watch(voiceOverStateProvider);
                        return ListenableBuilder(
                          listenable: Listenable.merge(
                            [recordingNotifier],
                          ),
                          builder: (
                            BuildContext context,
                            Widget? _,
                          ) {
                            if (state.canUndo && !recordingNotifier.value) {
                              return GestureDetector(
                                onTap: handleUndo,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white10,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    YTIcons.undo_arrow,
                                    size: 24,
                                  ),
                                ),
                              );
                            }

                            return const SizedBox();
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: handleTapRecord,
                  onLongPress: handleLongPressRecord,
                  onLongPressEnd: handleLongPressEndRecord,
                  child: ListenableBuilder(
                    listenable: Listenable.merge(
                      [
                        dragRecordNotifier,
                        recordingNotifier,
                        enabledRecordNotifier,
                      ],
                    ),
                    builder: (
                      BuildContext context,
                      Widget? _,
                    ) {
                      final bool recording = recordingNotifier.value;
                      final bool dragging = dragRecordNotifier.value;
                      final bool enabled = enabledRecordNotifier.value;

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
                            enabled: enabled,
                          ),
                          RecordButton(
                            enabled: enabled,
                            isRecording: recording && !dragging,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final state = ref.watch(voiceOverStateProvider);
                        return ListenableBuilder(
                          listenable: recordingNotifier,
                          builder: (
                            BuildContext context,
                            Widget? _,
                          ) {
                            if (state.canRedo && !recordingNotifier.value) {
                              return GestureDetector(
                                onTap: handleRedo,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white10,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    YTIcons.redo_arrow,
                                    size: 24,
                                  ),
                                ),
                              );
                            }

                            return const SizedBox();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }

  void handleUndo() {
    ref.read(voiceOverStateProvider.notifier).undo();
    final state = ref.read(voiceOverStateProvider);
    if (state.canUndo) {
      final tDuration = state.recordDuration.inMilliseconds;
      final latestRecording = state.recordings.last as VoiceRecording;
      final value = latestRecording.range.end.inMilliseconds / tDuration;
      _setProgressValue(value);
      _startDuration = latestRecording.range.end;
    } else {
      _setProgressValue(0);
      _startDuration = Duration.zero;
      enabledRecordNotifier.value = true;
    }
  }

  // TODO(josh4500): Seems similar to handleUndo
  void handleRedo() {
    ref.read(voiceOverStateProvider.notifier).redo();
    final state = ref.read(voiceOverStateProvider);
    if (state.canUndo) {
      final tDuration = state.recordDuration.inMilliseconds;
      final latestRecording = state.recordings.last as VoiceRecording;
      final value = latestRecording.range.end.inMilliseconds / tDuration;
      _setProgressValue(value);
      _startDuration = latestRecording.range.end;
    } else {
      _setProgressValue(0);
      _startDuration = Duration.zero;
    }
  }
}

class VoiceRecordingProgress extends ConsumerWidget {
  const VoiceRecordingProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(voiceOverStateProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      child: Consumer(
        builder: (
          BuildContext context,
          WidgetRef ref,
          Widget? childWidget,
        ) {
          final current = ref.watch(currentVoiceRecordingProvider);
          final recordings = <VoiceRecording>[
            ...state.recordings.cast<VoiceRecording>(),
            if (current.state == RecordCaptureState.recording) current,
          ];

          return CustomPaint(
            foregroundPainter: VoiceRecordingProgressPainter(
              ranges: _calcOffset(
                recordings,
                state.recordDuration,
              ),
            ),
            child: childWidget,
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox.expand(),
        ),
      ),
    );
  }
}

List<RangeValue> _calcOffset(
  List<VoiceRecording> recordings,
  Duration tDuration,
) {
  return [
    for (final recording in recordings)
      RangeValue(
        start: recording.range.start.inMilliseconds / tDuration.inMilliseconds,
        end: recording.range.end.inMilliseconds / tDuration.inMilliseconds,
      ),
  ];
}

class VoiceRecordingProgressPainter extends CustomPainter {
  VoiceRecordingProgressPainter({super.repaint, required this.ranges});

  final List<RangeValue> ranges;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = AppPalette.red;

    for (final range in ranges) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(
            range.start * size.width + 2,
            2,
            range.end * size.width,
            size.height - 2,
          ),
          const Radius.circular(8),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
