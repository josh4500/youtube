import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../constants.dart';
import 'custom_scroll_physics.dart';
import 'gestures/custom_ink_well.dart';
import 'over_scroll_glow_behavior.dart';
import 'persistent_header_delegate.dart';
import 'sheet_drag_indicator.dart';

typedef PageDraggableBuilder = Widget Function(
  BuildContext context,
  ScrollController? scrollController,
);

class PageDraggableSheet extends StatefulWidget {
  const PageDraggableSheet({
    super.key,
    required this.title,
    this.trailingTitle,
    this.dragDownDismiss = false,
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
    this.subtitle,
    this.showDivider = true,
    this.dragDismissible = true,
  });

  final bool dragDownDismiss;
  final String title;
  final String? trailingTitle;
  final BorderRadius borderRadius;
  final ScrollController controller;
  final VoidCallback onClose;
  final bool showDragIndicator, showDivider, dragDismissible;
  final Widget Function(
    BuildContext context,
    ScrollController controller,
    CustomScrollPhysics scrollPhysics,
  ) contentBuilder;
  final DraggableScrollableController? draggableController;
  final List<Widget> actions;
  final Widget? bottom;
  final PreferredSize? subtitle;
  final List<PageDraggableOverlayChild> overlayChildren;
  final ValueChanged<int>? onOpenOverlayChild;
  final Widget? dynamicTab;
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

  late final ScrollController _innerScrollController;
  late final CustomScrollPhysics _innerListPhysics;
  late final AnimationController _dynamicTabHideController;
  late final Animation<double> _dynamicTabHideAnimation;

  VelocityTracker? _velocityTracker;
  double _beginPixels = 0.0;
  bool _canDragSheet = true;
  bool get hasDynamicTab => widget.dynamicTab != null;

  @override
  void initState() {
    super.initState();

    _innerScrollController = ScrollController();
    _innerListPhysics = CustomScrollPhysics();

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
      widget.onOpenOverlayChild?.call(index);
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

      if (_innerScrollController.hasClients &&
          _innerScrollController.offset < 100 &&
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
    _innerScrollController.dispose();
    super.dispose();
  }

  void _onTapScrollHeader() {
    widget.draggableController!.animateTo(
      1,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeIn,
    );
  }

  void _changeDraggableSize(
    CustomScrollPhysics scrollPhysics,
    PointerMoveEvent event,
  ) {
    final double yDist = event.delta.dy;
    final double height = MediaQuery.sizeOf(context).height;
    final double size = widget.draggableController!.size;

    final double newSize = event.delta.dy < 0 && size <= widget.baseHeight
        ? clampDouble(size - (yDist / height), 0, widget.baseHeight)
        : clampDouble(size - (yDist / height), 0, 1);
    if (newSize >= widget.baseHeight) {
      scrollPhysics.canScroll = true;
    } else {
      scrollPhysics.canScroll = false;
    }

    if (_canDragSheet) widget.draggableController!.jumpTo(newSize);
  }

  void _onPointerDownOnSheet(PointerDownEvent event) {
    _velocityTracker = VelocityTracker.withKind(event.kind);
  }

  void _onPointerMoveOnSheetContent(PointerMoveEvent event) {
    if (widget.dragDismissible == false) return;

    if (event.delta.dy <= 0 && _innerScrollController.offset != 0) {
      _canDragSheet = false;
    }

    _velocityTracker?.addPosition(event.timeStamp, event.localPosition);

    if (widget.draggableController != null) {
      if (!_innerScrollController.hasClients ||
          _innerScrollController.offset == 0 && !_overlayAnyChildIsOpened) {
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

  void _onPointerLeaveOnSheetContent(PointerUpEvent event) {
    if (widget.dragDismissible == false) return;
    _canDragSheet = _innerScrollController.offset == 0;
    if (widget.draggableController != null) {
      _innerListPhysics.canScroll = true;
      if (_overlayAnyChildIsOpened) {
        if (_overlayLastChildIndex != null) {
          widget.overlayChildren[_overlayLastChildIndex!].controller
              ._scrollPhysics.canScroll = true;
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

    if (_innerScrollController.hasClients &&
        _innerScrollController.offset == 0) {
      // Calculate the velocity
      final velocity = _velocityTracker?.getVelocity();
      if (velocity != null && velocity.pixelsPerSecond.dy > kMaxDragVelocity) {
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
                  final aValue = _dynamicTabHideAnimation.value;
                  final baseHeight =
                      60.0 + (widget.subtitle?.preferredSize.height ?? 0);
                  const dynamicTabHeight = 44;
                  return SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: PersistentHeaderDelegate(
                      minHeight: baseHeight,
                      maxHeight: (aValue * dynamicTabHeight) + baseHeight,
                      child: childWidget!,
                    ),
                  );
                },
                child: Material(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (widget.showDragIndicator)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: SheetDragIndicator(),
                        )
                      else
                        const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: _onTapScrollHeader,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 4),
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
                                        if (widget.trailingTitle != null)
                                          Text(
                                            widget.trailingTitle!,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        const Spacer(),
                                        const SizedBox(width: 12),
                                        ...widget.actions,
                                      ],
                                    ),
                                  ),
                                  for (final overlayChild
                                      in widget.overlayChildren)
                                    Positioned.fill(
                                      child: _OverlayChildTitle(
                                        controller: overlayChild.controller,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(0, -8),
                            child: CustomInkWell(
                              onTap: _closeSheet,
                              padding: const EdgeInsets.all(8),
                              borderRadius: BorderRadius.circular(32),
                              splashFactory: NoSplash.splashFactory,
                              child: const Icon(YTIcons.close_outlined),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(child: widget.subtitle?.child),
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
                      if (widget.showDivider)
                        const Divider(thickness: 1, height: 0),
                    ],
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
                          _innerScrollController,
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
                      for (final overlayChild in widget.overlayChildren)
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
    CustomScrollPhysics scrollPhysics,
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
  final _scrollController = ScrollController();
  final _scrollPhysics = CustomScrollPhysics();

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
      value: widget.controller.isOpened ? 1 : 0,
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
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  maxHeight: 28,
                ),
                splashColor: Colors.transparent,
                onPressed: widget.controller.close,
                icon: const Icon(YTIcons.arrow_back_outlined),
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

// TODO(josh4500): Complete new API for Draggable
// Tasks left
// 1: Close using the controller
// 2: Back button should close (using controller), which closes opened children
//    (PageDraggableOverlayChild) consecutively.
// 3: Change bottom opacity based on top sheet draggable size.
// 4: Change horizontal size based on pointer event.
// 5: Whether to pass or dynamic create the controller.
// 6: Create grouped draggable which add or remove DraggableSheet entry based on max size of group.
//
//

class StackedPageDraggable extends StatefulWidget {
  const StackedPageDraggable({super.key, required this.child});
  final Widget child;

  static _StackedPageDraggableState? _maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<_StackedPageDraggableState>();
  }

  static _StackedPageDraggableState _of(BuildContext context) {
    return _maybeOf(context)!;
  }

  static void open(
    BuildContext context,
    Object key,
    PageDraggableBuilder builder,
  ) {
    _of(context).openBottomSheet(key, builder);
  }

  @override
  State<StackedPageDraggable> createState() => _StackedPageDraggableState();
}

class _StackedPageDraggableState extends State<StackedPageDraggable> {
  final _History _history = _History();
  final GlobalKey<OverlayState> _overlayKey = GlobalKey();

  OverlayState get _overlayState => _overlayKey.currentState!;

  @override
  void dispose() {
    _history.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      key: _overlayKey,
      initialEntries: [
        OverlayEntry(builder: (BuildContext context) => widget.child),
      ],
    );
  }

  void openBottomSheet(Object key, PageDraggableBuilder builder) {
    final controller = DraggableScrollableController();

    final newEntry = OverlayEntry(
      builder: (BuildContext context) {
        final properties = context.provide<DraggableProperties>();
        return DraggableSheet(
          builder: builder,
          controller: controller,
          snapSizes: properties.snapSizes,
          initialHeight: properties.initialHeight,
        );
      },
    );
    final didAdd = _history.addDraggable(key, newEntry);
    if (didAdd) {
      _overlayState.insert(newEntry);
    }
  }
}

class DraggableProperties {
  DraggableProperties({
    required this.snapSizes,
    required this.initialHeight,
  }) : assert(
          initialHeight >= 0 || initialHeight <= 1,
          'initialHeight cannot be less than 0 or greater tha 1',
        );

  final List<double> snapSizes;
  final double initialHeight;
}

class DraggableSheet extends StatefulWidget {
  const DraggableSheet({
    super.key,
    required this.controller,
    required this.snapSizes,
    required this.builder,
    required this.initialHeight,
  });

  final double initialHeight;
  final List<double> snapSizes;
  final PageDraggableBuilder builder;
  final DraggableScrollableController controller;

  @override
  State<DraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet>
    with TickerProviderStateMixin {
  late final sizeController = AnimationController(
    vsync: this,
    value: 0,
    duration: Durations.medium1,
  );

  late final opacityController = AnimationController(
    vsync: this,
    value: 0,
    duration: Durations.medium1,
  );

  @override
  void dispose() {
    sizeController.dispose();
    opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      child: Builder(
        builder: (context) {
          if (context.orientation.isLandscape) {
            return SizeTransition(
              axis: Axis.horizontal,
              axisAlignment: -1,
              sizeFactor: CurvedAnimation(
                parent: sizeController,
                curve: Curves.bounceInOut,
              ),
              child: Listener(
                child: widget.builder(context, null),
              ),
            );
          }
          return DraggableScrollableSheet(
            snap: true,
            minChildSize: 0,
            snapSizes: widget.snapSizes,
            controller: widget.controller,
            shouldCloseOnMinExtent: false,
            initialChildSize: widget.initialHeight,
            snapAnimationDuration: Durations.medium4,
            builder: (
              BuildContext context,
              ScrollController controller,
            ) {
              return Material(
                child: FadeTransition(
                  opacity: ReverseAnimation(opacityController),
                  child: widget.builder(context, controller),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _History extends ChangeNotifier {
  final _entryKeys = <Object?>[];
  final _entries = <Object, OverlayEntry>{};

  Object? get lastEntryKey => _entryKeys.isNotEmpty ? _entryKeys.last : null;
  bool addDraggable(Object key, OverlayEntry entry) {
    bool didAdd = false;

    _entries.putIfAbsent(key, () {
      didAdd = true;
      _entryKeys.add(key);
      return entry;
    });

    return didAdd;
  }

  void pop() => _removeDraggable(lastEntryKey);

  void _removeDraggable(Object? key) {
    _entries.remove(key)?.remove();
  }
}
