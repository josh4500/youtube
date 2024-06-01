import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class VideoEffectOptions extends StatefulWidget {
  const VideoEffectOptions({
    super.key,
    this.controller,
    this.items = const <EffectItem>[],
    this.onExpand,
  });

  final VideoEffectOptionsController? controller;
  final List<EffectItem> items;
  final ValueChanged<bool>? onExpand;

  @override
  State<VideoEffectOptions> createState() => _VideoEffectOptionsState();
}

class _VideoEffectOptionsState extends State<VideoEffectOptions>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;
  final ValueNotifier<bool> _showLabelNotifier = ValueNotifier<bool>(true);
  Timer? initialShowTimer;

  static const int maxInitialShown = 4;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInCubic);
    controller.addListener(() {
      _showLabelNotifier.value = controller.value == 1;
    });

    widget.controller?.addListener(expandOrClose);

    initialShowTimer = Timer(const Duration(seconds: 3), () {
      _showLabelNotifier.value = false;
    });
  }

  @override
  void dispose() {
    initialShowTimer?.cancel();
    _showLabelNotifier.dispose();
    controller.dispose();
    super.dispose();
  }

  void expandOrClose() {
    initialShowTimer?.cancel();
    if (widget.items.length > maxInitialShown) {
      widget.onExpand?.call(controller.isCompleted);
      if (controller.isCompleted) {
        controller.reverse();
      } else {
        controller.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const EdgeInsets itemVerticalMargin = EdgeInsets.symmetric(vertical: 10);
    const EdgeInsets labelVerticalMargin = EdgeInsets.symmetric(vertical: 10);
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
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (int i = 0; i < maxInitialShown; i++)
                              GestureDetector(
                                onTap: widget.items[i].onTap,
                                child: Container(
                                  margin: labelVerticalMargin,
                                  child: Text(
                                    widget.items[i].label,
                                    style: labelTextStyle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (widget.items.length > maxInitialShown) ...[
                          SizeTransition(
                            sizeFactor: animation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                for (int i = maxInitialShown;
                                    i < widget.items.length;
                                    i++)
                                  GestureDetector(
                                    onTap: widget.items[i].onTap,
                                    child: Container(
                                      margin: labelVerticalMargin,
                                      child: Text(
                                        widget.items[i].label,
                                        style: labelTextStyle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: expandOrClose,
                            child: SizedBox(
                              height: 40,
                              child: Center(
                                child: Text(
                                  visible && controller.value == 0
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      for (int i = 0; i < maxInitialShown; i++)
                        EffectWidget(
                          margin: itemVerticalMargin,
                          item: widget.items[i],
                        ),
                    ],
                  ),
                  if (widget.items.length > maxInitialShown) ...[
                    SizeTransition(
                      sizeFactor: animation,
                      child: Column(
                        children: [
                          for (int i = maxInitialShown;
                              i < widget.items.length;
                              i++)
                            EffectWidget(
                              margin: itemVerticalMargin,
                              item: widget.items[i],
                            ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: expandOrClose,
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: -.5).animate(controller),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          margin: itemVerticalMargin,
                          decoration: const BoxDecoration(
                            color: Colors.white30,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(YTIcons.chevron_down, size: 16),
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
  });

  final EdgeInsets margin;
  final EffectItem item;

  @override
  State<EffectWidget> createState() => _EffectWidgetState();
}

class _EffectWidgetState extends State<EffectWidget> with MaterialStateMixin {
  bool active = false;
  void handleTap() {
    widget.item.onTap?.call();
    if (widget.item.onTap != null) {
      active = !active;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomActionChip(
      padding: EdgeInsets.zero,
      margin: widget.margin,
      onTap: handleTap,
      icon: Icon(
        active ? widget.item.activeIcon ?? widget.item.icon : widget.item.icon,
        size: 20,
      ),
    );
  }
}

class EffectItem {
  const EffectItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final VoidCallback? onTap;
}

// TODO(josh4500): Refactor usage or Implement a mediator
class VideoEffectOptionsController extends ChangeNotifier {
  void close() {
    notifyListeners();
  }
}
