// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core/utils/duration.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/screens/video/player_view_controller.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'player_actions_control.dart';
import 'player_autoplay_switch.dart';
import 'player_cast_caption_control.dart';
import 'player_chapters_control.dart';
import 'player_description.dart';
import 'player_duration_control.dart';
import 'player_fullscreen.dart';
import 'player_loading.dart';
import 'player_minimize.dart';
import 'player_next.dart';
import 'player_notifications.dart';
import 'player_play_pause_restart.dart';
import 'player_previous.dart';
import 'player_rotate.dart';
import 'player_seek_slide_frame.dart';
import 'player_settings.dart';
import 'player_unlock.dart';
import 'seek_indicator.dart';

const double kSlideFrameHeight = 80;
const double kMaxVerticalDrag = kSlideFrameHeight / 2;

class PlayerOverlayControls extends ConsumerStatefulWidget {
  const PlayerOverlayControls({super.key});

  @override
  ConsumerState<PlayerOverlayControls> createState() =>
      _PlayerOverlayControlsState();
}

class _PlayerOverlayControlsState extends ConsumerState<PlayerOverlayControls>
    with TickerProviderStateMixin {
  late PlayerViewController viewController;

  late final AnimationController _slideFrameController;

  bool _controlsHidden = true;

  /// Flag to track whether the long press has started
  bool _startedOnLongPress = false;

  /// Y position of user pointer when long press action starts
  double _longPressYStartPosition = 0;

  /// Timer used for hiding `Release` message while slide seeking.
  Timer? _releaseTimer;

  late final _controlMessageController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  final ValueNotifier<String> _latestControlMessage = ValueNotifier<String>('');
  Timer? _controlMessageTimer;

  /// Whether it was playing
  bool wasPlaying = false;

  late Animation<double> _slideFrameAnimation;
  @override
  void initState() {
    super.initState();
    _slideFrameController = AnimationController(
      vsync: this,
      value: 0,
      duration: const Duration(milliseconds: 300),
    );

    _slideFrameAnimation = CurvedAnimation(
      parent: _slideFrameController,
      curve: Curves.easeInToLinear,
    );
  }

  StreamSubscription<PlayerSignal>? _playerSignalSubscription;
  Timer? _showUnlockTimer;

  @override
  void didChangeDependencies() {
    viewController = context.provide<PlayerViewController>();

    Future.microtask(() {
      final playerRepo = ref.read(playerRepositoryProvider);
      _playerSignalSubscription ??= playerRepo.playerSignalStream.listen(
        _onPlayerSignalEvent,
      );
    });
    super.didChangeDependencies();
  }

  void _onPlayerSignalEvent(signal) async {
    if (signal == PlayerSignal.autoplay) {
      _controlMessageTimer?.cancel(); // Cancels previous timer

      final value = ref.read(preferencesProvider).autoplay ? 'on' : 'off';
      _latestControlMessage.value = 'Autoplay is $value';
      _controlMessageController.forward();
      _controlMessageTimer = Timer(const Duration(seconds: 4), () async {
        await _controlMessageController.reverse();

        _latestControlMessage.value = '';
        _controlMessageTimer?.cancel();
        _controlMessageTimer = null;
      });
    }
  }

  @override
  void dispose() {
    _controlMessageTimer?.cancel();
    _latestControlMessage.dispose();
    _playerSignalSubscription?.cancel();
    _showUnlockTimer?.cancel();
    _slideFrameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        NotifierSelector(
          notifier: viewController,
          selector: (state) => state.seekState,
          builder: (
            BuildContext context,
            PlayerSeekState seekState,
            Widget? _,
          ) {
            return _DoubleTapSeekIndicator(seekState: seekState);
          },
        ),
        AnimatedVisibility(
          animation: _slideFrameAnimation,
          child: const ColoredBox(
            color: Colors.black54,
            child: SizedBox.expand(),
          ),
        ),
        GestureDetector(
          onLongPressEnd: _onLongPressEnd,
          onDoubleTapDown: _onDoubleTapDown,
          onLongPressStart: _onLongPressStart,
          onLongPressMoveUpdate: _onLongPressMoveUpdate,
          child: Container(
            color: Colors.transparent,
            height: double.infinity,
            width: double.infinity,
            child: AnimatedVisibility(
              animation: viewController.controlsAnimation,
              child: const ColoredBox(
                color: Colors.black54,
                child: SizedBox.expand(),
              ),
            ),
          ),
        ),
        AnimatedVisibility(
          animation: viewController.controlsAnimation,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.topCenter,
                    child: _TopControlV2(),
                  ),
                  NotifierSelector(
                    notifier: viewController,
                    selector: (state) => state.controlMessage,
                    builder: (
                      BuildContext context,
                      String? value,
                      Widget? _,
                    ) {
                      return AnimatedValuedVisibility(
                        visible: value != null,
                        alignment: Alignment.center,
                        child: Text(
                          _latestControlMessage.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Center(child: _MiddleControl()),
              // Shows loading indicator, regardless if controls are shown/hidden
              const Center(child: PlayerLoadingIndicator()),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: AnimatedVisibility(
                      animation: _slideFrameAnimation,
                      child: const _SlideFramePlayButton(),
                    ),
                  ),
                  const _OverlayDurationOrientation(),
                  const _OverlayProgress(),
                  PlayerSeekSlideFrame(
                    frameHeight: kSlideFrameHeight,
                    sizeAnimation: _slideFrameAnimation,
                  ),
                  const _OverlayVideoSuggestions(),
                ],
              ),
            ],
          ),
        ),
        NotifierSelector(
          notifier: viewController,
          selector: (state) => state.seekState.type,
          builder: (
            BuildContext context,
            SeekType seekType,
            Widget? _,
          ) {
            return SeekIndicator(type: seekType);
          },
        ),
        NotifierSelector(
          notifier: viewController,
          selector: (state) => state.seekState.duration,
          builder: (
            BuildContext context,
            Duration duration,
            Widget? _,
          ) {
            return AnimatedValuedVisibility(
              visible: duration != Duration.zero,
              alignment: Alignment.bottomCenter,
              child: const _OverlaySeekDuration(),
            );
          },
        ),
        NotifierSelector(
          notifier: viewController,
          selector: (state) => state.isControlsLocked && state.showUnlock,
          builder: (BuildContext context, bool show, Widget? _) {
            return AnimatedValuedVisibility(
              visible: show,
              alignment: const Alignment(0, .7),
              child: const PlayerUnlock(),
            );
          },
        ),
      ],
    );
  }

  void _onDoubleTapDown(TapDownDetails details) {
    if (viewController.isControlsLocked) return;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isForward = details.localPosition.dx > (screenWidth / 2);
    final isRewind = details.localPosition.dx < (screenWidth / 2);

    if (isForward) {
      ForwardSeekPlayerNotification().dispatch(context);
    } else if (isRewind) {
      RewindSeekPlayerNotification().dispatch(context);
    }
  }

  void _onLongPressStart(LongPressStartDetails details) {
    if (viewController.isControlsLocked) return;

    _longPressYStartPosition = details.localPosition.dy;

    _startedOnLongPress = true;

    final isPlaying = ref.read(playerNotifierProvider).playing;
    final isLoading = ref.read(playerNotifierProvider).loading;

    if (isLoading) return;
    if (isPlaying) {
      Forward2xSpeedStartPlayerNotification().dispatch(context);
    } else {
      SlideSeekStartPlayerNotification().dispatch(context);
    }
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    if (!_startedOnLongPress) return;

    _longPressYStartPosition = 0;
    _startedOnLongPress = false;

    final isPlaying = viewController.playerState.playing;
    final hasEnded = viewController.playerState.ended;

    if (isPlaying && !hasEnded) {
      Forward2xSpeedEndPlayerNotification().dispatch(context);
    } else {
      // Whether to keep slide frame
      if (_slideFrameController.value > 0.7) {
        _slideFrameController.forward();
      } else {
        _slideFrameController.reverse();
        SlideSeekEndPlayerNotification().dispatch(context);
      }
    }
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (viewController.isControlsLocked) return;

    final isLoading = ref.read(playerNotifierProvider).loading;
    if (isLoading) return;
    final PlayerSeekState seekState = viewController.seekState;
    if (seekState.type.isSlideSeeking) {
      const fullDuration = Duration(seconds: 60);
      final totalMilliseconds = fullDuration.inMilliseconds;

      final localY = details.localPosition.dy;
      final screenWidth = MediaQuery.sizeOf(context).width;

      if (seekState.type.isSlideFrame == false) {
        final bound = Duration(microseconds: (totalMilliseconds * 0.1).floor());

        final localDeltaX = details.localOffsetFromOrigin.dx;
        final value = ((localDeltaX / screenWidth) * totalMilliseconds).floor();

        final nextDuration =
            (seekState.duration + Duration(microseconds: value)).clamp(
          Duration.zero,
          fullDuration,
        );

        SlideSeekUpdatePlayerNotification(
          duration: nextDuration,
          showRelease: _checkOutOfBound(
            nextDuration,
            seekState.startDuration + bound,
            seekState.startDuration - bound,
          ),
        ).dispatch(context);
        // Updates and locks progress from video
        // TODO ref.read(playerRepositoryProvider).updatePosition(_slideSeekDuration);
      }

      if (_longPressYStartPosition - localY >= kMaxVerticalDrag ||
          seekState.type.isSlideFrame) {
        _updateSlideFrameController(
          (_longPressYStartPosition - localY) / kSlideFrameHeight,
        );
      }
    }
  }

  void _updateSlideFrameController(double value) {
    // TODO
    // if (!_seekIndicatorNotifier.value.isSlideSeeking) {
    //   HapticFeedback.selectionClick();
    // }
    // _seekIndicatorNotifier.value = value < kMaxVerticalDrag / kSlideFrameHeight
    //     ? SeekType.slideLeftOrRight
    //     : SeekType.slideFrame;
    // _seekIndicatorController.forward();
    // _slideFrameController.value = value;
  }
}

bool _checkOutOfBound(
    Duration nextDuration, Duration upperBound, Duration lowerBound) {
  // Send a vibration feedback when going in or out of lower and upper bound
  if (nextDuration > upperBound) {
    if (nextDuration < upperBound) {
      HapticFeedback.selectionClick();
      return true;
    }
  } else if (nextDuration < upperBound) {
    if (nextDuration > upperBound) {
      HapticFeedback.selectionClick();
      return true;
    }
  }

  return false;
}

class _DoubleTapSeekIndicator extends StatefulWidget {
  const _DoubleTapSeekIndicator({required this.seekState});
  final PlayerSeekState seekState;

  @override
  State<_DoubleTapSeekIndicator> createState() =>
      _DoubleTapSeekIndicatorState();
}

class _DoubleTapSeekIndicatorState extends State<_DoubleTapSeekIndicator> {
  SeekType _lastType = SeekType.none;
  int _lastRate = 0;

  @override
  void didUpdateWidget(covariant _DoubleTapSeekIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seekState.type != widget.seekState.type &&
        widget.seekState.type.isDoubleTap) {
      _lastType = widget.seekState.type;
    }
    if (widget.seekState.rate > 0) {
      _lastRate = widget.seekState.rate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isForward = widget.seekState.type == SeekType.doubleTapRight ||
        _lastType == SeekType.doubleTapRight;
    return AnimatedValuedVisibility(
      visible: widget.seekState.type.isDoubleTap,
      duration: const Duration(milliseconds: 300),
      alignment: isForward ? Alignment.centerRight : Alignment.centerLeft,
      child: LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          return ClipPath(
            clipper: SeekIndicatorClipper(forward: isForward),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: constraints.maxWidth / 2,
              decoration: const BoxDecoration(color: Colors.black12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(isForward ? Icons.fast_forward : Icons.fast_rewind),
                  const SizedBox(height: 8),
                  Text('${isForward ? '' : '-'}$_lastRate seconds'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OverlaySeekDuration extends ConsumerWidget {
  const _OverlaySeekDuration();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(24),
      ),
      child: StreamBuilder<Progress>(
        initialData: Progress.zero,
        stream: ref.read(playerRepositoryProvider).videoProgressStream,
        builder: (context, snapshot) {
          return Text(
            snapshot.data!.position.hoursMinutesSeconds,
          );
        },
      ),
    );
  }
}

class _OverlayProgress extends StatefulWidget {
  const _OverlayProgress();

  @override
  State<_OverlayProgress> createState() => _OverlayProgressState();
}

class _OverlayProgressState extends State<_OverlayProgress> {
  late PlayerViewController viewController;
  bool wasPlaying = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewController = context.provide<PlayerViewController>();
  }

  /// When PlaybackProgress is tapped to change the position of currently playing
  /// video.
  void _onTap(Duration position) {
    if (viewController.isControlsLocked) return;
    viewController.seekTo(position);
  }

  void _onDragStart(Duration position) {
    if (viewController.isControlsLocked) return;
    wasPlaying = viewController.playerState.playing;
    if (wasPlaying) {
      viewController.pauseVideo();
    }
    SlideSeekStartPlayerNotification().dispatch(context);
  }

  void _onDragEnd() {
    if (viewController.isControlsLocked) return;

    // TODO Close SlideFrame

    SlideSeekEndPlayerNotification().dispatch(context);
    if (wasPlaying) viewController.playVideo();
    wasPlaying = false;
  }

  void _onVerticalDrag(double yOffset) {
    if (viewController.isControlsLocked) return;

    if (yOffset > 0 && yOffset <= kSlideFrameHeight) {
      // TODO _updateSlideFrameController(yOffset.abs() / kSlideFrameHeight);
    }
  }

  void _onVerticalDragEnd() {
    if (viewController.isControlsLocked) return;

    // Whether to keep slide frame
    // TODO
    // if (_showingSlideFrame && _slideFrameController.value > 0.7) {
    //   // TODO _slideFrameController.forward();
    // } else {
    //   _onEndAnySlideSeek();
    // }
  }

  void _onVerticalDragStart() {
    if (viewController.isControlsLocked) return;
    SlideSeekStartPlayerNotification(lockProgress: true).dispatch(context);
  }

  /// Callback for when Video position is changed from the PlaybackProgress indicator
  void _onChangePosition(Duration position) {
    if (viewController.isControlsLocked) return;
    final startDuration = viewController.seekState.startDuration;
    final totalMicroseconds = viewController.videoDuration.inMicroseconds;
    final bound = Duration(microseconds: (totalMicroseconds * 0.1).floor());
    // Updates and locks progress from video
    SlideSeekUpdatePlayerNotification(
      duration: position,
      showRelease: _checkOutOfBound(
        position,
        startDuration + bound,
        startDuration - bound,
      ),
    ).dispatch(context);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: NotifierSelector(
        notifier: viewController,
        selector: (state) => (
          state.isControlsVisible && state.showPlaybackProgress,
          state.boxProp.isExpanded
        ),
        builder: (BuildContext context, (bool, bool) value, Widget? _) {
          return CustomOrientationBuilder(
            onLandscape: (BuildContext context, Widget? childWidget) {
              return AnimatedValuedVisibility(
                visible: value.$1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: childWidget,
                ),
              );
            },
            onPortrait: (BuildContext context, Widget? progressWidget) {
              return Row(
                children: [
                  AnimatedValuedVisibility(
                    visible: value.$1 && value.$2,
                    child: const PlayPauseRestartControl(
                      useControlButton: false,
                    ),
                  ),
                  Expanded(
                    child: AnimatedValuedVisibility(
                      visible: value.$1 && value.$2,
                      child: progressWidget,
                    ),
                  ),
                  AnimatedValuedVisibility(
                    visible: value.$1 && value.$2,
                    child: Row(
                      children: [
                        SizedBox(width: 12.w),
                        const PlayerDurationControl(
                          full: false,
                          reversed: true,
                        ),
                        SizedBox(width: 12.w),
                      ],
                    ),
                  ),
                ],
              );
            },
            child: PlaybackProgress(
              animation: viewController.controlsAnimation,
              alignment: value.$2 ? Alignment.center : Alignment.bottomCenter,
              progress: viewController.videoProgressStream,
              // TODO(Josh4500): Revisit this code
              start: viewController.videoProgress ?? Progress.zero,
              // TODO(Josh4500): Get ready value
              end: const Duration(minutes: 1),
              onTap: _onTap,
              onDragStart: _onDragStart,
              onChangePosition: _onChangePosition,
              onDragEnd: _onDragEnd,
              onVerticalDrag: _onVerticalDrag,
              onVerticalDragStart: _onVerticalDragStart,
              onVerticalDragEnd: _onVerticalDragEnd,
            ),
          );
        },
      ),
    );
  }
}

class _TopOrientationControl extends ConsumerWidget {
  const _TopOrientationControl();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(
      playerViewStateProvider.select((state) => state.isExpanded),
    );

    return Row(
      children: [
        if (context.orientation.isPortrait && !isExpanded)
          const PlayerMinimize()
        else ...[
          const PlayerFullscreen(),
          const PlayerRotateControl(),
        ],
      ],
    );
  }
}

class _TopControlV2 extends StatelessWidget {
  const _TopControlV2();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TopOrientationControl(),
        Spacer(),
        PlayerAutoplaySwitch(),
        PlayerCastCaptionControl(),
        PlayerSettings(),
      ],
    );
  }
}

class _MiddleControl extends StatelessWidget {
  const _MiddleControl();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = math.min(size.width, size.height);
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: width),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PlayerPrevious(),
          PlayPauseRestartControl(),
          PlayerNext(),
        ],
      ),
    );
  }
}

class _SlideFramePlayButton extends StatelessWidget {
  const _SlideFramePlayButton();
  @override
  Widget build(BuildContext context) {
    void onClose() {
      SlideSeekEndPlayerNotification().dispatch(context);
    }

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: onClose,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(YTIcons.close_outlined, size: 16),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onClose,
            // TODO ref.read(playerRepositoryProvider).playVideo();

            child: Container(
              constraints: BoxConstraints.tightFor(
                width: 54.w,
                height: 54.w,
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                YTIcons.play_arrow,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OverlayVideoSuggestions extends StatelessWidget {
  const _OverlayVideoSuggestions();

  @override
  Widget build(BuildContext context) {
    final viewController = context.provide<PlayerViewController>();

    return NotifierSelector(
      notifier: viewController,
      selector: (state) {
        return (state.boxProp.isExpanded || state.isFullscreen) &&
            state.isControlsVisible;
      },
      builder: (
        BuildContext context,
        bool visible,
        Widget? _,
      ) {
        final isLandscape = context.orientation.isLandscape;
        return AnimatedValuedVisibility(
          visible: visible,
          child: Row(
            children: [
              if (isLandscape) ...[
                Row(
                  children: [
                    const PlayPauseRestartControl(useControlButton: false),
                    SizedBox(width: 8.w),
                    const PlayerDurationControl(full: false, reversed: true),
                  ],
                ),
                const Spacer(),
              ],
              const PlayerMoreVideos(),
              if (context.orientation.isPortrait) ...[
                const Spacer(),
                const RotatedBox(
                  quarterTurns: 2,
                  child: PlayerMinimize(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _OverlayDurationOrientation extends StatelessWidget {
  const _OverlayDurationOrientation();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? _) {
        final isExpanded = ref.watch(
          playerViewStateProvider.select((state) => state.isExpanded),
        );
        if (context.orientation.isPortrait && !isExpanded) {
          return const Row(
            children: [
              PlayerDurationControl(),
              PlayerChapterControl(),
              Spacer(),
              PlayerFullscreen(),
            ],
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: PlayerDescriptionV2(
                  showOnFullscreen: context.orientation.isLandscape,
                  showOnExpanded: isExpanded,
                ),
              ),
              SizedBox(width: 24.w),
              if (context.orientation.isLandscape)
                const Expanded(
                  child: PlayerActionsControlV2(),
                )
              else
                const PlayerActionsControlV2(direction: Axis.vertical),
            ],
          );
        }
      },
    );
  }
}
