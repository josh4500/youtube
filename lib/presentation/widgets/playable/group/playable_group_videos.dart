import 'package:flutter/material.dart';

import '../../gestures/tappable_area.dart';
import '../playable_video_content.dart';

class PlayableGroupVideos extends StatelessWidget {
  const PlayableGroupVideos({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          title: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        SizedBox(
          height: 162,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (BuildContext context, int index) {
              return TappableArea(
                onTap: () {},
                onLongPress: () {},
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                child: const PlayableVideoContent(
                  width: 142,
                  height: 80,
                  direction: Axis.vertical,
                ),
              );
            },
            itemCount: 15,
          ),
        ),
        const SizedBox(height: 10),
        const Divider(height: 0, thickness: 1),
      ],
    );
  }
}
