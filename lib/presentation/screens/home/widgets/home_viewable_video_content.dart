import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class HomeViewableVideoContent extends ConsumerWidget {
  const HomeViewableVideoContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ViewableVideoContent(
      onTap: () async {
        if (context.orientation.isLandscape) {
          await context.goto(
            AppRoutes.playerLandscapeScreen,
          );
        }
        ref.read(playerRepositoryProvider).openPlayerScreen();
      },
      onMore: () {
        showDynamicSheet(
          context,
          items: [
            DynamicSheetItem(
              leading: const Icon(
                YTIcons.playlist_play_outlined,
              ),
              title: 'Play next in queue',
              trailing: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image.asset(
                  AssetsPath.ytPAccessIcon48,
                  width: 18,
                  height: 18,
                ),
              ),
            ),
            const DynamicSheetItem(
              leading: Icon(YTIcons.watch_later_outlined),
              title: 'Save to Watch later',
            ),
            const DynamicSheetItem(
              leading: Icon(YTIcons.save_outlined_1),
              title: 'Save to playlist',
            ),
            const DynamicSheetItem(
              leading: Icon(YTIcons.share_outlined),
              title: 'Share',
            ),
            const DynamicSheetItem(
              leading: Icon(
                YTIcons.not_interested_outlined,
              ),
              title: 'Not interested',
            ),
            const DynamicSheetItem(
              leading: Icon(
                YTIcons.not_interested_outlined,
              ),
              title: 'Don\'t recommend channel',
              dependents: [
                DynamicSheetItemDependent.auth,
              ],
            ),
            const DynamicSheetItem(
              leading: Icon(
                YTIcons.youtube_music_outlined,
              ),
              title: 'Listened with YouTube music',
              trailing: Icon(
                YTIcons.external_link_rounded_outlined,
                size: 20,
              ),
            ),
            const DynamicSheetItem(
              leading: Icon(YTIcons.report_outlined),
              title: 'Report',
            ),
          ],
        );
      },
    );
  }
}
