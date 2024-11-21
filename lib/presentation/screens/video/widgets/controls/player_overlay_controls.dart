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
  // Timer instance
  Timer? _controlHideTimer;
  late final AnimationController _controlsVisibilityController;
  late final Animation<double> _controlsAnimation;

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
  double _longPressXStartPosition = 0;

  /// Timer used for hiding `Release` message while slide seeking.
  Timer? _releaseTimer;

  late final _controlMessageController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  final ValueNotifier<String> _latestControlMessage = ValueNotifier<String>('');
  Timer? _controlMessageTimer;

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

  /// Whether it was playing
  bool wasPlaying = false;

  /// Duration when slide seeking on progress or long press
  Duration _slideSeekDuration = Duration.zero;

  bool get _showingSlideFrame {
    return _seekIndicatorNotifier.value.isSlideFrame;
  }

  late Animation<double> _slideFrameAnimation;
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
      value: 0,
      duration: const Duration(milliseconds: 300),
    );

    _slideFrameAnimation = CurvedAnimation(
      parent: _slideFrameController,
      curve: Curves.easeInToLinear,
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
    Future.microtask(() {
      final playerRepo = ref.read(playerRepositoryProvider);
      _playerSignalSubscription ??= playerRepo.playerSignalStream.listen(
        _onPlayerSignalEvent,
      );
    });
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
      if (mounted && context.orientation.isLandscape || isExpanded) {
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
    } else if (signal == PlayerSignal.autoplay) {
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
              alignment: Alignment.topCenter,
              animation: _seekIndicatorAnimation,
              child: SeekIndicator(
                valueListenable: _seekIndicatorNotifier,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: AnimatedVisibility(
                    animation: _slideFrameAnimation,
                    child: _SlideFramePlayButton(
                      onClose: _onEndAnySlideSeek,
                    ),
                  ),
                ),
                AnimatedVisibility(
                  animation: _controlsAnimation,
                  child: const _OverlayDurationOrientation(),
                ),
                AnimatedVisibility(
                  animation: _seekDurationIndicatorAnimation,
                  alignment: Alignment.center,
                  child: const _OverlaySeekDuration(),
                ),
                _OverlayProgress(
                  bufferAnimation: _bufferAnimation,
                  progressAnimation: _progressAnimation,
                  hideControlAnimation: _controlsAnimation,
                  showPlaybackProgress: _showPlaybackProgress,
                  onTap: _onPlaybackProgressTap,
                  onVerticalDrag: _onPlaybackVerticalDrag,
                  onVerticalDragStart: _onPlaybackVerticalDragStart,
                  onVerticalDragEnd: _onPlaybackVerticalDragEnd,
                  onHorizontalDragStart: _onPlaybackProgressDragStart,
                  onChangePosition: _onPlaybackProgressPositionChanged,
                  onHorizontalDragEnd: _onPlaybackProgressDragEnd,
                ),
                PlayerSeekSlideFrame(
                  frameHeight: kSlideFrameHeight,
                  sizeAnimation: _slideFrameAnimation,
                ),
                _OverlayVideoSuggestions(animation: _controlsAnimation),
              ],
            ),
            AnimatedVisibility(
              animation: _controlMessageController,
              child: ListenableBuilder(
                listenable: _latestControlMessage,
                builder: (BuildContext context, Widget? _) {
                  return AnimatedVisibility(
                    animation: _controlsAnimation,
                    alignment: const Alignment(0, -.48),
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
            ),
            AnimatedVisibility(
              animation: _showUnlockButtonAnimation,
              alignment: const Alignment(0, .7),
              child: const PlayerUnlock(),
            ),
            // Shows loading indicator, regardless if controls are shown/hidden
            const Center(child: PlayerLoadingIndicator()),
          ],
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

    // Seek video by seek rate
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

    // Seek video by seek rate
    ref
        .read(playerRepositoryProvider)
        .seek(Duration(seconds: seekRate), reverse: true);

    // Show seek rate widget
    await _showDoubleTapSeekIndicator.forward();

    // Reset seek rate and hide widget
    _resetSeekRate();
  }

  // Method to show the 2x speed indicator and update video speed
  void _show2xSpeed() {
    _seekIndicatorNotifier.value = SeekNotificationType.speedUp2X;
    _seekIndicatorController.forward();
    _controlsVisibilityController.reverse(from: 0);
    ref.read(playerRepositoryProvider).setSpeed(); // Update video speed
  }

  /// Hide the 2x speed indicator and reset video speed to normal (1x)
  void _hide2xSpeed() {
    _seekIndicatorController.reverse();
    // Reset video speed to normal (1x)
    ref.read(playerRepositoryProvider).setSpeed(PlayerSpeed.normal);
  }

  /// Shows  sliding seek indicator and initiate necessary actions
  void _showSlideSeek() {
    _seekIndicatorNotifier.value = SeekNotificationType.slideLeftOrRight;
    _seekIndicatorController.forward();
    _controlsVisibilityController.reverse(from: 0);
    _showProgressIndicator();
  }

  /// Hides the sliding seek indicator and perform related cleanup actions
  void _hideSlideSeek() {
    _seekIndicatorController.reverse();

    // If a sliding seek duration is set, perform seek operation to that duration
    // Release updating from video
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
      } else {
        _controlsHidden = true;
      }
    }
  }

  void _hideSlideFrameSeek() {
    _slideFrameController.reverse();
    _seekIndicatorNotifier.value = SeekNotificationType.none;
  }

  void _onEndAnySlideSeek() {
    _hideSlideSeek();
    _hideSlideFrameSeek();
    _seekIndicatorNotifier.value = SeekNotificationType.none;
    SlideSeekEndPlayerNotification().dispatch(context);
  }

  void _onDoubleTapDown(TapDownDetails details) {
    if (_preventCommonControlGestures) return;
    final isLoading = ref.read(playerNotifierProvider).loading;
    if (isLoading) return;

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
    _longPressXStartPosition = details.localPosition.dx;
    _slideSeekDuration =
        ref.read(playerRepositoryProvider).currentVideoPosition;

    _startedOnLongPress = true;

    final isPlaying = ref.read(playerNotifierProvider).playing;
    final isLoading = ref.read(playerNotifierProvider).loading;

    if (isLoading) return;
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

    _longPressYStartPosition = 0;
    _startedOnLongPress = false;

    final isPlaying = ref.read(playerNotifierProvider).playing;
    final hasEnded = ref.read(playerNotifierProvider).ended;
    final isLoading = ref.read(playerNotifierProvider).loading;

    if (isLoading) return;

    if (isPlaying && !hasEnded) {
      Forward2xSpeedEndPlayerNotification().dispatch(context);
      _hide2xSpeed();
    } else {
      // Whether to keep slide frame
      if (_showingSlideFrame && _slideFrameController.value > 0.7) {
        _slideFrameController.forward();
      } else {
        _onEndAnySlideSeek();
      }
    }
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (_preventCommonControlGestures) return;

    final isLoading = ref.read(playerNotifierProvider).loading;
    if (isLoading) return;

    if (_seekIndicatorNotifier.value.isSlideSeeking) {
      SlideSeekUpdatePlayerNotification().dispatch(context);
      // TODO(Josh4500): Use real data
      const fullDuration = Duration(seconds: 60);
      final totalMilliseconds = fullDuration.inMilliseconds;
      final lastPosition =
          ref.read(playerRepositoryProvider).currentVideoPosition;

      final localX = details.localPosition.dx;
      final localY = details.localPosition.dy;
      final screenWidth = MediaQuery.sizeOf(context).width;

      if (_showingSlideFrame == false) {
        final bound = Duration(microseconds: (totalMilliseconds * 0.1).floor());

        // Set initial values
        _lastDuration ??= lastPosition;
        _upperboundSlideDuration ??= lastPosition + bound;
        _lowerboundSlideDuration ??= lastPosition - bound;

        final localDeltaX = details.localOffsetFromOrigin.dx;
        final value = ((localDeltaX / screenWidth) * totalMilliseconds).floor();

        _longPressXStartPosition = localX;

        _slideSeekDuration += Duration(microseconds: value);

        _slideSeekDuration = _slideSeekDuration.clamp(
          Duration.zero,
          fullDuration,
        );

        _checkOutOfBound(lastPosition, _slideSeekDuration);

        _seekDurationIndicatorController.forward();

        // Updates and locks progress from video
        ref.read(playerRepositoryProvider).updatePosition(_slideSeekDuration);
      }

      if (_longPressYStartPosition - localY >= kMaxVerticalDrag ||
          _showingSlideFrame) {
        _updateSlideFrameController(
          (_longPressYStartPosition - localY) / kSlideFrameHeight,
        );
      }
    }
  }

  void _updateSlideFrameController(double value) {
    if (!_seekIndicatorNotifier.value.isSlideSeeking) {
      HapticFeedback.selectionClick();
    }
    _seekIndicatorNotifier.value = value < kMaxVerticalDrag / kSlideFrameHeight
        ? SeekNotificationType.slideLeftOrRight
        : SeekNotificationType.slideFrame;
    _seekIndicatorController.forward();
    _slideFrameController.value = value;
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

    SlideSeekStartPlayerNotification().dispatch(context);
    _showSlideSeek();
    // Updates and locks progress from video
    ref.read(playerRepositoryProvider).updatePosition(position);
  }

  void _onPlaybackProgressDragEnd() {
    if (_preventCommonControlGestures) return;

    ref.read(playerRepositoryProvider).seekTo(_slideSeekDuration);
    if (_showingSlideFrame == false && _slideFrameController.value < 0.7) {
      // Updates the progress for the last time and unlocks getting progress from
      // video
      ref.read(playerRepositoryProvider).updatePosition(
            _slideSeekDuration,
            lockProgress: false, // Releases lock on video progress
          );

      _seekIndicatorController.reverse();
      _hideSlideSeek();
      SlideSeekEndPlayerNotification().dispatch(context);
    }

    if (wasPlaying) ref.read(playerRepositoryProvider).playVideo();
    wasPlaying = false;
  }

  void _onPlaybackVerticalDrag(double yOffset) {
    if (_preventCommonControlGestures) return;

    if (yOffset > 0 && yOffset <= kSlideFrameHeight) {
      _updateSlideFrameController(yOffset.abs() / kSlideFrameHeight);
    }
  }

  void _onPlaybackVerticalDragEnd() {
    if (_preventCommonControlGestures) return;

    // Whether to keep slide frame
    if (_showingSlideFrame && _slideFrameController.value > 0.7) {
      _slideFrameController.forward();
    } else {
      _onEndAnySlideSeek();
    }
  }

  void _onPlaybackVerticalDragStart() {
    if (_preventCommonControlGestures) return;

    _showSlideSeek();
    SlideSeekStartPlayerNotification().dispatch(context);
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
    // Updates and locks progress from video
    ref.read(playerRepositoryProvider).updatePosition(position);
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

class _OverlayProgress extends ConsumerWidget {
  const _OverlayProgress({
    required this.showPlaybackProgress,
    required this.progressAnimation,
    required this.bufferAnimation,
    this.onTap,
    this.onHorizontalDragStart,
    this.onHorizontalDragEnd,
    this.onVerticalDrag,
    this.onChangePosition,
    required this.hideControlAnimation,
    this.onVerticalDragStart,
    this.onVerticalDragEnd,
  });

  final ValueChanged<Duration>? onTap;
  final ValueChanged<Duration>? onHorizontalDragStart;
  final VoidCallback? onHorizontalDragEnd;
  final VoidCallback? onVerticalDragEnd;
  final VoidCallback? onVerticalDragStart;
  final ValueChanged<Duration>? onChangePosition;
  final ValueChanged<double>? onVerticalDrag;

  final ValueNotifier<double> showPlaybackProgress;
  final Animation<double> hideControlAnimation;
  final Animation<double> progressAnimation;
  final Animation<Color?> bufferAnimation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerRepo = ref.read(playerRepositoryProvider);
    final isExpanded = ref.watch(
      playerViewStateProvider.select((state) => state.isExpanded),
    );
    return Align(
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
          return Row(
            children: [
              if (isExpanded)
                AnimatedVisibility(
                  animation: hideControlAnimation,
                  child: const PlayPauseRestartControl(
                    useControlButton: false,
                  ),
                ),
              Expanded(
                child: AnimatedVisibility(
                  animation: isExpanded
                      ? hideControlAnimation
                      : Animation.fromValueListenable(
                          showPlaybackProgress,
                        ),
                  child: progressWidget,
                ),
              ),
              if (isExpanded)
                AnimatedVisibility(
                  animation: hideControlAnimation,
                  child: Row(
                    children: [
                      SizedBox(width: 12.w),
                      const PlayerDurationControl(full: false, reversed: true),
                      SizedBox(width: 12.w),
                    ],
                  ),
                ),
            ],
          );
        },
        child: PlaybackProgress(
          alignment: isExpanded ? Alignment.center : Alignment.bottomCenter,
          progress: playerRepo.videoProgressStream,
          // TODO(Josh4500): Revisit this code
          start: playerRepo.currentVideoProgress ?? Progress.zero,
          // TODO(Josh4500): Get ready value
          end: const Duration(minutes: 1),
          animation: progressAnimation,
          bufferAnimation: bufferAnimation,
          onTap: onTap,
          onDragStart: onHorizontalDragStart,
          onChangePosition: onChangePosition,
          onDragEnd: onHorizontalDragEnd,
          onVerticalDrag: onVerticalDrag,
          onVerticalDragStart: onVerticalDragStart,
          onVerticalDragEnd: onVerticalDragEnd,
        ),
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

class _SlideFramePlayButton extends ConsumerWidget {
  const _SlideFramePlayButton({required this.onClose});
  final VoidCallback onClose;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            onTap: () {
              onClose();
              ref.read(playerRepositoryProvider).playVideo();
            },
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
  const _OverlayVideoSuggestions({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext context,
        WidgetRef ref,
        Widget? childWidget,
      ) {
        final isExpanded = ref.watch(
          playerViewStateProvider.select((state) => state.isExpanded),
        );
        final isLandscape = context.orientation.isLandscape;
        if (isExpanded || isLandscape) {
          return AnimatedVisibility(
            animation: animation,
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
        }
        return const SizedBox();
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
