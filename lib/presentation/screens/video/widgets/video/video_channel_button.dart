import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class VideoChannelButton extends StatelessWidget {
  const VideoChannelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AccountAvatar(size: 28, name: 'John Jackson'),
        SizedBox(width: 8),
        Flexible(
          child: Text(
            'Harris Craycraft',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text.rich(
          TextSpan(
            text: ' ',
            children: [
              IconSpan(
                YTIcons.verified_filled,
                color: Color(0xFFAAAAAA),
              ),
              TextSpan(text: ' 101K'),
            ],
          ),
          maxLines: 1,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFFAAAAAA),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
