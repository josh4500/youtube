import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core/enums/auth_state.dart';
import 'package:youtube_clone/presentation/provider/repository/home_repository_provider.dart';
import 'package:youtube_clone/presentation/router.dart';
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
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final bigScreen = constraints.maxWidth >= 600;
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: widget.height),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          if (widget.selectedIndex != 1)
                            const Divider(height: 1),
                          AuthStateBuilder(
                            builder: (BuildContext context, AuthState state) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      12 + (state.isAuthenticated ? 0 : 12),
                                ),
                                child: Row(
                                  mainAxisAlignment: constraints.maxWidth >= 600
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    _NavButton(
                                      key: const ValueKey(1),
                                      title: 'Home',
                                      onPressed: () => widget.onChangeIndex(0),
                                      isSelected: widget.selectedIndex == 0,
                                      selectedIcon: YTIcons.home_filled,
                                      notSelectedIcon: YTIcons.home_outlined,
                                    ),
                                    if (bigScreen) const SizedBox(width: 48),
                                    _NavButton(
                                      key: const ValueKey(2),
                                      title: 'Shorts',
                                      onPressed: () => widget.onChangeIndex(1),
                                      isSelected: widget.selectedIndex == 1,
                                      selectedIcon: YTIcons.shorts_filled,
                                      notSelectedIcon: YTIcons.shorts_outlined,
                                    ),
                                    if (bigScreen) const SizedBox(width: 48),
                                    if (state.isAuthenticated) ...[
                                      const _NavCreateButton(key: ValueKey(0)),
                                      if (bigScreen) const SizedBox(width: 48),
                                    ],
                                    _NavButton(
                                      key: const ValueKey(3),
                                      title: 'Subscriptions',
                                      onPressed: () => widget.onChangeIndex(2),
                                      isSelected: widget.selectedIndex == 2,
                                      selectedIcon:
                                          YTIcons.subscriptions_filled,
                                      notSelectedIcon:
                                          YTIcons.subscriptions_outlined,
                                    ),
                                    if (bigScreen) const SizedBox(width: 48),
                                    _NavLibraryButton(
                                      key: const ValueKey(4),
                                      widget: widget,
                                      isLibrary: false,
                                      isSelected: widget.selectedIndex == 3,
                                      onPressed: () => widget.onChangeIndex(3),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
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

class _NavCreateButton extends StatelessWidget {
  const _NavCreateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        AppTheme.setSystemOverlayStyle(
          Brightness.dark,
          const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.black,
            systemNavigationBarDividerColor: Colors.black,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        );
        await context.goto(AppRoutes.create);
        if (context.mounted) {
          AppTheme.setSystemOverlayStyle(context.theme.brightness);
        }
      },
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.standard,
      icon: const Icon(YTIcons.create_outlined, size: 36),
    );
  }
}

class _NavLibraryButton extends StatelessWidget {
  const _NavLibraryButton({
    super.key,
    required this.widget,
    required this.onPressed,
    required this.isLibrary,
    required this.isSelected,
  });

  final HomeNavigatorBar widget;
  final VoidCallback onPressed;
  final bool isLibrary;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AuthStateBuilder(
      builder: (BuildContext context, AuthState state) {
        return IconButton(
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.standard,
          onPressed: onPressed,
          highlightColor: Colors.white12,
          splashColor: Colors.transparent,
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (state.isInIncognito)
                const Icon(Icons.hourglass_top)
              else
                state.isUnauthenticated
                    ? Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.black,
                          size: 18,
                        ),
                      )
                    : AccountAvatar(
                        size: 22,
                        name: 'John Jackson',
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 1.5)
                            : null,
                      ),
              const SizedBox(height: 2),
              Text(
                isLibrary ? 'Library' : 'You',
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: .2,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppFont.roboto,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    super.key,
    required this.isSelected,
    required this.onPressed,
    required this.title,
    required this.selectedIcon,
    required this.notSelectedIcon,
  });
  final bool isSelected;
  final IconData selectedIcon;
  final IconData notSelectedIcon;
  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      isSelected: isSelected,
      onPressed: onPressed,
      highlightColor: Colors.white12,
      splashColor: Colors.transparent,
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(isSelected ? selectedIcon : notSelectedIcon),
          Text(
            title,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 10,
              letterSpacing: .2,
              fontWeight: FontWeight.w400,
              fontFamily: AppFont.roboto,
            ),
          ),
        ],
      ),
    );
  }
}
