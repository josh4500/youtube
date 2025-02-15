import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../video_notification.dart';

class PlayerActionsControl extends ConsumerWidget {
  const PlayerActionsControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (isExpanded, showDescription) = ref.watch(
      playerViewStateProvider.select(
        (state) => (state.isExpanded, state.showDescription),
      ),
    );
    final childWidget = Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppbarAction(icon: YTIcons.like_outlined),
              const AppbarAction(icon: YTIcons.dislike_outlined),
              AppbarAction(
                icon: YTIcons.reply_outlined,
                onTap: () {
                  ref.read(playerRepositoryProvider).sendPlayerSignal([
                    PlayerSignal.hideControls,
                    PlayerSignal.exitExpanded,
                  ]);
                  OpenBottomSheetNotification(
                    sheet: VideoBottomSheet.comment,
                  ).dispatch(context);
                },
              ),
              const AppbarAction(icon: YTIcons.save_outlined),
              const AppbarAction(icon: YTIcons.shared_filled),
              AppbarAction(
                onTap: () {
                  ref.read(playerRepositoryProvider).sendPlayerSignal([
                    PlayerSignal.hideControls,
                    PlayerSignal.exitExpanded,
                  ]);
                  OpenBottomSheetNotification(
                    sheet: VideoBottomSheet.description,
                  ).dispatch(context);
                },
                icon: YTIcons.more_horiz_outlined,
              ),
            ],
          ),
        ),
        if (isExpanded == false) const Spacer(),
        const PlayerMoreVideos(),
      ],
    );

    if (context.orientation.isLandscape) {
      // Hides Action controls when description or comments is show
      if (showDescription) {
        return const SizedBox();
      }
      return childWidget;
    } else {
      // Shows Action controls when video is expanded
      if (isExpanded) {
        return childWidget;
      }
      return const SizedBox();
    }
  }
}

class _ActionV2 extends StatelessWidget {
  const _ActionV2({this.onTap, required this.title, required this.icon});

  final VoidCallback? onTap;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TappableArea(
        onTap: onTap,
        padding: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                shadows: <Shadow>[Shadow(offset: Offset(1, 1), blurRadius: 2)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerActionsControlV2 extends ConsumerWidget {
  const PlayerActionsControlV2({super.key, this.direction = Axis.horizontal});
  final Axis direction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flex(
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Flex(
            direction: direction,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _ActionV2(icon: YTIcons.like_outlined, title: '52K'),
              const _ActionV2(icon: YTIcons.dislike_outlined, title: 'Dislike'),
              _ActionV2(
                icon: YTIcons.reply_outlined,
                title: '4.9K',
                onTap: () {
                  ref.read(playerRepositoryProvider).sendPlayerSignal([
                    PlayerSignal.hideControls,
                    PlayerSignal.exitExpanded,
                  ]);
                  OpenBottomSheetNotification(
                    sheet: VideoBottomSheet.comment,
                  ).dispatch(context);
                },
              ),
              const _ActionV2(icon: YTIcons.share_outlined, title: 'Share'),
              const _ActionV2(icon: YTIcons.shorts_outlined, title: 'Remix'),
              _ActionV2(
                title: 'More',
                onTap: () {
                  showDynamicSheet(
                    context,
                    items: [
                      const DynamicSheetOptionItem(
                        leading: Icon(YTIcons.save_outlined),
                        title: 'Save',
                      ),
                      const DynamicSheetOptionItem(
                        leading: Icon(YTIcons.clip_outlined),
                        title: 'Clip',
                      ),
                      const DynamicSheetOptionItem(
                        leading: Icon(YTIcons.shorts_filled),
                        title: 'Remix',
                      ),
                    ],
                  );
                },
                icon: YTIcons.more_horiz_outlined,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class PlayerMoreVideos extends StatelessWidget {
  const PlayerMoreVideos({super.key});

  @override
  Widget build(BuildContext context) {
    final moreDescription = Row(
      children: [
        Column(
          crossAxisAlignment: context.orientation.isPortrait
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: const <Widget>[
            Text(
              'More videos',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              'Tap or swipe up to see all',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
    return TappableArea(
      child: Row(
        children: [
          if (context.orientation.isLandscape) moreDescription,
          SizedBox(
            width: 60,
            height: 32,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                for (double i = 0; i < 3; i++)
                  Positioned(
                    top: -2 + (i * 4),
                    child: Container(
                      width: 36 + (i * 4),
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white, width: .9),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (context.orientation.isPortrait) moreDescription,
        ],
      ),
    );
  }
}
