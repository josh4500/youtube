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
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';
import 'package:youtube_clone/presentation/screens/subscriptions/widgets/subscriptions_tabs.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_chip.dart';
import 'package:youtube_clone/presentation/widgets/dynamic_tab.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';
import 'package:youtube_clone/presentation/widgets/viewable/group/viewable_group_shorts.dart';

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
                  icon: Icons.cast_outlined,
                  onTap: () {},
                ),
                AppbarAction(
                  icon: YTIcons.notification_outlined,
                  onTap: () {},
                ),
                AppbarAction(
                  icon: YTIcons.search_outlined,
                  onTap: () {},
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
            const SliverToBoxAdapter(
              child: ViewableGroupShorts(
                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        YTIcons.shorts_filled,
                        size: 36,
                        color: Colors.red,
                      ),
                      SizedBox(width: 12),
                      Text(
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

class SubscriptionAvatar extends StatelessWidget {
  const SubscriptionAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 16),
        Expanded(
          child: Stack(
            children: <Widget>[
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints c) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(c.maxHeight),
                    child: Container(
                      height: c.maxHeight,
                      width: c.maxHeight,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                right: 3.5,
                bottom: 3.5,
                child: Container(
                  width: 12.5,
                  height: 12.5,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1.7,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Owen Jones',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
