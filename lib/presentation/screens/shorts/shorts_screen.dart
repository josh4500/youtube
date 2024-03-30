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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_clone/presentation/screens/shorts/widgets/shorts_info_section.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_button.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_chip.dart';
import 'package:youtube_clone/presentation/widgets/custom_backbutton.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/player/playback/playback_progress.dart';

import '../../widgets/appbar_action.dart';
import 'widgets/shorts_category_actions.dart';
import 'widgets/shorts_comments_bottom_sheet.dart';

class ShortsScreen extends StatefulWidget {
  const ShortsScreen({
    super.key,
    this.isSubscription = false,
    this.isLive = false,
  });
  final bool isSubscription;
  final bool isLive;

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
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
  final ValueNotifier<ScrollPhysics> physicsNotifier =
      ValueNotifier<ScrollPhysics>(
    const AlwaysScrollableScrollPhysics(),
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
      physicsNotifier.value = const NeverScrollableScrollPhysics();
    } else {
      physicsNotifier.value = const AlwaysScrollableScrollPhysics();
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
    return Stack(
      children: <Widget>[
        SafeArea(
          bottom: false,
          child: Scaffold(
            backgroundColor: Colors.black,
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: false
                ? null
                : AppBar(
                    title: Text(
                      _isSubscriptionScreen
                          ? 'Subscriptions'
                          : _isLiveScreen
                              ? 'Live'
                              : 'Shorts',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    actions: const <Widget>[
                      AppbarAction(
                        icon: YTIcons.shorts_search,
                      ),
                      AppbarAction(
                        icon: Icons.camera_alt_outlined,
                      ),
                      AppbarAction(
                        icon: YTIcons.more_vert_outlined,
                      ),
                    ],
                  ),
            body: Builder(
              builder: (context) {
                if (false) {
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
                          } else if (notification is ScrollUpdateNotification) {
                            _progressVisibilityNotifier.value = false;
                          }
                          return false;
                        },
                        child: ValueListenableBuilder<ScrollPhysics>(
                          valueListenable: physicsNotifier,
                          builder: (
                            BuildContext context,
                            ScrollPhysics physics,
                            Widget? childWidget,
                          ) {
                            return PageView.builder(
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
                            );
                          },
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
    );
  }
}

class ShortsPlayerView extends StatelessWidget {
  const ShortsPlayerView({
    super.key,
    required bool isSubscriptionScreen,
    required bool isLiveScreen,
  })  : _isSubscriptionScreen = isSubscriptionScreen,
        _isLiveScreen = isLiveScreen;

  // TODO(Josh): Will be provider vlues
  final bool _isSubscriptionScreen;
  final bool _isLiveScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF656565),
        image: DecorationImage(
          image: _isSubscriptionScreen
              ? const NetworkImage(
                  'https://picsum.photos/360/700',
                )
              : _isLiveScreen
                  ? const NetworkImage(
                      'https://picsum.photos/400/800',
                    )
                  : const NetworkImage(
                      'https://picsum.photos/444/800',
                    ),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

class ShortsHistoryOff extends StatelessWidget {
  const ShortsHistoryOff({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 22),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: const Icon(YTIcons.shorts_search, size: 36),
            ),
          ),
          const Spacer(),
          const Text(
            'Shorts recommendation are off',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Your watch history is off, and we rely on watch history to tailor your Shorts feed. You can change your setting at any time, or try searching for Shorts instead. Learn more.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),
          CustomActionChip(
            title: 'Update setting',
            padding: const EdgeInsets.all(12),
            borderRadius: BorderRadius.circular(24),
            backgroundColor: Colors.white,
            alignment: Alignment.center,
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            onTap: () {},
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
