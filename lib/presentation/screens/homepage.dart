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

import '../providers.dart';
import '../screens.dart' show PlayerScreen;
import '../widgets/home/home_drawer.dart';
import '../widgets/home/home_navigation_bar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.child});
  final StatefulNavigationShell child;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  late final AnimationController _overlayPlayerController;
  late final Animation<Offset> _overlayPlayerAnimation;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
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

  @override
  Widget build(BuildContext context) {
    ref.listen(playerOverlayStateProvider, (bool? previous, bool next) {
      if (next) {
        _overlayPlayerController.forward();
      }
    });
    final scaffoldKey = ref.read(homeRepositoryProvider).scaffoldKey;
    return Scaffold(
      key: scaffoldKey,
      drawerEnableOpenDragGesture: false,
      // resizeToAvoidBottomInset: false,
      drawer: const HomeDrawer(),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            widget.child,
            SlideTransition(
              position: _overlayPlayerAnimation,
              child: Consumer(
                builder: (
                  BuildContext context,
                  WidgetRef ref,
                  Widget? childWidget,
                ) {
                  if (ref.watch(playerOverlayStateProvider)) {
                    return childWidget!;
                  }
                  return const SizedBox();
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints c) {
                      return PlayerScreen(
                        height: c.maxHeight,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeNavigatorBar(
        selectedIndex: widget.child.currentIndex,
        onChangeIndex: (int index) {
          widget.child.goBranch(
            index,
            initialLocation: index == widget.child.currentIndex,
          );
        },
      ),
    );
  }
}
