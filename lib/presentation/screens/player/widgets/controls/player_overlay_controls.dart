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
import 'package:youtube_clone/presentation/provider/state/player_tap_provider.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/controls/player_next.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/controls/player_previous.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/player_notifications.dart';
import 'package:youtube_clone/presentation/widgets/appbar_action.dart';
import 'package:youtube_clone/presentation/widgets/player/playback/playback_progress.dart';

import 'player_autoplay_switch.dart';
import 'player_fullscreen.dart';
import 'player_minimize.dart';
import 'player_play_pause_restart.dart';

class PlayerOverlayControls extends ConsumerStatefulWidget {
  const PlayerOverlayControls({super.key});

  @override
  ConsumerState<PlayerOverlayControls> createState() =>
      _PlayerOverlayControlsState();
}

class _PlayerOverlayControlsState extends ConsumerState<PlayerOverlayControls>
    with TickerProviderStateMixin {
  late final AnimationController _controlsOpacityController;
  late final Animation<double> _controlsAnimation;

  bool _controlsHidden = true;

  final _progressIsVisible = ValueNotifier<bool>(true);
  late final AnimationController _progressController;
  late final Animation<Color?> _progressAnimation;
  late final Animation<Color?> _bufferAnimation;

  Duration? _lastDuration;
  Duration? _upperboundSlideDuration;
  Duration? _lowerboundSlideDuration;

  final _showSlidingSeekIndicator = ValueNotifier<bool>(false);
  bool get _isSlidingSeek => _showSlidingSeekIndicator.value;
  final _slidingSeekDuration = ValueNotifier<Duration?>(null);
  final _showSlidingSeekDuration = ValueNotifier<bool>(false);

  final _showForward2XIndicator = ValueNotifier<bool>(false);
  bool _isForwardSeek = true;
  final _showDoubleTapSeekIndicator = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _controlsOpacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 175),
      reverseDuration: const Duration(milliseconds: 100),
    );

    _controlsAnimation = CurvedAnimation(
      parent: _controlsOpacityController,
      curve: Curves.easeIn,
    );

    _progressController = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 175),
      reverseDuration: const Duration(milliseconds: 100),
    );

    _progressAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.white,
    ).animate(_progressController);

    _bufferAnimation = ColorTween(
      begin: Colors.white24,
      end: Colors.transparent,
    ).animate(_progressController);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // TODO: Make sure after video is loaded
      _progressController.forward();
    });
  }

  // Timer instance
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoDuration =
        ref.read(playerRepositoryProvider).currentVideoDuration;
    return Consumer(
      builder: (context, ref, childWidget) {
        ref.listen(
          playerTapProvider,
          (previous, next) async {
            final actor = next.asData?.value;
            if (actor != PlayerTapActor.none) {
              _progressIsVisible.value = true;
              if (_controlsHidden || actor == PlayerTapActor.control) {
                _controlsHidden = false;
                _controlsOpacityController.forward();
                _progressController.reverse();
              } else {
                _controlsHidden = true;
                _controlsOpacityController.reverse();
                _progressController.forward();
              }

              if (_controlsHidden == false) {
                // Cancel any existing timer
                if (_timer != null && (_timer?.isActive ?? false)) {
                  _timer?.cancel();
                }

                // TODO: Test logic
                final isPlaying = ref.read(playerNotifierProvider).playing;
                // Auto hide only when video is playing
                if (isPlaying) {
                  _timer = Timer(const Duration(seconds: 3), () async {
                    _controlsHidden = true;
                    _progressController.forward();
                    await _controlsOpacityController.reverse();
                    ref
                        .read(playerRepositoryProvider)
                        .tapPlayer(PlayerTapActor.none);
                  });
                }
              }
            } else if (!_controlsHidden) {
              _controlsHidden = true;
              _timer?.cancel();
              _progressController.forward();
              _progressIsVisible.value = false;
              await _controlsOpacityController.reverse(from: 0);
              ref.read(playerRepositoryProvider).tapPlayer(PlayerTapActor.none);
            }
          },
        );

        final hideStateAsync = ref.watch(playerTapProvider);
        return hideStateAsync.when(
          data: (_) => Stack(
            children: [
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
                    clipper: SeekIndicatorClipper(
                      forward: _isForwardSeek,
                    ),
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
                          Builder(
                            builder: (context) {
                              final seekRate =
                                  ref.read(preferencesProvider).doubleTapSeek;
                              return Text(
                                '${_isForwardSeek ? '' : '-'}$seekRate seconds',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _controlsAnimation,
                builder: (context, innerChildWidget) {
                  return GestureDetector(
                    onDoubleTapDown: _onDoubleTapDown,
                    onLongPressStart: _onLongPressStart,
                    onLongPressEnd: _onLongPressEnd,
                    onLongPressMoveUpdate: _onLongPressMoveUpdate,
                    child: Container(
                      color: Colors.transparent,
                      child: Opacity(
                        opacity: _controlsAnimation.value,
                        child: Visibility(
                          visible: _controlsAnimation.value != 0,
                          child: innerChildWidget!,
                        ),
                      ),
                    ),
                  );
                },
                child: childWidget,
              ),
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
              Align(
                alignment: Alignment.lerp(
                  Alignment.center,
                  Alignment.bottomCenter,
                  0.75,
                )!,
                child: SeekIndicator(
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
                child: ValueListenableBuilder(
                  valueListenable: _progressIsVisible,
                  builder: (context, visible, childWidget) {
                    return AnimatedOpacity(
                      opacity: visible ? 1 : 0,
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 175),
                      child: PlaybackProgress(
                        progress: ref
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
            ],
          ),
          error: (_, __) => const SizedBox(),
          loading: () => const SizedBox(),
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
                AppbarAction(icon: Icons.cast_outlined),
                AppbarAction(icon: Icons.closed_caption_off),
                AppbarAction(icon: Icons.settings_outlined),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    );
  }

  void _showProgressIndicator() {}
  void _hideProgressIndicator() {}

  Future<void> _showForwardSeek() async {
    _controlsOpacityController.reverse(from: 0);
    _isForwardSeek = true;
    _showDoubleTapSeekIndicator.value = true;
    final seekDuration = ref.read(preferencesProvider).doubleTapSeek;
    await ref.read(playerRepositoryProvider).seek(
          Duration(seconds: seekDuration),
        );
    _showDoubleTapSeekIndicator.value = false;
  }

  Future<void> _showReverseSeek() async {
    _controlsOpacityController.reverse(from: 0);
    _isForwardSeek = false;
    _showDoubleTapSeekIndicator.value = true;
    final seekDuration = ref.read(preferencesProvider).doubleTapSeek;
    await ref.read(playerRepositoryProvider).seek(
          Duration(seconds: seekDuration),
          reverse: true,
        );
    _showDoubleTapSeekIndicator.value = false;
  }

  void _show2xSpeed() {
    _showForward2XIndicator.value = true;
    _controlsOpacityController.reverse(from: 0);
    ref.read(playerRepositoryProvider).setSpeed();
  }

  void _hide2xSpeed() {
    _showForward2XIndicator.value = false;
    ref.read(playerRepositoryProvider).setSpeed(1.0);
  }

  void _showSlideSeek() {
    _showSlidingSeekIndicator.value = true;
    _controlsOpacityController.reverse(from: 0);
    _showProgressIndicator();
  }

  void _hideSlideSeek() {
    _showSlidingSeekIndicator.value = false;
    _controlsOpacityController.forward();
    _hideProgressIndicator();
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

  void _onDoubleTapDown(TapDownDetails details) {
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

  void _onLongPressStart(LongPressStartDetails details) {
    if (!_controlsHidden) {
      final screenWidth = MediaQuery.sizeOf(context).width;
      final screenHeight = MediaQuery.sizeOf(context).height;

      final isExpanded = ref.read(playerNotifierProvider).expanded;
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
    _startedOnLongPress = false;
    final isPlaying = ref.read(playerNotifierProvider).playing;
    final hasEnded = ref.read(playerNotifierProvider).ended;

    if (isPlaying && !hasEnded) {
      Forward2xSpeedEndPlayerNotification().dispatch(context);
      _hide2xSpeed();
    } else {
      SlideSeekEndPlayerNotification().dispatch(context);
      _hideSlideSeek();
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
          _lastDuration = newDuration;
        }
      } else if (newDuration < _upperboundSlideDuration!) {
        if (_lastDuration! > _upperboundSlideDuration!) {
          HapticFeedback.selectionClick();
          _lastDuration = lastPosition;
        }
      }

      if (newDuration < _lowerboundSlideDuration!) {
        if (_lastDuration! > _lowerboundSlideDuration!) {
          HapticFeedback.selectionClick();
          _lastDuration = newDuration;
        }
      } else if (newDuration > _lowerboundSlideDuration!) {
        if (_lastDuration! < _lowerboundSlideDuration!) {
          HapticFeedback.selectionClick();
          _lastDuration = lastPosition;
        }
      }

      _showSlidingSeekDuration.value = true;
      _slidingSeekDuration.value = newDuration;
    }
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
