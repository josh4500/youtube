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
import 'package:youtube_clone/core/utils/duration.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class PlayerDurationControl extends ConsumerStatefulWidget {
  const PlayerDurationControl({
    super.key,
    this.full = true,
    this.reversed = false,
  });
  final bool full;
  final bool reversed;

  @override
  ConsumerState<PlayerDurationControl> createState() =>
      _PlayerDurationControlState();
}

class _PlayerDurationControlState extends ConsumerState<PlayerDurationControl> {
  bool reversed = false;

  @override
  Widget build(BuildContext context) {
    final videoDuration =
        ref.read(playerRepositoryProvider).currentVideoDuration;
    final videoPosition =
        ref.read(playerRepositoryProvider).currentVideoPosition;
    final positionStream = ref.read(playerRepositoryProvider).positionStream;

    return GestureDetector(
      onTap: () {
        if (widget.reversed == false) {
          setState(() => reversed = !reversed);
        }
      },
      child: CustomOrientationBuilder(
        onLandscape: (context, childWidget) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: childWidget,
          );
        },
        onPortrait: (context, childWidget) {
          return Padding(
            padding: EdgeInsets.zero,
            child: childWidget,
          );
        },
        child: Row(
          children: [
            const SizedBox(width: 8),
            StreamBuilder<Duration>(
              stream: positionStream,
              initialData: videoPosition,
              builder: (
                BuildContext context,
                AsyncSnapshot<Duration> snapshot,
              ) {
                final position = reversed || widget.reversed
                    ? videoDuration - (snapshot.data ?? Duration.zero)
                    : snapshot.data ?? Duration.zero;
                return Text(
                  '${reversed && !widget.reversed ? ' - ' : ''}${position.hoursMinutesSeconds}',
                  style: const TextStyle(fontSize: 11.5),
                );
              },
            ),
            if (widget.full)
              Text.rich(
                TextSpan(
                  text: '/',
                  children: [
                    TextSpan(
                      text: videoDuration.hoursMinutesSeconds,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Colors.white60,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
