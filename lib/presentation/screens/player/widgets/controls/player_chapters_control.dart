import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/screens/player/providers/player_viewstate_provider.dart';

class PlayerChapterControl extends ConsumerWidget {
  const PlayerChapterControl({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(playerRepositoryProvider).sendPlayerSignal([
          PlayerSignal.openChapters,
          if (ref.read(playerViewStateProvider).showChapters)
            PlayerSignal.showControls
          else
            PlayerSignal.hideControls,
        ]);
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text.rich(
            TextSpan(
              text: '·  ',
              style: TextStyle(
                fontSize: 13.5,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
              children: [
                TextSpan(
                  text: 'Intro',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.clip,
          ),
          Icon(
            Icons.chevron_right_outlined,
            size: 18,
          ),
        ],
      ),
    );
  }
}
