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
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets/player/playback/playback_caption.dart';
import 'package:youtube_clone/presentation/widgets/player/playback/playback_duration.dart';

import 'playback_progress.dart';

class PlaybackView extends StatefulWidget {
  const PlaybackView({super.key, required this.placeholder});
  final Widget placeholder;

  @override
  State<PlaybackView> createState() => _PlaybackViewState();
}

class _PlaybackViewState extends State<PlaybackView> {
  final bool _showPlaybackControls = false;
  final bool _showCaptions = false;
  final bool _hasTimage = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        widget.placeholder,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (_showPlaybackControls) ...<Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(YTIcons.sound_off),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.closed_caption),
              ),
            ],
            const Spacer(),
            const PlaybackDuration(),
          ],
        ),
        if (_showPlaybackControls && _showCaptions)
          const Positioned(
            left: 16,
            bottom: 16,
            child: PlaybackCaption(),
          ),
        if (_showPlaybackControls || _hasTimage)
          const Align(
            alignment: Alignment.bottomCenter,
            child: PlaybackProgress(),
          ),
      ],
    );
  }
}
