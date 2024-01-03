import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';

import '../../../widgets/playable/playable_shorts_content.dart';

class ShortsHistory extends StatelessWidget {
  const ShortsHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16,
          ),
          child: Text('Today'),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.sort_sharp,
                size: 40,
              ),
              SizedBox(width: 16),
              Text(
                'Shorts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 176,
          child: ScrollConfiguration(
            behavior: const OverScrollGlowBehavior(enabled: false),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16),
              itemBuilder: (context, index) {
                return const PlayableShortsContent(
                  width: 116,
                );
              },
              itemCount: 20,
            ),
          ),
        ),
      ],
    );
  }
}
