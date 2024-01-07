import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/channel/widgets/for_you_shorts_content.dart';
import 'package:youtube_clone/presentation/widgets/player/playback/playback_duration.dart';
import 'package:youtube_clone/presentation/widgets/player/playback/playback_progress.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

class ForYouVideoContent extends StatelessWidget {
  const ForYouVideoContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TappableArea(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: 16,
          top: 8,
        ),
        child: SizedBox(
          width: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: PlaybackDuration(),
                      ),
                      const Align(
                        alignment: Alignment.bottomLeft,
                        child: PlaybackProgress(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text('To beat the iPhone You Must... Be the iPhone?'),
              RichText(
                text: const TextSpan(
                  text: '31M views',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  children: [
                    TextSpan(text: '  '),
                    TextSpan(text: '1 month ago'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
