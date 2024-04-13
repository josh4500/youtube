import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../../providers/player_signal_provider.dart';
import '../../providers/player_viewstate_provider.dart';
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
    ref.watch(
      playerSignalProvider.select(
        (value) {
          final event = value.value;
          if (showOnExpanded) {
            return event == PlayerSignal.enterExpanded ||
                event == PlayerSignal.exitExpanded;
          }

          return event == PlayerSignal.enterFullscreen ||
              event == PlayerSignal.exitFullscreen ||
              event == PlayerSignal.openDescription ||
              event == PlayerSignal.closeDescription ||
              event == PlayerSignal.openComments ||
              event == PlayerSignal.closeComments;
        },
      ),
    );

    if (showOnExpanded) {
      if (!ref.read(playerViewStateProvider).isExpanded) {
        return const SizedBox();
      }
    } else {
      if (!ref.read(playerViewStateProvider).isFullscreen) {
        return const SizedBox();
      } else if (ref.read(playerViewStateProvider).showDescription) {
        return const SizedBox();
      }
    }

    return GestureDetector(
      onTap: () {
        if (ref.read(playerViewStateProvider).isExpanded) {
          DeExpandPlayerNotification().dispatch(context);
        }
        ref.read(playerRepositoryProvider).sendPlayerSignal([
          PlayerSignal.hideControls,
          PlayerSignal.openDescription,
        ]);
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
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
