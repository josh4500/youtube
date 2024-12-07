import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/core/utils/normalization.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'provider/short_recording_state.dart';
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

  @override
  void dispose() {
    _progressNotifier.dispose();
    _trimmingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: CreateProgress(),
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
            ValueListenableBuilder(
              valueListenable: _trimmingNotifier,
              builder: (
                BuildContext context,
                bool trimming,
                Widget? _,
              ) {
                if (trimming) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Trimmer(),
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12,
                      ),
                      child: SizedBox(
                        height: 56,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: LayoutBuilder(
                            builder: (
                              BuildContext context,
                              BoxConstraints constraints,
                            ) {
                              return GestureDetector(
                                onHorizontalDragUpdate:
                                    (DragUpdateDetails details) {
                                  final value = details.localPosition.dx /
                                      constraints.maxWidth;
                                  _progressNotifier.value = Alignment(
                                    value.normalizeRange(-1, 1),
                                    0,
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                      ),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.white10,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const SizedBox.expand(),
                                      ),
                                    ),
                                    InterimProgressIndicator(
                                      width: 6,
                                      alignment: _progressNotifier,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    ScrollConfiguration(
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
                                        onTap: () {
                                          _trimmingNotifier.value = true;
                                        },
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
                    ),
                  ],
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
                  Expanded(
                    child: ValueListenableBuilder(
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
                        );
                      },
                    ),
                  ),
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
