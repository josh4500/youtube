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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/provider/state/player_state_provider.dart';
import 'package:youtube_clone/presentation/widgets/appbar_action.dart';
import 'package:youtube_clone/presentation/widgets/player/playback/playback_progress.dart';

import 'player_autoplay_switch.dart';

class PlayerOverlayControls extends StatelessWidget {
  const PlayerOverlayControls({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black26,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                RotatedBox(
                  quarterTurns: 1,
                  child: Icon(Icons.chevron_right_rounded),
                ),
                Spacer(),
                PlayerAutoplaySwitch(),
                AppbarAction(icon: Icons.cast_outlined),
                AppbarAction(icon: Icons.closed_caption_off),
                AppbarAction(icon: Icons.settings_outlined),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.skip_previous,
                      color: Colors.white30,
                    ),
                  ),
                  const _PlayPauseControl(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.skip_next),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
          const Column(
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
                    Icon(Icons.fullscreen),
                  ],
                ),
              ),
              PlaybackProgress()
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayPauseControl extends ConsumerStatefulWidget {
  const _PlayPauseControl();

  @override
  ConsumerState<_PlayPauseControl> createState() => _PlayPauseControlState();
}

class _PlayPauseControlState extends ConsumerState<_PlayPauseControl>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    final isPlaying = ref.read(playerNotifierProvider).playing;
    controller = AnimationController(
      vsync: this,
      value: isPlaying ? 0 : 1,
      duration: const Duration(milliseconds: 300),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = ref.watch(
      playerNotifierProvider.select((value) => value.playing),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: () {
          if (isPlaying) {
            controller.forward();
            ref.read(playerRepositoryProvider).pauseVideo();
          } else {
            controller.reverse();
            ref.read(playerRepositoryProvider).playVideo();
          }
        },
        borderRadius: BorderRadius.circular(32),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.black12,
            shape: BoxShape.circle,
          ),
          child: AnimatedIcon(
            icon: AnimatedIcons.pause_play,
            progress: animation,
            size: 54.0,
            semanticLabel: 'Show menu',
          ),
        ),
      ),
    );
  }
}
