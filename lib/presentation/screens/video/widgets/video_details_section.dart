import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'controls/player_ambient.dart';
import 'video/video_description_button.dart';
import 'video_actions.dart';
import 'video_channel_context.dart';
import 'video_channel_section.dart';
import 'video_comment_section.dart';

class VideoDetailsSection extends StatelessWidget {
  const VideoDetailsSection({
    super.key,
    this.physics,
    this.controller,
    required this.onScrollNotification,
  });

  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool Function(ScrollNotification notification) onScrollNotification;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: onScrollNotification,
      child: CustomScrollView(
        physics: physics,
        controller: controller,
        scrollBehavior: const NoOverScrollGlowBehavior(),
        slivers: <Widget>[
          const SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                PlayerAmbient(),
                Column(
                  children: <Widget>[
                    VideoDescriptionButton(),
                    // VideoContext(),
                    VideoChannelSection(),
                    VideoChannelContext(),
                    VideoActions(),
                    VideoCommentSection(),
                    SizedBox(height: 12),
                  ],
                ),
              ],
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: FadingSliverPersistentHeaderDelegate(
              height: 48,
              child: const Material(
                child: Column(
                  children: [
                    Spacer(),
                    SizedBox(
                      height: 40,
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
                    Spacer(),
                    Divider(height: 0, thickness: 1),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: ViewableVideoContent()),
          const SliverToBoxAdapter(child: ViewableVideoContent()),
          const SliverToBoxAdapter(child: ViewableVideoContent()),
          const SliverToBoxAdapter(child: ViewableVideoContent()),
          const SliverToBoxAdapter(child: ViewableVideoContent()),
          const SliverToBoxAdapter(child: ViewableVideoContent()),
        ],
      ),
    );
  }
}
