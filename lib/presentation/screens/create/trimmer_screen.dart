import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/core/utils/normalization.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/screens/create/provider/shorts_create_state.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'provider/short_recording_state.dart';
import 'widgets/create_close_button.dart';
import 'widgets/create_progress.dart';
import 'widgets/editor/editor_timeline.dart';

class TrimmerScreen extends ConsumerStatefulWidget {
  const TrimmerScreen({super.key});

  @override
  ConsumerState<TrimmerScreen> createState() => _TrimmerScreenState();
}

class _TrimmerScreenState extends ConsumerState<TrimmerScreen> {
  final ValueNotifier<bool> _trimmingNotifier = ValueNotifier<bool>(
    false,
  );
  final ValueNotifier<int> _selectedRecording = ValueNotifier<int>(0);
  final _progressNotifier = ValueNotifier<Alignment>(
    Alignment.centerLeft,
  );

  // TODO(josh4500): Rename
  double _trimTime = 0.0;
  final TrimController _trimHistoryController = TrimController();
  final _trimExpandNotifier = ValueNotifier<bool>(false);
  final _trimProgressNotifier = ValueNotifier<Alignment>(
    Alignment.centerLeft,
  );

  @override
  void dispose() {
    _trimHistoryController.dispose();
    _progressNotifier.dispose();
    _trimExpandNotifier.dispose();
    _trimProgressNotifier.dispose();
    _trimmingNotifier.dispose();
    super.dispose();
  }

  void onTapThumbnail(Recording recording) {
    _trimTime = recording.duration.inMilliseconds / 1000;
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

    final shortsRecordingState = ref.read(shortRecordingProvider);
    final recordings = shortsRecordingState.recordings;
    final tDuration = shortsRecordingState.duration;

    if (recordings.isNotEmpty) {
      final currentTime = value * tDuration.inSeconds;
      double elapsed = 0;

      for (int i = 0; i <= shortsRecordingState.recordings.length; i++) {
        final recording = shortsRecordingState.recordings[i];
        elapsed += recording.duration.inSeconds;
        if (currentTime <= elapsed) {
          _selectedRecording.value = i;
          break;
        }
      }
    }
  }

  void _setTrimProgress(double value) {
    _trimProgressNotifier.value = Alignment(
      value.normalizeRange(-1, 1),
      0,
    );
  }

  void _undoTrim() {
    _trimHistoryController.undo();
    _setTrimProgress(_trimHistoryController.current.start);
  }

  void _redoTrim() {
    _trimHistoryController.redo();
    _setTrimProgress(_trimHistoryController.current.start);
  }

  bool handleTrimmerNotification(
    TrimmerNotification notification,
    BoxConstraints constraints,
  ) {
    if (notification is TrimmerDragUpdateNotification) {
      final position = notification.position;
      final range = notification.range;

      if (position != TrimDragPosition.none) {
        _setTrimProgress(position.isLeft ? range.start : range.end);
      } else {
        _setTrimProgress(
          (notification.details.xPosition / notification.details.width)
              .clamp(range.start, range.end),
        );
      }
    } else if (notification is TrimmerLongPressNotification) {
      final position = notification.position;
      final range = notification.range;
      _setTrimProgress(position.isLeft ? range.start : range.end);
      _trimExpandNotifier.value = true;
    } else if (notification is TrimmerEndNotification) {
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
            Consumer(
              builder: (
                BuildContext context,
                WidgetRef ref,
                Widget? _,
              ) {
                final isEditing = ref.watch(
                  shortsCreateProvider.select(
                    (state) => state.isEditing,
                  ),
                );
                if (isEditing) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CreateCloseButton(
                        color: Colors.white10,
                        highlightColor: Colors.white38,
                      ),
                      NotifierSelector(
                        notifier: _trimHistoryController,
                        selector: (state) => state.canUndo || state.canRedo,
                        builder: (
                          BuildContext context,
                          bool canDelete,
                          Widget? _,
                        ) {
                          if (!canDelete) return const SizedBox();
                          return _DeleteTrimButton(
                            onTap: () {
                              _trimmingNotifier.value = false;
                              _trimHistoryController.clear();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
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
                              // TODO(josh4500): Make indicator be placed in after and before
                              // Range's start and end respectively
                              RepaintBoundary(
                                child: InterimProgressIndicator(
                                  width: 6,
                                  alignment: _trimProgressNotifier,
                                ),
                              ),
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
                                  child: Trimmer(
                                    controller: _trimHistoryController,
                                    child: const DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                      ),
                                      child: SizedBox.expand(),
                                    ),
                                  ),
                                ),
                              ),
                              ListenableBuilder(
                                listenable: _trimHistoryController,
                                builder: (
                                  BuildContext context,
                                  Widget? _,
                                ) {
                                  final range = _trimHistoryController.current;
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
                        height: 56,
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
                                    child: ValueListenableBuilder(
                                      valueListenable: _selectedRecording,
                                      builder: (
                                        BuildContext context,
                                        int selected,
                                        Widget? _,
                                      ) {
                                        return _RecordingThumbnail(
                                          key: GlobalObjectKey(index),
                                          recording: recording,
                                          selected: selected == index,
                                        );
                                      },
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
                  Consumer(
                    builder: (
                      BuildContext context,
                      WidgetRef ref,
                      Widget? _,
                    ) {
                      final isEditing = ref.watch(
                        shortsCreateProvider.select(
                          (state) => state.isEditing,
                        ),
                      );
                      if (isEditing) {
                        return const SizedBox();
                      }
                      return ListenableBuilder(
                        listenable: _trimmingNotifier,
                        builder: (
                          BuildContext context,
                          Widget? _,
                        ) {
                          if (!_trimmingNotifier.value) {
                            return const SizedBox();
                          }
                          return NotifierSelector(
                            notifier: _trimHistoryController,
                            selector: (state) => (
                              _trimHistoryController.canUndo,
                              _trimHistoryController.canRedo
                            ),
                            builder: (
                              BuildContext context,
                              (bool, bool) state,
                              Widget? _,
                            ) {
                              return Row(
                                children: [
                                  GestureDetector(
                                    onTap: _undoTrim,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: state.$1
                                            ? Colors.white10
                                            : Colors.white.withOpacity(0.01),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        YTIcons.undo_arrow,
                                        color: state.$1
                                            ? Colors.white
                                            : Colors.white24,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: _redoTrim,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: state.$2
                                            ? Colors.white10
                                            : Colors.white.withOpacity(0.01),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        YTIcons.redo_arrow,
                                        color: state.$2
                                            ? Colors.white
                                            : Colors.white24,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  const Spacer(),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () {
                      if (_trimmingNotifier.value) {
                        // TODO(josh4500): Process edits
                        _trimmingNotifier.value = false;
                        _trimHistoryController.clear();
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

class _DeleteTrimButton extends StatelessWidget {
  const _DeleteTrimButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      onTap: onTap,
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
    );
  }
}

class _RecordingThumbnail extends StatelessWidget {
  const _RecordingThumbnail({
    super.key,
    this.selected = false,
    required this.recording,
  });
  final bool selected;
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
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  (recording.duration.inMilliseconds / 1000).toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    shadows: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
