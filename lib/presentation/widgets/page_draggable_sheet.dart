import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clone/core/utils/normalization.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../constants.dart';
import 'custom_scroll_physics.dart';
import 'gestures/custom_ink_well.dart';
import 'over_scroll_glow_behavior.dart';
import 'persistent_header_delegate.dart';
import 'sheet_drag_indicator.dart';

const double kInitialSize = 0;
const double kInitialOpacity = 1;

typedef PageDraggableBuilder = Widget Function(
  BuildContext context,
  ScrollController? scrollController,
  DraggableScrollableController? draggableScrollController,
);

class DraggableProperties {
  DraggableProperties({this.initialHeight = .8})
      : assert(
          initialHeight >= 0 || initialHeight <= 1,
          'initialHeight cannot be less than 0 or greater tha 1',
        ),
        snapSizes = [
          0,
          if (initialHeight > 0 && initialHeight < 1) initialHeight,
          1,
        ];

  final List<double> snapSizes;
  final double initialHeight;
}

class SlotKey {
  SlotKey(this.value);

  final Object value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SlotKey && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'SlotKey{value: $value}';
}

abstract class SlotEntry {}

class SingleSlotEntry extends SlotEntry {
  SingleSlotEntry({required this.entry});

  final OverlayEntry entry;
  void remove() => entry.remove();
}

class MultiSlotEntry extends SlotEntry {
  MultiSlotEntry({required this.size, required this.groupKey});

  final int size;
  final SlotKey groupKey;
  final Map<SlotKey, OverlayEntry> _slots = {};
  final List<SlotKey> _slotOrder = [];

  OverlayEntry? operator [](SlotKey key) => _slots[key];
  bool get isEmpty => _slots.isEmpty;
  bool exist(SlotKey? itemKey) => _slots.containsKey(itemKey);
  void operator []=(SlotKey key, OverlayEntry entry) {
    if (_slots.length >= size) {
      final oldestKey = _slotOrder.removeAt(0);
      _slots.remove(oldestKey)?.remove();
    }
    _slots[key] = entry;
    _slotOrder.add(key);
  }

  void remove(SlotKey? key) {
    if (key != null) {
      _slots.remove(key)?.remove();
      _slotOrder.remove(key);
    }
  }

  void removeAll() {
    _slots.forEach((_, value) => value.remove());
    _slots.clear();
    _slotOrder.clear();
  }
}

class _History extends ChangeNotifier {
  final _entryKeys = <SlotKey>[];
  final _entries = <SlotKey, SlotEntry>{};
  SlotKey? get _lastEntryKey => _entryKeys.isNotEmpty ? _entryKeys.last : null;

  bool addDraggable(SlotKey key, SlotEntry entry) {
    bool didAdd = false;
    _entries.putIfAbsent(key, () {
      didAdd = true;
      _entryKeys.add(key);
      return entry;
    });
    return didAdd;
  }

  void pop([SlotKey? key]) => _removeEntry(key ?? _lastEntryKey);

  void addOrReplaceEntry(
    SlotKey key,
    SlotKey? itemKey,
    int groupSize,
    OverlayEntry Function() callback,
  ) {
    final existingEntry = _entries[key];
    final isGroup = itemKey != null;

    if (existingEntry != null) {
      if (isGroup) {
        if (existingEntry is SingleSlotEntry) {
          existingEntry.remove();
          _entries.remove(key);
          _entryKeys.add(key);
          _entries[key] = MultiSlotEntry(size: groupSize, groupKey: key);
        }

        final multiSlotEntry = _entries[key]! as MultiSlotEntry;
        if (!multiSlotEntry.exist(itemKey)) {
          multiSlotEntry[itemKey] = callback.call();
        }
      } else {
        if (existingEntry is MultiSlotEntry) {
          existingEntry.removeAll();
          _entries.remove(key);
          _entryKeys.add(key);
          _entries[key] = SingleSlotEntry(entry: callback.call());
        }
      }
    } else {
      if (isGroup) {
        _entryKeys.add(key);
        _entries[key] = MultiSlotEntry(size: groupSize, groupKey: key);
        final multiSlotEntry = _entries[key]! as MultiSlotEntry;
        multiSlotEntry[itemKey] = callback.call();
      } else {
        _entryKeys.add(key);
        _entries[key] = SingleSlotEntry(entry: callback.call());
      }
    }

    notifyListeners();
  }

  void _removeEntry(SlotKey? key, {SlotKey? itemKey}) {
    if (key == null) return; // Add null check

    final slotEntry = _entries[key];
    if (slotEntry != null) {
      if (slotEntry is SingleSlotEntry) {
        slotEntry.remove();
        _entries.remove(key);
        _entryKeys.remove(key); // Remove from key list
      } else if (slotEntry is MultiSlotEntry) {
        if (itemKey != null) {
          slotEntry.remove(itemKey);
          if (slotEntry.isEmpty) {
            _entries.remove(key);
            _entryKeys.remove(key);
          }
        } else {
          slotEntry.removeAll();
          _entries.remove(key);
          _entryKeys.remove(key);
        }
      }
      notifyListeners();
    }
  }

  SlotEntry? retrieveSlotEntry(SlotKey slotKey) => _entries[slotKey];

  @override
  void dispose() {
    _entries.clear();
    _entryKeys.clear();
    super.dispose();
  }
}

class PageDraggableController extends ChangeNotifier {
  PageDraggableController({this.initialHeight = 1}) {
    if (kFlutterMemoryAllocationsEnabled) {
      ChangeNotifier.maybeDispatchObjectCreation(this);
    }
    _dragController.addListener(_listener);
  }

  @override
  void dispose() {
    _dragController.removeListener(_listener);
    _dragController.dispose();
    super.dispose();
  }

  void _listener() {
    _widthRatio = _dragController.size.normalize(0, initialHeight);
    notifyListeners();
  }

  final _dragController = DraggableScrollableController();

  final double initialHeight;

  double get size => _dragController.size;

  double _widthRatio = kInitialSize;
  double get widthRatio => _widthRatio;

  double _opacity = kInitialOpacity;
  double get opacity => _opacity;

  set size(double value) {
    _dragController.jumpTo(value);
  }

  set widthRatio(double value) {
    if (value != _widthRatio) {
      _widthRatio = value.clamp(0.0, 1.0);
      notifyListeners();
    }
  }

  set opacity(double value) {
    if (value != _opacity) {
      _opacity = value.clamp(0.0, 1.0);
      notifyListeners();
    }
  }

  void open() {
    _widthRatio = 1;
    _opacity = 1;
    _dragController.animateTo(
      initialHeight,
      duration: Durations.medium4,
      curve: Curves.easeIn,
    );
    notifyListeners();
  }

  void close() {
    widthRatio = 0;
    _dragController.animateTo(
      0,
      duration: Durations.medium4,
      curve: Curves.easeIn,
    );
  }
}

abstract class DragSheetNotification extends Notification {}

class DragSheetCloseNotification extends DragSheetNotification {}

class PageDraggableSheet extends StatefulWidget {
  const PageDraggableSheet({
    super.key,
    required this.title,
    this.trailingTitle,
    this.dragDownDismiss = false,
    this.borderRadius = BorderRadius.zero,
    required this.controller,
    this.onClose,
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
  final VoidCallback? onClose;
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
    widget.onClose?.call();
    DragSheetCloseNotification().dispatch(context);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Material(
        borderRadius: widget.borderRadius,
        child: ScrollConfiguration(
          behavior: const NoScrollGlowBehavior(),
          child: CustomScrollView(
            controller: widget.controller,
            slivers: <Widget>[
              AnimatedBuilder(
                animation: _dynamicTabHideAnimation,
                builder: (context, childWidget) {
                  final aValue = _dynamicTabHideAnimation.value;
                  final baseHeight =
                      56.0 + (widget.subtitle?.preferredSize.height ?? 0);
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
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: _onTapScrollHeader,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
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
                          Transform.translate(
                            offset: const Offset(-4, -8),
                            child: CustomInkWell(
                              onTap: _closeSheet,
                              padding: const EdgeInsets.all(8),
                              borderRadius: BorderRadius.circular(32),
                              splashFactory: NoSplash.splashFactory,
                              child: const Icon(
                                YTIcons.close_outlined,
                                size: 20,
                              ),
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
    widget.controller.addListener(_listener);
  }

  void _listener() {
    if (widget.controller.isOpened) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
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

    widget.controller.addListener(_listener);
  }

  void _listener() {
    if (widget.controller.isOpened) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    super.dispose();
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
              const SizedBox(width: 12),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  maxHeight: 56,
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

class DraggableSheet extends StatefulWidget {
  const DraggableSheet({
    super.key,
    required this.controller,
    required this.properties,
    required this.builder,
  });

  final DraggableProperties properties;
  final PageDraggableBuilder builder;
  final PageDraggableController controller;

  @override
  State<DraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller._dragController.animateTo(
        widget.properties.initialHeight,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInCubic,
      );
    });
    widget.controller.addListener(_listener);
  }

  void _listener() {}

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  bool _handleNotification(DragSheetNotification notification) {
    if (notification is DragSheetCloseNotification) {
      widget.controller.close();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NotificationListener<DragSheetNotification>(
        onNotification: _handleNotification,
        child: Builder(
          builder: (BuildContext context) {
            if (context.orientation.isLandscape) {
              return LayoutBuilder(
                builder: (
                  BuildContext context,
                  BoxConstraints constraints,
                ) {
                  return Listener(
                    onPointerMove: (PointerMoveEvent event) {
                      widget.controller.widthRatio =
                          widget.controller.widthRatio +
                              (-event.delta.dx / constraints.maxWidth * .4);
                    },
                    onPointerUp: (PointerUpEvent event) async {
                      if (widget.controller.widthRatio >= 0.5) {
                        // TODO(): Close the sheet
                      } else {
                        // TODO(): Open the sheet
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth * .4,
                        ),
                        child: NotifierSelector(
                          notifier: widget.controller,
                          selector: (state) => state.widthRatio,
                          builder: (
                            BuildContext context,
                            double width,
                            Widget? childWidget,
                          ) {
                            return SizeTransition(
                              axis: Axis.horizontal,
                              axisAlignment: -1,
                              sizeFactor: AlwaysStoppedAnimation(width),
                              child: childWidget,
                            );
                          },
                          child: widget.builder(context, null, null),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return DraggableScrollableSheet(
              snap: true,
              minChildSize: 0,
              snapSizes: widget.properties.snapSizes,
              controller: widget.controller._dragController,
              shouldCloseOnMinExtent: false,
              initialChildSize: widget.properties.initialHeight,
              snapAnimationDuration: Durations.medium4,
              builder: (
                BuildContext context,
                ScrollController controller,
              ) {
                return Material(
                  child: NotifierSelector(
                    notifier: widget.controller,
                    selector: (state) => state.opacity,
                    builder: (
                      BuildContext context,
                      double opacity,
                      Widget? childWidget,
                    ) {
                      return FadeTransition(
                        opacity: AlwaysStoppedAnimation(opacity),
                        child: childWidget,
                      );
                    },
                    child: widget.builder(
                      context,
                      controller,
                      widget.controller._dragController,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class PageSizeNotifier extends ValueNotifier<double> {
  PageSizeNotifier({double? value}) : super(value ?? 0);
}

mixin PageDraggableSizeListenerMixin<T extends StatefulWidget> on State<T> {
  PageSizeNotifier? _pageSizeNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Assuming PageSizeNotifier is provided higher in the widget tree
    final notifier = context.provide<PageSizeNotifier>();
    if (notifier != _pageSizeNotifier) {
      _pageSizeNotifier?.removeListener(_onPageSizeChange);
      _pageSizeNotifier = notifier;
      _pageSizeNotifier?.addListener(_onPageSizeChange);
    }
  }

  @override
  void dispose() {
    _pageSizeNotifier?.removeListener(_onPageSizeChange);
    super.dispose();
  }

  void _onPageSizeChange() {
    didChangePageDraggableSize(_pageSizeNotifier?.value ?? 0.0);
  }

  /// Called when the top most and last page draggable size changes
  void didChangePageDraggableSize(double size);
}

class StackedPageDraggable extends StatefulWidget {
  const StackedPageDraggable({
    super.key,
    required this.child,
    this.properties,
  });
  final Widget child;
  final DraggableProperties? properties;

  static _StackedPageDraggableState? _maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<_StackedPageDraggableState>();
  }

  static _StackedPageDraggableState _of(BuildContext context) {
    return _maybeOf(context)!;
  }

  static void open(
    BuildContext context, {
    required Object key,
    required PageDraggableBuilder builder,
    Object? below,
    int groupSize = 1,
    Object? childKey,
  }) {
    _of(context).openBottomSheet(
      key,
      context,
      builder,
      below: below,
      groupSize: groupSize,
      childKey: childKey,
    );
  }

  @override
  State<StackedPageDraggable> createState() => _StackedPageDraggableState();
}

class _StackedPageDraggableState extends State<StackedPageDraggable> {
  final PageSizeNotifier _pageSizeNotifier = PageSizeNotifier();
  final _History _history = _History();
  final List<SlotKey> _slotKeys = [];

  SlotKey? get secondLastEntryKey {
    if (_slotKeys.length > 1) {
      return _slotKeys[_slotKeys.length - 2];
    }
    return null;
  }

  final Map<SlotKey, PageDraggableController> _pageDraggableControllers = {};
  final GlobalKey<OverlayState> _overlayKey = GlobalKey<OverlayState>();
  OverlayState get _overlayState => _overlayKey.currentState!;

  @override
  void dispose() {
    _history.dispose();
    _pageDraggableControllers.forEach((key, value) {
      value.removeListener(() => _onSheetChange(key));
    });
    _pageSizeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      key: _overlayKey,
      clipBehavior: Clip.none,
      initialEntries: [
        OverlayEntry(
          canSizeOverlay: true,
          builder: (BuildContext context) => ModelBinding(
            model: _pageSizeNotifier,
            child: widget.child,
          ),
        ),
      ],
    );
  }

  void jumpTo(double size) {
    _pageDraggableControllers.forEach((key, value) {
      if (_slotKeys.contains(key)) {
        value.size = size;
        value.opacity = value.widthRatio.invertByOne;
      }
    });
  }

  void _onSheetChange(SlotKey sheetKey) {
    _pageDraggableControllers.forEach((key, value) {
      if (sheetKey != key &&
          sheetKey != secondLastEntryKey &&
          _pageDraggableControllers.containsKey(sheetKey)) {
        if (secondLastEntryKey != null) {
          _pageDraggableControllers[secondLastEntryKey]?.opacity =
              _pageDraggableControllers[sheetKey]!.widthRatio.invertByOne;
        }
      }

      if (_slotKeys.length == 1 && sheetKey == key) {
        _pageSizeNotifier.value = value.size;
      }

      if (sheetKey == key) {
        if (value.widthRatio <= 0) {
          _slotKeys.remove(key);
        } else if (!_slotKeys.contains(key)) {
          _slotKeys.add(key);
        }
      }
    });
  }

  void openBottomSheet(
    Object key,
    BuildContext context,
    PageDraggableBuilder builder, {
    Object? below,
    int groupSize = 1,
    Object? childKey,
  }) {
    assert(_overlayKey.currentState != null, 'Overlay State cannot be null');
    final properties = widget.properties ?? DraggableProperties();

    final isGroup = childKey != null && groupSize > 1;
    final slotKey = SlotKey(key);
    final itemKey = isGroup ? SlotKey(childKey) : null;

    _slotKeys
      ..remove(itemKey ?? slotKey)
      ..add(itemKey ?? slotKey);

    _pageDraggableControllers[itemKey ?? slotKey]?.open();

    _history.addOrReplaceEntry(slotKey, itemKey, groupSize, () {
      _pageDraggableControllers.remove(itemKey ?? slotKey)
        ?..removeListener(() => _onSheetChange(itemKey ?? slotKey))
        ..dispose();

      final controller = PageDraggableController(
        initialHeight: properties.initialHeight,
      );
      controller.addListener(() => _onSheetChange(slotKey));
      _pageDraggableControllers[itemKey ?? slotKey] = controller;

      final newEntry = OverlayEntry(
        maintainState: true,
        // canSizeOverlay: true,
        builder: (BuildContext context) {
          return DraggableSheet(
            key: GlobalObjectKey(itemKey ?? slotKey),
            builder: builder,
            controller: controller,
            properties: properties,
          );
        },
      );
      final belowEntry = key != below && below != null
          ? _history.retrieveSlotEntry(SlotKey(below))
          : null;
      _overlayState.insert(
        newEntry,
        below: belowEntry is SingleSlotEntry ? belowEntry.entry : null,
      );
      return newEntry;
    });
  }

  bool pop() {
    bool didPop = true;
    if (_slotKeys.isNotEmpty) {
      didPop = false;
      _pageDraggableControllers[_slotKeys.last]?.close();
    }
    return didPop;
  }
}

extension StackPagePop on BuildContext {
  bool stackPagePop() {
    return StackedPageDraggable._of(this).pop();
  }
}
