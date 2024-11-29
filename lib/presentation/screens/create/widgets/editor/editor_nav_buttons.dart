import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../notifications/editor_notification.dart';

class EditorNavButtons extends StatelessWidget {
  const EditorNavButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: CustomActionButton(
              icon: const Icon(YTIcons.timeline, size: 16),
              title: 'Timeline',
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              onTap: () {
                OpenTimelineNotification().dispatch(context);
              },
              alignment: Alignment.center,
              padding: const EdgeInsets.all(12),
              backgroundColor: Colors.white12,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: CustomActionChip(
              title: 'Next',
              alignment: Alignment.center,
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              padding: EdgeInsets.all(12),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
