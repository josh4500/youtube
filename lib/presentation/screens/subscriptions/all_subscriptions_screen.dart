import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/subscriptions/widgets/subscription_tile.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

import '../../widgets/appbar_action.dart';
import 'widgets/popup/show_all_subscriptions_menu.dart';

class AllSubscriptionsScreen extends StatelessWidget {
  const AllSubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
            initialData: false,
            future: Future.delayed(const Duration(seconds: 2), () => true),
            builder: (context, snapshot) {
              if (!snapshot.data!) return const SizedBox();
              return const Text('All subscriptions');
            }),
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
            icon: Icons.more_vert,
            onTapDown: (details) async {
              final position = details.globalPosition;
              await showAllSubscriptionsMenu(
                context,
                RelativeRect.fromLTRB(position.dx, 0, 0, 0),
              );
            },
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const OverScrollGlowBehavior(
          enabled: false,
        ),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TappableArea(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      child: Row(
                        children: [
                          Text('Most relevant'),
                          SizedBox(width: 4),
                          RotatedBox(
                            quarterTurns: 1,
                            child: Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return const SubscriptionTile();
                },
                childCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
