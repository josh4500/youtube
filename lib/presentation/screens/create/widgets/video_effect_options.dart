import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class EffectOption {
  const EffectOption({
    required this.icon,
    this.activeIcon,
    required this.value,
    this.animation = EffectTapAnimation.switches,
    this.onTap,
  });

  final IconData icon;
  final IconData? activeIcon;
  final EffectTapAnimation animation;
  final Enum value;
  final VoidCallback? onTap;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EffectOption &&
          runtimeType == other.runtimeType &&
          icon == other.icon &&
          activeIcon == other.activeIcon &&
          value == other.value;

  @override
  int get hashCode => icon.hashCode ^ activeIcon.hashCode ^ value.hashCode;
}

enum EffectAction { add, remove }

enum EffectTapAnimation { rotate, switches }

typedef EffectStatusListener = void Function(
  EffectAction action,
  EffectOption effect,
);

class EffectController extends ChangeNotifier {
  final Set<EffectOption> _selectedItems = {};
  final List<EffectStatusListener> _statusListener = [];

  void addStatusListener(EffectStatusListener listener) =>
      _statusListener.add(listener);
  void removeStatusListener(EffectStatusListener listener) =>
      _statusListener.remove(listener);

  void toggle(EffectOption item) {
    final EffectAction action;
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
      action = EffectAction.remove;
    } else {
      _selectedItems.add(item);
      action = EffectAction.add;
    }

    for (final listener in _statusListener) {
      listener(action, item);
    }
  }

  bool _isOpened = false;
  bool get isOpened => _isOpened;

  void open() {
    final oldValue = _isOpened;
    _isOpened = true;
    if (oldValue != _isOpened) notifyListeners();
  }

  void close() {
    final oldValue = _isOpened;
    _isOpened = false;
    if (oldValue != _isOpened) notifyListeners();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EffectController &&
          runtimeType == other.runtimeType &&
          _selectedItems == other._selectedItems &&
          _statusListener == other._statusListener &&
          _isOpened == other._isOpened;

  @override
  int get hashCode =>
      _selectedItems.hashCode ^ _statusListener.hashCode ^ _isOpened.hashCode;
}

class VideoEffectOptions extends StatefulWidget {
  const VideoEffectOptions({
    super.key,
    this.controller,
    this.items = const <EffectOption>[],
    this.labelGetter,
    this.onOpenChanged,
    this.maxShowMore = 4,
  });

  final EffectController? controller;
  final List<EffectOption> items;
  final ValueChanged<bool>? onOpenChanged;
  final String Function(Enum enumValue)? labelGetter;
  final int maxShowMore;

  @override
  State<VideoEffectOptions> createState() => _VideoEffectOptionsState();
}

class _VideoEffectOptionsState extends State<VideoEffectOptions>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;
  final ValueNotifier<bool> _showLabelNotifier = ValueNotifier<bool>(true);
  Timer? initialShowTimer;
  int get maxShowMore => widget.maxShowMore;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(openOrCloseCallback);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInCubic,
    );

    initialShowTimer = Timer(const Duration(seconds: 3), () {
      _showLabelNotifier.value = false;
    });
  }

  @override
  void dispose() {
    _showLabelNotifier.dispose();
    initialShowTimer?.cancel();
    animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant VideoEffectOptions oldWidget) {
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(openOrCloseCallback);
      widget.controller?.addListener(openOrCloseCallback);
    }
    super.didUpdateWidget(oldWidget);
  }

  void openOrCloseCallback() {
    initialShowTimer?.cancel();
    if (widget.items.length > maxShowMore) {
      final isExpanded = widget.controller!.isOpened;
      _showLabelNotifier.value = isExpanded;

      widget.onOpenChanged?.call(isExpanded);
      if (isExpanded) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    }
  }

  void effectiveOpenOrClose() {
    if (widget.controller == null) return;
    if (widget.controller!.isOpened) {
      widget.controller?.close();
    } else {
      widget.controller?.open();
    }
  }

  void effectiveSelectItem(EffectOption item) {
    item.onTap?.call();
    widget.controller?.toggle(item);
  }

  @override
  Widget build(BuildContext context) {
    const EdgeInsets itemVerticalMargin = EdgeInsets.symmetric(vertical: 6);
    const EdgeInsets labelVerticalMargin = EdgeInsets.symmetric(vertical: 13);
    const TextStyle labelTextStyle = TextStyle(
      fontSize: 15,
      shadows: [Shadow(offset: Offset(1, 1), color: Colors.black54)],
    );
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.items.isNotEmpty)
            ValueListenableBuilder(
              valueListenable: _showLabelNotifier,
              builder: (
                BuildContext context,
                bool visible,
                Widget? _,
              ) {
                return Visibility(
                  visible: visible,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (int i = 0;
                                i < maxShowMore && i < widget.items.length;
                                i++)
                              GestureDetector(
                                onTap: () => effectiveSelectItem(
                                  widget.items[i],
                                ),
                                child: Container(
                                  margin: labelVerticalMargin,
                                  child: Text(
                                    widget.labelGetter
                                            ?.call(widget.items[i].value) ??
                                        widget.items[i].value.name,
                                    style: labelTextStyle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (widget.items.length > maxShowMore) ...[
                          SizeTransition(
                            sizeFactor: animation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(
                                widget.items.length - maxShowMore,
                                (int index) {
                                  final item =
                                      widget.items[maxShowMore + index];
                                  return GestureDetector(
                                    onTap: () => effectiveSelectItem(item),
                                    child: Container(
                                      margin: labelVerticalMargin,
                                      child: Text(
                                        widget.labelGetter?.call(item.value) ??
                                            item.value.name,
                                        style: labelTextStyle,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: effectiveOpenOrClose,
                            child: SizedBox(
                              height: 40,
                              child: Center(
                                child: Text(
                                  visible && animationController.value == 0
                                      ? 'More'
                                      : 'Close',
                                  style: labelTextStyle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          if (widget.items.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      for (int i = 0; i < maxShowMore; i++)
                        EffectWidget(
                          item: widget.items[i],
                          margin: itemVerticalMargin,
                          controller: widget.controller,
                        ),
                    ],
                  ),
                  if (widget.items.length > maxShowMore) ...[
                    SizeTransition(
                      sizeFactor: animation,
                      child: Column(
                        children: [
                          for (int i = maxShowMore;
                              i < widget.items.length;
                              i++)
                            EffectWidget(
                              item: widget.items[i],
                              margin: itemVerticalMargin,
                              controller: widget.controller,
                            ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: effectiveOpenOrClose,
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: -.5)
                            .animate(animationController),
                        child: Container(
                          margin: itemVerticalMargin + const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white38,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(YTIcons.chevron_down, size: 24),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class EffectWidget extends StatefulWidget {
  const EffectWidget({
    super.key,
    required this.margin,
    required this.item,
    this.controller,
  });

  final EdgeInsets margin;
  final EffectOption item;
  final EffectController? controller;

  @override
  State<EffectWidget> createState() => _EffectWidgetState();
}

class _EffectWidgetState extends State<EffectWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  final ValueNotifier<bool> activeNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    widget.controller?.addStatusListener(changeStateCallback);
  }

  void handleTap() {
    widget.item.onTap?.call();
    widget.controller?.toggle(widget.item);
    widget.controller?.close();
  }

  void changeStateCallback(EffectAction action, EffectOption effect) {
    if (effect == widget.item) {
      if (widget.item.animation == EffectTapAnimation.rotate) {
        controller.reset();
        controller.forward();
      } else {
        activeNotifier.value = action == EffectAction.add;
      }
    }
  }

  @override
  void didUpdateWidget(covariant EffectWidget oldWidget) {
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeStatusListener(changeStateCallback);
      widget.controller?.addStatusListener(changeStateCallback);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO(josh4500): Throws error trying to dispose and this also affects the CameraController dispose (due to exception)
    // controller.dispose();
    activeNotifier.dispose();
    widget.controller?.removeStatusListener(changeStateCallback);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomActionChip(
      onTap: handleTap,
      margin: widget.margin,
      padding: const EdgeInsets.all(4),
      backgroundColor: Colors.transparent,
      icon: Builder(
        builder: (BuildContext context) {
          if (widget.item.animation == EffectTapAnimation.rotate) {
            final animation = CurvedAnimation(
              parent: controller,
              curve: Curves.easeInCirc,
            );
            return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? childWidget) {
                return Transform.rotate(
                  angle: -math.pi * animation.value,
                  child: childWidget,
                );
              },
              child: Icon(widget.item.icon, size: 24),
            );
          }

          return ValueListenableBuilder<bool>(
            valueListenable: activeNotifier,
            builder: (BuildContext context, bool active, Widget? _) {
              return Icon(
                active
                    ? widget.item.activeIcon ?? widget.item.icon
                    : widget.item.icon,
                size: 24,
              );
            },
          );
        },
      ),
    );
  }
}
