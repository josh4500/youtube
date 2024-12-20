import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../../provider/media_album_state.dart';
import '../../provider/short_recording_state.dart';
import '../media/media_selector.dart';
import '../notifications/capture_notification.dart';
import '../notifications/create_notification.dart';

class CaptureRecordingControl extends StatelessWidget {
  const CaptureRecordingControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? _) {
              final album = ref.watch(mediaAlbumStateProvider).value?.selected;
              if (album == null) {
                return const Icon(YTIcons.image_outlined, size: 40);
              }
              return GestureDetector(
                onTap: () => showMediaSelector(context, videoOnly: false),
                child: Container(
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
                ),
              );
            },
          ),
          SizedBox(width: 36.w),
          Expanded(
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? _) {
                final recordingState = ref.watch(shortRecordingProvider);
                return Row(
                  children: [
                    if (recordingState.canUndo)
                      GestureDetector(
                        onTap: () {
                          if (recordingState.hasOneRecording) {
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
                      SizedBox(width: 38.w),
                    const Spacer(),
                    if (recordingState.canRedo)
                      GestureDetector(
                        onTap: () {
                          if (recordingState.canRedo) {
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
                      SizedBox(width: 38.w),
                    SizedBox(width: 36.w),
                    if (recordingState.canUndo)
                      _CompleteButton(
                        isPublishable: recordingState.isPublishable,
                      )
                    else
                      SizedBox(width: 38.w),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CompleteButton extends StatelessWidget {
  const _CompleteButton({required this.isPublishable});

  final bool isPublishable;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isPublishable) {
          CompleteNotification().dispatch(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isPublishable ? Colors.white : Colors.white24,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          YTIcons.check_outlined,
          color: Colors.black,
          size: 32,
        ),
      ),
    );
  }
}
