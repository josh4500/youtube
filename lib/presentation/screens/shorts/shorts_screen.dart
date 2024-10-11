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
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/shorts_category_actions.dart';
import 'widgets/shorts_comments_bottom_sheet.dart';
import 'widgets/shorts_history_off.dart';
import 'widgets/shorts_info_section.dart';
import 'widgets/shorts_player_view.dart';
import 'widgets/shorts_viewer_discretion.dart';

class ShortsScreen extends ConsumerStatefulWidget {
  const ShortsScreen({
    super.key,
    this.isSubscription = false,
    this.isLive = false,
  });
  final bool isSubscription;
  final bool isLive;

  @override
  ConsumerState<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends ConsumerState<ShortsScreen> {
  final PageController _pageController = PageController();
  final _showProgressNotifier = ValueNotifier<bool>(true);
  final _showViewerDiscretion = ValueNotifier<bool>(false);

  int _currentIndex = 0;
  final ValueNotifier<bool> _isPaused = ValueNotifier<bool>(false);
  bool get _isMainScreen => !widget.isSubscription && !widget.isLive;
  bool get _isSubscriptionScreen => widget.isSubscription;
  bool get _isLiveScreen => widget.isLive;
  bool get _showCategoryActions => _isPaused.value && _isMainScreen;

  final ValueNotifier<bool> _replyIsOpenedNotifier = ValueNotifier<bool>(false);

  bool _commentOpened = false;
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();

  final ValueNotifier<double> playerBottomPadding = ValueNotifier<double>(0);
  final CustomScrollableScrollPhysics physics =
      const CustomScrollableScrollPhysics(
    tag: 'shorts',
  );
  final _replyController = PageDraggableOverlayChildController(
    title: 'Replies',
  );
  @override
  void initState() {
    super.initState();
    _draggableController.addListener(_resizeCallBack);
    _draggableController.addListener(_scrollPhysicsCallback);
  }

  void _onPageIndexChange(int index) {
    _currentIndex = index;
    // Reset state for new page
    _isPaused.value = false;

    // TODO(josh4500): This should not behave this way. The discretion should be stack on top video with the discretion
    if (index == 2) {
      _showViewerDiscretion.value = true;
    } else {
      _showViewerDiscretion.value = false;
    }
  }

  void closeViewerDiscretion() {
    _showViewerDiscretion.value = false;
  }

  void skipViewerDiscretion() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInCubic,
    );
  }

  void _pausePlay() {
    if (_commentOpened) {
      _closeCommentSheet();
      return;
    }
    _isPaused.value = !_isPaused.value;
  }

  void _openCommentSheet() {
    _commentOpened = true;
    _draggableController.animateTo(
      0.68,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInCubic,
    );
  }

  void _closeCommentSheet() {
    if (_replyController.isOpened) {
      _replyController.close();
      return;
    }

    _commentOpened = false;
    _draggableController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _scrollPhysicsCallback() {
    final double size = _draggableController.size;
    if (size > 0) {
      ref.read(homeRepositoryProvider).lockNavBarPosition();
      physics.canScroll(false);
    } else {
      ref.read(homeRepositoryProvider).unlockNavBarPosition();
      physics.canScroll(true);
    }
  }

  void _resizeCallBack() {
    final double size = _draggableController.size;
    final double screenHeight = MediaQuery.sizeOf(context).height - 8;
    final double calc = (screenHeight * size) - (kToolbarHeight + 12);

    playerBottomPadding.value = calc <= 50
        ? size > 0
            ? 50
            : 0
        : calc;
    if (size == 0 && _replyController.isOpened) _replyController.close();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _replyController.dispose();
    _draggableController.removeListener(_resizeCallBack);
    _draggableController.removeListener(_scrollPhysicsCallback);
    _draggableController.dispose();
    super.dispose();
  }

  bool onScrollShortsNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      _showProgressNotifier.value = true;
    } else if (notification is ScrollUpdateNotification) {
      _showProgressNotifier.value = false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    const historyOff = 0 != 0;
    return Stack(
      children: <Widget>[
        Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          appBar: historyOff
              ? null
              : AppBar(
                  title: ValueListenableBuilder<bool>(
                    valueListenable: _showViewerDiscretion,
                    builder: (
                      BuildContext context,
                      bool showViewerDiscretion,
                      Widget? _,
                    ) {
                      return Visibility(
                        visible: showViewerDiscretion == false,
                        child: Text(
                          _isSubscriptionScreen
                              ? 'Subscriptions'
                              : _isLiveScreen
                                  ? 'Live'
                                  : 'Shorts',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  backgroundColor: Colors.transparent,
                  actions: <Widget>[
                    ValueListenableBuilder<bool>(
                      valueListenable: _showViewerDiscretion,
                      builder: (
                        BuildContext context,
                        bool showViewerDiscretion,
                        Widget? _,
                      ) {
                        return Visibility(
                          visible: showViewerDiscretion == false,
                          child: const AppbarAction(
                            icon: YTIcons.shorts_search,
                          ),
                        );
                      },
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _showViewerDiscretion,
                      builder: (
                        BuildContext context,
                        bool showViewerDiscretion,
                        Widget? _,
                      ) {
                        return Visibility(
                          visible: showViewerDiscretion == false,
                          child: const AppbarAction(
                            icon: YTIcons.more_vert_outlined,
                          ),
                        );
                      },
                    ),
                  ],
                ),
          body: Builder(
            builder: (context) {
              if (historyOff) {
                return const ShortsHistoryOff();
              }

              final bottomSpaceWidget = ValueListenableBuilder<double>(
                valueListenable: playerBottomPadding,
                builder: (
                  BuildContext context,
                  double value,
                  Widget? _,
                ) {
                  return SizedBox(
                    height: value,
                    width: double.infinity,
                  );
                },
              );

              final bottomSpaceWidget2 = ValueListenableBuilder<double>(
                valueListenable: playerBottomPadding,
                builder: (
                  BuildContext context,
                  double value,
                  Widget? _,
                ) {
                  return SizedBox(
                    height: value.clamp(0, 50),
                    width: double.infinity,
                  );
                },
              );

              return Stack(
                children: <Widget>[
                  ScrollConfiguration(
                    behavior: const OverScrollGlowBehavior(enabled: false),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: onScrollShortsNotification,
                      child: PageView.builder(
                        physics: physics,
                        controller: _pageController,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          final infoWidget = Align(
                            alignment: Alignment.bottomCenter,
                            child: ShortsInfoSection(
                              onTapComment: _openCommentSheet,
                            ),
                          );

                          final actionsWidget = ListenableBuilder(
                            listenable: _isPaused,
                            builder: (
                              BuildContext context,
                              Widget? childWidget,
                            ) {
                              return Visibility(
                                visible: _showCategoryActions &&
                                    index == _currentIndex,
                                child: const ShortsCategoryActions(),
                              );
                            },
                          );

                          return ValueListenableBuilder<bool>(
                            valueListenable: _showViewerDiscretion,
                            builder: (
                              BuildContext context,
                              bool showViewerDiscretion,
                              Widget? _,
                            ) {
                              if (showViewerDiscretion) {
                                return ShortsViewerDiscretion(
                                  onClickContinue: closeViewerDiscretion,
                                  onClickSkipVideo: skipViewerDiscretion,
                                );
                              }

                              final shortsPlayerView = ShortsPlayerView(
                                isSubscriptionScreen: _isSubscriptionScreen,
                                isLiveScreen: _isLiveScreen,
                              );

                              return Stack(
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: _pausePlay,
                                          child: shortsPlayerView,
                                        ),
                                      ),
                                      bottomSpaceWidget,
                                    ],
                                  ),
                                  if (showViewerDiscretion == false) ...[
                                    Column(
                                      children: [
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              infoWidget,
                                              actionsWidget,
                                            ],
                                          ),
                                        ),
                                        bottomSpaceWidget2,
                                      ],
                                    ),
                                  ],
                                ],
                              );
                            },
                          );
                        },
                        onPageChanged: _onPageIndexChange,
                        itemCount: 20,
                      ),
                    ),
                  ),

                  // Playback progress bar
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _showProgressNotifier,
                      builder: (
                        BuildContext context,
                        bool visible,
                        Widget? childWidget,
                      ) {
                        return ValueListenableBuilder<bool>(
                          valueListenable: _showViewerDiscretion,
                          builder: (
                            BuildContext context,
                            bool showViewerDiscretion,
                            Widget? childWidget,
                          ) {
                            return Visibility(
                              visible: showViewerDiscretion == false,
                              child: const PlaybackProgress(),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // Comment and Reply bottom sheet
        DraggableScrollableSheet(
          snap: true,
          minChildSize: 0,
          initialChildSize: 0,
          snapSizes: const <double>[0.0, 0.68],
          shouldCloseOnMinExtent: false,
          controller: _draggableController,
          snapAnimationDuration: const Duration(milliseconds: 300),
          builder: (BuildContext context, ScrollController controller) {
            return ShortsCommentsBottomSheet(
              controller: controller,
              replyController: _replyController,
              closeComment: _closeCommentSheet,
              draggableController: _draggableController,
            );
          },
        ),
      ],
    );
  }
}
