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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/provider/state/player_tap_provider.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/controls/player_next.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/controls/player_previous.dart';
import 'package:youtube_clone/presentation/widgets/appbar_action.dart';
import 'package:youtube_clone/presentation/widgets/player/playback/playback_progress.dart';

import 'player_autoplay_switch.dart';
import 'player_fullscreen.dart';
import 'player_minimize.dart';
import 'player_play_pause_restart.dart';

class PlayerOverlayControls extends StatefulWidget {
  const PlayerOverlayControls({super.key});

  @override
  State<PlayerOverlayControls> createState() => _PlayerOverlayControlsState();
}

class _PlayerOverlayControlsState extends State<PlayerOverlayControls>
    with TickerProviderStateMixin {
  late final AnimationController _controlsOpacityController;
  late final Animation<double> _controlsAnimation;
  bool hidden = true;

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
    return Consumer(
      builder: (context, ref, childWidget) {
        ref.listen(
          playerTapProvider,
          (previous, next) async {
            final actor = next.asData?.value;
            if (actor != PlayerTapActor.none) {
              if (hidden || actor == PlayerTapActor.control) {
                hidden = false;
                _controlsOpacityController.forward();
              } else {
                hidden = true;
                _controlsOpacityController.reverse();
              }

              if (hidden == false) {
                // Cancel any existing timer
                if (_timer != null && (_timer?.isActive ?? false)) {
                  _timer?.cancel();
                }

                _timer = Timer(const Duration(seconds: 5), () async {
                  hidden = true;
                  await _controlsOpacityController.reverse();
                  ref
                      .read(playerRepositoryProvider)
                      .tapPlayer(PlayerTapActor.none);
                });
              }
            } else if (!hidden) {
              hidden = true;
              _timer?.cancel();
              await _controlsOpacityController.reverse(from: 0);
              ref.read(playerRepositoryProvider).tapPlayer(PlayerTapActor.none);
            }
          },
        );

        final hideStateAsync = ref.watch(playerTapProvider);
        return hideStateAsync.when(
          data: (_) => AnimatedBuilder(
            animation: _controlsAnimation,
            builder: (context, innerChildWidget) {
              return Visibility(
                visible: _controlsAnimation.value > 0,
                child: Opacity(
                  opacity: _controlsAnimation.value,
                  child: innerChildWidget,
                ),
              );
            },
            child: childWidget,
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
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('0:18'),
                          Text(
                            ' / 5:22:41',
                            style: TextStyle(
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                      PlayerFullscreen(),
                    ],
                  ),
                ),
                PlaybackProgress()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
