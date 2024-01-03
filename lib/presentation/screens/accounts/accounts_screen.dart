import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';
import 'package:youtube_clone/presentation/screens/accounts/account_incognito_screen.dart';
import 'package:youtube_clone/presentation/screens/accounts/widgets/account_option_tile.dart';
import 'package:youtube_clone/presentation/screens/accounts/widgets/account_section.dart';
import 'package:youtube_clone/presentation/widgets/builders/auth_state_builder.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';

import '../../widgets/playlist/add_new_playlist.dart';
import '../../widgets/appbar_action.dart';
import '../../widgets/custom_action_chip.dart';
import '../../widgets/playable/playable_content.dart';
import '../../widgets/tappable_area.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          AppbarAction(
            icon: Icons.cast_outlined,
            onTap: () {},
          ),
          AppbarAction(
            icon: Icons.notifications_outlined,
            onTap: () {},
          ),
          AppbarAction(
            icon: Icons.search,
            onTap: () {},
          ),
          AppbarAction(
            icon: Icons.settings_outlined,
            onTap: () => context.goto(AppRoutes.settings),
          ),
        ],
      ),
      body: AuthStateBuilder(builder: (context, state) {
        if (state.isInIncognito) {
          return const AccountIncognitoScreen();
        }
        return CustomScrollView(
          scrollBehavior: const OverScrollGlowBehavior(enabled: false),
          slivers: [
            SliverToBoxAdapter(
              child: AccountSection(
                onTapSwitchAccount: () {},
                onTapChannelInfo: () {
                  context.goto(AppRoutes.accountChannel);
                },
                onTapGoogleAccount: () {},
                onTapIncognito: () {},
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SomeWidget(
                    title: 'History',
                    height: MediaQuery.sizeOf(context).height * 0.23,
                    onTap: () => context.goto(AppRoutes.watchHistory),
                    itemBuilder: (context, index) {
                      return TappableArea(
                        onPressed: () => context.goto(AppRoutes.watchHistory),
                        child: const PlayableContent(
                          width: 160,
                          height: 110,
                        ),
                      );
                    },
                    itemCount: 3,
                  ),
                  SomeWidget(
                    title: 'Playlist',
                    height: MediaQuery.sizeOf(context).height * 0.23,
                    onTap: () => context.goto(AppRoutes.accountPlaylists),
                    itemBuilder: (context, index) {
                      return TappableArea(
                        onPressed: () => context.goto(
                          AppRoutes.playlist,
                        ),
                        child: index == 7
                            ? const AddNewPlaylist()
                            : const PlayableContent(
                                width: 160,
                                height: 110,
                                isPlaylist: true,
                              ),
                      );
                    },
                    itemCount: 8,
                  ),
                  AccountOptionTile(
                    title: 'Your videos',
                    icon: Icons.video_settings,
                    networkRequired: true,
                    onTap: () => context.goto(AppRoutes.yourVideos),
                  ),
                  AccountOptionTile(
                    title: 'Downloads',
                    summary: '20 recommendations',
                    icon: Icons.download,
                    onTap: () => context.goto(AppRoutes.downloads),
                  ),
                  AccountOptionTile(
                    title: 'Your clips',
                    icon: Icons.cut_outlined,
                    networkRequired: true,
                    onTap: () => context.goto(AppRoutes.yourClips),
                  ),
                  const Divider(thickness: 1.5),
                  AccountOptionTile(
                    title: 'Your movies',
                    icon: Icons.movie_sharp,
                    networkRequired: true,
                    onTap: () => context.goto(AppRoutes.yourMovies),
                  ),
                  AccountOptionTile(
                    title: 'Get Youtube Premium',
                    icon: Icons.video_settings,
                    networkRequired: true,
                    onTap: () {},
                  ),
                  const Divider(thickness: 1.5),
                  AccountOptionTile(
                    title: 'Time watched',
                    icon: Icons.table_rows_outlined,
                    networkRequired: true,
                    onTap: () {},
                  ),
                  AccountOptionTile(
                    title: 'Help and feedback',
                    icon: Icons.help_outline_outlined,
                    onTap: () {},
                  ),
                  const Divider(height: 0, thickness: 1.5),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}

// TODO: Rename and extract components
class SomeWidget extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Axis direction;
  final ScrollPhysics? physics;
  final VoidCallback? onTap;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int? itemCount;

  const SomeWidget({
    super.key,
    required this.title,
    this.width,
    this.height,
    this.physics,
    this.padding,
    this.direction = Axis.horizontal,
    required this.itemBuilder,
    this.onTap,
    this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            ListTile(
              title: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              onTap: onTap,
            ),
            Positioned(
              top: 10,
              right: 5,
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: CustomActionChip(
                  title: 'View all',
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  border: const Border.fromBorderSide(
                    BorderSide(color: Colors.white12, width: 0.9),
                  ),
                  onTap: onTap,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: width,
          height: height,
          child: ScrollConfiguration(
            behavior: const OverScrollGlowBehavior(enabled: false),
            child: ListView.builder(
              physics: physics,
              padding: padding ??
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
              itemCount: itemCount,
              itemBuilder: itemBuilder,
              scrollDirection: direction,
            ),
          ),
        ),
      ],
    );
  }
}
