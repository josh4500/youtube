import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core/enums/auth_state.dart';
import 'package:youtube_clone/presentation/provider/repository/home_repository_provider.dart';

import '../../widgets.dart';

class HomeNavigatorBar extends ConsumerStatefulWidget {
  const HomeNavigatorBar({
    super.key,
    this.height = 100,
    this.duration = const Duration(milliseconds: 200),
    required this.selectedIndex,
    required this.onChangeIndex,
  });
  final int selectedIndex;
  final Duration duration;
  final double height;
  final ValueChanged<int> onChangeIndex;

  @override
  ConsumerState<HomeNavigatorBar> createState() => _HomeNavigatorBarState();
}

class _HomeNavigatorBarState extends ConsumerState<HomeNavigatorBar>
    with SingleTickerProviderStateMixin {
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
    ref.listen(
      homeRepositoryProvider,
      (_, next) {
        _controller.value = next.navBarPos;
      },
    );

    return Material(
      child: Container(
        constraints: BoxConstraints(maxHeight: widget.height),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const Divider(height: 0.5),
            SizeTransition(
              axisAlignment: -1,
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
      ),
    );
  }
}
