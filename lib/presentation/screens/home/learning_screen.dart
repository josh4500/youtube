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
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';
import 'package:youtube_clone/presentation/widgets/playable/group/playable_group_contents.dart';
import 'package:youtube_clone/presentation/widgets/playable/group/playable_group_videos.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  late final AnimationController opacityController;
  late final Animation animation;

  @override
  void initState() {
    super.initState();
    opacityController = AnimationController(
      vsync: this,
      value: 0,
      duration: const Duration(milliseconds: 150),
    );
    animation = CurvedAnimation(parent: opacityController, curve: Curves.ease);
    scrollController.addListener(() {
      if (scrollController.offset <= 60) {
        opacityController.value = scrollController.offset / 60;
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(onPressed: context.pop),
        title: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return Opacity(
              opacity: animation.value,
              child: child,
            );
          },
          child: const Text(
            'Learning',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        actions: <Widget>[
          AppbarAction(
            icon: Icons.cast_outlined,
            onTap: () {},
          ),
          AppbarAction(
            icon: YTIcons.search_outlined,
            onTap: () {},
          ),
          AppbarAction(
            icon: YTIcons.more_vert_outlined,
            onTap: () {},
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const OverScrollGlowBehavior(enabled: false),
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4,
                ),
                child: Text(
                  'Learning',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: PlayableGroupVideos(title: 'Featured'),
            ),
            SliverToBoxAdapter(
              child: PlayableGroupVideos(
                title: 'History of Women\'s Rights',
                subtitle:
                    'Women have fought for equality for decades. This include issues',
                onTap: () {},
              ),
            ),
            SliverToBoxAdapter(
              child: PlayableGroupVideos(
                title: 'National Reading Month: Why you should be reading',
                subtitle:
                    'Reading has many benefits than just entertainment and in this list you will have different ways',
                onTap: () {},
              ),
            ),
            SliverToBoxAdapter(
              child: PlayableGroupContents(
                title: 'Recommended for you',
                subtitle: 'Based on what you\'ve watched before',
                onTap: () {},
              ),
            ),
            SliverToBoxAdapter(
              child: PlayableGroupVideos(
                title: 'Black Women Authors You Should Know',
                subtitle:
                    'Whether it\'s a well-known author who\'s been a staple on bookshelves',
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
