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
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core/constants/constants.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/widgets/appbar_action.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_chip.dart';
import 'package:youtube_clone/presentation/widgets/dynamic_tab.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';
import 'package:youtube_clone/presentation/widgets/viewable/viewable_video_content.dart';

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
            SliverToBoxAdapter(
              child: Consumer(
                builder: (context, ref, _) {
                  return ViewableVideoContent(
                    onTap: () {
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
