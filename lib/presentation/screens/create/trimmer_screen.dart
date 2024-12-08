import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/core.dart';
import 'package:youtube_clone/core/utils/normalization.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'provider/short_recording_state.dart';
import 'widgets/create_close_button.dart';
import 'widgets/create_progress.dart';
import 'widgets/editor/editor_timeline.dart';

class TrimmerScreen extends StatefulWidget {
  const TrimmerScreen({super.key});

  @override
  State<TrimmerScreen> createState() => _TrimmerScreenState();
}

class _TrimmerScreenState extends State<TrimmerScreen> {
  final ValueNotifier<bool> _trimmingNotifier = ValueNotifier<bool>(
    false,
  );

  final _progressNotifier = ValueNotifier<Alignment>(
    Alignment.centerLeft,
  );

  // TODO(josh4500): Rename
  double _trimTime = 0.0;
  final _trimExpandNotifier = ValueNotifier<bool>(false);
  final _trimRangeNotifier = ValueNotifier<RangeValue>(
    RangeValue.zero,
  );
  final _trimProgressNotifier = ValueNotifier<Alignment>(
    Alignment.centerLeft,
  );

  @override
  void dispose() {
    _progressNotifier.dispose();
    _trimExpandNotifier.dispose();
    _trimRangeNotifier.dispose();
    _trimProgressNotifier.dispose();
    _trimmingNotifier.dispose();
    super.dispose();
  }

  void onTapThumbnail(Recording recording) {
    _trimTime = recording.duration.inMilliseconds / 1000;
    _trimRangeNotifier.value = const RangeValue(start: 0, end: 1);
    _trimmingNotifier.value = true;
  }

  void handleDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    final value = details.localPosition.dx / constraints.maxWidth;
    _setProgress(value);
  }

  void _setProgress(double value) {
    _progressNotifier.value = Alignment(
      value.clamp(0, 1).normalizeRange(-1, 1),
      0,
    );
  }

  bool handleTrimmerNotification(
    TrimmerNotification notification,
    BoxConstraints constraints,
  ) {
    if (notification is TrimmerDragUpdateNotification) {
      final position = notification.position;
      final range = notification.range;

      if (position != TrimDragPosition.none) {
        _trimProgressNotifier.value = Alignment(
          (position.isLeft ? range.start : range.end).normalizeRange(-1, 1),
          0,
        );
      } else {
        _trimProgressNotifier.value = Alignment(
          (notification.details.xPosition / notification.details.width)
              .clamp(range.start, range.end)
              .normalizeRange(-1, 1),
          0,
        );
      }
      _trimRangeNotifier.value = notification.range;
    } else if (notification is TrimmerLongPressNotification) {
      final position = notification.position;
      final range = notification.range;
      _trimProgressNotifier.value = Alignment(
        (position.isLeft ? range.start : range.end).normalizeRange(-1, 1),
        0,
      );
      _trimExpandNotifier.value = true;
      _trimRangeNotifier.value = notification.range;
    } else if (notification is TrimmerEndNotification) {
      _trimRangeNotifier.value = notification.range;
      _trimExpandNotifier.value = false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: CreateProgress(),
            ),
            // TODO(josh4500): Only show while still recording
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CreateCloseButton(
                    color: Colors.white10,
                  ),
                  CustomInkWell(
                    borderRadius: BorderRadius.circular(24),
                    splashFactory: NoSplash.splashFactory,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white10,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        YTIcons.delete_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(
                      color: Colors.white10,
                    ),
                    Center(
                      child: AnimatedIcon(
                        icon: AnimatedIcons.pause_play,
                        size: 56,
                        progress: AlwaysStoppedAnimation(1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            LayoutBuilder(
              builder: (
                BuildContext context,
                BoxConstraints constraints,
              ) {
                return ValueListenableBuilder(
                  valueListenable: _trimmingNotifier,
                  builder: (
                    BuildContext context,
                    bool trimming,
                    Widget? _,
                  ) {
                    if (trimming) {
                      return SizedBox(
                        height: 64,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                          child: Stack(
                            children: [
                              ValueListenableBuilder(
                                valueListenable: _trimExpandNotifier,
                                builder: (
                                  BuildContext context,
                                  bool expand,
                                  Widget? childWidget,
                                ) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: expand ? 0 : 4,
                                    ),
                                    child: childWidget,
                                  );
                                },
                                child:
                                    NotificationListener<TrimmerNotification>(
                                  onNotification: (notification) =>
                                      handleTrimmerNotification(
                                    notification,
                                    constraints,
                                  ),
                                  child: const Trimmer(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                      ),
                                      child: SizedBox.expand(),
                                    ),
                                  ),
                                ),
                              ),
                              ValueListenableBuilder(
                                valueListenable: _trimRangeNotifier,
                                builder: (
                                  BuildContext context,
                                  RangeValue range,
                                  Widget? _,
                                ) {
                                  return Align(
                                    alignment: Alignment(
                                      ((range.distance / 2) + range.start)
                                          .normalizeRange(-1, 1),
                                      0,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${(_trimTime * range.distance).toStringAsPrecision(2)}s',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // TODO(josh4500): Make indicator be placed in after and before
                              // Range's start and end respectively
                              RepaintBoundary(
                                child: InterimProgressIndicator(
                                  width: 6,
                                  alignment: _trimProgressNotifier,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) => handleDragUpdate(
                          details,
                          constraints,
                        ),
                        child: SizedBox(
                          height: 56,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 4,
                                ),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const SizedBox.expand(),
                                ),
                              ),
                              RepaintBoundary(
                                child: InterimProgressIndicator(
                                  width: 6,
                                  alignment: _progressNotifier,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: _trimmingNotifier,
              builder: (
                BuildContext context,
                bool trimming,
                Widget? _,
              ) {
                if (trimming) return const SizedBox();
                return ScrollConfiguration(
                  behavior: const NoScrollGlowBehavior(),
                  child: LayoutBuilder(
                    builder: (
                      BuildContext context,
                      BoxConstraints constraints,
                    ) {
                      return SizedBox(
                        height: 80,
                        width: constraints.maxWidth,
                        child: Center(
                          child: Consumer(
                            builder: (
                              BuildContext context,
                              WidgetRef ref,
                              Widget? _,
                            ) {
                              final state = ref.watch(
                                shortRecordingProvider,
                              );
                              return ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 8,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (
                                  BuildContext context,
                                  int index,
                                ) {
                                  final recording = state.recordings[index];
                                  return GestureDetector(
                                    onTap: () => onTapThumbnail(recording),
                                    child: _RecordingThumbnail(
                                      key: GlobalObjectKey(index),
                                      recording: recording,
                                    ),
                                  );
                                },
                                itemCount: state.recordings.length,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 24,
              ),
              child: Row(
                children: [
                  ...[
                    ValueListenableBuilder(
                      valueListenable: _trimmingNotifier,
                      builder: (
                        BuildContext context,
                        bool trimming,
                        Widget? _,
                      ) {
                        return Text(
                          trimming
                              ? 'Adjust the length of the clip'
                              : 'Tap thumbnail to edit',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                  ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white10,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        YTIcons.undo_arrow,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white10,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        YTIcons.redo_arrow,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ],
                  const Spacer(),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () {
                      if (_trimmingNotifier.value) {
                        // TODO(josh4500): Process edits
                        _trimmingNotifier.value = false;
                      } else {
                        // TODO(josh4500): Process edits
                        context.pop();
                      }
                    },
                    label: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                      splashFactory: NoSplash.splashFactory,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordingThumbnail extends StatelessWidget {
  const _RecordingThumbnail({super.key, required this.recording});

  final Recording recording;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 42,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            (recording.duration.inMilliseconds / 1000).toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
