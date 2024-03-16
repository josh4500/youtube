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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core/constants/constants.dart';
import 'package:youtube_clone/core/progress.dart';
import 'package:youtube_clone/core/utils/duration.dart';
import 'package:youtube_clone/presentation/constants/values.dart';
import 'package:youtube_clone/presentation/preferences.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/screens/player/providers/player_expanded_state_provider.dart';
import 'package:youtube_clone/presentation/provider/state/player_state_provider.dart';
import 'package:youtube_clone/presentation/screens/player/providers/player_viewstate_provider.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/controls/player_settings.dart';
import 'package:youtube_clone/presentation/theme/device_theme.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../player/player_notifications.dart';
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
import 'player_play_pause_restart.dart';
import 'player_previous.dart';
import 'player_seek_slide_frame.dart';
import 'seek_indicator.dart';

class PlayerOverlayControls extends ConsumerStatefulWidget {
  const PlayerOverlayControls({super.key});

  @override
  ConsumerState<PlayerOverlayControls> createState() =>
      _PlayerOverlayControlsState();
}

class _PlayerOverlayControlsState extends ConsumerState<PlayerOverlayControls>
    with TickerProviderStateMixin {
  // Timer instance
  Timer? _controlHideTimer;
  late final AnimationController _controlsVisibilityController;
  late final Animation<double> _controlsAnimation;

  static const double slideFrameHeight = 80;

  final _showSlideFrame = ValueNotifier<bool>(false);
  late final AnimationController _slideFrameController;

  bool _controlsHidden = true;

  /// Flag to prevents control gestures
  ///   - Double tap
  bool _preventCommonControlGestures = false;

  /// Flag to track whether the long press has started
  bool _startedOnLongPress = false;

  /// Y position of user pointer when long press action starts
  double _longPressYPosition = 0;

  /// X position of user pointer when long press action starts
  //double _longPressXPosition = 0;

  /// Timer used for hiding `Release` message while slide seeking.
  Timer? _releaseTimer;

  /// Notifier for showing/hiding playback progress
  final _showPlaybackProgress = ValueNotifier<bool>(true);

  /// Animation controllers and animations for buffering and progress
  late final AnimationController _bufferController;
  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;
  late final Animation<Color?> _bufferAnimation;

  /// Latest duration of the playback
  Duration? _lastDuration;

  /// Upper bound value for sliding seek duration.
  ///
  /// Sends a vibration when user slides over this value
  Duration? _upperboundSlideDuration;

  /// Upper bound value for sliding seek duration
  ///
  /// Sends a vibration when user slides over this value
  Duration? _lowerboundSlideDuration;

  bool _showPullUp = false;
  final _showSlidingSeekIndicator = ValueNotifier<bool>(false);
  final _showSlidingReleaseIndicator = ValueNotifier<bool>(false);
  final _slidingSeekDuration = ValueNotifier<Duration?>(null);
  final _showSlidingSeekDuration = ValueNotifier<bool>(false);

  /// Notifiers and variables for forward seeking at 2x speed
  final _showForward2XIndicator = ValueNotifier<bool>(false);

  /// Rate of seeking on double tap
  final _seekRate = ValueNotifier<int>(0);

  /// Whether direction for seeking is forward.
  final _isForwardSeek = ValueNotifier<bool>(true);

  /// Notifier for showing double tap seek indicator
  late final AnimationController _showDoubleTapSeekIndicator;
  late final Animation<double> _showDoubleTapSeekAnimation;

  /// Whether sliding seek is active
  bool get _isSlidingSeek {
    return _showSlidingSeekIndicator.value || _showSlideFrame.value;
  }

  @override
  void initState() {
    super.initState();

    _controlsVisibilityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 225),
      reverseDuration: const Duration(milliseconds: 100),
    );

    _controlsAnimation = CurvedAnimation(
      parent: _controlsVisibilityController,
      curve: Curves.easeIn,
    );

    _slideFrameController = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 300),
    );

    _bufferController = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 225),
      reverseDuration: const Duration(milliseconds: 100),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 225),
      reverseDuration: const Duration(milliseconds: 100),
    );

    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInCubic,
      reverseCurve: Curves.easeOutCubic,
    );

    _bufferAnimation = ColorTween(
      begin: Colors.white38,
      end: Colors.transparent,
    ).animate(_bufferController);

    _showDoubleTapSeekIndicator = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 225),
    );

    _showDoubleTapSeekAnimation = CurvedAnimation(
      parent: _showDoubleTapSeekIndicator,
      curve: Curves.easeInCubic,
      reverseCurve: Curves.easeOutCubic,
    );

    // TODO: Use Orientation for condition
    Future(() {
      if (!ref.read(playerNotifierProvider).loading) {
        if (!ref.read(playerNotifierProvider).playing) {
          _controlsHidden = false;
          _controlsVisibilityController.value = 1;
        } else {
          _controlsHidden = true;
          _controlsVisibilityController.value = 0;
          _showPlaybackProgress.value = false;
        }
      }

      final playerRepo = ref.read(playerRepositoryProvider);
      _subscription = playerRepo.playerSignalStream.listen(
        (signal) async {
          if (signal == PlayerSignal.showControls) {
            final isExpanded =
                ref.read(playerRepositoryProvider).playerViewState.isExpanded;
            if (context.orientation.isLandscape || isExpanded) {
              _showPlaybackProgress.value = true;
            }

            _controlsHidden = false;
            _controlsVisibilityController.forward();
            _bufferController.reverse();

            _progressController.forward();

            // Cancels existing timer
            _controlHideTimer?.cancel();

            // Auto hide only when video is playing
            _controlHideTimer = Timer(const Duration(seconds: 3), () async {
              final isPlaying = ref.read(playerNotifierProvider).playing;
              if (isPlaying) {
                _controlsHidden = true;
                // Note: Hide progress indicator first before hiding main controls
                _progressController.reverse();

                // Reversing before sending signal, animates the reverse on
                // auto hide
                await _controlsVisibilityController.reverse();
                final isExpanded = ref
                    .read(playerRepositoryProvider)
                    .playerViewState
                    .isExpanded;
                // Hides PlaybackProgress
                if (mounted && context.orientation.isLandscape || isExpanded) {
                  _showPlaybackProgress.value = false;
                }

                ref
                    .read(playerRepositoryProvider)
                    .sendPlayerSignal([PlayerSignal.hideControls]);
              }
            });
          } else if (signal == PlayerSignal.hideControls) {
            _controlsHidden = true;
            _controlHideTimer?.cancel();
            _bufferController.forward();

            // Note: Hide progress indicator first before hiding main controls
            _progressController.reverse();

            // Reverse opacity without animation
            // NOTE: from: 0 messes up ColorTween for the progress indicator
            // _controlsVisibilityController is used for progress color indicator
            await _controlsVisibilityController.reverse(from: 0);

            final isExpanded =
                ref.read(playerRepositoryProvider).playerViewState.isExpanded;
            // Hides PlaybackProgress while in landscape mode, when controls are
            // hidden
            if (mounted && context.orientation.isLandscape || isExpanded) {
              _showPlaybackProgress.value = false;
            }
          } else if (signal == PlayerSignal.hidePlaybackProgress) {
            _showPlaybackProgress.value = false;
          } else if (signal == PlayerSignal.showPlaybackProgress) {
            _showPlaybackProgress.value = true;
          } else if (signal == PlayerSignal.minimize) {
            _preventCommonControlGestures = true;
          } else if (signal == PlayerSignal.maximize) {
            _preventCommonControlGestures = false;
          }
        },
      );
    });
  }

  StreamSubscription? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    _controlHideTimer?.cancel();
    _controlsVisibilityController.dispose();
    _showSlidingSeekIndicator.dispose();
    _showDoubleTapSeekIndicator.dispose();
    _showForward2XIndicator.dispose();
    _showSlidingSeekDuration.dispose();
    _slideFrameController.dispose();
    _bufferController.dispose();
    _showSlidingReleaseIndicator.dispose();
    _slidingSeekDuration.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SeekIndicator(
                  valueListenable: _showForward2XIndicator,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('2X'),
                      SizedBox(width: 4),
                      Icon(Icons.fast_forward),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.lerp(
                  Alignment.center,
                  Alignment.bottomCenter,
                  0.75,
                )!,
                child: ValueListenableBuilder(
                  valueListenable: _showSlideFrame,
                  builder: (_, show, __) {
                    if (show) return const SizedBox();
                    return SeekIndicator(
                      valueListenable: _showSlidingSeekDuration,
                      child: ValueListenableBuilder(
                        valueListenable: _slidingSeekDuration,
                        builder: (_, duration, __) {
                          return SizedBox(
                            child: duration != null
                                ? Text(duration.hoursMinutesSeconds)
                                : null,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              AnimatedBuilder(
                animation: _showDoubleTapSeekAnimation,
                builder: (context, childWidget) {
                  return Opacity(
                    opacity: _showDoubleTapSeekAnimation.value,
                    child: childWidget,
                  );
                },
                child: ValueListenableBuilder(
                  valueListenable: _isForwardSeek,
                  builder: (_, isForwardSeek, childWidget) {
                    return Align(
                      alignment: isForwardSeek
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ClipPath(
                        clipper: SeekIndicatorClipper(forward: isForwardSeek),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                          ),
                          width: MediaQuery.sizeOf(context).width / 2,
                          decoration: const BoxDecoration(
                            color: Colors.black12,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isForwardSeek)
                                const Icon(Icons.fast_forward)
                              else
                                const Icon(Icons.fast_rewind),
                              const SizedBox(height: 8),
                              ValueListenableBuilder(
                                valueListenable: _seekRate,
                                builder: (context, value, __) {
                                  return Text(
                                    '${isForwardSeek ? '' : '-'}$value seconds',
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _showSlidingReleaseIndicator,
                builder: (context, value, _) {
                  return AnimatedCrossFade(
                    firstChild: Align(
                      alignment: Alignment.topCenter,
                      child: SeekIndicator(
                        valueListenable: _showSlidingSeekIndicator,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _showPullUp
                                ? const Icon(Icons.expand_less)
                                : const Icon(Icons.linear_scale),
                            const SizedBox(width: 4),
                            Text(
                              _showPullUp
                                  ? 'Pull up for precise seeking'
                                  : 'Slide left or right to seek',
                            ),
                          ],
                        ),
                      ),
                    ),
                    secondChild: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 24,
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 16,
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: const Text('Release to cancel'),
                      ),
                    ),
                    crossFadeState: value
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 150),
                  );
                },
              ),
              GestureDetector(
                // onTap: _onTap,
                onDoubleTapDown: _onDoubleTapDown,
                onLongPressStart: _onLongPressStart,
                onLongPressEnd: _onLongPressEnd,
                onLongPressMoveUpdate: _onLongPressMoveUpdate,
                child: AnimatedBuilder(
                  animation: _controlsAnimation,
                  builder: (context, childWidget) {
                    return Container(
                      color: Colors.transparent,
                      height: double.infinity,
                      width: double.infinity,
                      child: ValueListenableBuilder(
                        valueListenable: _showSlideFrame,
                        builder: (_, showSlideFrame, __) {
                          return Visibility(
                            visible: _controlsAnimation.value != 0 &&
                                !showSlideFrame,
                            child: Opacity(
                              opacity: _controlsAnimation.value,
                              child: childWidget!,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: ColoredBox(
                    color: Colors.black54,
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const _GroupControl(),
                              PlayerSeekSlideFrame(
                                animation: _slideFrameController,
                                frameHeight: slideFrameHeight,
                                valueListenable: _showSlideFrame,
                                onClose: _onEndSlideFrameSeek,
                                seekDurationIndicator: SeekIndicator(
                                  valueListenable: _showSlidingSeekDuration,
                                  child: ValueListenableBuilder(
                                    valueListenable: _slidingSeekDuration,
                                    builder: (_, duration, __) {
                                      return SizedBox(
                                        child: duration != null
                                            ? Text(duration.hoursMinutesSeconds)
                                            : null,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const PlayerActionsControl(),
                      ],
                    ),
                  ),
                ),
              ),
              // Shows loading indicator, regardless if controls are shown/hidden
              const Center(child: PlayerLoadingIndicator()),
              Align(
                alignment: Alignment.bottomLeft,
                child: CustomOrientationBuilder(
                  onLandscape: (context, childWidget) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 58,
                      ),
                      child: childWidget,
                    );
                  },
                  onPortrait: (context, childWidget) {
                    return Consumer(
                      builder: (context, ref, _) {
                        ref.watch(playerExpandedStateProvider);
                        final isExpanded =
                            ref.read(playerViewStateProvider).isExpanded;
                        if (isExpanded) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 58,
                              horizontal: 8,
                            ),
                            child: childWidget!,
                          );
                        }
                        return childWidget!;
                      },
                    );
                  },
                  child: ValueListenableBuilder(
                    valueListenable: _showPlaybackProgress,
                    builder: (context, visible, childWidget) {
                      return Visibility(
                        visible: visible,
                        // opacity: visible ? 1 : 0,
                        // curve: Curves.easeInCubic,
                        // duration: const Duration(milliseconds: 100),
                        child: childWidget!,
                      );
                    },
                    child: Builder(
                      builder: (context) {
                        final playerRepo = ref.read(playerRepositoryProvider);
                        return PlaybackProgress(
                          progress: playerRepo.videoProgressStream,
                          // TODO: Revisit this code
                          start:
                              playerRepo.currentVideoProgress ?? Progress.zero,
                          // TODO: Get ready value
                          end: const Duration(minutes: 1),
                          animation: _progressAnimation,
                          bufferAnimation: _bufferAnimation,
                          onTap: _onPlaybackProgressTap,
                          onDragStart: _onPlaybackProgressDragStart,
                          onChangePosition: _onPlaybackProgressPositionChanged,
                          onDragEnd: _onPlaybackProgressDragEnd,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showProgressIndicator() {
    _progressController.value = 1;
  }

  Timer? _seekRateTimer;

  void _resetSeekRate() {
    _seekRateTimer = Timer(const Duration(milliseconds: 200), () async {
      await _showDoubleTapSeekIndicator.reverse();
      _seekRate.value = 0;
    });
  }

  Future<void> _showForwardSeek() async {
    // Hide controls
    _controlsVisibilityController.reverse(from: 0);

    // Set forward direction of seek
    _isForwardSeek.value = true;

    // Set seek rate
    _seekRateTimer?.cancel();
    final seekRate = ref.read(preferencesProvider).doubleTapSeek;
    _seekRate.value += seekRate;

    // Seek player by seek rate
    ref.read(playerRepositoryProvider).seek(Duration(seconds: seekRate));

    // Show seek rate widget
    await _showDoubleTapSeekIndicator.forward();

    // Reset seek rate and hide widget
    _resetSeekRate();
  }

  Future<void> _showReverseSeek() async {
    // Hide controls
    _controlsVisibilityController.reverse(from: 0);

    // Set reverse direction of seek
    _isForwardSeek.value = false;

    // Set seek rate
    _seekRateTimer?.cancel();
    final seekRate = ref.read(preferencesProvider).doubleTapSeek;
    _seekRate.value += seekRate;

    // Seek player by seek rate
    ref
        .read(playerRepositoryProvider)
        .seek(Duration(seconds: seekRate), reverse: true);

    // Show seek rate widget
    await _showDoubleTapSeekIndicator.forward();

    // Reset seek rate and hide widget
    _resetSeekRate();
  }

  // Method to show the 2x speed indicator and update player speed
  void _show2xSpeed() {
    _showForward2XIndicator.value = true;
    _controlsVisibilityController.reverse(from: 0);
    ref.read(playerRepositoryProvider).setSpeed(); // Update player speed
  }

  /// Hide the 2x speed indicator and reset player speed to normal (1x)
  void _hide2xSpeed() {
    _showForward2XIndicator.value = false;
    // Reset player speed to normal (1x)
    ref.read(playerRepositoryProvider).setSpeed(1.0);
  }

  /// Shows  sliding seek indicator and initiate necessary actions
  void _showSlideSeek() {
    _showSlidingSeekIndicator.value = true;
    _showPlaybackProgress.value = true;
    _controlsVisibilityController.reverse(from: 0);
    _showProgressIndicator();
  }

  /// Hides the sliding seek indicator and perform related cleanup actions
  void _hideSlideSeek() {
    _preventCommonControlGestures = false;
    _showSlidingSeekIndicator.value = false;

    // If a sliding seek duration is set, perform seek operation to that duration
    if (_slidingSeekDuration.value != null) {
      // Release updating from player
      ref.read(playerRepositoryProvider).updatePosition(
            _slidingSeekDuration.value!,
            lockProgress: false,
          );
      ref.read(playerRepositoryProvider).seekTo(_slidingSeekDuration.value!);
    }

    // Reset sliding seek-related values and indicators
    _slidingSeekDuration.value = null;
    _showSlidingSeekDuration.value = false;

    // Reset duration variables for slide seeking
    _lastDuration = null;
    _upperboundSlideDuration = null;
    _lowerboundSlideDuration = null;

    // Contingency to hide pull up message
    _showPullUp = false;

    // If controls are not hidden, manage control visibility and progress indicator
    if (!_controlsHidden) {
      if (!ref.read(playerNotifierProvider).playing) {
        _controlsVisibilityController.forward();
        _showPlaybackProgress.value = true;
      } else {
        _controlsHidden = true;
        _showPlaybackProgress.value = false;
      }
    } else {
      _showPlaybackProgress.value = false;
    }
  }

  void _onEndSlideFrameSeek() {
    _hideSlideSeek();
    _preventCommonControlGestures = false;
    // Show progress indicator
    _showPlaybackProgress.value = true;
    SlideSeekEndPlayerNotification().dispatch(context);
  }

  void _onDoubleTapDown(TapDownDetails details) {
    if (_preventCommonControlGestures) return;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final greyArea = screenWidth * 0.2;
    final isForward = details.localPosition.dx > (screenWidth / 2) + greyArea;
    final isRewind = details.localPosition.dx < (screenWidth / 2) - greyArea;

    if (isForward) {
      ForwardSeekPlayerNotification().dispatch(context);
      _showForwardSeek();
    } else if (isRewind) {
      RewindSeekPlayerNotification().dispatch(context);
      _showReverseSeek();
    }
  }

  void _showReleaseIndicator() {
    _showSlidingReleaseIndicator.value = true;
    _releaseTimer?.cancel();
    _releaseTimer = Timer(const Duration(seconds: 2), () {
      _showSlidingReleaseIndicator.value = false;
    });
  }

  void _onLongPressStart(LongPressStartDetails details) {
    if (_preventCommonControlGestures) return;

    _longPressYPosition = details.localPosition.dy;
    // _longPressXPosition = details.localPosition.dx;

    if (!_controlsHidden) {
      final screenWidth = MediaQuery.sizeOf(context).width;
      final screenHeight = MediaQuery.sizeOf(context).height;

      final isExpanded =
          ref.read(playerRepositoryProvider).playerViewState.isExpanded;
      final possibleVideoHeight =
          (isExpanded ? 1 : avgVideoViewPortHeight) * screenHeight;

      const greyArea = 65;
      final localY = details.localPosition.dy;
      final localX = details.localPosition.dx;

      final left = localX + greyArea < screenWidth / 2;
      final right = localX - greyArea > screenWidth / 2;

      final top = localY + (greyArea / 2) < possibleVideoHeight / 2;
      final bottom = localY > (possibleVideoHeight / 2) + (greyArea / 2);

      if ((!right && !left) && (!top && !bottom)) return;
    }

    _startedOnLongPress = true;

    final isPlaying = ref.read(playerNotifierProvider).playing;
    if (isPlaying) {
      Forward2xSpeedStartPlayerNotification().dispatch(context);
      _show2xSpeed();
    } else {
      SlideSeekStartPlayerNotification().dispatch(context);
      _showSlideSeek();
    }
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    if (_preventCommonControlGestures) return;

    if (!_startedOnLongPress) return;
    _longPressYPosition = 0;
    _startedOnLongPress = false;
    final isPlaying = ref.read(playerNotifierProvider).playing;
    final hasEnded = ref.read(playerNotifierProvider).ended;

    if (isPlaying && !hasEnded) {
      Forward2xSpeedEndPlayerNotification().dispatch(context);
      _hide2xSpeed();
    } else {
      // When slide frame is not active and slide seek is available
      if (!_showSlideFrame.value) {
        SlideSeekEndPlayerNotification().dispatch(context);
        _hideSlideSeek();
      } else {
        if (_slideFrameController.value < 0.7) {
          _showSlideFrame.value = false;
          _slideFrameController.value = 0;
          _hideSlideSeek();
        } else {
          _slideFrameController.value = 1;
        }
      }
    }
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (_preventCommonControlGestures) return;

    if (_isSlidingSeek) {
      SlideSeekUpdatePlayerNotification().dispatch(context);
      final totalMicroseconds = ref
          .read(playerRepositoryProvider)
          .currentVideoDuration
          .inMicroseconds;
      final lastPosition =
          ref.read(playerRepositoryProvider).currentVideoPosition;

      final localX = details.localPosition.dx;
      final localY = details.localPosition.dy;
      final screenWidth = MediaQuery.sizeOf(context).width;

      final bound = Duration(microseconds: (totalMicroseconds * 0.1).floor());

      // Set initial values
      _lastDuration ??= lastPosition;
      _upperboundSlideDuration ??= lastPosition + bound;
      _lowerboundSlideDuration ??= lastPosition - bound;

      // TODO: This might fix inconsistency with changes in position
      //  final longPressXDuration = Duration(
      //         microseconds:
      //             (_longPressXPosition * totalMicroseconds / screenWidth).floor(),
      //       );
      // Duration newDuration;
      // if (_longPressXPosition < localX) {
      //   newDuration = longPressXDuration +
      //       Duration(
      //         microseconds: ((localX - _longPressXPosition) *
      //                 totalMicroseconds /
      //                 screenWidth)
      //             .floor(),
      //       );
      // }else {
      //   newDuration = longPressXDuration  -
      //       Duration(
      //         microseconds: (( _longPressXPosition - localX) *
      //             totalMicroseconds /
      //             screenWidth)
      //             .floor(),
      //       );
      // }
      final newDuration = Duration(
        microseconds: (localX * totalMicroseconds / screenWidth).floor(),
      );

      _checkOutOfBound(lastPosition, newDuration);

      if (!_showSlideFrame.value) {
        _showSlidingSeekDuration.value = true;
        _slidingSeekDuration.value = newDuration;

        // Updates and locks progress from player
        ref.read(playerRepositoryProvider).updatePosition(newDuration);
      }

      if (localY < (_longPressYPosition - 10)) {
        if (!_showSlidingSeekIndicator.value) {
          HapticFeedback.selectionClick();
        }

        _showSlidingSeekIndicator.value = false;
        _showSlideFrame.value = true;
        _slideFrameController.value = clampDouble(
          (_longPressYPosition - localY) / 50,
          0,
          1,
        );
      }
    }
  }

  void _checkOutOfBound(Duration lastPosition, Duration newDuration) {
    // Send a vibration
    if (newDuration > _upperboundSlideDuration!) {
      if (_lastDuration! < _upperboundSlideDuration!) {
        HapticFeedback.selectionClick();
        _showReleaseIndicator();
        _lastDuration = newDuration;
      }
    } else if (newDuration < _upperboundSlideDuration!) {
      if (_lastDuration! > _upperboundSlideDuration!) {
        HapticFeedback.selectionClick();
        _showReleaseIndicator();
        _lastDuration = lastPosition;
      }
    }

    if (newDuration < _lowerboundSlideDuration!) {
      if (_lastDuration! > _lowerboundSlideDuration!) {
        HapticFeedback.selectionClick();
        _showReleaseIndicator();
        _lastDuration = newDuration;
      }
    } else if (newDuration > _lowerboundSlideDuration!) {
      if (_lastDuration! < _lowerboundSlideDuration!) {
        HapticFeedback.selectionClick();
        _showReleaseIndicator();
        _lastDuration = lastPosition;
      }
    }
  }

  bool wasPlaying = false;

  /// When PlaybackProgress is tapped to change the position of currently playing
  /// video.
  void _onPlaybackProgressTap(Duration position) {
    if (_progressController.value > 0) {
      ref.read(playerRepositoryProvider).seekTo(position);
    } else {
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal([PlayerSignal.showControls]);
    }
  }

  void _onPlaybackProgressDragStart(Duration position) {
    wasPlaying = ref.read(playerNotifierProvider).playing;
    if (wasPlaying) ref.read(playerRepositoryProvider).pauseVideo();

    _showPullUp = true;
    _showSlidingSeekDuration.value = true;
    _slidingSeekDuration.value = position;

    _showSlideSeek();
    // Updates and locks progress from player
    ref.read(playerRepositoryProvider).updatePosition(position);
  }

  void _onPlaybackProgressDragEnd() {
    if (_slidingSeekDuration.value != null) {
      ref.read(playerRepositoryProvider).seekTo(_slidingSeekDuration.value!);
      // Updates the progress for the las time and unlocks getting progress from
      // player
      ref.read(playerRepositoryProvider).updatePosition(
            _slidingSeekDuration.value!,
            lockProgress: false, // Releases lock on player progress
          );
    }

    _showPullUp = false;
    _slidingSeekDuration.value = null;
    _showSlidingReleaseIndicator.value = false;
    _hideSlideSeek();

    if (wasPlaying) ref.read(playerRepositoryProvider).playVideo();
    wasPlaying = false;
  }

  /// Callback for when Video position is changed from the PlaybackProgress indicator
  void _onPlaybackProgressPositionChanged(Duration position) {
    final lastPosition =
        ref.read(playerRepositoryProvider).currentVideoPosition;
    final totalMicroseconds =
        ref.read(playerRepositoryProvider).currentVideoDuration.inMicroseconds;
    final bound = Duration(microseconds: (totalMicroseconds * 0.1).floor());

    // Set initial values
    _lastDuration ??= lastPosition;
    _upperboundSlideDuration ??= lastPosition + bound;
    _lowerboundSlideDuration ??= lastPosition - bound;

    // Send vibration feedback when going in or out of lower and upper bound
    _checkOutOfBound(lastPosition, position);

    _slidingSeekDuration.value = position;
    // Updates and locks progress from player
    ref.read(playerRepositoryProvider).updatePosition(position);
  }
}

class _GroupControl extends StatelessWidget {
  const _GroupControl();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _TopControl(),
        _MiddleControl(),
        _BottomControl(),
      ],
    );
  }
}

class _TopControl extends StatelessWidget {
  const _TopControl();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlayerMinimize(),
            Expanded(
              child: PlayerDescription(
                showOnFullscreen: true,
              ),
            ),
            PlayerAutoplaySwitch(),
            PlayerCastCaptionControl(),
            PlayerSettings(),
          ],
        ),
        PlayerDescription(
          showOnExpanded: true,
        ),
      ],
    );
  }
}

class _MiddleControl extends StatelessWidget {
  const _MiddleControl();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlayerPrevious(),
        PlayPauseRestartControl(),
        PlayerNext(),
      ],
    );
  }
}

class _BottomControl extends StatelessWidget {
  const _BottomControl();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          PlayerDurationControl(),
          PlayerChapterControl(),
          Spacer(),
          PlayerFullscreen(),
        ],
      ),
    );
  }
}
