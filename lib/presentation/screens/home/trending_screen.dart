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
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../providers.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen>
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
    final List<String> tabs = <String>['Now', 'Music', 'Gaming', 'Movies'];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
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
              'Trending',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          actions: <Widget>[
            AppbarAction(
              icon: YTIcons.cast_outlined,
              onTap: () {},
            ),
            AppbarAction(
              icon: YTIcons.search_outlined,
              onTap: () => context.goto(AppRoutes.search),
            ),
            AppbarAction(
              icon: YTIcons.more_vert_outlined,
              onTap: () {},
            ),
          ],
        ),
        body: ScrollConfiguration(
          behavior: const OverScrollGlowBehavior(enabled: false),
          child: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (BuildContext context, bool isScrolled) {
              return <Widget>[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8,
                    ),
                    child: Text(
                      'Trending',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context,
                  ),
                  sliver: SliverPersistentHeader(
                    floating: true,
                    pinned: true,
                    delegate: PersistentHeaderDelegate(
                      maxHeight: 50,
                      minHeight: 50,
                      child: Material(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TabBar(
                              isScrollable: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              indicatorPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              tabAlignment: TabAlignment.start,
                              dividerColor: Colors.white,
                              indicatorColor: Colors.white,
                              enableFeedback: true,
                              indicatorWeight: 2.5,
                              tabs: tabs
                                  .map((String name) => Tab(text: name))
                                  .toList(),
                            ),
                            const Divider(height: .75, thickness: 1),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: tabs.map((String tabName) {
                return Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context,
                          ),
                        ),
                        if (tabName == 'Now') ..._buildNow(context),
                        if (tabName == 'Music') ..._buildMusic(context),
                        if (tabName == 'Gaming') ..._buildGaming(context),
                        if (tabName == 'Movies') ..._buildMovies(context),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNow(BuildContext context) {
    return <Widget>[
      const SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 14,
              ),
              child: Text(
                'Trending videos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Divider(height: 0, thickness: 1.5),
          ],
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
        child: ViewableGroupShorts(
          title: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 14,
            ),
            child: Text(
              'Trending shorts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
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
    ];
  }

  List<Widget> _buildMusic(BuildContext context) {
    return <Widget>[
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
      const SliverToBoxAdapter(
        child: ViewableVideoContent(),
      ),
      const SliverToBoxAdapter(
        child: ViewableVideoContent(),
      ),
    ];
  }

  List<Widget> _buildGaming(BuildContext context) {
    return <Widget>[
      const SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 14,
              ),
              child: Text(
                'Trending videos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Divider(height: 0, thickness: 1.5),
          ],
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
      const SliverToBoxAdapter(
        child: ViewableVideoContent(),
      ),
    ];
  }

  List<Widget> _buildMovies(BuildContext context) {
    return <Widget>[
      const SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 14,
              ),
              child: Text(
                'Trending videos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Divider(height: 0, thickness: 1.5),
          ],
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
      const SliverToBoxAdapter(
        child: ViewableVideoContent(),
      ),
    ];
  }
}
