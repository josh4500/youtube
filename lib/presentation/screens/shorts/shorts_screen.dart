import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/shorts/widgets/shorts_info_section.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/player/playback/playback_progress.dart';

import '../../widgets/appbar_action.dart';
import 'widgets/shorts_comments_bottom_sheet.dart';
import 'widgets/shorts_subscription_button.dart';

class ShortsScreen extends StatefulWidget {
  final bool isSubscription;
  const ShortsScreen({super.key, this.isSubscription = false});

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<bool> _progressVisibilityNotifier = ValueNotifier<bool>(
    true,
  );

  int _currentIndex = 0;
  final _isPaused = ValueNotifier(false);
  bool get _isMainScreen => !widget.isSubscription;
  bool get _isSubscriptionScreen => widget.isSubscription;
  bool get _showSubscriptionButton => _isPaused.value && !widget.isSubscription;

  final ValueNotifier<bool> _replyIsOpenedNotifier = ValueNotifier<bool>(false);

  bool _commentOpened = false;
  final _commentsController = DraggableScrollableController();

  final ValueNotifier<double> playerBottomPadding = ValueNotifier(0);
  final ValueNotifier<ScrollPhysics> physicsNotifier = ValueNotifier(
    const AlwaysScrollableScrollPhysics(),
  );

  @override
  void initState() {
    super.initState();
    _commentsController.addListener(_resizeCallBack);
    _commentsController.addListener(_scrollPhysicsCallback);
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
    _commentsController.animateTo(
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
    _commentsController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _scrollPhysicsCallback() {
    final size = _commentsController.size;
    if (size > 0) {
      physicsNotifier.value = const NeverScrollableScrollPhysics();
    } else {
      physicsNotifier.value = const AlwaysScrollableScrollPhysics();
    }
  }

  void _resizeCallBack() {
    final size = _commentsController.size;
    final screenHeight = MediaQuery.sizeOf(context).height - 8;
    final calc = (screenHeight * size) - (kToolbarHeight + 12);

    if (calc <= screenHeight) {
      playerBottomPadding.value = calc <= 0 ? 0 : calc;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();

    _commentsController.removeListener(_resizeCallBack);
    _commentsController.removeListener(_scrollPhysicsCallback);
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          bottom: false,
          child: Scaffold(
            backgroundColor: Colors.black,
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                _isSubscriptionScreen ? 'Subscriptions' : 'Shorts',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.transparent,
              actions: const [
                AppbarAction(
                  icon: Icons.search,
                ),
                AppbarAction(
                  icon: Icons.camera_alt_outlined,
                ),
                AppbarAction(
                  icon: Icons.more_vert_sharp,
                ),
              ],
            ),
            body: Stack(
              children: [
                ScrollConfiguration(
                  behavior: const OverScrollGlowBehavior(enabled: false),
                  child: NotificationListener(
                    onNotification: (ScrollNotification notification) {
                      if (notification is ScrollEndNotification) {
                        _progressVisibilityNotifier.value = true;
                      } else if (notification is ScrollUpdateNotification) {
                        _progressVisibilityNotifier.value = false;
                      }
                      return false;
                    },
                    child: ValueListenableBuilder(
                      valueListenable: physicsNotifier,
                      builder: (context, physics, _) {
                        return PageView.builder(
                          physics: physics,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Column(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: _pausePlay,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Image.network(
                                            _isSubscriptionScreen
                                                ? 'https://dummyimage.com/360x700/17b00f/fff.jpg'
                                                : 'https://dummyimage.com/360x700/c7b01e/fff.jpg',
                                            alignment: Alignment.center,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: playerBottomPadding,
                                      builder: (context, value, _) {
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
                                  builder: (context, childWidget) {
                                    if (_showSubscriptionButton &&
                                        index == _currentIndex) {
                                      return childWidget!;
                                    }
                                    return const SizedBox();
                                  },
                                  child: const ShortsSubscriptionButton(),
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
                    builder: (context, visible, childWidget) {
                      return Visibility(
                        visible: visible,
                        child: childWidget!,
                      );
                    },
                    child: const PlaybackProgress(),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Comment and Reply bottom sheet
        DraggableScrollableSheet(
          snap: true,
          minChildSize: 0,
          maxChildSize: 1,
          initialChildSize: 0,
          snapSizes: const [0, 0.68],
          shouldCloseOnMinExtent: false,
          controller: _commentsController,
          snapAnimationDuration: const Duration(milliseconds: 300),
          builder: (context, controller) {
            return ShortsCommentsBottomSheet(
              controller: controller,
              replyNotifier: _replyIsOpenedNotifier,
              closeComment: _closeCommentSheet,
            );
          },
        ),
      ],
    );
  }
}
