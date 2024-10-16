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
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/account_channel_section.dart';
import 'widgets/popup/show_account_playlists_sort_menu.dart';

class AccountChannelScreen extends StatefulWidget {
  const AccountChannelScreen({super.key});

  @override
  State<AccountChannelScreen> createState() => _AccountChannelScreenState();
}

class _AccountChannelScreenState extends State<AccountChannelScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Josh',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
          leading: CustomBackButton(onPressed: context.pop),
          actions: <Widget>[
            AppbarAction(
              icon: YTIcons.cast_outlined,
              onTap: () {},
            ),
            AppbarAction(
              icon: YTIcons.search_outlined,
              onTap: () => context.goto(AppRoutes.search),
            ),
            AppbarAction(
              icon: YTIcons.more_vert_outlined,
              onTap: () {},
            ),
          ],
        ),
        body: ScrollConfiguration(
          behavior: const OverScrollGlowBehavior(enabled: false),
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool isInScroll) {
              return <Widget>[
                SliverToBoxAdapter(
                  child: AccountChannelSection(moreChannel: () {}),
                ),
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context,
                  ),
                  sliver: const SliverPersistentHeader(
                    floating: true,
                    pinned: true,
                    delegate: PersistentHeaderDelegate(
                      maxHeight: 50,
                      minHeight: 50,
                      child: TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        tabs: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Tab(text: 'Home'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Tab(text: 'Playlists'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                Container(), // TODO(Josh): Home tab
                Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      key: const PageStorageKey<String>('name'),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 12.0,
                            ),
                            child: TappableArea(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 2,
                              ),
                              onTap: () async {
                                showAccountPlaylistsSortMenu(context);
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(YTIcons.sort_outlined),
                                  SizedBox(width: 4),
                                  Text('Sort'),
                                  SizedBox(width: 4),
                                  RotatedBox(
                                    quarterTurns: 1,
                                    child: Icon(YTIcons.chevron_right),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return TappableArea(
                                onTap: () {},
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4.0,
                                    horizontal: 8.0,
                                  ),
                                  child: PlayableContent(
                                    width: 180,
                                    height: 120,
                                    direction: Axis.horizontal,
                                    isPlaylist: true,
                                  ),
                                ),
                              );
                            },
                            childCount: 5,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
