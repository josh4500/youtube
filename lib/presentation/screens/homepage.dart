import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/widgets/builders/auth_state_builder.dart';
import 'package:youtube_clone/presentation/widgets/connection_snackbar.dart';

class HomePage extends StatefulWidget {
  final StatefulNavigationShell child;
  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPlayerActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Padding(
        padding: isPlayerActive
            ? MediaQuery.viewInsetsOf(
                context,
              )
            : EdgeInsets.zero,
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
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0,
      upperBound: widget.height,
      animationBehavior: AnimationBehavior.preserve,
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 50),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      constraints: BoxConstraints(maxHeight: widget.height),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Divider(height: 0.5),
          Row(
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
