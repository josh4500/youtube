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
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final ScrollController _scrollController = ScrollController();

  /// Play Something notifier
  final ValueNotifier<bool> _playSNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checker);
  }

  /// Animates size of "Play Something" button depending on the scroll direction
  void _checker() {
    final ScrollDirection direction =
        _scrollController.position.userScrollDirection;
    final double offset = _scrollController.offset;
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
    const historyOff = 0 == 8;
    return Scaffold(
      floatingActionButton: AuthStateBuilder(
        builder: (BuildContext context, state) {
          return Visibility(
            visible: state.isAuthenticated,
            child: Consumer(
              builder: (
                BuildContext context,
                WidgetRef ref,
                Widget? childWidget,
              ) {
                final bool isPlayerActive =
                    ref.watch(playerOverlayStateProvider);

                return Visibility(
                  child: Transform.translate(
                    offset: isPlayerActive
                        ? const Offset(0, -kMiniPlayerHeight)
                        : Offset.zero,
                    child: RawMaterialButton(
                      elevation: 0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(12.0),
                      constraints: const BoxConstraints(
                        minWidth: 44.0,
                        minHeight: 36.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onPressed: () {},
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOutCubic,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Icon(YTIcons.play_arrow, color: Colors.black),
                            ValueListenableBuilder<bool>(
                              valueListenable: _playSNotifier,
                              builder: (
                                BuildContext context,
                                bool show,
                                Widget? _,
                              ) {
                                return Visibility(
                                  visible: show,
                                  child: const Row(
                                    children: <Widget>[
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
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      body: ScrollConfiguration(
        behavior: const OverScrollGlowBehavior(enabled: false),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              automaticallyImplyLeading: false,
              leadingWidth: 120,
              leading: const AppLogo(),
              actions: <Widget>[
                AppbarAction(
                  icon: YTIcons.cast_outlined,
                  onTap: () {},
                ),
                AppbarAction(
                  icon: YTIcons.notification_outlined,
                  onTap: () => context.goto(AppRoutes.notifications),
                ),
                AppbarAction(
                  icon: YTIcons.search_outlined,
                  onTap: () => context.goto(AppRoutes.search),
                ),
              ],
              bottom: historyOff == false
                  ? PreferredSize(
                      preferredSize: Size(MediaQuery.sizeOf(context).width, 48),
                      child: SizedBox(
                        height: 48,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: DynamicTab(
                            initialIndex: 0,
                            leadingWidth: 7.5,
                            useTappable: true,
                            leading: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Consumer(
                                builder: (context, ref, child) {
                                  return CustomActionChip(
                                    borderRadius: BorderRadius.circular(4),
                                    backgroundColor: Colors.white12,
                                    icon: const Icon(YTIcons.discover_outlined),
                                    onTap: () {
                                      ref
                                          .read(homeRepositoryProvider)
                                          .openDrawer();
                                    },
                                  );
                                },
                              ),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TappableArea(
                                onTap: () {},
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
                    )
                  : null,
            ),
            if (historyOff)
              const SliverToBoxAdapter(child: HomeFeedHistoryOff())
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Consumer(
                      builder: (context, ref, child) {
                        return ViewableVideoContent(
                          onTap: () async {
                            if (context.orientation.isLandscape) {
                              await context
                                  .goto(AppRoutes.playerLandscapeScreen);
                            }
                            ref
                                .read(playerRepositoryProvider)
                                .openPlayerScreen();
                          },
                          onMore: () {
                            showDynamicSheet(
                              context,
                              items: [
                                DynamicSheetItem(
                                  leading: const Icon(
                                    YTIcons.playlist_play_outlined,
                                  ),
                                  title: 'Play next in queue',
                                  trailing: ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: Image.asset(
                                      AssetsPath.ytPAccessIcon48,
                                      width: 18,
                                      height: 18,
                                    ),
                                  ),
                                ),
                                const DynamicSheetItem(
                                  leading: Icon(YTIcons.watch_later_outlined),
                                  title: 'Save to Watch later',
                                ),
                                const DynamicSheetItem(
                                  leading: Icon(YTIcons.save_outlined_1),
                                  title: 'Save to playlist',
                                ),
                                const DynamicSheetItem(
                                  leading: Icon(YTIcons.share_outlined),
                                  title: 'Share',
                                ),
                                const DynamicSheetItem(
                                  leading: Icon(
                                    YTIcons.not_interested_outlined,
                                  ),
                                  title: 'Not interested',
                                ),
                                const DynamicSheetItem(
                                  leading: Icon(
                                    YTIcons.not_interested_outlined,
                                  ),
                                  title: 'Don\'t recommend channel',
                                  dependents: [DynamicSheetItemDependent.auth],
                                ),
                                const DynamicSheetItem(
                                  leading: Icon(
                                    YTIcons.youtube_music_outlined,
                                  ),
                                  title: 'Listened with YouTube music',
                                  trailing: Icon(
                                    YTIcons.external_link_outlined,
                                    size: 20,
                                  ),
                                ),
                                const DynamicSheetItem(
                                  leading: Icon(YTIcons.report_outlined),
                                  title: 'Report',
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  childCount: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HomeFeedHistoryOff extends StatelessWidget {
  const HomeFeedHistoryOff({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Image.asset(
            AssetsPath.logo92,
            height: 86,
            fit: BoxFit.fitHeight,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    return CustomActionButton(
                      backgroundColor: Colors.white10,
                      padding: const EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(24),
                      useTappable: false,
                      icon: const Icon(
                        YTIcons.discover_outlined,
                        size: 20,
                      ),
                      onTap: ref.read(homeRepositoryProvider).openDrawer,
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomActionButton(
                    title: 'Search YouTube',
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.white30,
                    ),
                    backgroundColor: Colors.white10,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    useTappable: false,
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => context.goto(AppRoutes.search),
                  ),
                ),
                const SizedBox(width: 12),
                CustomActionButton(
                  backgroundColor: Colors.white10,
                  padding: const EdgeInsets.all(10),
                  borderRadius: BorderRadius.circular(24),
                  useTappable: false,
                  icon: const Icon(YTIcons.mic_outlined, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.075),
              borderRadius: BorderRadius.circular(12),
            ),
            child: 00 == 88
                ? Column(
                    children: [
                      const SizedBox(height: 18),
                      const Text(
                        'Try searching to get started',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 18),
                      RichText(
                        text: const TextSpan(
                          text:
                              'Start watching videos to help us build a feed of videos you\'ll love.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                    ],
                  )
                : Column(
                    children: [
                      const SizedBox(height: 18),
                      const Text(
                        'Your watch history is off',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 18),
                      RichText(
                        text: const TextSpan(
                          text:
                              'You can change setting at any time to get the latest videos tailored to you. ',
                          children: [
                            TextSpan(
                              text: 'Learn more',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      CustomActionButton(
                        title: 'Update Setting',
                        backgroundColor: Colors.white.withOpacity(0.08),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        alignment: Alignment.center,
                        useTappable: false,
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
