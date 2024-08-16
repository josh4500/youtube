import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../../provider/media_album_state.dart';
import '../../provider/short_recording_state.dart';
import '../notifications/create_notification.dart';

class CaptureTimelineControl extends StatelessWidget {
  const CaptureTimelineControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? _) {
            final album = ref.watch(mediaAlbumStateProvider).value?.selected;
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
        Expanded(
          child: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? _) {
              final timelineState = ref.watch(shortRecordingProvider);
              return Row(
                children: [
                  if (timelineState.hasTimelines)
                    GestureDetector(
                      onTap: () {
                        if (timelineState.hasOneTimeline) {
                          CreateNotification(hideNavigator: false)
                              .dispatch(context);
                        }
                        ref.read(shortRecordingProvider.notifier).undo();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(YTIcons.undo_arrow, size: 30),
                      ),
                    )
                  else
                    const SizedBox(width: 38),
                  const Spacer(),
                  if (timelineState.hasUndidTimeline)
                    GestureDetector(
                      onTap: () {
                        if (timelineState.hasUndidTimeline) {
                          CreateNotification(hideNavigator: true)
                              .dispatch(context);
                        }
                        ref.read(shortRecordingProvider.notifier).redo();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(YTIcons.redo_arrow, size: 30),
                      ),
                    )
                  else
                    const SizedBox(width: 38),
                  const SizedBox(width: 36),
                  if (timelineState.hasTimelines)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: timelineState.isPublishable
                            ? Colors.white
                            : Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        YTIcons.check_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                    )
                  else
                    const SizedBox(width: 38),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
