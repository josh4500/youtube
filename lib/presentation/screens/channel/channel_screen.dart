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
import 'package:youtube_clone/presentation/screens/channel/widgets/channel_section.dart';
import 'package:youtube_clone/presentation/view_models/content/shorts_view_model.dart';
import 'package:youtube_clone/presentation/view_models/content/video_view_model.dart';
import 'package:youtube_clone/presentation/widgets/dynamic_tab.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/playable/playable_content.dart';
import 'package:youtube_clone/presentation/widgets/playable/playable_video_content.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';
import 'package:youtube_clone/presentation/widgets/viewable/viewable_post_content.dart';
import 'package:youtube_clone/presentation/widgets/viewable/viewable_shorts_content.dart';
import 'package:youtube_clone/presentation/widgets/viewable/viewable_video_content.dart';

import '../../widgets/appbar_action.dart';
import 'widgets/for_you_content.dart';

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({super.key});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  @override
  Widget build(BuildContext context) {
    // NOTE: These tabs are all conditional
    // Home, Videos and Community are the defaults. Others are conditional
    final List<String> tabs = <String>[
      'Home',
      'Videos',
      'Shorts',
      'Releases', // TODO: DO impl
      'Live',
      'Podcasts',
      'Playlists', // TODO: DO impl
      'Community',
      'Products', // TODO: Do impl
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Marques Brownlee'),
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
          ],
        ),
        body: ScrollConfiguration(
          behavior: const OverScrollGlowBehavior(enabled: false),
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool isScrolled) {
              return <Widget>[
                const SliverToBoxAdapter(
                  child: ChannelSection(),
                ),
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context,
                  ),
                  sliver: SliverAppBar(
                    primary: true,
                    automaticallyImplyLeading: false,
                    floating: true,
                    pinned: true,
                    toolbarHeight: 8,
                    bottom: TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      dividerColor: Colors.white,
                      indicatorColor: Colors.white,
                      tabs: tabs.map((String name) => Tab(text: name)).toList(),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: tabs.map((tabName) {
                return Builder(
                  builder: (context) {
                    return CustomScrollView(
                      slivers: [
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context,
                          ),
                        ),
                        if (tabName == 'Home') ..._buildHome(),
                        if (tabName == 'Videos') ..._buildVideos(),
                        if (tabName == 'Shorts') ..._buildShorts(),
                        if (tabName == 'Live') ..._buildLives(),
                        if (tabName == 'Playlists') ..._buildPlaylists(),
                        if (tabName == 'Community') ..._buildCommunity(),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHome() {
    return [
      ..._buildFeaturedVideo(),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 336,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'For You',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemBuilder: (context, index) {
                    if (index == 2) {
                      return ForYouContent(
                        content: VideoViewModel(),
                      );
                    }

                    return ForYouContent(
                      content: ShortsViewModel(),
                    );
                  },
                  itemCount: 10,
                ),
              ),
            ],
          ),
        ),
      ),
      const SliverToBoxAdapter(
        child: SizedBox(height: 16),
      ),
      ..._buildFeaturedSection(title: 'Videos'),
      ..._buildFeaturedSection(title: 'Shorts'),
      ..._buildFeaturedSection(
        title: 'Retro Tech S2',
        summary:
            'Marques Brownlee rewinds the clock to look at tech of the past - and what we thought would be our future. He\'s joined by comics, scientists wit bright minds',
      ),
    ];
  }

  List<Widget> _buildFeaturedVideo() {
    return [
      const SliverToBoxAdapter(
        child: Column(
          children: [
            ViewableVideoContent(),
            Divider(thickness: 1.5),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildFeaturedSection({required String title, String? summary}) {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (summary != null) ...[
                const SizedBox(height: 8),
                Text(
                  summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ),
      if (title == 'Shorts')
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return const ViewableShortsContent(
                showTitle: false,
              );
            },
            childCount: 6,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            childAspectRatio: 9 / 16,
          ),
        )
      else
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return const TappableArea(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16,
                ),
                child: PlayableVideoContent(
                  height: 112,
                  width: 180,
                ),
              );
            },
            childCount: 5,
          ),
        ),
      const SliverToBoxAdapter(
        child: TappableArea(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16,
          ),
          child: RotatedBox(
            quarterTurns: 1,
            child: Icon(Icons.chevron_right),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildVideos() {
    return [
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            height: 45,
            child: DynamicTab(
              initialIndex: 0,
              options: ['Latest', 'Popular', 'Oldest'],
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return const TappableArea(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: PlayableVideoContent(
                height: 112,
                width: 180,
              ),
            );
          },
          childCount: 10,
        ),
      ),
    ];
  }

  List<Widget> _buildShorts() {
    return [
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            height: 45,
            child: DynamicTab(
              initialIndex: 0,
              options: ['Latest', 'Popular'],
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return const ViewableShortsContent(
              showTitle: false,
            );
          },
          childCount: 20,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          childAspectRatio: 9 / 16,
        ),
      ),
    ];
  }

  List<Widget> _buildLives() {
    return [
      const SliverToBoxAdapter(
        child: SizedBox(height: 8),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return const TappableArea(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: PlayableVideoContent(
                height: 112,
                width: 180,
              ),
            );
          },
          childCount: 10,
        ),
      ),
    ];
  }

  List<Widget> _buildPlaylists() {
    return [
      const SliverToBoxAdapter(
        child: SizedBox(height: 8),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return const TappableArea(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: PlayableContent(
                width: 180,
                height: 112,
                direction: Axis.horizontal,
                isPlaylist: true,
              ),
            );
          },
          childCount: 10,
        ),
      ),
    ];
  }

  List<Widget> _buildCommunity() {
    return [
      const SliverToBoxAdapter(
        child: SizedBox(height: 8),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return const ViewablePostContent();
          },
          childCount: 10,
        ),
      ),
    ];
  }
}
