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
