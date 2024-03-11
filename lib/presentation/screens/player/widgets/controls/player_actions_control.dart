import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/screens/player/providers/player_expanded_state_provider.dart';
import 'package:youtube_clone/presentation/screens/player/providers/player_viewstate_provider.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../providers/player_signal_provider.dart';

class PlayerActionsControl extends StatelessWidget {
  const PlayerActionsControl({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomOrientationBuilder(
      onLandscape: (_, childWidget) {
        return Consumer(
          builder: (context, ref, child) {
            ref.watch(
              playerSignalProvider.select(
                (value) {
                  final event = value.value;

                  return event == PlayerSignal.enterFullscreen ||
                      event == PlayerSignal.exitFullscreen ||
                      event == PlayerSignal.openDescription ||
                      event == PlayerSignal.closeDescription ||
                      event == PlayerSignal.openComments ||
                      event == PlayerSignal.closeComments;
                },
              ),
            );

            // Hides Action controls when description or comments is show
            if (ref.read(playerViewStateProvider).showDescription) {
              return const SizedBox();
            }
            return childWidget!;
          },
        );
      },
      onPortrait: (_, childWidget) => Consumer(
        builder: (context, ref, child) {
          ref.watch(playerExpandedStateProvider);

          // Shows Action controls when player is expanded
          if (ref.read(playerViewStateProvider).isExpanded) {
            return childWidget!;
          }
          return const SizedBox();
        },
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.thumb_up_alt_outlined),
                  const Icon(Icons.thumb_down_alt_outlined),
                  Consumer(
                    builder: (context, ref, child) {
                      return AppbarAction(
                        icon: Icons.chat_outlined,
                        onTap: () {
                          ref.read(playerRepositoryProvider).sendPlayerSignal([
                            PlayerSignal.hideControls,
                            PlayerSignal.openComments,
                          ]);
                        },
                      );
                    },
                  ),
                  const Icon(Icons.add_box_outlined),
                  const Icon(Icons.reply_outlined),
                  const Icon(Icons.more_horiz),
                ],
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                ref.watch(playerExpandedStateProvider);
                final isExpanded =
                    ref.watch(playerViewStateProvider).isExpanded;
                if (isExpanded) return const SizedBox();
                return const Spacer();
              },
            ),
            const SizedBox(width: 32),
            TappableArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      ref.watch(playerExpandedStateProvider);
                      final isExpanded =
                          ref.watch(playerViewStateProvider).isExpanded;
                      if (isExpanded) {
                        return const SizedBox();
                      }

                      return const Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'More videos',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Tap or swipe up to see all',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                        ],
                      );
                    },
                  ),
                  const PlayerMoreVideos(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerMoreVideos extends StatelessWidget {
  const PlayerMoreVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
