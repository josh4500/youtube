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
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/provider/index_notifier.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../screens.dart' show VideoScreenFix;
import '../widgets/home/home_drawer.dart';
import '../widgets/home/home_navigation_bar.dart';

abstract class HomeMessenger {
  static void openDrawer(BuildContext context) {
    context.findAncestorStateOfType<_HomePageState>()?.openDrawer();
  }

  static void closeDrawer(BuildContext context) {
    context.findAncestorStateOfType<_HomePageState>()?.closeDrawer();
  }

  static void lockNavBarPosition(BuildContext context) {
    context
        .findAncestorStateOfType<_HomePageState>()
        ?._bottomBarKey
        .currentState
        ?.lockNavBarPosition();
  }

  static void unlockNavBarPosition(BuildContext context) {
    context
        .findAncestorStateOfType<_HomePageState>()
        ?._bottomBarKey
        .currentState
        ?.unlockNavBarPosition();
  }

  static void updateNavBarPosition(BuildContext context, double value) {
    context
        .findAncestorStateOfType<_HomePageState>()
        ?._bottomBarKey
        .currentState
        ?.updateNavBarPosition(value);
  }

  static void openPlayer(BuildContext context) {
    context.findAncestorStateOfType<_HomeOverlayWrapperState>()?.openPlayer();
  }

  static void closePlayer(BuildContext context) {
    context.findAncestorStateOfType<_HomeOverlayWrapperState>()?.closePlayer();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.child});
  final StatefulNavigationShell child;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _homeOverlayKey = GlobalKey<_HomeOverlayWrapperState>();
  final _bottomBarKey = GlobalKey<HomeNavigatorBarState>();

  void openDrawer() => _scaffoldKey.currentState?.openDrawer();
  void closeDrawer() => _scaffoldKey.currentState?.closeDrawer();

  @override
  Widget build(BuildContext context) {
    return StackedPageDraggable(
      child: Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: false,
        extendBody: true,
        drawer: const HomeDrawer(),
        body: HomeOverlayWrapper(
          key: _homeOverlayKey,
          child: widget.child,
        ),
        bottomNavigationBar: HomeNavigatorBar(
          key: _bottomBarKey,
          selectedIndex: widget.child.currentIndex,
          onChangeIndex: (int index) {
            widget.child.goBranch(
              index,
              initialLocation: index == widget.child.currentIndex,
            );
          },
        ),
      ),
    );
  }
}

class HomeOverlayWrapper extends StatefulWidget {
  const HomeOverlayWrapper({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  State<HomeOverlayWrapper> createState() => _HomeOverlayWrapperState();
}

class _HomeOverlayWrapperState extends State<HomeOverlayWrapper>
    with TickerProviderStateMixin {
  final GlobalKey _videoScreenKey = GlobalKey();

  late final AnimationController _overlayDnotifController;

  bool _preventShowingExploreDownloads = true;
  final IndexNotifier<HomeTab> _tabNotifier = IndexNotifier(HomeTab.feed);
  final ValueNotifier<bool> _showPlayerNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _overlayDnotifController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _resetExploreDownloadsPrevention();
  }

  @override
  void dispose() {
    _overlayDnotifController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomeOverlayWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    final int index = widget.child.currentIndex;

    _tabNotifier.value = HomeTab.values[index];

    if (oldWidget.child.currentIndex != widget.child.currentIndex) {
      if (index == HomeTab.short.index) {
        AppTheme.setSystemOverlayStyle();
      } else if (oldWidget.child.currentIndex == HomeTab.short.index) {
        AppTheme.setSystemOverlayStyle(context.theme.brightness);
      }
    }
  }

  void showExploreDownloads() {
    if (!_preventShowingExploreDownloads) {
      _overlayDnotifController.forward();
    }
  }

  void hideExploreDownloads() => _overlayDnotifController.reverse();

  void openPlayer() {
    _showPlayerNotifier.value = true;
  }

  Future<void> closePlayer() async {
    _showPlayerNotifier.value = false;
  }

  void onNoThanks() {
    _resetExploreDownloadsPrevention();
    hideExploreDownloads();
  }

  void _resetExploreDownloadsPrevention() {
    _preventShowingExploreDownloads = true;
    Future.delayed(
      const Duration(minutes: 3),
      () => _preventShowingExploreDownloads = false,
    );
  }

  void onGotoDownloads() {
    hideExploreDownloads();
    _resetExploreDownloadsPrevention();

    widget.child.goBranch(3);
    context.goto(AppRoutes.downloads);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        widget.child,
        SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _showPlayerNotifier,
                    builder: (
                      BuildContext context,
                      bool showPlayer,
                      Widget? childWidget,
                    ) {
                      return Visibility(
                        visible: showPlayer,
                        child: ModelBinding<IndexNotifier>(
                          model: _tabNotifier,
                          child: StackedPageDraggable(
                            properties: DraggableProperties(
                              initialHeight: 1 -
                                  (kPlayerMinHeight /
                                      math.max(
                                        constraints.maxWidth,
                                        constraints.maxHeight,
                                      )),
                            ),
                            child: VideoScreenFix(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Visibility(
                    visible: widget.child.currentIndex != 1,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizeTransition(
                        sizeFactor: CurvedAnimation(
                          parent: _overlayDnotifController,
                          curve: Curves.easeOutCubic,
                          reverseCurve: Curves.easeInCubic,
                        ),
                        child: ExploreDownloadsOverlay(
                          onNoThanks: onNoThanks,
                          onGotoDownloads: onGotoDownloads,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class ExploreDownloadsOverlay extends StatelessWidget {
  const ExploreDownloadsOverlay({
    super.key,
    required this.onNoThanks,
    required this.onGotoDownloads,
  });

  final VoidCallback onNoThanks;
  final VoidCallback onGotoDownloads;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF212121),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(AssetsPath.download130, width: 36.w, height: 36.w),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'You\'re offline. Explore downloads?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFF1F1F1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Pick videos that will download automatically the next time you\'re online.',
                  style: TextStyle(color: Color(0xFFAAAAAA)),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TappableArea(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      onTap: onNoThanks,
                      child: Text(
                        'No thanks',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: context.theme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CustomActionChip(
                      title: 'Go to Downloads',
                      onTap: onGotoDownloads,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      backgroundColor: context.theme.primaryColor,
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
