import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/subscriptions/widgets/subscriptions_tabs.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_chip.dart';
import 'package:youtube_clone/presentation/widgets/dynamic_tab.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';
import 'package:youtube_clone/presentation/widgets/viewable/group/viewable_group_shorts.dart';
import 'package:youtube_clone/presentation/widgets/viewable/viewable_shorts_content.dart';

import '../../widgets/appbar_action.dart';
import '../../widgets/viewable/viewable_post_content.dart';
import '../../widgets/viewable/viewable_video_content.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  final ValueNotifier<int?> _selectedChannel = ValueNotifier<int?>(null);
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
        ],
      ),
      body: ScrollConfiguration(
        behavior: const OverScrollGlowBehavior(
          enabled: false,
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              collapsedHeight: MediaQuery.sizeOf(context).width * 0.3 +
                  16 +
                  MediaQuery.sizeOf(context).height * 0.05,
              floating: true,
              flexibleSpace: Column(
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
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomActionChip(
                                title: 'View channel',
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(8),
                                backgroundColor: Colors.white12,
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
            const SliverToBoxAdapter(
              child: ViewablePostContent(),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const Divider(thickness: 1.5, height: 0),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.adb_sharp,
                          size: 36,
                          color: Colors.red,
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Shorts',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  const ViewableGroupShorts(),
                  const SizedBox(height: 16),
                ],
              ),
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
