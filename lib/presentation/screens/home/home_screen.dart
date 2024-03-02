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
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core/constants/constants.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/theme/device_theme.dart';
import 'package:youtube_clone/presentation/widgets/appbar_action.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_chip.dart';
import 'package:youtube_clone/presentation/widgets/dynamic_tab.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';
import 'package:youtube_clone/presentation/widgets/viewable/viewable_video_content.dart';

import '../../router/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _playSNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checker);
  }

  void _checker() {
    final direction = _scrollController.position.userScrollDirection;
    final offset = _scrollController.offset;
    if (direction == ScrollDirection.forward && offset <= 100) {
      _playSNotifier.value = true;
    } else if (direction == ScrollDirection.reverse && offset >= 100) {
      _playSNotifier.value = false;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checker);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Consumer(
        builder: (context, ref, childWidget) {
          final isPlayerActive = ref.watch(playerOverlayStateProvider);
          return Transform.translate(
            offset: isPlayerActive
                ? const Offset(0, -kMiniPlayerHeight)
                : Offset.zero,
            child: RawMaterialButton(
              elevation: 0,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(16.0),
              constraints: const BoxConstraints(
                minWidth: 44.0,
                minHeight: 36.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () {},
              child: AnimatedSize(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOutCubic,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                      size: 28,
                    ),
                    ValueListenableBuilder(
                      valueListenable: _playSNotifier,
                      builder: (context, value, _) {
                        if (!value) return const SizedBox();
                        return const Row(
                          children: [
                            SizedBox(width: 8),
                            Text(
                              'Play something',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      body: ScrollConfiguration(
        behavior: const OverScrollGlowBehavior(enabled: false),
        child: CustomScrollView(
          controller: _scrollController,
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
                preferredSize: Size(MediaQuery.sizeOf(context).width, 48),
                child: SizedBox(
                  height: 48,
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
            SliverToBoxAdapter(
              child: Consumer(
                builder: (context, ref, _) {
                  return ViewableVideoContent(
                    onTap: () async {
                      if (context.orientation.isLandscape) {
                        await context.goto(AppRoutes.playerLandscapeScreen);
                      }
                      ref.read(playerRepositoryProvider).openPlayerScreen();
                    },
                  );
                },
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
            const SliverFillRemaining(),
          ],
        ),
      ),
    );
  }
}
