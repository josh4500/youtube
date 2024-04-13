// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'package:flutter/material.dart';
import 'package:youtube_clone/core/enums/auth_state.dart';
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';
import 'package:youtube_clone/presentation/screens/accounts/account_incognito_screen.dart';
import 'package:youtube_clone/presentation/screens/accounts/widgets/account_option_tile.dart';
import 'package:youtube_clone/presentation/screens/accounts/widgets/account_section.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../widgets/playlist/add_new_playlist.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          AppbarAction(
            icon: YTIcons.cast_outlined,
            onTap: () {},
          ),
          AppbarAction(
            icon: YTIcons.notification_outlined,
            onTap: () => context.goto(AppRoutes.notifications),
          ),
          AppbarAction(
            icon: YTIcons.search_outlined,
            onTap: () => context.goto(AppRoutes.search),
          ),
          AppbarAction(
            icon: YTIcons.settings_outlined,
            onTap: () => context.goto(AppRoutes.settings),
          ),
        ],
      ),
      body: AuthStateBuilder(
        builder: (BuildContext context, AuthState state) {
          if (state.isInIncognito) {
            return const AccountIncognitoScreen();
          }
          return CustomScrollView(
            scrollBehavior: const OverScrollGlowBehavior(enabled: false),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: AccountSection(
                  onTapIncognito: () {},
                  onTapChannelInfo: () {
                    context.goto(AppRoutes.accountChannel);
                  },
                  onTapSwitchAccount: () {},
                  onTapGoogleAccount: () {},
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    GroupedViewBuilder(
                      title: 'History',
                      height: 170,
                      onTap: () => context.goto(AppRoutes.watchHistory),
                      itemBuilder: (BuildContext context, int index) {
                        return TappableArea(
                          child: PlayableContent(
                            width: 160,
                            margin: const EdgeInsets.only(bottom: 16),
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
                                    leading: Icon(
                                      YTIcons.watch_later_outlined,
                                    ),
                                    title: 'Save to Watch later',
                                  ),
                                  const DynamicSheetItem(
                                    leading: Icon(YTIcons.save_outlined_1),
                                    title: 'Save to playlist',
                                  ),
                                  const DynamicSheetItem(
                                    leading: Icon(YTIcons.download_outlined),
                                    title: 'Download',
                                  ),
                                  const DynamicSheetItem(
                                    leading: Icon(YTIcons.share_outlined),
                                    title: 'Share',
                                  ),
                                  const DynamicSheetItem(
                                    leading: Icon(YTIcons.delete_outlined),
                                    title: 'Remove from watch history',
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                      itemCount: 3,
                    ),
                    GroupedViewBuilder(
                      title: 'Playlist',
                      height: 170,
                      onTap: () => context.goto(AppRoutes.accountPlaylists),
                      itemBuilder: (BuildContext context, int index) {
                        return TappableArea(
                          onTap: () => context.goto(AppRoutes.playlist),
                          child: index == 7
                              ? const AddNewPlaylist()
                              : PlayableContent(
                                  width: 160,
                                  isPlaylist: true,
                                  margin: const EdgeInsets.only(bottom: 16),
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
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            child: Image.asset(
                                              AssetsPath.ytPAccessIcon48,
                                              width: 18,
                                              height: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                        );
                      },
                      itemCount: 8,
                    ),
                    AccountOptionTile(
                      title: 'Your videos',
                      icon: YTIcons.your_videos_outlined,
                      networkRequired: true,
                      onTap: () => context.goto(AppRoutes.yourVideos),
                    ),
                    AccountOptionTile(
                      title: 'Downloads',
                      summary: '20 recommendations',
                      icon: YTIcons.download_outlined,
                      onTap: () => context.goto(AppRoutes.downloads),
                    ),
                    AccountOptionTile(
                      title: 'Your clips',
                      icon: YTIcons.clip_outlined,
                      networkRequired: true,
                      onTap: () => context.goto(AppRoutes.yourClips),
                    ),
                    const Divider(thickness: 1),
                    AccountOptionTile(
                      title: 'Your movies',
                      icon: YTIcons.movies_outlined,
                      networkRequired: true,
                      onTap: () => context.goto(AppRoutes.yourMovies),
                    ),
                    AccountOptionTile(
                      title: 'Get Youtube Premium',
                      icon: YTIcons.youtube_outlined,
                      networkRequired: true,
                      onTap: () {},
                    ),
                    const Divider(thickness: 1),
                    AccountOptionTile(
                      title: 'Time watched',
                      icon: YTIcons.analytics_outlined,
                      networkRequired: true,
                      onTap: () {},
                    ),
                    AccountOptionTile(
                      title: 'Help and feedback',
                      icon: YTIcons.help_outlined,
                      onTap: () {},
                    ),
                    const Divider(height: 0, thickness: 1),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
