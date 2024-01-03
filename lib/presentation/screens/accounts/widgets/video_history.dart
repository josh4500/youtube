import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';

import '../../../widgets/playable/playable_shorts_content.dart';
import '../../../widgets/playable/playable_video_content.dart';

class VideoHistory extends StatelessWidget {
  const VideoHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const OverScrollGlowBehavior(enabled: false),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return const PlayableVideoContent(
            height: 160,
          );
        },
        itemCount: 1,
      ),
    );
  }
}
