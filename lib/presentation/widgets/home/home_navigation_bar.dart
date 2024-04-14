import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core/enums/auth_state.dart';
import 'package:youtube_clone/presentation/provider/repository/home_repository_provider.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../account_avatar.dart';
import '../builders/auth_state_builder.dart';
import '../connection_snackbar.dart';

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
    with TickerProviderStateMixin {
  late final AnimationController _navBarSizeController;
  late final Animation<double> _navBarSizeAnimation;

  late final AnimationController _navBarSlideController;
  late final Animation<Offset> _navBarSlideAnimation;

  @override
  void initState() {
    super.initState();

    _navBarSizeController = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 1,
      animationBehavior: AnimationBehavior.preserve,
    );

    _navBarSizeAnimation = CurvedAnimation(
      parent: _navBarSizeController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _navBarSlideController = AnimationController(
      vsync: this,
      duration: widget.duration,
      animationBehavior: AnimationBehavior.preserve,
    );

    _navBarSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(
      CurvedAnimation(
        parent: _navBarSlideController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );
  }

  @override
  void dispose() {
    _navBarSizeController.dispose();
    _navBarSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      homeRepositoryProvider,
      (_, next) {
        _navBarSizeController.value = next.navBarPos;
        if (next.navBarHidden) {
          _navBarSlideController.forward();
        } else {
          _navBarSlideController.reverse();
        }
      },
    );

    // TODO(josh): Needs perfection compare to native
    return Theme(
      data: widget.selectedIndex == 1 ? AppTheme.dark : Theme.of(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SlideTransition(
            position: _navBarSlideAnimation,
            child: SizeTransition(
              axisAlignment: -1,
              sizeFactor: _navBarSizeAnimation,
              child: Material(
                child: Container(
                  constraints: BoxConstraints(maxHeight: widget.height),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      if (widget.selectedIndex != 1) const Divider(height: 0.5),
                      AuthStateBuilder(
                        builder: (BuildContext context, AuthState state) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 26.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.standard,
                                  isSelected: widget.selectedIndex == 0,
                                  onPressed: () => widget.onChangeIndex(0),
                                  icon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        widget.selectedIndex == 0
                                            ? YTIcons.home_filled
                                            : YTIcons.home_outlined,
                                      ),
                                      const Text(
                                        'Home',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.standard,
                                  onPressed: () => widget.onChangeIndex(1),
                                  icon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        widget.selectedIndex == 1
                                            ? YTIcons.shorts_filled
                                            : YTIcons.shorts_outlined,
                                      ),
                                      const Text(
                                        'Short',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                                if (state.isAuthenticated)
                                  IconButton(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    visualDensity: VisualDensity.standard,
                                    onPressed: () {},
                                    icon: const Icon(
                                      YTIcons.create_outlined,
                                      size: 32,
                                      weight: 0.8,
                                    ),
                                  ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.standard,
                                  onPressed: () => widget.onChangeIndex(2),
                                  icon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        widget.selectedIndex == 2
                                            ? YTIcons.subscriptions_filled
                                            : YTIcons.subscriptions_outlined,
                                      ),
                                      const Text(
                                        'Subscriptions',
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.standard,
                                  onPressed: () => widget.onChangeIndex(3),
                                  icon: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      if (state.isInIncognito)
                                        const Icon(Icons.hourglass_top)
                                      else
                                        state.isNotAuthenticated
                                            ? Container(
                                                margin: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                ),
                                                child: const Icon(
                                                  Icons.person_rounded,
                                                  color: Colors.black,
                                                  size: 18,
                                                ),
                                              )
                                            : AccountAvatar(
                                                size: 24,
                                                name: 'John Jackson',
                                                border:
                                                    widget.selectedIndex == 3
                                                        ? Border.all(
                                                            color: Colors.white,
                                                            width: 1.5,
                                                          )
                                                        : null,
                                              ),
                                      const Text(
                                        'You',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AuthStateBuilder(
            builder: (BuildContext context, AuthState state) {
              if (state.isInIncognito) {
                if (widget.selectedIndex == 1) {
                  return const SizedBox(height: 22);
                }
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(4),
                  color: const Color(0xFF212121),
                  child: const Text(
                    'You\'re incognito',
                    style: TextStyle(fontSize: 12),
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
