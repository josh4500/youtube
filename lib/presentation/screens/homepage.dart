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
import 'package:youtube_clone/core/enums/auth_state.dart';

import '../constants.dart';
import '../providers.dart';
import '../screens.dart' show PlayerScreen;
import '../widgets.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.child});
  final StatefulNavigationShell child;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      animationBehavior: AnimationBehavior.preserve,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, kMiniPlayerHeight),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
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
      _controller.reverse();
    } else {
      _controller.forward();
    }

    Future<void>(() {
      final bool isPlayerActive = ref.read(playerOverlayStateProvider);
      if (oldWidget.child.currentIndex != widget.child.currentIndex) {
        if (isPlayerActive && _controller.value != 1) {
          if (index == 1 && ref.read(playerNotifierProvider).playing) {
            ref.read(playerRepositoryProvider).minimizeAndPauseVideo();
          } else {
            ref.read(playerRepositoryProvider).minimize();
          }
        }
      }
    });

    // TODO(Josh): When open new viewable/playable, if
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(playerOverlayStateProvider, (bool? previous, bool next) {
      if (next) {
        _controller.forward();
      }
    });
    return SafeArea(
      bottom: false,
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        resizeToAvoidBottomInset: false,
        drawerEnableOpenDragGesture: false,
        drawer: const Drawer(
          child: HomeDrawer(),
        ),
        body: Stack(
          children: <Widget>[
            widget.child,
            SlideTransition(
              position: _animation,
              child: Consumer(
                builder:
                    (BuildContext context, WidgetRef ref, Widget? childWidget) {
                  final bool isPlayerActive =
                      ref.watch(playerOverlayStateProvider);
                  if (isPlayerActive) {
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
        bottomNavigationBar: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? childWidget) {
            final bool isPlayerActive = ref.watch(playerOverlayStateProvider);
            return Padding(
              padding: isPlayerActive
                  ? MediaQuery.viewInsetsOf(context)
                  : EdgeInsets.zero,
              child: childWidget,
            );
          },
          child: CustomNavigatorBar(
            selectedIndex: widget.child.currentIndex,
            onChangeIndex: (int index) {
              widget.child.goBranch(
                index,
                initialLocation: index == widget.child.currentIndex,
              );
            },
          ),
        ),
      ),
    );
  }
}

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: AppLogo(),
        ),
      ],
    );
  }
}

class CustomNavigatorBar extends StatefulWidget {
  const CustomNavigatorBar({
    super.key,
    this.controller,
    this.height = 100,
    this.duration = const Duration(milliseconds: 200),
    required this.selectedIndex,
    required this.onChangeIndex,
  });
  final int selectedIndex;
  final NavigationBarController? controller;
  final Duration duration;
  final double height;
  final ValueChanged<int> onChangeIndex;

  @override
  State<CustomNavigatorBar> createState() => _CustomNavigatorBarState();
}

class _CustomNavigatorBarState extends State<CustomNavigatorBar>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 0,
      animationBehavior: AnimationBehavior.preserve,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: widget.height),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const Divider(height: 0.5),
          SizeTransition(
            sizeFactor: _animation,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  onPressed: () => widget.onChangeIndex(0),
                  icon: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.home),
                      // Text('Home'),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => widget.onChangeIndex(1),
                  icon: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.sort),
                      // Text('Short'),
                    ],
                  ),
                ),
                AuthStateBuilder(
                  builder: (BuildContext context, AuthState state) {
                    if (state.isNotAuthenticated || state.isInIncognito) {
                      return const SizedBox();
                    }
                    return IconButton(
                      onPressed: () {},
                      icon: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.add_circle_outline_rounded,
                            size: 32,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                IconButton(
                  onPressed: () => widget.onChangeIndex(2),
                  icon: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.subscriptions_outlined),
                      // Text('Subscription'),
                    ],
                  ),
                ),
                AuthStateBuilder(
                  builder: (BuildContext context, AuthState state) {
                    return IconButton(
                      onPressed: () => widget.onChangeIndex(3),
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (state.isInIncognito)
                            const Icon(Icons.hourglass_top)
                          else
                            state.isNotAuthenticated
                                ? const Icon(Icons.person_off)
                                : const Icon(Icons.person),
                          //const Text('You'),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          AuthStateBuilder(
            builder: (BuildContext context, AuthState state) {
              if (state.isInIncognito) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.grey,
                  child: const Text(
                    'You\'re incognito',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                );
              }
              return const ConnectionSnackbar(autoHide: true);
            },
          ),
        ],
      ),
    );
  }
}

class NavigationBarController extends ChangeNotifier {}
