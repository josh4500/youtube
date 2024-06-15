import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../notifications/create_notification.dart';

class CaptureTimelineControl extends StatelessWidget {
  const CaptureTimelineControl({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
        const SizedBox(width: 36),
        GestureDetector(
          onTap: () {
            // TODO(josh4500): Check if recorded timeline is empty
            CreateNotification(hideNavigator: false).dispatch(context);
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.black26,
              shape: BoxShape.circle,
            ),
            child: const Icon(YTIcons.undo_arrow, size: 30),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
          ),
          child: const Icon(YTIcons.redo_arrow, size: 30),
        ),
        const SizedBox(width: 36),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            YTIcons.check_outlined,
            color: Colors.black,
            size: 30,
          ),
        ),
      ],
    );
  }
}
