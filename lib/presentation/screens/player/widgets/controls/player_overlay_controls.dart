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
import 'package:youtube_clone/core/utils/duration.dart';
import 'package:youtube_clone/presentation/preferences.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/provider/state/player_state_provider.dart';
import 'package:youtube_clone/presentation/provider/state/player_signal_provider.dart';
import 'package:youtube_clone/presentation/theme/device_theme.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../player/player_notifications.dart';
import 'player_autoplay_switch.dart';
import 'player_cast_caption_control.dart';
import 'player_fullscreen.dart';
import 'player_minimize.dart';
import 'player_next.dart';
import 'player_play_pause_restart.dart';
import 'player_previous.dart';
import 'player_seek_slide_frame.dart';

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

  final _showPlaybackProgress = ValueNotifier<bool>(true);
  late final AnimationController _bufferController;
  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;
  late final Animation<Color?> _bufferAnimation;

  Duration? _lastDuration;
  Duration? _upperboundSlideDuration;
  Duration? _lowerboundSlideDuration;

  final _showSlidingSeekIndicator = ValueNotifier<bool>(false);
  final _showSlidingReleaseIndicator = ValueNotifier<bool>(false);
  final _slidingSeekDuration = ValueNotifier<Duration?>(null);
  final _showSlidingSeekDuration = ValueNotifier<bool>(false);

  final _showForward2XIndicator = ValueNotifier<bool>(false);
  int _seekRate = 0;
  bool _isForwardSeek = true;
  final _showDoubleTapSeekIndicator = ValueNotifier<bool>(false);

  bool get _isSlidingSeek {
    return _showSlidingSeekIndicator.value || _showSlideFrame.value;
  }

  @override
  void initState() {
    super.initState();

    _controlsVisibilityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 175),
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
      duration: const Duration(milliseconds: 175),
      reverseDuration: const Duration(milliseconds: 100),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 175),
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
  }

  @override
  void dispose() {
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
    ref.listen(
      playerSignalProvider,
      (previous, next) async {
        final signal = next.asData?.value;
        if (signal == PlayerSignal.showControls) {
          if (context.orientation.isLandscape) {
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

              // Hides PlaybackProgress
              if (mounted && context.orientation.isLandscape) {
                _showPlaybackProgress.value = false;
              }

              ref
                  .read(playerRepositoryProvider)
                  .sendPlayerSignal(PlayerSignal.hideControls);
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

          // Hides PlaybackProgress while in landscape mode, when controls are
          // hidden
          if (mounted && context.orientation.isLandscape) {
            _showPlaybackProgress.value = false;
          }
        } else if (signal == PlayerSignal.minimize) {
          _showPlaybackProgress.value = false;
        } else if (signal == PlayerSignal.maximize) {
          _showPlaybackProgress.value = true;
        }
      },
    );
    return Column(
      children: [
        Expanded(
          child: Stack(
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
              ValueListenableBuilder(
                valueListenable: _showDoubleTapSeekIndicator,
                builder: (context, value, childWidget) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 175),
                    opacity: value ? 1 : 0,
                    child: childWidget,
                  );
                },
                child: Align(
                  alignment: _isForwardSeek
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: ClipPath(
                    clipper: SeekIndicatorClipper(forward: _isForwardSeek),
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
                          if (_isForwardSeek)
                            const Icon(Icons.fast_forward)
                          else
                            const Icon(Icons.fast_rewind),
                          const SizedBox(height: 8),
                          Text(
                            '${_isForwardSeek ? '' : '-'}$_seekRate seconds',
                          ),
                        ],
                      ),
                    ),
                  ),
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
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.linear_scale),
                            SizedBox(width: 4),
                            Text('Slide left or right to seek'),
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
                          color: Colors.black45,
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
                onTap: _onTap,
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
                  child: const ColoredBox(
                    color: Colors.black26,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            PlayerMinimize(),
                            Spacer(),
                            PlayerAutoplaySwitch(),
                            PlayerCastCaptionControl(),
                            AppbarAction(icon: Icons.settings_outlined),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PlayerPrevious(),
                                PlayPauseRestartControl(),
                                PlayerNext(),
                              ],
                            ),
                          ],
                        ),
                        PlayerControlDuration(),
                      ],
                    ),
                  ),
                ),
              ),
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
              Align(
                alignment: Alignment.bottomLeft,
                child: CustomOrientationBuilder(
                  onLandscape: (context, childWidget) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: childWidget,
                    );
                  },
                  onPortrait: (context, childWidget) {
                    return childWidget!;
                  },
                  child: Consumer(
                    builder: (context, ref, child) {
                      final videoDuration = ref
                          .read(playerRepositoryProvider)
                          .currentVideoDuration;

                      return ValueListenableBuilder(
                        valueListenable: _showPlaybackProgress,
                        builder: (context, visible, childWidget) {
                          return AnimatedOpacity(
                            opacity: visible ? 1 : 0,
                            curve: Curves.easeInCubic,
                            duration: const Duration(milliseconds: 100),
                            child: childWidget,
                          );
                        },
                        child: PlaybackProgress(
                          progress: ref
                              .read(playerRepositoryProvider)
                              .videoStreamProgress,
                          start: ref
                              .read(playerRepositoryProvider)
                              .currentVideoProgress,
                          end: videoDuration,
                          animation: _progressAnimation,
                          bufferAnimation: _bufferAnimation,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        CustomOrientationBuilder(
          onLandscape: (_, childWidget) => childWidget!,
          onPortrait: (_, childWidget) => const SizedBox(),
          child: GestureDetector(
            onTap: _onTap,
            child: AnimatedBuilder(
              animation: _controlsAnimation,
              builder: (context, childWidget) {
                return ValueListenableBuilder(
                  valueListenable: _showSlideFrame,
                  builder: (_, showSlideFrame, __) {
                    return Opacity(
                      opacity: _controlsAnimation.value,
                      child: childWidget!,
                    );
                  },
                );
              },
              child: const ColoredBox(
                color: Colors.black26,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.thumb_up_alt_outlined),
                            Icon(Icons.thumb_down_alt_outlined),
                            Icon(Icons.chat_outlined),
                            Icon(Icons.chat_outlined),
                            Icon(Icons.reply_outlined),
                            Icon(Icons.more_horiz),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(),
                            TappableArea(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'More videos',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Tap or swipe up to see all',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 8),
                                  SizedBox(
                                    width: 60,
                                    height: 32,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned(
                                          top: -2,
                                          child: PlayerMoreVideos(
                                            width: 36,
                                            height: 22,
                                          ),
                                        ),
                                        Positioned(
                                          top: 2,
                                          width: 40,
                                          child: PlayerMoreVideos(
                                            width: 40,
                                            height: 22,
                                          ),
                                        ),
                                        PlayerMoreVideos(
                                          height: 22,
                                          width: 44,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _showProgressIndicator() {
    _progressController.value = 1;
  }

  void _hideProgressIndicator() {
    _progressController.value = 0;
  }

  /// Toggles the visibility of player controls based on the current state.
  void _onTap() {
    // Check if player controls are currently visible
    if (ref.read(playerRepositoryProvider).playerViewState.showControls) {
      // If visible, send a signal to hide controls
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal(PlayerSignal.hideControls);
    } else {
      // If not visible, send a signal to show controls
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal(PlayerSignal.showControls);
    }
  }

  Timer? _seekRateTimer;

  void _resetSeekRate() {
    _seekRateTimer = Timer(const Duration(milliseconds: 500), () {
      _seekRate = 0;
      _showDoubleTapSeekIndicator.value = false;
    });
  }

  Future<void> _showForwardSeek() async {
    // Hide controls
    _controlsVisibilityController.reverse(from: 0);

    // Set forward direction of seek
    _isForwardSeek = true;

    // Set seek rate
    _seekRateTimer?.cancel();
    _seekRate += ref.read(preferencesProvider).doubleTapSeek;

    // Show seek rate widget
    _showDoubleTapSeekIndicator.value = true;

    // Send signal for fast forward action
    ref
        .read(playerRepositoryProvider)
        .sendPlayerSignal(PlayerSignal.fastForward);

    // Seek player by seek rate
    ref.read(playerRepositoryProvider).seek(Duration(seconds: _seekRate));

    // Reset seek rate and hide widget
    _resetSeekRate();
  }

  Future<void> _showReverseSeek() async {
    // Hide controls
    _controlsVisibilityController.reverse(from: 0);

    // Set reverse direction of seek
    _isForwardSeek = false;

    // Set seek rate
    _seekRateTimer?.cancel();
    _seekRate += ref.read(preferencesProvider).doubleTapSeek;

    // Show seek rate widget
    _showDoubleTapSeekIndicator.value = true;

    // Send signal for fast forward / rewind action
    ref
        .read(playerRepositoryProvider)
        .sendPlayerSignal(PlayerSignal.fastForward);

    // Seek player by seek rate
    ref
        .read(playerRepositoryProvider)
        .seek(Duration(seconds: _seekRate), reverse: true);

    // Reset seek rate and hide widget
    _resetSeekRate();
  }

  void _show2xSpeed() {
    _showForward2XIndicator.value = true;
    _controlsVisibilityController.reverse(from: 0);
    ref.read(playerRepositoryProvider).setSpeed();
  }

  void _hide2xSpeed() {
    _showForward2XIndicator.value = false;
    ref.read(playerRepositoryProvider).setSpeed(1.0);
  }

  void _showSlideSeek() {
    _showSlidingSeekIndicator.value = true;
    _controlsVisibilityController.reverse(from: 0);
    _showProgressIndicator();
  }

  void _hideSlideSeek() {
    _showSlidingSeekIndicator.value = false;
    _showPlaybackProgress.value = true;

    if (!_controlsHidden) {
      if (!ref.read(playerNotifierProvider).playing) {
        _controlsVisibilityController.forward();
      } else {
        _controlsHidden = true;
      }
      _hideProgressIndicator();
    }

    if (_slidingSeekDuration.value != null) {
      ref.read(playerRepositoryProvider).seekTo(_slidingSeekDuration.value!);
    }
    _slidingSeekDuration.value = null;
    _showSlidingSeekDuration.value = false;

    // Reset  values
    _lastDuration = null;
    _upperboundSlideDuration = null;
    _lowerboundSlideDuration = null;
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

  bool _startedOnLongPress = false;
  double _longPressYPosition = 0;
  Timer? _releaseTimer;

  void _showReleaseIndicator() {
    _showSlidingReleaseIndicator.value = true;
    _releaseTimer?.cancel();
    _releaseTimer = Timer(const Duration(seconds: 2), () {
      _showSlidingReleaseIndicator.value = false;
    });
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _longPressYPosition = details.localPosition.dy;

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

      final newDuration = Duration(
        microseconds: (localX * totalMicroseconds / screenWidth).floor(),
      );

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

      if (!_showSlideFrame.value) {
        _showSlidingSeekDuration.value = true;
        _slidingSeekDuration.value = newDuration;

        // Hide progress indicator
        _showPlaybackProgress.value = false;
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
}

class PlayerMoreVideos extends StatelessWidget {
  final double width;
  final double height;

  const PlayerMoreVideos({
    super.key,
    this.width = 54,
    this.height = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white, width: 1),
      ),
    );
  }
}

class PlayerControlDuration extends ConsumerStatefulWidget {
  const PlayerControlDuration({super.key});

  @override
  ConsumerState<PlayerControlDuration> createState() =>
      _PlayerControlDurationState();
}

class _PlayerControlDurationState extends ConsumerState<PlayerControlDuration> {
  bool reversed = false;

  @override
  Widget build(BuildContext context) {
    final videoDuration =
        ref.read(playerRepositoryProvider).currentVideoDuration;
    final videoPosition =
        ref.read(playerRepositoryProvider).currentVideoPosition;
    final positionStream = ref.read(playerRepositoryProvider).positionStream;

    return GestureDetector(
      onTap: () => setState(() => reversed = !reversed),
      child: CustomOrientationBuilder(
        onLandscape: (context, childWidget) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: childWidget,
          );
        },
        onPortrait: (context, childWidget) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: childWidget,
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                StreamBuilder<Duration>(
                  stream: positionStream,
                  initialData: videoPosition,
                  builder: (context, snapshot) {
                    final position = reversed
                        ? videoDuration - (snapshot.data ?? Duration.zero)
                        : snapshot.data ?? Duration.zero;
                    return Text(reversed
                        ? '-${position.hoursMinutesSeconds}'
                        : position.hoursMinutesSeconds);
                  },
                ),
                const Text(
                  ' / ',
                  style: TextStyle(
                    color: Colors.white60,
                  ),
                ),
                Text(
                  videoDuration.hoursMinutesSeconds,
                  style: const TextStyle(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
            const PlayerFullscreen(),
          ],
        ),
      ),
    );
  }
}

class SeekIndicator extends StatelessWidget {
  final ValueListenable<bool> valueListenable;
  final Widget child;

  const SeekIndicator({
    super.key,
    required this.valueListenable,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (context, value, childWidget) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 175),
          opacity: value ? 1 : 0,
          child: childWidget,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(32),
        ),
        child: child,
      ),
    );
  }
}

class SeekIndicatorClipper extends CustomClipper<Path> {
  final bool forward;

  SeekIndicatorClipper({super.reclip, this.forward = true});
  @override
  Path getClip(Size size) {
    Path path = Path();

    if (forward) {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width * .2, size.height);
      path.quadraticBezierTo(0, size.height * .5, size.width * .2, 0);
    } else {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width * .8, size.height);
      path.quadraticBezierTo(size.width, size.height * .5, size.width * .8, 0);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}
