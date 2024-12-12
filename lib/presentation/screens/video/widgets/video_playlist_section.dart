import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'video_notification.dart';

class VideoPlaylistSection extends StatelessWidget {
  const VideoPlaylistSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        reverse: true,
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 12,
            ),
            child: TappableArea(
              onTap: () => OpenBottomSheetNotification(
                sheet: VideoBottomSheet.playlist,
              ).dispatch(context),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: context.theme.canvasColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(YTIcons.playlists_outlined),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Next: Distributed Systems 1.2: Computer',
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Next: Distributed Systems series 1/23',
                              style: TextStyle(
                                fontSize: 12,
                                color: context.theme.colorScheme.surface
                                    .withValues(alpha: .38),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(YTIcons.chevron_down),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
