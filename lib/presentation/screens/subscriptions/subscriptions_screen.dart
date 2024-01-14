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
import 'package:youtube_clone/presentation/screens/subscriptions/widgets/subscriptions_tabs.dart';
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
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
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
              floating: true,
              bottom: PreferredSize(
                preferredSize: Size(
                  MediaQuery.sizeOf(context).width,
                  MediaQuery.sizeOf(context).width * 0.3 +
                      MediaQuery.sizeOf(context).height * 0.05,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).width * 0.3,
                      child: SubscriptionsTabs(
                        valueListenable: _selectedChannel,
                        onChange: (value) {},
                      ),
                    ),
                    const SizedBox(height: 8),
                    ValueListenableBuilder(
                      valueListenable: _selectedChannel,
                      builder: (context, value, childWidget) {
                        if (value != null) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
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
                          'Post'
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
              child: ViewableGroupShorts(),
            ),
            ValueListenableBuilder(
              valueListenable: _selectedChannel,
              builder: (context, value, childWidget) {
                if (value != null) {
                  return const SliverFillRemaining();
                }
                return childWidget!;
              },
              child: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
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
      children: [
        const SizedBox(height: 16),
        Expanded(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, c) {
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
                      color: Colors.black,
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
