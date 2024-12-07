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
import 'package:youtube_clone/core.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/history_search_text_field.dart';
import 'widgets/popup/show_history_menu.dart';

class WatchHistoryScreen extends StatefulWidget {
  const WatchHistoryScreen({super.key});

  @override
  State<WatchHistoryScreen> createState() => _WatchHistoryScreenState();
}

class _WatchHistoryScreenState extends State<WatchHistoryScreen>
    with TickerProviderStateMixin {
  final ScrollController controller = ScrollController();
  final FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();
  final SharedSlidableState sharedSlidableState = SharedSlidableState(null);

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

    controller.addListener(() {
      if (controller.offset <= 150) {
        opacityController.value = controller.offset / 150;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    opacityController.dispose();
    textEditingController.dispose();
    sharedSlidableState.dispose();
    super.dispose();
  }

  void onMorePlayableVideo() {
    showDynamicSheet(
      context,
      items: [
        const DynamicSheetOptionItem(
          leading: Icon(YTIcons.delete_outlined),
          title: 'Remove from watch history',
        ),
        DynamicSheetOptionItem(
          leading: const Icon(
            YTIcons.playlist_play_outlined,
          ),
          title: 'Play next in queue',
          trailing: ImageFromAsset.ytPAccessIcon,
        ),
        const DynamicSheetOptionItem(
          leading: Icon(
            YTIcons.watch_later_outlined,
          ),
          title: 'Save to Watch later',
        ),
        const DynamicSheetOptionItem(
          leading: Icon(YTIcons.save_outlined),
          title: 'Save to playlist',
        ),
        const DynamicSheetOptionItem(
          leading: Icon(YTIcons.download_outlined),
          title: 'Download video',
        ),
        const DynamicSheetOptionItem(
          leading: Icon(YTIcons.share_outlined),
          title: 'Share',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupedTimes = <HistoryItem>[
      ShortHistoryItem(DateTime.now()),
      ShortHistoryItem(DateTime.now()),
      ShortHistoryItem(DateTime.now()),
      ShortHistoryItem(DateTime.now()),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 1))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 1))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 1))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 2))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 2))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 2))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 2))),
      // ShortHistoryItem(DateTime.now().subtract(const Duration(days: 2))),
      // ShortHistoryItem(DateTime.now().subtract(const Duration(days: 2))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 3))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 3))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 3))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 3))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 15))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 15))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 15))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 30))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 30))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 30))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 33))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 33))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 300))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 300))),
      VideosHistoryItem(DateTime.now().subtract(const Duration(days: 301))),
    ];

    final historyItems = groupedTimes.group([
      Grouper<ShortHistoryItem>(),
      Grouper<VideosHistoryItem>(),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return Opacity(opacity: animation.value, child: child);
          },
          child: const Text(
            'History',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        leading: CustomBackButton(onPressed: context.pop),
        actions: <Widget>[
          AppbarAction(icon: YTIcons.cast_outlined, onTap: () {}),
          AppbarAction(
            icon: YTIcons.search_outlined,
            onTap: () => context.goto(AppRoutes.search),
          ),
          AppbarAction(
            icon: YTIcons.more_vert_outlined,
            onTapDown: (TapDownDetails details) {
              final Offset position = details.globalPosition;
              showHistoryMenu(
                context,
                RelativeRect.fromLTRB(position.dx, 0, 0, 0),
              );
            },
          ),
        ],
      ),
      body: DefaultGroupProvider<DateTime>(
        applyHeadSeg: DateHead.month.index,
        buildAsFirst: (currentDateBuild) {
          final firstGroup = historyItems.first.items;
          return currentDateBuild == firstGroup.first.time;
        },
        child: GestureDetector(
          onTap: focusNode.unfocus,
          child: ScrollConfiguration(
            behavior: const OverScrollGlowBehavior(enabled: false),
            child: CustomScrollView(
              controller: controller,
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'History',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      HistorySearchTextField(
                        focusNode: focusNode,
                        controller: textEditingController,
                      ),
                    ],
                  ),
                ),
                for (final historyItem in historyItems)
                  if (historyItem.type == ShortHistoryItem)
                    SliverSingleGroup<DateTime>(
                      item: historyItem.items.first.time,
                      separatorBuilder: (date) => SeparatorWidget(date: date),
                      itemHeadGetter: (DateTime item) => item.asHeader.index,
                      sliver: ModelBinding(
                        model: <ShortsViewModel>[
                          ShortsViewModel.test,
                          ShortsViewModel.test,
                          ShortsViewModel.test,
                        ],
                        child: SliverGroupShorts(
                          width: 125,
                          height: 196,
                          showDivider: false,
                          onMore: () {
                            showDynamicSheet(
                              context,
                              items: [
                                const DynamicSheetOptionItem(
                                  leading: Icon(YTIcons.delete_outlined),
                                  title: 'Remove from watch history',
                                ),
                                const DynamicSheetOptionItem(
                                  leading: Icon(
                                    YTIcons.watch_later_outlined,
                                  ),
                                  title: 'Save to Watch later',
                                ),
                                const DynamicSheetOptionItem(
                                  leading: Icon(YTIcons.save_outlined),
                                  title: 'Save to playlist',
                                ),
                                const DynamicSheetOptionItem(
                                  leading: Icon(YTIcons.share_outlined),
                                  title: 'Share',
                                ),
                              ],
                            );
                          },
                          view: ShortsGroupView.playable,
                        ),
                      ),
                    )
                  else
                    SliverGroupList<DateTime>(
                      comparator: (a, b) => !a.compareYMD(b),
                      itemBuilder: (BuildContext context, int index) {
                        return HistoryVideo(
                          index: index,
                          sharedSlidableState: sharedSlidableState,
                          onMore: onMorePlayableVideo,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SeparatorWidget(
                          date: historyItem[index].time,
                        );
                      },
                      itemIndexer: (int index) => historyItem[index].time,
                      childCount: historyItem.length,
                      itemHeadGetter: (DateTime item) => item.asHeader.index,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryVideo extends StatelessWidget {
  const HistoryVideo({
    super.key,
    required this.index,
    this.sharedSlidableState,
    required this.onMore,
  });
  final int index;
  final SharedSlidableState? sharedSlidableState;
  final VoidCallback onMore;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(index),
      sizeRatio: 0.3,
      sharedSlidableState: sharedSlidableState,
      items: <SlidableItem>[
        SlidableItem(
          icon: const Icon(Icons.delete),
          onTap: sharedSlidableState?.close,
        ),
      ],
      child: Material(
        child: TappableArea(
          onTap: () {},
          releasedColor: Colors.transparent,
          highlightColor: context.theme.brightness.isDark
              ? Colors.white10
              : const Color(0xFFC9C9C9),
          splashColor: Colors.black12,
          // splashFactory: InkSparkle.splashFactory,
          child: PlayableVideoContent(
            width: 160,
            height: 88,
            margin: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16.0,
            ),
            onMore: onMore,
          ),
        ),
      ),
    );
  }
}

abstract class HistoryItem {
  HistoryItem(this.time);

  final DateTime time;
}

class ShortHistoryItem extends HistoryItem {
  ShortHistoryItem(super.time);
}

class VideosHistoryItem extends HistoryItem {
  VideosHistoryItem(super.time);
}

class SeparatorWidget extends StatelessWidget {
  const SeparatorWidget({super.key, required this.date});
  final DateTime date;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Text(
        date.header,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
