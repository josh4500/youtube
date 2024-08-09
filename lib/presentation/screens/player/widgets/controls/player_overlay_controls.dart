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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core/utils/duration.dart';
import 'package:youtube_clone/presentation/preferences.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/controls/player_rotate.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/view_models/progress.dart';
import 'package:youtube_clone/presentation/view_models/state/player_settings_view_model.dart';
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
import 'player_seek_slide_frame.dart';
import 'player_settings.dart';
import 'player_unlock.dart';
import 'seek_indicator.dart';

const double kSlideFrameHeight = 80;

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

  final _showSlideFrame = ValueNotifier<bool>(false);
  late final AnimationController _slideFrameController;

  bool _controlsHidden = true;

  /// Flag to prevents control gestures
  ///   - Double tap
  bool _preventCommonControlGestures = false;

  /// Flag to track whether the long press has started
  bool _startedOnLongPress = false;

  /// Y position of user pointer when long press action starts
  double _longPressYStartPosition = 0;

  /// X position of user pointer when long press action starts
  double _longPressXUpdatePosition = 0;

  /// Timer used for hiding `Release` message while slide seeking.
  Timer? _releaseTimer;

  /// Notifier for showing/hiding playback progress
  final _showPlaybackProgress = ValueNotifier<double>(1);

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

  late final AnimationController _seekDurationIndicatorController;
  late final Animation<double> _seekDurationIndicatorAnimation;

  late final AnimationController _seekIndicatorController;
  late final Animation<double> _seekIndicatorAnimation;

  final _seekIndicatorNotifier = ValueNotifier<SeekNotificationType>(
    SeekNotificationType.none,
  );

  /// Rate of seeking on double tap
  final _seekRate = ValueNotifier<int>(0);

  /// Whether direction for seeking is forward.
  final _isForwardSeek = ValueNotifier<bool>(true);

  /// Notifier for showing double tap seek indicator
  late final AnimationController _showDoubleTapSeekIndicator;
  late final Animation<double> _showDoubleTapSeekAnimation;

  /// Notifier for showing unlock button
  late final AnimationController _showUnlockButton;
  late final Animation<double> _showUnlockButtonAnimation;

  /// Whether sliding seek is active
  bool get _isSlidingSeek {
    return _seekIndicatorNotifier.value.isSlide || _showSlideFrame.value;
  }

  /// Whether it was playing
  bool wasPlaying = false;

  /// Duration when slide seeking on progress or long press
  Duration _slideSeekDuration = Duration.zero;

  late Animation<Offset> _slideAnimation;
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

    _seekIndicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 175),
    );

    _seekIndicatorAnimation = CurvedAnimation(
      parent: _seekIndicatorController,
      curve: Curves.easeIn,
    );

    _seekDurationIndicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 175),
    );

    _seekDurationIndicatorAnimation = CurvedAnimation(
      parent: _seekDurationIndicatorController,
      curve: Curves.easeIn,
    );

    _slideFrameController = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = _slideFrameController.drive(
      Tween<Offset>(
        begin: const Offset(0, kSlideFrameHeight),
        end: Offset.zero,
      ),
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

    _showUnlockButton = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _showUnlockButtonAnimation = CurvedAnimation(
      parent: _showUnlockButton,
      curve: Curves.easeInCubic,
      reverseCurve: Curves.easeOutCubic,
    );
  }

  StreamSubscription<PlayerSignal>? _playerSignalSubscription;
  Timer? _showUnlockTimer;

  @override
  void didUpdateWidget(covariant PlayerOverlayControls oldWidget) {
    if (context.orientation.isLandscape && _controlsHidden) {
      _showPlaybackProgress.value = 0;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    final playerRepo = ref.read(playerRepositoryProvider);
    _playerSignalSubscription ??= playerRepo.playerSignalStream.listen(
      _onPlayerSignalEvent,
    );
    super.didChangeDependencies();
  }

  void _onPlayerSignalEvent(signal) async {
    final hasEnded = ref.read(playerNotifierProvider).ended;
    final isPlaying = ref.read(playerNotifierProvider).playing;
    final isExpanded = ref.read(playerViewStateProvider).isExpanded;

    if (signal == PlayerSignal.lockScreen) {
      _preventCommonControlGestures = true;
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal([PlayerSignal.hideControls]);
    } else if (signal == PlayerSignal.unlockScreen) {
      _preventCommonControlGestures = false;
      _showUnlockButton.reverse(from: 0);
      _showUnlockTimer?.cancel();
    } else if (signal == PlayerSignal.showUnlock) {
      _showUnlockButton.forward();
      _showUnlockTimer?.cancel();
      _showUnlockTimer = Timer(const Duration(seconds: 3), () {
        _showUnlockButton.reverse();
      });
    } else if (signal == PlayerSignal.showControls) {
      if (context.orientation.isLandscape || isExpanded) {
        _showPlaybackProgress.value = 1;
      }

      _controlsHidden = false;
      _controlsVisibilityController.forward();
      _bufferController.reverse();

      _progressController.forward();

      // Cancels existing timer
      _controlHideTimer?.cancel();

      // Auto hide only when video is playing
      _controlHideTimer = Timer(const Duration(seconds: 3), () async {
        if (isPlaying) {
          _controlsHidden = true;
          // Note: Hide progress indicator first before hiding main controls
          _progressController.reverse();

          // Reversing before sending signal, animates the reverse on
          // auto hide
          await _controlsVisibilityController.reverse();
          // Hides PlaybackProgress
          if (mounted && context.orientation.isLandscape || isExpanded) {
            _showPlaybackProgress.value = 0;
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
      await _controlsVisibilityController.reverse(
        from: hasEnded || !isPlaying ? null : 0,
      );

      // Hides PlaybackProgress while in landscape mode, when controls are
      // hidden
      if (mounted && context.orientation.isLandscape || isExpanded) {
        _showPlaybackProgress.value = 0;
      }
    } else if (signal == PlayerSignal.hidePlaybackProgress) {
      _showPlaybackProgress.value = 0;
    } else if (signal == PlayerSignal.showPlaybackProgress) {
      _showPlaybackProgress.value = 1;
    } else if (signal == PlayerSignal.minimize) {
      _preventCommonControlGestures = true;
    } else if (signal == PlayerSignal.maximize) {
      _preventCommonControlGestures = false;
    }
  }

  @override
  void dispose() {
    _playerSignalSubscription?.cancel();
    _showUnlockButton.dispose();
    _showUnlockTimer?.cancel();
    _controlHideTimer?.cancel();
    _controlsVisibilityController.dispose();
    _seekIndicatorNotifier.dispose();
    _showDoubleTapSeekIndicator.dispose();
    _seekDurationIndicatorController.dispose();
    _slideFrameController.dispose();
    _bufferController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: _showSlideFrame,
          builder: (
            BuildContext _,
            bool showingSlideFrame,
            Widget? childWidget,
          ) {
            return Visibility(
              visible: showingSlideFrame == false,
              child: AnimatedVisibility(
                animation: _seekDurationIndicatorAnimation,
                alignment: Alignment.lerp(
                  Alignment.center,
                  Alignment.bottomCenter,
                  context.orientation.isPortrait ? 0.75 : 0.6,
                )!,
                child: _buildShowSlideSeekDuration(),
              ),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: _isForwardSeek,
          builder: (
            BuildContext context,
            bool isForwardSeek,
            Widget? childWidget,
          ) {
            return AnimatedVisibility(
              animation: _showDoubleTapSeekAnimation,
              alignment: _isForwardSeek.value
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: ClipPath(
                clipper: SeekIndicatorClipper(forward: isForwardSeek),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  width: MediaQuery.sizeOf(context).width / 2,
                  decoration: const BoxDecoration(color: Colors.black12),
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
        Stack(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: _showSlideFrame,
              builder: (
                BuildContext context,
                bool showSlideFrame,
                Widget? childWidget,
              ) {
                return Visibility(
                  visible: showSlideFrame,
                  child: const ColoredBox(
                    color: Colors.black54,
                    child: SizedBox.expand(),
                  ),
                );
              },
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
                  animation: _controlsAnimation,
                  alignment: Alignment.center,
                  child: const ColoredBox(
                    color: Colors.black54,
                    child: SizedBox.expand(),
                  ),
                ),
              ),
            ),
            AnimatedVisibility(
              animation: _controlsAnimation,
              alignment: Alignment.topCenter,
              child: const _TopControlV2(),
            ),
            AnimatedVisibility(
              animation: _controlsAnimation,
              alignment: Alignment.center,
              child: const _MiddleControl(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _BottomControlV2(
                animation: _controlsAnimation,
                progress: _OverlayProgress(
                  slideAnimation: _slideAnimation,
                  showPlaybackProgress: _showPlaybackProgress,
                  hideControlAnimation: _controlsAnimation,
                  progressAnimation: _progressAnimation,
                  bufferAnimation: _bufferAnimation,
                  onTap: _onPlaybackProgressTap,
                  onDragStart: _onPlaybackProgressDragStart,
                  onChangePosition: _onPlaybackProgressPositionChanged,
                  onDragEnd: _onPlaybackProgressDragEnd,
                ),
              ),
            ),
            AnimatedVisibility(
              animation: _showUnlockButtonAnimation,
              alignment: Alignment.lerp(
                Alignment.center,
                Alignment.bottomCenter,
                0.7,
              )!,
              child: const PlayerUnlock(),
            ),
            // Shows loading indicator, regardless if controls are shown/hidden
            const Center(child: PlayerLoadingIndicator()),
          ],
        ),
        AnimatedVisibility(
          alignment: Alignment.topCenter,
          animation: _seekIndicatorAnimation,
          child: SeekIndicator(valueListenable: _seekIndicatorNotifier),
        ),
        PlayerSeekSlideFrame(
          animation: _slideFrameController,
          frameHeight: kSlideFrameHeight,
          valueListenable: _showSlideFrame,
          onClose: _onEndSlideFrameSeek,
          seekDurationIndicator: _buildShowSlideSeekDuration(),
        ),
      ],
    );
  }

  Widget _buildShowSlideSeekDuration() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
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
    _seekIndicatorNotifier.value = SeekNotificationType.speedUp2X;
    _seekIndicatorController.forward();
    _controlsVisibilityController.reverse(from: 0);
    ref.read(playerRepositoryProvider).setSpeed(); // Update player speed
  }

  /// Hide the 2x speed indicator and reset player speed to normal (1x)
  void _hide2xSpeed() {
    _seekIndicatorController.reverse();
    // Reset player speed to normal (1x)
    ref.read(playerRepositoryProvider).setSpeed(PlayerSpeed.normal);
  }

  /// Shows  sliding seek indicator and initiate necessary actions
  void _showSlideSeek() {
    _seekIndicatorNotifier.value = SeekNotificationType.slideLeftOrRight;
    _seekIndicatorController.forward();
    _showPlaybackProgress.value = 1;
    _controlsVisibilityController.reverse(from: 0);
    _showProgressIndicator();
  }

  /// Hides the sliding seek indicator and perform related cleanup actions
  void _hideSlideSeek() {
    _preventCommonControlGestures = false;
    _seekIndicatorController.reverse();

    // If a sliding seek duration is set, perform seek operation to that duration
    // Release updating from player
    ref.read(playerRepositoryProvider).updatePosition(
          _slideSeekDuration,
          lockProgress: false,
        );
    ref.read(playerRepositoryProvider).seekTo(_slideSeekDuration);

    // Reset sliding seek-related values and indicators
    _seekDurationIndicatorController.reverse();

    // Reset duration variables for slide seeking
    _lastDuration = null;
    _upperboundSlideDuration = null;
    _lowerboundSlideDuration = null;

    // If controls are not hidden, manage control visibility and progress indicator
    if (!_controlsHidden) {
      if (!ref.read(playerNotifierProvider).playing) {
        _controlsVisibilityController.forward();
        _showPlaybackProgress.value = 1;
      } else {
        _controlsHidden = true;
        _showPlaybackProgress.value = 0;
      }
    } else {
      _showPlaybackProgress.value = 0;
    }
  }

  void _onEndSlideFrameSeek() {
    _hideSlideSeek();
    _preventCommonControlGestures = false;
    // Show progress indicator
    _showPlaybackProgress.value = 1;
    SlideSeekEndPlayerNotification().dispatch(context);
  }

  void _onDoubleTapDown(TapDownDetails details) {
    if (_preventCommonControlGestures) return;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isForward = details.localPosition.dx > (screenWidth / 2);
    final isRewind = details.localPosition.dx < (screenWidth / 2);

    if (isForward) {
      ForwardSeekPlayerNotification().dispatch(context);
      _showForwardSeek();
    } else if (isRewind) {
      RewindSeekPlayerNotification().dispatch(context);
      _showReverseSeek();
    }
  }

  void _showReleaseIndicator() {
    _seekIndicatorNotifier.value = SeekNotificationType.release;
    _seekIndicatorController.forward();
    _releaseTimer?.cancel();
    _releaseTimer = Timer(const Duration(seconds: 2), () {
      _seekIndicatorController.reverse();
    });
  }

  void _onLongPressStart(LongPressStartDetails details) {
    if (_preventCommonControlGestures) return;

    _longPressYStartPosition = details.localPosition.dy;
    _longPressXUpdatePosition = details.localPosition.dx;
    _slideSeekDuration =
        ref.read(playerRepositoryProvider).currentVideoPosition;

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
    _longPressYStartPosition = 0;
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
      // TODO(Josh4500): Use real data
      final totalMicroseconds = const Duration(seconds: 60).inMicroseconds;
      final lastPosition =
          ref.read(playerRepositoryProvider).currentVideoPosition;

      final localX = details.localPosition.dx;
      final localY = details.localPosition.dy;
      final screenWidth = MediaQuery.sizeOf(context).width;

      if (_showSlideFrame.value == false) {
        final bound = Duration(microseconds: (totalMicroseconds * 0.1).floor());

        // Set initial values
        _lastDuration ??= lastPosition;
        _upperboundSlideDuration ??= lastPosition + bound;
        _lowerboundSlideDuration ??= lastPosition - bound;

        final localDeltaX = localX - _longPressXUpdatePosition;
        _longPressXUpdatePosition = localX;

        final newD = (localDeltaX * totalMicroseconds / screenWidth).floor();

        _slideSeekDuration = localDeltaX.isNegative
            ? _slideSeekDuration - Duration(microseconds: newD.abs())
            : _slideSeekDuration + Duration(microseconds: newD);

        _slideSeekDuration = _slideSeekDuration.clamp(
          Duration.zero,
          // TODO(Josh4500): Use real data
          const Duration(seconds: 60),
        );

        _checkOutOfBound(lastPosition, _slideSeekDuration);

        _seekDurationIndicatorController.forward();

        // Updates and locks progress from player
        ref.read(playerRepositoryProvider).updatePosition(_slideSeekDuration);
      }

      if (localY < (_longPressYStartPosition - 30)) {
        if (!_seekIndicatorNotifier.value.isSlide) {
          HapticFeedback.selectionClick();
        }

        _showSlideFrame.value = true; // This disengages long press sliding seek
        _seekIndicatorNotifier.value = SeekNotificationType.slideLeftOrRight;
        _seekIndicatorController.forward();

        _slideFrameController.value = clampDouble(
          (_longPressYStartPosition - 30 - localY) / kSlideFrameHeight,
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

  /// When PlaybackProgress is tapped to change the position of currently playing
  /// video.
  void _onPlaybackProgressTap(Duration position) {
    if (_preventCommonControlGestures) return;

    if (_progressController.value > 0) {
      ref.read(playerRepositoryProvider).seekTo(position);
    } else {
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal([PlayerSignal.showControls]);
    }
  }

  void _onPlaybackProgressDragStart(Duration position) {
    if (_preventCommonControlGestures) return;

    wasPlaying = ref.read(playerNotifierProvider).playing;
    if (wasPlaying) ref.read(playerRepositoryProvider).pauseVideo();

    _seekDurationIndicatorController.forward();
    _slideSeekDuration = position;

    _showSlideSeek();
    // Updates and locks progress from player
    ref.read(playerRepositoryProvider).updatePosition(position);
  }

  void _onPlaybackProgressDragEnd() {
    if (_preventCommonControlGestures) return;

    ref.read(playerRepositoryProvider).seekTo(_slideSeekDuration);
    // Updates the progress for the last time and unlocks getting progress from
    // player
    ref.read(playerRepositoryProvider).updatePosition(
          _slideSeekDuration,
          lockProgress: false, // Releases lock on player progress
        );

    _seekIndicatorController.reverse();
    _hideSlideSeek();

    if (wasPlaying) ref.read(playerRepositoryProvider).playVideo();
    wasPlaying = false;
  }

  /// Callback for when Video position is changed from the PlaybackProgress indicator
  void _onPlaybackProgressPositionChanged(Duration position) {
    if (_preventCommonControlGestures) return;

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

    _slideSeekDuration = position;
    // Updates and locks progress from player
    ref.read(playerRepositoryProvider).updatePosition(position);
  }
}

class _OverlayProgress extends ConsumerWidget {
  const _OverlayProgress({
    required this.slideAnimation,
    required this.showPlaybackProgress,
    required this.progressAnimation,
    required this.bufferAnimation,
    this.onTap,
    this.onDragStart,
    this.onDragEnd,
    this.onChangePosition,
    required this.hideControlAnimation,
  });

  final ValueChanged<Duration>? onTap;
  final ValueChanged<Duration>? onDragStart;
  final VoidCallback? onDragEnd;
  final ValueChanged<Duration>? onChangePosition;

  final Animation<Offset> slideAnimation;
  final ValueNotifier<double> showPlaybackProgress;
  final Animation<double> hideControlAnimation;
  final Animation<double> progressAnimation;
  final Animation<Color?> bufferAnimation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerRepo = ref.read(playerRepositoryProvider);
    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (BuildContext context, Widget? childWidget) {
        return FractionalTranslation(
          translation: slideAnimation.value,
          child: childWidget,
        );
      },
      child: Align(
        alignment: Alignment.bottomLeft,
        child: CustomOrientationBuilder(
          onLandscape: (BuildContext context, Widget? childWidget) {
            return AnimatedVisibility(
              animation: hideControlAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: childWidget,
              ),
            );
          },
          onPortrait: (BuildContext context, Widget? progressWidget) {
            return Consumer(
              builder: (
                BuildContext context,
                WidgetRef ref,
                Widget? _,
              ) {
                final playerViewState = ref.watch(playerViewStateProvider);

                return Row(
                  children: [
                    if (playerViewState.isExpanded)
                      AnimatedVisibility(
                        animation: hideControlAnimation,
                        child: const PlayPauseRestartControl(),
                      ),
                    Expanded(
                      child: AnimatedVisibility(
                        animation: playerViewState.isExpanded
                            ? hideControlAnimation
                            : Animation.fromValueListenable(
                                showPlaybackProgress,
                              ),
                        child: progressWidget,
                      ),
                    ),
                    if (playerViewState.isExpanded) const SizedBox(width: 12)
                  ],
                );
              },
            );
          },
          child: PlaybackProgress(
            progress: playerRepo.videoProgressStream,
            // TODO(Josh4500): Revisit this code
            start: playerRepo.currentVideoProgress ?? Progress.zero,
            // TODO(Josh4500): Get ready value
            end: const Duration(minutes: 1),
            animation: progressAnimation,
            bufferAnimation: bufferAnimation,
            onTap: onTap,
            onDragStart: onDragStart,
            onChangePosition: onChangePosition,
            onDragEnd: onDragEnd,
          ),
        ),
      ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
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

class _TopOrientationControl extends ConsumerWidget {
  const _TopOrientationControl();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(playerViewStateProvider).isExpanded;

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
    return const Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TopOrientationControl(),
            Spacer(),
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

class _BottomControl extends StatelessWidget {
  const _BottomControl({required this.progress});
  final Widget progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Row(
            children: [
              PlayerDurationControl(),
              PlayerChapterControl(),
              Spacer(),
              PlayerFullscreen(),
            ],
          ),
          progress,
          const PlayerActionsControl(),
        ],
      ),
    );
  }
}

class _BottomControlV2 extends StatelessWidget {
  const _BottomControlV2({required this.progress, required this.animation});
  final Widget progress;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedVisibility(
          animation: animation,
          child: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? _) {
              final isExpanded = ref.watch(playerViewStateProvider).isExpanded;
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
                    const SizedBox(width: 24),
                    if (context.orientation.isLandscape)
                      const Expanded(
                        child: PlayerActionsControlV2(),
                      )
                    else
                      const PlayerActionsControlV2(
                        direction: Axis.vertical,
                      ),
                  ],
                );
              }
            },
          ),
        ),
        progress,
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? childWidget) {
            bool isExpanded = false;
            final isLandscape = context.orientation.isLandscape;
            if (!isLandscape) {
              isExpanded = ref.watch(playerViewStateProvider).isExpanded;
            }
            if (isExpanded || isLandscape) {
              return AnimatedVisibility(
                animation: animation,
                child: Row(
                  children: [
                    if (isLandscape) ...[
                      const Row(
                        children: [
                          PlayPauseRestartControl(
                            backgroundColor: Colors.transparent,
                          ),
                          SizedBox(width: 8),
                          PlayerDurationControl(),
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
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
