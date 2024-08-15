import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../../provider/media_album_state.dart';
import '../notifications/create_notification.dart';

class CaptureTimelineControl extends StatelessWidget {
  const CaptureTimelineControl({super.key});

  @override
  Widget build(BuildContext context) {
    const timelineState = CreateTimelineState(
      recordDuration: Duration(seconds: 15),
    );
    return Row(
      children: [
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? _) {
            final album = ref.read(mediaAlbumStateProvider).value?.selected;
            if (album == null) {
              return const Icon(Icons.photo_outlined, size: 40);
            }
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AssetEntityImage(
                  album.thumbAsset,
                  fit: BoxFit.cover,
                  isOriginal: false, // Defaults to `true`.
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 36),
        if (timelineState.hasTimelines)
          GestureDetector(
            onTap: () {
              timelineState.undo();
              // ModelBinding.update<CreateTimelineState>(context, timelineState);
              if (timelineState.timelines.isEmpty) {
                CreateNotification(hideNavigator: false).dispatch(context);
              }
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
        if (timelineState.hasUndidTimeline)
          GestureDetector(
            onTap: () {
              timelineState.redo();
              // ModelBinding.update<CreateTimelineState>(context, timelineState);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: const Icon(YTIcons.redo_arrow, size: 30),
            ),
          ),
        const SizedBox(width: 36),
        if (timelineState.isCompleted)
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
