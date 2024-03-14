import 'dart:ui';

import 'package:flutter/material.dart';

import 'custom_scroll_physics.dart';
import 'dynamic_tab.dart';
import 'over_scroll_glow_behavior.dart';
import 'persistent_header_delegate.dart';

class PageDraggableSheet extends StatefulWidget {
  final String scrollTag;
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
  final List<PageDraggableOverlayChildItem> overlayChildren;
  final ValueChanged<int>? onOpenOverlayChild;
  final DynamicTab? dynamicTab;
  final double dynamicTabShowOffset;
  final double baseHeight;

  const PageDraggableSheet({
    super.key,
    required this.title,
    this.subtitle,
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
    this.overlayChildren = const <PageDraggableOverlayChildItem>[],
    this.onOpenOverlayChild,
  });

  @override
  State<PageDraggableSheet> createState() => _PageDraggableSheetState();
}

class _PageDraggableSheetState extends State<PageDraggableSheet>
    with TickerProviderStateMixin {
  bool _overlayAnyChildIsOpened = false;

  late final ScrollController _innerListController;
  late final CustomScrollableScrollPhysics _innerListPhysics;
  late final ValueNotifier<bool> _dynamicTabNotifier;

  @override
  void initState() {
    super.initState();

    _innerListController = ScrollController();
    _innerListPhysics = CustomScrollableScrollPhysics(tag: widget.scrollTag);
    _dynamicTabNotifier = ValueNotifier<bool>(widget.dynamicTab != null);

    for (int i = 0; i < widget.overlayChildren.length; i++) {
      widget.overlayChildren[i].addAnimation(
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 250),
          reverseDuration: const Duration(milliseconds: 250),
        ),
      );
    }

    for (int i = 0; i < widget.overlayChildren.length; i++) {
      final overlayChild = widget.overlayChildren[i];
      // TODO: Revise code
      overlayChild.listenable.addListener(() => _onOpenOverlayChild(i));
    }

    // Adds listener to hide DynamicTabs if available
    if (widget.dynamicTab != null) {
      _innerListController.addListener(_onHideDynamicTabsCallback);
    }
  }

  Future<void> _onOpenOverlayChild(int index) async {
    final opened = widget.overlayChildren[index].listenable.value;
    if (widget.dynamicTab != null) {
      if (opened) {
        _dynamicTabNotifier.value = false;
      } else {
        if (_innerListController.offset < 100) {
          _dynamicTabNotifier.value = true;
        }
      }
    }
    _overlayAnyChildIsOpened &= opened;
  }

  Future<void> _onHideDynamicTabsCallback() async {
    if (_innerListController.offset >= 100) {
      _dynamicTabNotifier.value = false;
    } else {
      _dynamicTabNotifier.value = true;
    }
  }

  @override
  void dispose() {
    _innerListController.dispose();
    for (final overlayChild in widget.overlayChildren) {
      overlayChild.controller.dispose();
    }
    super.dispose();
  }

  void _onPointerMoveOnSheetContent(PointerMoveEvent event) {
    if (widget.draggableController != null) {
      if (_innerListController.offset == 0) {
        final yDist = event.delta.dy;
        final height = MediaQuery.sizeOf(context).height;
        final size = widget.draggableController!.size;

        final newSize = event.delta.dy < 0 && size <= widget.baseHeight
            ? clampDouble(size - (yDist / height), 0, widget.baseHeight)
            : clampDouble(size - (yDist / height), 0, 1);

        if (newSize >= widget.baseHeight) {
          _innerListPhysics.canScroll(true);
        } else {
          _innerListPhysics.canScroll(false);
        }
        widget.draggableController!.jumpTo(newSize);
      }
    }
  }

  void _onPointerLeaveOnSheetContent(PointerUpEvent event) {
    if (widget.draggableController != null) {
      _innerListPhysics.canScroll(true);
      final size = widget.draggableController!.size;
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
      // TODO: _closeAllOverChild();
    }
    widget.onClose();
  }

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
            slivers: [
              ValueListenableBuilder(
                valueListenable: _dynamicTabNotifier,
                builder: (context, showDynamicTabs, childWidget) {
                  // TODO: Fix pointer being recognized in scrollable below SliverPersistentHeader
                  return SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: PersistentHeaderDelegate(
                      minHeight: 60,
                      maxHeight: showDynamicTabs ? 100 : 60,
                      child: Material(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                            childWidget!,
                            if (showDynamicTabs)
                              const SizedBox(height: 8)
                            else
                              const SizedBox(height: 16),
                            if (showDynamicTabs) ...[
                              Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    child: widget.dynamicTab,
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ],
                            const Divider(thickness: 1.5, height: 0),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 18,
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
                            child: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      for (final overlayChild in widget.overlayChildren)
                        _OverlayChildTitle(
                          slideAnimation: overlayChild.slideAnimation,
                          opacityAnimation: overlayChild.opacityAnimation,
                          title: overlayChild.title,
                          onClose: () {},
                        ),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: true,
                fillOverscroll: false,
                child: Listener(
                  onPointerMove: _onPointerMoveOnSheetContent,
                  onPointerUp: _onPointerLeaveOnSheetContent,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      widget.contentBuilder(
                        context,
                        _innerListController,
                        _innerListPhysics,
                      ),
                      for (final overlayChild in widget.overlayChildren)
                        _PageDraggableOverlayChild(
                          item: overlayChild,
                        ),
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

class _PageDraggableOverlayChild extends StatefulWidget {
  final PageDraggableOverlayChildItem item;

  const _PageDraggableOverlayChild({
    required this.item,
  });

  @override
  State<_PageDraggableOverlayChild> createState() =>
      _PageDraggableOverlayChildState();
}

class _PageDraggableOverlayChildState
    extends State<_PageDraggableOverlayChild> {
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: widget.item.slideAnimation,
      child: Material(
        child: widget.item.builder(context),
      ),
    );
  }
}

class PageDraggableOverlayChildItem {
  final String title;
  final ValueNotifier<bool> listenable;
  final Widget Function(BuildContext context) builder;
  final int? count;
  late final AnimationController controller;
  late final Animation<double> opacityAnimation;
  late final Animation<Offset> slideAnimation;

  PageDraggableOverlayChildItem({
    required this.title,
    required this.listenable,
    required this.builder,
    this.count,
  });

  void addAnimation(AnimationController animation) {
    controller = animation;
    opacityAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
    );
    slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: const Offset(0, 0),
    ).animate(animation);
  }

  void open() {
    listenable.value = true;
    controller.forward();
  }

  void close() {
    listenable.value = false;
    controller.reverse();
  }
}

class _OverlayChildTitle extends StatelessWidget {
  final Animation<Offset> slideAnimation;
  final Animation<double> opacityAnimation;
  final String title;
  final VoidCallback onClose;

  const _OverlayChildTitle({
    required this.slideAnimation,
    required this.opacityAnimation,
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Material(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(32),
                onTap: onClose,
                child: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 32),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
