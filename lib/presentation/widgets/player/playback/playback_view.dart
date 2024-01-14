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
import 'package:youtube_clone/presentation/widgets/player/playback/playback_caption.dart';
import 'package:youtube_clone/presentation/widgets/player/playback/playback_duration.dart';

import 'playback_progress.dart';

class PlaybackView extends StatefulWidget {
  final Widget placeholder;
  const PlaybackView({super.key, required this.placeholder});

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
      children: [
        widget.placeholder,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_showPlaybackControls) ...[
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.volume_off),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.closed_caption),
              ),
            ],
            const Spacer(),
            const PlaybackDuration()
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
