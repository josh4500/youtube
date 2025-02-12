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
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/channel_section.dart';
import 'widgets/for_you_content.dart';
import 'widgets/menu/show_channel_menu.dart';

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
      'Releases',
      'Live',
      'Podcasts',
      'Playlists',
      'Community',
      'Products', // TODO(Josh): Do impl
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Marques Brownlee'),
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
              onTapDown: (TapDownDetails details) {
                final Offset position = details.globalPosition;
                showChannelMenu(
                  context,
                  RelativeRect.fromLTRB(position.dx, 0, 0, 0),
                );
              },
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
                    automaticallyImplyLeading: false,
                    floating: true,
                    pinned: true,
                    toolbarHeight: 8,
                    bottom: TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      tabs: tabs.map((String name) => Tab(text: name)).toList(),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: tabs.map((String tabName) {
                return Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      physics: const ClampingScrollPhysics(),
                      slivers: <Widget>[
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
                        if (tabName == 'Releases') ..._buildReleases(),
                        if (tabName == 'Podcasts') ..._buildPodcasts(),
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
    return <Widget>[
      ..._buildFeaturedVideo(),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 336,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12,
                ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 2) {
                      return ForYouContent(
                        content: VideoViewModel.test,
                      );
                    }

                    return ForYouContent(
                      content: ShortsViewModel.test,
                    );
                  },
                  itemCount: 10,
                ),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 112,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Our members',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Thank you, channel members!',
                          style: TextStyle(
                            fontSize: 16,
                            color: context.theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      'Join',
                      style: TextStyle(
                        fontSize: 16,
                        color: context.theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  itemBuilder: (BuildContext context, int index) {
                    return const AccountAvatar();
                  },
                  itemCount: 10,
                ),
              ),
            ],
          ),
        ),
      ),
      const SliverToBoxAdapter(
        child: SizedBox(height: 12),
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
    return <Widget>[
      const SliverToBoxAdapter(
        child: Column(
          children: <Widget>[
            ViewableVideoContent(),
            Divider(thickness: 1),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildFeaturedSection({required String title, String? summary}) {
    return <Widget>[
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  if (title == 'Shorts') ...[
                    Image.asset(
                      AssetsPath.logoShorts32,
                      filterQuality: FilterQuality.high,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (summary != null) ...<Widget>[
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
            (BuildContext context, int index) {
              return ModelBinding(
                model: ShortsViewModel.test,
                child: const ViewableShortsContent(
                  showTitle: false,
                ),
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
            (BuildContext context, int index) {
              return TappableArea(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12,
                ),
                onLongPress: onMoreVideo,
                child: PlayableVideoContent(
                  width: 160,
                  height: 88,
                  onMore: onMoreVideo,
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
            horizontal: 12,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Icon(YTIcons.chevron_down),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildVideos() {
    return <Widget>[
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            height: 40,
            child: DynamicTab(
              initialIndex: 0,
              options: <String>['Latest', 'Popular', 'Oldest'],
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
          (BuildContext context, int index) {
            return TappableArea(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12,
              ),
              onTap: () {},
              onLongPress: onMoreVideo,
              child: PlayableVideoContent(
                width: 160,
                height: 88,
                onMore: onMoreVideo,
              ),
            );
          },
          childCount: 10,
        ),
      ),
    ];
  }

  List<Widget> _buildShorts() {
    return <Widget>[
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            height: 40,
            child: DynamicTab(
              initialIndex: 0,
              options: <String>['Latest', 'Popular'],
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
          (BuildContext context, int index) {
            return ViewableShortsContent(
              showTitle: false,
              onMore: () {
                showDynamicSheet(
                  context,
                  items: [
                    const DynamicSheetOptionItem(
                      leading: Icon(YTIcons.feedbck_outlined),
                      title: 'Send feedback',
                      dependents: [DynamicSheetItemDependent.auth],
                    ),
                  ],
                );
              },
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
    return <Widget>[
      const SliverToBoxAdapter(
        child: SizedBox(height: 8),
      ),
      const SliverToBoxAdapter(
        child: SizedBox(
          height: 40,
          child: DynamicTab(
            initialIndex: 0,
            options: ['Latest', 'Popular', 'Oldest'],
          ),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return TappableArea(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12,
              ),
              onLongPress: onMoreVideo,
              child: PlayableLiveContent(
                width: 160,
                height: 88,
                completed: index != 0,
                onMore: onMoreVideo,
              ),
            );
          },
          childCount: 10,
        ),
      ),
    ];
  }

  List<Widget> _buildReleases() {
    return [
      const SliverToBoxAdapter(child: SizedBox(height: 8)),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return TappableArea(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12,
              ),
              onTap: () {},
              child: PlayableContent(
                width: 160,
                height: 88,
                direction: Axis.horizontal,
                isPlaylist: true,
                onMore: () {
                  showDynamicSheet(
                    context,
                    items: [
                      DynamicSheetOptionItem(
                        leading: const Icon(YTIcons.playlist_play_outlined),
                        title: 'Play next in queue',
                        trailing: ImageFromAsset.ytPAccessIcon,
                      ),
                      const DynamicSheetOptionItem(
                        leading: Icon(YTIcons.save_outlined),
                        title: 'Save to library',
                      ),
                      const DynamicSheetOptionItem(
                        leading: Icon(YTIcons.share_outlined),
                        title: 'Share',
                      ),
                    ],
                  );
                },
              ),
            );
          },
          childCount: 10,
        ),
      ),
    ];
  }

  List<Widget> _buildPodcasts() {
    return <Widget>[
      const SliverToBoxAdapter(child: SizedBox(height: 8)),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return TappableArea(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12,
              ),
              onTap: () {},
              child: PlayableContent(
                width: 160,
                height: 170,
                direction: Axis.horizontal,
                isPlaylist: true,
                isPodcasts: true,
                onMore: () {
                  showDynamicSheet(
                    context,
                    items: [
                      DynamicSheetOptionItem(
                        leading: const Icon(YTIcons.playlist_play_outlined),
                        title: 'Play next in queue',
                        trailing: ImageFromAsset.ytPAccessIcon,
                      ),
                      const DynamicSheetOptionItem(
                        leading: Icon(YTIcons.save_outlined),
                        title: 'Save to library',
                      ),
                      const DynamicSheetOptionItem(
                        leading: Icon(YTIcons.share_outlined),
                        title: 'Share',
                      ),
                    ],
                  );
                },
              ),
            );
          },
          childCount: 10,
        ),
      ),
    ];
  }

  List<Widget> _buildPlaylists() {
    return <Widget>[
      const SliverToBoxAdapter(
        child: SizedBox(height: 8),
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
            onTap: () async {},
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
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12,
              ),
              child: PlayableContent(
                width: 160,
                height: 88,
                direction: Axis.horizontal,
                isPlaylist: true,
                onMore: () {
                  showDynamicSheet(
                    context,
                    items: [
                      DynamicSheetOptionItem(
                        leading: const Icon(YTIcons.playlist_play_outlined),
                        title: 'Play next in queue',
                        trailing: ImageFromAsset.ytPAccessIcon,
                      ),
                      const DynamicSheetOptionItem(
                        leading: Icon(YTIcons.save_outlined),
                        title: 'Save to library',
                      ),
                      const DynamicSheetOptionItem(
                        leading: Icon(YTIcons.share_outlined),
                        title: 'Share',
                      ),
                    ],
                  );
                },
              ),
            );
          },
          childCount: 10,
        ),
      ),
    ];
  }

  List<Widget> _buildCommunity() {
    return <Widget>[
      const SliverToBoxAdapter(
        child: SizedBox(height: 4),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return ViewablePostContent(
              onMore: () {
                showDynamicSheet(
                  context,
                  items: [
                    const DynamicSheetOptionItem(
                      leading: Icon(YTIcons.report_outlined),
                      title: 'Report',
                    ),
                  ],
                );
              },
            );
          },
          childCount: 10,
        ),
      ),
    ];
  }

  void onMoreVideo() {
    showDynamicSheet(
      context,
      items: [
        DynamicSheetOptionItem(
          leading: const Icon(YTIcons.watch_later_outlined),
          title: 'Play next in queue',
          trailing: ImageFromAsset.ytPAccessIcon,
          dependents: const [DynamicSheetItemDependent.premium],
        ),
        const DynamicSheetOptionItem(
          leading: Icon(YTIcons.watch_later_outlined),
          title: 'Save to Watch later',
          dependents: [DynamicSheetItemDependent.auth],
        ),
        const DynamicSheetOptionItem(
          leading: Icon(YTIcons.add_playlist_outlined),
          title: 'Save to playlist',
          dependents: [DynamicSheetItemDependent.auth],
        ),
        const DynamicSheetOptionItem(
          leading: Icon(YTIcons.download_outlined),
          title: 'Download video',
          dependents: [DynamicSheetItemDependent.auth],
        ),
        const DynamicSheetOptionItem(
          leading: Icon(YTIcons.share_outlined),
          title: 'Share',
        ),
      ],
    );
  }
}
