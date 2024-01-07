import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/appbar_action.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_chip.dart';
import 'package:youtube_clone/presentation/widgets/dynamic_tab.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';
import 'package:youtube_clone/presentation/widgets/viewable/viewable_post_content.dart';
import 'package:youtube_clone/presentation/widgets/viewable/viewable_video_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
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
            bottom: PreferredSize(
              preferredSize: Size(
                MediaQuery.sizeOf(context).width,
                MediaQuery.sizeOf(context).height * 0.05,
              ),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.05 + 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: DynamicTab(
                    initialIndex: 0,
                    leadingWidth: 8,
                    leading: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CustomActionChip(
                        borderRadius: BorderRadius.circular(4),
                        backgroundColor: Colors.white12,
                        icon: const Icon(Icons.assistant_navigation),
                      ),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TappableArea(
                        onPressed: () {},
                        padding: const EdgeInsets.all(4.0),
                        child: const Text(
                          'Send feedback',
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                    options: const <String>[
                      'All',
                      'Music',
                      'Debates',
                      'News',
                      'Computer programing',
                      'Apple',
                      'Mixes',
                      'Manga',
                      'Podcasts',
                      'Stewie Griffin',
                      'Gaming',
                      'Electrical Engineering',
                      'Physics',
                      'Live',
                      'Sketch comedy',
                      'Courts',
                      'AI',
                      'Machines',
                      'Recently uploaded',
                      'Posts',
                      'New to you',
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: ViewableVideoContent(),
          ),
          const SliverToBoxAdapter(
            child: ViewableVideoContent(),
          ),
          const SliverToBoxAdapter(
            child: ViewableVideoContent(),
          ),
          const SliverToBoxAdapter(
            child: ViewableVideoContent(),
          ),
          SliverFillRemaining(),
        ],
      ),
    );
  }
}
