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
  final ValueNotifier<bool> _progressVisibilityNotifier = ValueNotifier<bool>(
    true,
  );

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
    if (_replyIsOpenedNotifier.value) {
      _replyIsOpenedNotifier.value = false;
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
      ref.read(homeRepositoryProvider).hideNavBar();
      physics.canScroll(false);
    } else {
      ref.read(homeRepositoryProvider).showNavBar();
      physics.canScroll(true);
    }
  }

  void _resizeCallBack() {
    final double size = _draggableController.size;
    final double screenHeight = MediaQuery.sizeOf(context).height - 8;
    final double calc = (screenHeight * size) - (kToolbarHeight + 12);

    if (calc <= screenHeight) {
      playerBottomPadding.value = calc <= 0 ? 0 : calc;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();

    _draggableController.removeListener(_resizeCallBack);
    _draggableController.removeListener(_scrollPhysicsCallback);
    _draggableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const historyOff = 0 != 0;
    return Theme(
      data: AppTheme.dark,
      child: Stack(
        children: <Widget>[
          SafeArea(
            bottom: false,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: false,
              appBar: historyOff
                  ? AppBar()
                  : AppBar(
                      title: Text(
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
                      backgroundColor: Colors.transparent,
                      actions: const <Widget>[
                        AppbarAction(
                          icon: YTIcons.shorts_search,
                        ),
                        AppbarAction(
                          icon: YTIcons.more_vert_outlined,
                        ),
                      ],
                    ),
              body: Builder(
                builder: (context) {
                  if (historyOff) {
                    return const ShortsHistoryOff();
                  }
                  return Stack(
                    children: <Widget>[
                      ScrollConfiguration(
                        behavior: const OverScrollGlowBehavior(enabled: false),
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification notification) {
                            if (notification is ScrollEndNotification) {
                              _progressVisibilityNotifier.value = true;
                            } else if (notification
                                is ScrollUpdateNotification) {
                              _progressVisibilityNotifier.value = false;
                            }
                            return false;
                          },
                          child: PageView.builder(
                            physics: physics,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: _pausePlay,
                                          child: ShortsPlayerView(
                                            isSubscriptionScreen:
                                                _isSubscriptionScreen,
                                            isLiveScreen: _isLiveScreen,
                                          ),
                                        ),
                                      ),
                                      ValueListenableBuilder<double>(
                                        valueListenable: playerBottomPadding,
                                        builder: (
                                          BuildContext context,
                                          double value,
                                          _,
                                        ) {
                                          return SizedBox(
                                            height: value,
                                            width: double.infinity,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ShortsInfoSection(
                                      onTapComment: _openCommentSheet,
                                    ),
                                  ),
                                  ListenableBuilder(
                                    listenable: _isPaused,
                                    builder: (
                                      BuildContext context,
                                      Widget? childWidget,
                                    ) {
                                      if (_showCategoryActions &&
                                          index == _currentIndex) {
                                        return childWidget!;
                                      }
                                      return const SizedBox();
                                    },
                                    child: const ShortsCategoryActions(),
                                  ),
                                ],
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
                          valueListenable: _progressVisibilityNotifier,
                          builder: (
                            BuildContext context,
                            bool visible,
                            Widget? childWidget,
                          ) {
                            return Visibility(
                              visible: visible,
                              child: childWidget!,
                            );
                          },
                          child: const PlaybackProgress(),
                        ),
                      ),
                    ],
                  );
                },
              ),
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
                replyNotifier: _replyIsOpenedNotifier,
                closeComment: _closeCommentSheet,
                draggableController: _draggableController,
              );
            },
          ),
        ],
      ),
    );
  }
}
