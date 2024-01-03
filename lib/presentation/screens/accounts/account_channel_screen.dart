import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/accounts/widgets/account_channel_section.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/playable/playable_content.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

import '../../widgets/appbar_action.dart';
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
          actions: [
            AppbarAction(
              icon: Icons.cast_outlined,
              onTap: () {},
            ),
            AppbarAction(
              icon: Icons.search,
              onTap: () {},
            ),
            AppbarAction(
              icon: Icons.more_vert_outlined,
              onTap: () {},
            ),
          ],
        ),
        body: ScrollConfiguration(
          behavior: const OverScrollGlowBehavior(enabled: false),
          child: NestedScrollView(
            headerSliverBuilder: (context, isInScroll) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: AccountChannelSection(moreChannel: () {}),
                  ),
                ),
              ];
            },
            body: Builder(
              builder: (context) {
                return CustomScrollView(
                  key: const PageStorageKey<String>('name'),
                  slivers: [
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                    ),
                    SliverFillRemaining(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TabBar(
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            dividerColor: Colors.white,
                            indicatorColor: Colors.white,
                            tabs: [
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
                          const Divider(height: 0),
                          Expanded(
                            child: TabBarView(
                              children: [
                                Container(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: 16.0,
                                      ),
                                      child: TappableArea(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 2,
                                        ),
                                        onPressed: () async {
                                          showAccountPlaylistsSortMenu(context);
                                        },
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.sort),
                                            SizedBox(width: 4),
                                            Text('Sort'),
                                            SizedBox(width: 4),
                                            RotatedBox(
                                              quarterTurns: 1,
                                              child: Icon(Icons.chevron_right),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          return TappableArea(
                                            onPressed: () {},
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
                                        itemCount: 5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
