import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/provider/state/player_view_state_provider.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../video_notification.dart';
import 'player_notifications.dart';

class PlayerChapterControl extends ConsumerWidget {
  const PlayerChapterControl({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (context.orientation.isLandscape) {
          ExitFullscreenPlayerNotification().dispatch(context);
        }
        OpenBottomSheetNotification(
          sheet: VideoBottomSheet.chapter,
        ).dispatch(context);
        ref.read(playerRepositoryProvider).sendPlayerSignal([
          if (ref.read(playerViewStateProvider).showChapters)
            PlayerSignal.showControls
          else
            PlayerSignal.hideControls,
        ]);
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              text: kDotSeparator,
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'Intro',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    IconSpan(YTIcons.chevron_right),
                  ],
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
  }
}
