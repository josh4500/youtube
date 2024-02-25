// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
  const _PlayPauseControl({super.key});

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
