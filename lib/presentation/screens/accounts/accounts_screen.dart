// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
import '../../widgets/playable/playable_content.dart';
import '../../widgets/tappable_area.dart';
import '../../widgets/viewable/group/viewable_group_contents.dart';

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
                onTapIncognito: () {},
                onTapChannelInfo: () => context.goto(AppRoutes.accountChannel),
                onTapSwitchAccount: () {},
                onTapGoogleAccount: () {},
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ViewableGroupContent(
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
                  ViewableGroupContent(
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
