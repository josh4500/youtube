import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/channel/widgets/for_you_shorts_content.dart';
import 'package:youtube_clone/presentation/screens/channel/widgets/for_you_video_content.dart';
import 'package:youtube_clone/presentation/view_models/content/content_view_model.dart';
import 'package:youtube_clone/presentation/view_models/content/shorts_view_model.dart';

class ForYouContent extends StatelessWidget {
  final ContentViewModel content;
  const ForYouContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    if (content is ShortsViewModel) {
      return const ForYouShortsContent();
    } else {
      return const ForYouVideoContent();
    }
  }
}
