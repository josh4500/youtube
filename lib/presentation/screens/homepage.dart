// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/core/constants/constants.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository.dart';
import 'package:youtube_clone/presentation/screens/player/player_screen.dart';
import 'package:youtube_clone/presentation/widgets/builders/auth_state_builder.dart';
import 'package:youtube_clone/presentation/widgets/connection_snackbar.dart';

class HomePage extends ConsumerStatefulWidget {
  final StatefulNavigationShell child;
  const HomePage({super.key, required this.child});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
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
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final index = widget.child.currentIndex;
    if (index == 1) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(playerOverlayStateProvider, (previous, next) {
      if (next) {
        _controller.forward();
      }
    });
    return Scaffold(
      body: Stack(
        children: [
          widget.child,
          SlideTransition(
            position: _animation,
            child: Consumer(
              builder: (context, ref, childWidget) {
                final isPlayerActive = ref.watch(playerOverlayStateProvider);
                if (isPlayerActive) {
                  return childWidget!;
                }
                return const SizedBox();
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: LayoutBuilder(builder: (context, c) {
                  return PlayerScreen(
                    height: c.maxHeight,
                    width: c.maxWidth,
                  );
                }),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, childWidget) {
          final isPlayerActive = ref.watch(playerOverlayStateProvider);
          return Padding(
            padding: isPlayerActive
                ? MediaQuery.viewInsetsOf(
                    context,
                  )
                : EdgeInsets.zero,
            child: childWidget,
          );
        },
        child: CustomNavigatorBar(
          selectedIndex: widget.child.currentIndex,
          onChangeIndex: (index) {
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

class CustomNavigatorBar extends StatefulWidget {
  final int selectedIndex;
  final NavigationBarController? controller;
  final Duration duration;
  final double height;
  final ValueChanged<int> onChangeIndex;

  const CustomNavigatorBar({
    super.key,
    this.controller,
    this.height = 100,
    this.duration = const Duration(milliseconds: 200),
    required this.selectedIndex,
    required this.onChangeIndex,
  });

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
      value: 1,
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
        children: [
          const Divider(height: 0.5),
          SizeTransition(
            sizeFactor: _animation,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => widget.onChangeIndex(0),
                  icon: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home),
                      // Text('Home'),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => widget.onChangeIndex(1),
                  icon: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sort),
                      // Text('Short'),
                    ],
                  ),
                ),
                AuthStateBuilder(
                  builder: (context, state) {
                    if (state.isNotAuthenticated || state.isInIncognito) {
                      return const SizedBox();
                    }
                    return IconButton(
                      onPressed: () {},
                      icon: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                    children: [
                      Icon(Icons.subscriptions_outlined),
                      // Text('Subscription'),
                    ],
                  ),
                ),
                AuthStateBuilder(
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () => widget.onChangeIndex(3),
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          state.isInIncognito
                              ? const Icon(Icons.hourglass_top)
                              : state.isNotAuthenticated
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
            builder: (context, state) {
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
