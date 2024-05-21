import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/state/player_view_state_provider.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

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
            final playerViewState = ref.watch(playerViewStateProvider);

            // Hides Action controls when description or comments is show
            if (playerViewState.showDescription) {
              return const SizedBox();
            }
            return childWidget!;
          },
        );
      },
      onPortrait: (_, childWidget) => Consumer(
        builder: (context, ref, child) {
          final playerViewState = ref.watch(playerViewStateProvider);

          // Shows Action controls when player is expanded
          if (playerViewState.isExpanded) {
            return childWidget!;
          }
          return const SizedBox();
        },
      ),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return Row(
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
                          PlayerSignal.openComments,
                        ]);
                      },
                    ),
                    const AppbarAction(icon: YTIcons.save_outlined),
                    const AppbarAction(icon: YTIcons.shared_filled),
                    AppbarAction(
                      onTap: () {
                        ref.read(playerRepositoryProvider).sendPlayerSignal([
                          PlayerSignal.hideControls,
                          PlayerSignal.exitExpanded,
                          PlayerSignal.openDescription,
                        ]);
                      },
                      icon: YTIcons.more_horiz_outlined,
                    ),
                  ],
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final playerViewState = ref.watch(playerViewStateProvider);
                  if (playerViewState.isExpanded) return const SizedBox();
                  return const Spacer();
                },
              ),
              const PlayerMoreVideos(),
            ],
          );
        },
      ),
    );
  }
}

class PlayerMoreVideos extends StatelessWidget {
  const PlayerMoreVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return TappableArea(
      child: Row(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final playerViewState = ref.watch(playerViewStateProvider);
              if (playerViewState.isExpanded) {
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
        ],
      ),
    );
  }
}
