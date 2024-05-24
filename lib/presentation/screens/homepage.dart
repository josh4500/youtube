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
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../providers.dart';
import '../screens.dart' show PlayerScreen;
import '../widgets/home/home_drawer.dart';
import '../widgets/home/home_navigation_bar.dart';
// import 'player/old_player_screen.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key, required this.child});
  final StatefulNavigationShell child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = ref.read(homeRepositoryProvider).scaffoldKey;
    final overlayKey = ref.read(homeRepositoryProvider).overlayKey;
    return Scaffold(
      key: scaffoldKey,
      drawerEnableOpenDragGesture: false,
      extendBody: true,
      drawer: const HomeDrawer(),
      body: HomeOverlayWrapper(key: overlayKey, child: child),
      bottomNavigationBar: HomeNavigatorBar(
        selectedIndex: child.currentIndex,
        onChangeIndex: (int index) {
          child.goBranch(
            index,
            initialLocation: index == child.currentIndex,
          );
        },
      ),
    );
  }
}

class HomeOverlayWrapper extends ConsumerStatefulWidget {
  const HomeOverlayWrapper({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  ConsumerState<HomeOverlayWrapper> createState() => HomeOverlayWrapperState();
}

class HomeOverlayWrapperState extends ConsumerState<HomeOverlayWrapper>
    with TickerProviderStateMixin {
  late final AnimationController _overlayPlayerController;
  late final Animation<Offset> _overlayPlayerAnimation;

  late final AnimationController _overlayDnotifController;
  late final Animation<double> _overlayDnotifAnimation;

  bool _preventShowingExploreDownloads = true;

  @override
  void initState() {
    super.initState();
    _overlayPlayerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 600),
    );

    _overlayPlayerAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _overlayPlayerController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    _overlayDnotifController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _overlayDnotifAnimation = CurvedAnimation(
      parent: _overlayDnotifController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _resetExploreDownloadsPrevention();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant HomeOverlayWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    final int index = widget.child.currentIndex;
    if (index == 1) {
      _overlayPlayerController.reverse();
    } else {
      _overlayPlayerController.forward();
    }

    Future<void>(() {
      final bool isPlayerActive = ref.read(playerOverlayStateProvider);
      if (oldWidget.child.currentIndex != widget.child.currentIndex) {
        if (isPlayerActive && _overlayPlayerController.value != 1) {
          if (index == 1 && ref.read(playerNotifierProvider).ended) {
            ref.read(playerRepositoryProvider).minimize();
          } else {
            ref.read(playerRepositoryProvider).minimizeAndPauseVideo();
          }
        }
      }
    });
  }

  void showExploreDownloads() {
    if (!_preventShowingExploreDownloads) {
      _overlayDnotifController.forward();
    }
  }

  void hideExploreDownloads() => _overlayDnotifController.reverse();

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
    ref.listen(playerOverlayStateProvider, (bool? previous, bool next) {
      if (next) {
        _overlayPlayerController.forward();
      }
    });

    // TODO(josh4500): Investigate double rebuild
    final screenSize = MediaQuery.sizeOf(context);

    print('Rebuild');
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.child,
          SlideTransition(
            position: _overlayPlayerAnimation,
            child: Consumer(
              builder: (
                BuildContext context,
                WidgetRef ref,
                Widget? childWidget,
              ) {
                final showPlayer = ref.watch(playerOverlayStateProvider);
                return Visibility(
                  visible: showPlayer,
                  child: PlayerScreen(
                    width: screenSize.width,
                    height: screenSize.height,
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: widget.child.currentIndex != 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizeTransition(
                sizeFactor: _overlayDnotifAnimation,
                child: ExploreDownloadsOverlay(
                  onNoThanks: onNoThanks,
                  onGotoDownloads: onGotoDownloads,
                ),
              ),
            ),
          ),
        ],
      ),
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
          Image.asset(AssetsPath.download130, width: 36, height: 36),
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
                      child: const Text(
                        'No thanks',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3EA6FF),
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
                      backgroundColor: const Color(0xFF3EA6FF),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
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
