import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

import 'custom_scroll_physics.dart';
import 'dynamic_tab.dart';
import 'gestures/custom_ink_well.dart';
import 'over_scroll_glow_behavior.dart';
import 'persistent_header_delegate.dart';
import 'sheet_drag_indicator.dart';

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
    this.bottom,
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
  final Widget? bottom;
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
  final List<int> _overlayChildIndexList = <int>[];
  int? _overlayLastChildIndex;
  bool get _overlayAnyChildIsOpened => _overlayChildIndexList.isNotEmpty;

  late final ScrollController _innerListController;
  late final CustomScrollableScrollPhysics _innerListPhysics;
  late final AnimationController _dynamicTabHideController;
  late final Animation<double> _dynamicTabHideAnimation;

  VelocityTracker? _velocityTracker;

  bool get hasDynamicTab => widget.dynamicTab != null;

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
      value: hasDynamicTab ? 1 : 0,
      duration: const Duration(milliseconds: 250),
    );

    _dynamicTabHideAnimation = CurvedAnimation(
      parent: _dynamicTabHideController,
      curve: Curves.linear,
    );
  }

  Future<void> _onOpenOverlayChild(int index) async {
    final bool opened = widget.overlayChildren[index].controller.isOpened;

    if (opened) {
      _overlayLastChildIndex = index;
      _overlayChildIndexList.add(index);

      if (hasDynamicTab) {
        _dynamicTabHideController.reverse();
      }
    } else {
      // Resets the topmost to null
      if (!_overlayAnyChildIsOpened) {
        _overlayLastChildIndex = null;
      } else {
        _overlayLastChildIndex = _overlayChildIndexList.last;
      }
      _overlayChildIndexList.remove(index);

      if (_innerListController.hasClients &&
          _innerListController.offset < 100 &&
          hasDynamicTab) {
        _dynamicTabHideController.forward();
      }
    }
  }

  Future<void> _onHideDynamicTabsCallback(
    double changePixels,
    double extentBefore,
  ) async {
    if (changePixels >= 100) {
      _dynamicTabHideController.reverse();
    } else if (changePixels <= -100 || extentBefore < 100) {
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

  void _onTapScrollHeader() {
    widget.draggableController!.animateTo(
      1,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeIn,
    );
  }

  void _onPointerDownOnSheet(PointerDownEvent event) {
    _velocityTracker = VelocityTracker.withKind(event.kind);
  }

  void _onPointerMoveOnSheetContent(PointerMoveEvent event) {
    _velocityTracker?.addPosition(event.timeStamp, event.localPosition);

    if (widget.draggableController != null) {
      if (_innerListController.offset == 0 && !_overlayAnyChildIsOpened) {
        _changeDraggableSize(_innerListPhysics, event);
      } else if (_overlayAnyChildIsOpened && _overlayLastChildIndex != null) {
        final PageDraggableOverlayChildController controller =
            widget.overlayChildren[_overlayLastChildIndex!].controller;
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
        if (_overlayLastChildIndex != null) {
          widget.overlayChildren[_overlayLastChildIndex!].controller
              ._scrollPhysics
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

    if (_innerListController.hasClients && _innerListController.offset == 0) {
      // Calculate the velocity
      final velocity = _velocityTracker?.getVelocity();
      if (velocity != null && velocity.pixelsPerSecond.dy > 300) {
        if (event.delta.dy > 1) {
          widget.draggableController!.animateTo(
            1,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeIn,
          );
        } else {
          widget.draggableController!.animateTo(
            0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeIn,
          );
        }
      }
    }

    _velocityTracker = null;
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
                  final v = _dynamicTabHideAnimation.value;

                  return SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: PersistentHeaderDelegate(
                      minHeight: 66,
                      maxHeight: (v * 44) + 66,
                      child: childWidget!,
                    ),
                  );
                },
                child: Material(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _onTapScrollHeader,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (widget.showDragIndicator)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: SheetDragIndicator(),
                          )
                        else
                          const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Column(
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        widget.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
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
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      const Spacer(),
                                      const SizedBox(width: 12),
                                      ...widget.actions,
                                      const SizedBox(width: 12),
                                      IconButton(
                                        onPressed: _closeSheet,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                          maxHeight: 28,
                                        ),
                                        splashColor: Colors.transparent,
                                        icon: const Icon(
                                          YTIcons.close_outlined,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                ],
                              ),
                              for (final PageDraggableOverlayChild overlayChild
                                  in widget.overlayChildren)
                                Positioned(
                                  top: -4,
                                  child: _OverlayChildTitle(
                                    controller: overlayChild.controller,
                                  ),
                                ),
                            ],
                          ),
                        ),
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
                        const Divider(thickness: 1, height: 0),
                      ],
                    ),
                  ),
                ),
              ),
              SliverFillRemaining(
                child: Listener(
                  onPointerDown: _onPointerDownOnSheet,
                  onPointerMove: _onPointerMoveOnSheetContent,
                  onPointerUp: _onPointerLeaveOnSheetContent,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) {
                          if (hasDynamicTab) {
                            if (notification is ScrollStartNotification) {
                              _beginPixels = notification.metrics.pixels;
                            } else if (notification is ScrollEndNotification) {
                              _onHideDynamicTabsCallback(
                                notification.metrics.pixels - _beginPixels,
                                notification.metrics.extentBefore,
                              );
                            }
                          }
                          return false;
                        },
                        child: widget.contentBuilder(
                          context,
                          _innerListController,
                          _innerListPhysics,
                        ),
                      ),
                      if (widget.bottom != null)
                        SingleChildScrollView(
                          reverse: true,
                          child: IntrinsicHeight(
                            child: widget.bottom,
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
    // controller.dispose();
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
              CustomInkWell(
                borderRadius: BorderRadius.circular(32),
                padding: const EdgeInsets.all(8),
                onTap: widget.controller.close,
                child: const Icon(YTIcons.arrow_back_outlined),
              ),
              const SizedBox(width: 24),
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
