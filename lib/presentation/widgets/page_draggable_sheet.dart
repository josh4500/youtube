import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

import 'custom_scroll_physics.dart';
import 'dynamic_tab.dart';
import 'over_scroll_glow_behavior.dart';
import 'persistent_header_delegate.dart';

class PageDraggableSheet extends StatefulWidget {
  const PageDraggableSheet({
    super.key,
    required this.title,
    this.subtitle,
    this.dragDownDismiss = false,
    required this.scrollTag,
    this.borderRadius = BorderRadius.zero,
    required this.controller,
    required this.onClose,
    required this.showDragIndicator,
    required this.draggableController,
    required this.contentBuilder,
    this.dynamicTab,
    required this.baseHeight,
    this.dynamicTabShowOffset = 100,
    this.actions = const <Widget>[],
    this.overlayChildren = const <PageDraggableOverlayChild>[],
    this.onOpenOverlayChild,
  });

  final String scrollTag;
  final bool dragDownDismiss;
  final String title;
  final String? subtitle;
  final BorderRadius borderRadius;
  final ScrollController controller;
  final VoidCallback onClose;
  final bool showDragIndicator;
  final Widget Function(
    BuildContext context,
    ScrollController controller,
    CustomScrollableScrollPhysics scrollPhysics,
  ) contentBuilder;
  final DraggableScrollableController? draggableController;
  final List<Widget> actions;
  final List<PageDraggableOverlayChild> overlayChildren;
  final ValueChanged<int>? onOpenOverlayChild;
  final DynamicTab? dynamicTab;
  final double dynamicTabShowOffset;
  final double baseHeight;

  @override
  State<PageDraggableSheet> createState() => _PageDraggableSheetState();
}

class _PageDraggableSheetState extends State<PageDraggableSheet>
    with SingleTickerProviderStateMixin {
  final Queue<int> _overlayChildQueue = Queue<int>();
  int? _overlayChildIndex;
  int _overlayChildOpenCount = 0;
  bool _overlayAnyChildIsOpened = false;

  late final ScrollController _innerListController;
  late final CustomScrollableScrollPhysics _innerListPhysics;
  late final AnimationController _dynamicTabHideController;
  late final Animation<double> _dynamicTabHideAnimation;

  @override
  void initState() {
    super.initState();

    _innerListController = ScrollController();
    _innerListPhysics = CustomScrollableScrollPhysics(tag: widget.scrollTag);

    for (int i = 0; i < widget.overlayChildren.length; i++) {
      final PageDraggableOverlayChild overlayChild = widget.overlayChildren[i];
      overlayChild.controller.addListener(() => _onOpenOverlayChild(i));
    }

    _dynamicTabHideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _dynamicTabHideAnimation = CurvedAnimation(
      parent: _dynamicTabHideController,
      curve: Curves.linear,
    );
  }

  Future<void> _onOpenOverlayChild(int index) async {
    final bool opened = widget.overlayChildren[index].controller.isOpened;
    if (widget.dynamicTab != null) {
      if (opened) {
        _overlayChildOpenCount += 1;
        _dynamicTabHideController.reverse();
        _overlayAnyChildIsOpened = true;
        _overlayChildIndex = index;
        _overlayChildQueue.add(index);
      } else {
        _overlayChildOpenCount -= 1;
        _overlayAnyChildIsOpened = _overlayChildOpenCount >= 1;

        // Resets the topmost to null
        if (!_overlayAnyChildIsOpened) {
          _overlayChildIndex = null;
        } else {}

        _overlayChildQueue.removeWhere((int val) => val == index);
        if (_innerListController.offset < 100) {
          _dynamicTabHideController.forward();
        }
      }
    }
  }

  Future<void> _onHideDynamicTabsCallback(double offset) async {
    if (offset >= 100) {
      _dynamicTabHideController.reverse();
    } else if (offset <= -100) {
      _dynamicTabHideController.forward();
    }
  }

  @override
  void dispose() {
    _innerListController.dispose();
    for (final PageDraggableOverlayChild overlayChild
        in widget.overlayChildren) {
      overlayChild.controller.dispose();
    }
    super.dispose();
  }

  void _onPointerMoveOnSheetContent(PointerMoveEvent event) {
    if (widget.draggableController != null) {
      if (_innerListController.offset == 0 && !_overlayAnyChildIsOpened) {
        _changeDraggableSize(_innerListPhysics, event);
      } else if (_overlayAnyChildIsOpened && _overlayChildIndex != null) {
        final PageDraggableOverlayChildController controller =
            widget.overlayChildren[_overlayChildIndex!].controller;
        if (controller._scrollController.offset == 0 && controller.isOpened) {
          _changeDraggableSize(controller._scrollPhysics, event);
        }
      }
    }
  }

  void _changeDraggableSize(
    CustomScrollableScrollPhysics scrollPhysics,
    PointerMoveEvent event,
  ) {
    final double yDist = event.delta.dy;
    final double height = MediaQuery.sizeOf(context).height;
    final double size = widget.draggableController!.size;

    final double newSize = event.delta.dy < 0 && size <= widget.baseHeight
        ? clampDouble(size - (yDist / height), 0, widget.baseHeight)
        : clampDouble(size - (yDist / height), 0, 1);
    if (newSize >= widget.baseHeight) {
      scrollPhysics.canScroll(true);
    } else {
      scrollPhysics.canScroll(false);
    }
    widget.draggableController!.jumpTo(newSize);
  }

  void _onPointerLeaveOnSheetContent(PointerUpEvent event) {
    if (widget.draggableController != null) {
      _innerListPhysics.canScroll(true);
      if (_overlayAnyChildIsOpened) {
        if (_overlayChildIndex != null) {
          widget.overlayChildren[_overlayChildIndex!].controller._scrollPhysics
              .canScroll(true);
        }
      }
      final double size = widget.draggableController!.size;
      if ((size != 0.0 || size != widget.baseHeight) && size != 1) {
        widget.draggableController!.animateTo(
          size < widget.baseHeight / 2 ? 0.0 : widget.baseHeight,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeIn,
        );
      }
    }
  }

  void _closeSheet() {
    if (_overlayAnyChildIsOpened) {
      for (final PageDraggableOverlayChild element in widget.overlayChildren) {
        element.controller.close();
      }
    }
    widget.onClose();
  }

  double _beginPixels = 0.0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Material(
        borderRadius: widget.borderRadius,
        child: ScrollConfiguration(
          behavior: const NoOverScrollGlowBehavior(),
          child: CustomScrollView(
            controller: widget.controller,
            slivers: <Widget>[
              AnimatedBuilder(
                animation: _dynamicTabHideAnimation,
                builder: (context, childWidget) {
                  final v = widget.dynamicTab == null
                      ? 0
                      : _dynamicTabHideAnimation.value;

                  return SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: PersistentHeaderDelegate(
                      minHeight: 66,
                      maxHeight: (v * (111 - 66)) + 66,
                      child: childWidget!,
                    ),
                  );
                },
                child: Material(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (widget.showDragIndicator)
                        Container(
                          height: 4,
                          width: 45,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(32),
                          ),
                        )
                      else
                        const SizedBox(height: 16),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                        ),
                        child: Stack(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                if (widget.subtitle != null)
                                  Text(
                                    widget.subtitle!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                const Spacer(),
                                const SizedBox(width: 12),
                                ...widget.actions,
                                const SizedBox(width: 12),
                                InkWell(
                                  borderRadius: BorderRadius.circular(32),
                                  onTap: _closeSheet,
                                  child: const Icon(
                                    YTIcons.close_outlined,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            for (final PageDraggableOverlayChild overlayChild
                                in widget.overlayChildren)
                              _OverlayChildTitle(
                                controller: overlayChild.controller,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      if (widget.dynamicTab != null)
                        SizeTransition(
                          sizeFactor: _dynamicTabHideAnimation,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                                child: widget.dynamicTab,
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      const Divider(thickness: 1.1, height: 0),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                child: Listener(
                  onPointerMove: _onPointerMoveOnSheetContent,
                  onPointerUp: _onPointerLeaveOnSheetContent,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) {
                          if (notification is ScrollStartNotification) {
                            _beginPixels = notification.metrics.pixels;
                          }
                          if (notification is ScrollEndNotification) {
                            _onHideDynamicTabsCallback(
                              notification.metrics.pixels - _beginPixels,
                            );
                          }
                          return false;
                        },
                        child: widget.contentBuilder(
                          context,
                          _innerListController,
                          _innerListPhysics,
                        ),
                      ),
                      for (final PageDraggableOverlayChild overlayChild
                          in widget.overlayChildren)
                        overlayChild,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageDraggableOverlayChild extends StatefulWidget {
  const PageDraggableOverlayChild({
    super.key,
    required this.controller,
    required this.builder,
  });
  final PageDraggableOverlayChildController controller;
  final Widget Function(
    BuildContext context,
    ScrollController controller,
    CustomScrollableScrollPhysics scrollPhysics,
  ) builder;

  @override
  State<PageDraggableOverlayChild> createState() =>
      _PageDraggableOverlayChildState();
}

class _PageDraggableOverlayChildState extends State<PageDraggableOverlayChild>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 250),
    );
    slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(controller);
    widget.controller.addListener(() {
      if (widget.controller.isOpened) {
        controller.forward();
      } else {
        controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: Material(
        child: widget.builder(
          context,
          widget.controller._scrollController,
          widget.controller._scrollPhysics,
        ),
      ),
    );
  }
}

class PageDraggableOverlayChildController extends ChangeNotifier {
  PageDraggableOverlayChildController({
    required this.title,
  });
  final String title;
  final ScrollController _scrollController = ScrollController();
  final CustomScrollableScrollPhysics _scrollPhysics =
      const CustomScrollableScrollPhysics(tag: 'innerChild');

  bool _isOpened = false;
  bool get isOpened => _isOpened;

  void open() {
    _isOpened = true;
    notifyListeners();
  }

  void close() {
    _isOpened = false;
    notifyListeners();
  }
}

class _OverlayChildTitle extends StatefulWidget {
  const _OverlayChildTitle({required this.controller});
  final PageDraggableOverlayChildController controller;

  @override
  State<_OverlayChildTitle> createState() => _OverlayChildTitleState();
}

class _OverlayChildTitleState extends State<_OverlayChildTitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> opacityAnimation;
  late final Animation<Offset> slideAnimation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 250),
    );
    opacityAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );
    slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(controller);

    widget.controller.addListener(() {
      if (widget.controller.isOpened) {
        controller.forward();
      } else {
        controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: opacityAnimation,
        child: Material(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                borderRadius: BorderRadius.circular(32),
                onTap: widget.controller.close,
                child: const Icon(YTIcons.arrow_back_outlined),
              ),
              const SizedBox(width: 20),
              Text(
                widget.controller.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
