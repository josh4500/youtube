import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/custom_scroll_physics.dart';
import 'package:youtube_clone/presentation/widgets/dynamic_tab.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/viewable/viewable_video_content.dart';

import 'video_actions.dart';
import 'video_comment_section.dart';
import 'video_description_section.dart';

class PlayerInfoSection extends StatefulWidget {
  const PlayerInfoSection({super.key});

  @override
  State<PlayerInfoSection> createState() => _PlayerInfoSectionState();
}

class _PlayerInfoSectionState extends State<PlayerInfoSection> {
  final _infoScrollController = ScrollController();
  final _infoScrollPhysics = const CustomScrollableScrollPhysics(tag: 'info');
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const NoOverScrollGlowBehavior(),
      child: CustomScrollView(
        physics: _infoScrollPhysics,
        controller: _infoScrollController,
        slivers: const [
          SliverToBoxAdapter(
            child: Column(
              children: [
                VideoDescriptionSection(),
                VideoActions(),
                VideoCommentSection(),
              ],
            ),
          ),
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            elevation: 0,
            toolbarHeight: 24,
            expandedHeight: 0,
            flexibleSpace: SizedBox(
              height: 48,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 4.0,
                ),
                child: DynamicTab(
                  initialIndex: 0,
                  leadingWidth: 8,
                  options: <String>[
                    'All',
                    'Something',
                    'Related',
                    'Recently uploaded',
                    'Watched',
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ViewableVideoContent(),
          ),
          SliverToBoxAdapter(
            child: ViewableVideoContent(),
          ),
          SliverToBoxAdapter(
            child: ViewableVideoContent(),
          ),
          SliverToBoxAdapter(
            child: ViewableVideoContent(),
          ),
          SliverToBoxAdapter(
            child: ViewableVideoContent(),
          ),
          SliverToBoxAdapter(
            child: ViewableVideoContent(),
          ),
        ],
      ),
    );
  }
}
