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
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/subscriptions_tabs.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<int?> _selectedChannel = ValueNotifier<int?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: const OverScrollGlowBehavior(
          enabled: false,
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
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
              ],
              floating: true,
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 125 + 44),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 120,
                      child: SubscriptionsTabs(
                        valueListenable: _selectedChannel,
                        onChange: (int? value) {},
                      ),
                    ),
                    const SizedBox(height: 8),
                    ValueListenableBuilder<int?>(
                      valueListenable: _selectedChannel,
                      builder: (
                        BuildContext context,
                        int? value,
                        Widget? childWidget,
                      ) {
                        if (value != null) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                CustomActionChip(
                                  title: 'View channel',
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                  backgroundColor: Colors.white12,
                                  onTap: () {
                                    context.goto(
                                      AppRoutes.channel.withPrefixParent(
                                        AppRoutes.subscriptions,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                        return SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.05,
                          child: childWidget,
                        );
                      },
                      child: DynamicTab(
                        initialIndex: 1,
                        useTappable: true,
                        trailing: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TappableArea(
                            onPressed: () {},
                            padding: const EdgeInsets.all(4.0),
                            child: const Text(
                              'Settings',
                              style: TextStyle(
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                        options: const <String>[
                          'All',
                          'Today',
                          'Live',
                          'Shorts',
                          'Continue watching',
                          'Unwatched',
                          'Post',
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: ViewablePostContent(),
            ),
            SliverToBoxAdapter(
              // TODO(josh4500): What is the use of this Widget
              child: ViewableGroupShorts(
                title: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        AssetsPath.logoShorts32,
                        filterQuality: FilterQuality.high,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Shorts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<int?>(
              valueListenable: _selectedChannel,
              builder: (BuildContext context, int? value, Widget? childWidget) {
                if (value != null) {
                  return const SliverFillRemaining();
                }
                return childWidget!;
              },
              child: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ViewableVideoContent(
                      onMore: () {
                        showDynamicSheet(
                          context,
                          items: [
                            DynamicSheetItem(
                              leading:
                                  const Icon(YTIcons.playlist_play_outlined),
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
                              leading: Icon(YTIcons.watch_later_outlined),
                              title: 'Save to Watch later',
                            ),
                            const DynamicSheetItem(
                              leading: Icon(YTIcons.save_outlined_1),
                              title: 'Save to playlist',
                            ),
                            const DynamicSheetItem(
                              leading: Icon(YTIcons.download_outlined),
                              title: 'Download video',
                            ),
                            const DynamicSheetItem(
                              leading: Icon(YTIcons.share_outlined),
                              title: 'Share',
                            ),
                            const DynamicSheetItem(
                              leading: Icon(YTIcons.close_circle_outlined),
                              title: 'Unsubscribe',
                              dependents: [DynamicSheetItemDependent.auth],
                            ),
                            const DynamicSheetItem(
                              leading: Icon(YTIcons.not_interested_outlined),
                              title: 'Hide',
                              dependents: [DynamicSheetItemDependent.auth],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  childCount: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
