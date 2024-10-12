import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class HomeViewableVideoContent extends ConsumerWidget {
  const HomeViewableVideoContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ViewableVideoContent(
      onTap: ref.read(playerRepositoryProvider).openPlayerScreen,
      onMore: () {
        showDynamicSheet(
          context,
          items: [
            DynamicSheetOptionItem(
              leading: const Icon(YTIcons.playlist_play_outlined),
              title: 'Play next in queue',
              trailing: ImageFromAsset.ytPAccessIcon,
            ),
            const DynamicSheetOptionItem(
              leading: Icon(YTIcons.watch_later_outlined),
              title: 'Save to Watch later',
            ),
            const DynamicSheetOptionItem(
              leading: Icon(YTIcons.save_outlined),
              title: 'Save to playlist',
            ),
            const DynamicSheetOptionItem(
              leading: Icon(YTIcons.share_outlined),
              title: 'Share',
            ),
            const DynamicSheetOptionItem(
              leading: Icon(
                YTIcons.not_interested_outlined,
              ),
              title: 'Not interested',
            ),
            const DynamicSheetOptionItem(
              leading: Icon(
                YTIcons.not_interested_outlined,
              ),
              title: 'Don\'t recommend channel',
              dependents: [
                DynamicSheetItemDependent.auth,
              ],
            ),
            const DynamicSheetOptionItem(
              leading: Icon(
                YTIcons.youtube_music_outlined,
              ),
              title: 'Listened with YouTube music',
              trailing: Icon(
                YTIcons.external_link_rounded_outlined,
                size: 20,
              ),
            ),
            const DynamicSheetOptionItem(
              leading: Icon(YTIcons.report_outlined),
              title: 'Report',
            ),
          ],
        );
      },
    );
  }
}
