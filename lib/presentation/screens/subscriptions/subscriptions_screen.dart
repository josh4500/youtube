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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';
import 'package:youtube_clone/presentation/screens/subscriptions/widgets/subscriptions_tabs.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_chip.dart';
import 'package:youtube_clone/presentation/widgets/dynamic_tab.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';
import 'package:youtube_clone/presentation/widgets/viewable/group/viewable_group_shorts.dart';

import '../../providers.dart';
import '../../widgets/appbar_action.dart';
import '../../widgets/viewable/viewable_post_content.dart';
import '../../widgets/viewable/viewable_video_content.dart';

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
                  onTap: () {},
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return AppbarAction(
                      icon: YTIcons.search_outlined,
                      onTap: () async {
                        ref.read(homeRepositoryProvider).lockNavBarPosition();
                        await context.goto(AppRoutes.search);
                      },
                    );
                  },
                ),
              ],
              floating: true,
              bottom: PreferredSize(
                preferredSize: Size(
                  MediaQuery.sizeOf(context).width,
                  MediaQuery.sizeOf(context).width * 0.3 +
                      MediaQuery.sizeOf(context).height * 0.05,
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.sizeOf(context).width * 0.3,
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
                    return const ViewableVideoContent();
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
