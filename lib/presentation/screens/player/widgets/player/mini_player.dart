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
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        const Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Google Chromecast: Official Video',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFFF1F1F1),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Harris Craycraft',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFFAAAAAA),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: ListView(
            reverse: true,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: const <Widget>[
              _MiniPlayerCloseButton(),
              _MiniPlayerPausePlayButton(),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniPlayerPausePlayButton extends ConsumerWidget {
  const _MiniPlayerPausePlayButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerNotifier = ref.watch(playerNotifierProvider);
    final isPlaying = playerNotifier.playing;
    final isRestart = playerNotifier.ended;
    final isLoading = playerNotifier.loading;
    return TappableArea(
      onTap: () {
        if (!isRestart) {
          if (isPlaying) {
            ref.read(playerRepositoryProvider).pauseVideo();
          } else {
            ref.read(playerRepositoryProvider).playVideo();
          }
        } else if (!isLoading) {
          ref.read(playerRepositoryProvider).restartVideo();
        }
      },
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
      child: Icon(
        isRestart
            ? Icons.restart_alt
            : isPlaying
                ? Icons.pause
                : Icons.play_arrow,
      ),
    );
  }
}

class _MiniPlayerCloseButton extends ConsumerWidget {
  const _MiniPlayerCloseButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TappableArea(
      onTap: ref.read(playerRepositoryProvider).closePlayerScreen,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14),
      child: const Icon(YTIcons.close_outlined),
    );
  }
}
