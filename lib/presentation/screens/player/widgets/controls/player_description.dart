import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../video/video_description_button.dart';
import 'player_notifications.dart';

class PlayerDescription extends ConsumerWidget {
  const PlayerDescription({
    super.key,
    this.showOnExpanded = false,
    this.showOnFullscreen = false,
  })  : assert(
          showOnExpanded || showOnFullscreen,
          'At least showOnExpanded or showOnFullscreen should be true',
        ),
        assert(
          !(showOnExpanded && showOnFullscreen),
          'showOnExpanded or showOnFullscreen cannot be true at the same time',
        );
  final bool showOnExpanded;
  final bool showOnFullscreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerViewState = ref.watch(playerViewStateProvider);
    if (showOnExpanded && !playerViewState.isExpanded) {
      return const SizedBox();
    } else if (playerViewState.showDescription ||
        context.orientation.isPortrait) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () {
        if (playerViewState.isExpanded) {
          ExitExpandPlayerNotification().dispatch(context);
        }
        ref.read(playerRepositoryProvider).sendPlayerSignal([
          PlayerSignal.hideControls,
          PlayerSignal.openDescription,
        ]);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: showOnFullscreen ? 8 : 0,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'LP Funds Fund Controversy: LP Spokesman Says Obi\'s Transparency, Foundation Of Labour Party',
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Icon(YTIcons.chevron_right),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'Channels Television',
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerDescriptionV2 extends ConsumerWidget {
  const PlayerDescriptionV2({
    super.key,
    this.showOnExpanded = false,
    this.showOnFullscreen = false,
  }) : assert(
          showOnExpanded || showOnFullscreen,
          'At least showOnExpanded or showOnFullscreen should be true',
        );
  final bool showOnExpanded;
  final bool showOnFullscreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerViewState = ref.watch(playerViewStateProvider);

    if (showOnExpanded && !playerViewState.isExpanded) {
      return const SizedBox();
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: showOnFullscreen ? 8 : 0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TappableArea(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AccountAvatar(size: 32, name: 'Harris Craycraft'),
                SizedBox(width: 12),
                Text.rich(
                  TextSpan(
                    text: 'Harris Craycraft ',
                    children: [
                      IconSpan(
                        YTIcons.verified_filled,
                        color: Color(0xFFAAAAAA),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '101K',
                  style: TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          VideoDescriptionButton(),
        ],
      ),
    );
  }
}
