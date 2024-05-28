import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class EffectOptions extends StatefulWidget {
  const EffectOptions({super.key, this.items = const <EffectItem>[]});

  final List<EffectItem> items;

  @override
  State<EffectOptions> createState() => _EffectOptionsState();
}

class _EffectOptionsState extends State<EffectOptions>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;
  final ValueNotifier<bool> _showLabelNotifier = ValueNotifier<bool>(true);

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
  }

  @override
  void dispose() {
    _showLabelNotifier.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const EdgeInsets itemVerticalPadding = EdgeInsets.symmetric(vertical: 10);
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
                              Container(
                                margin: itemVerticalPadding,
                                child: Text(
                                  widget.items[i].label,
                                  style: labelTextStyle,
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
                                  Container(
                                    margin: itemVerticalPadding,
                                    child: Text(
                                      widget.items[i].label,
                                      style: labelTextStyle,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 24,
                            child: Center(
                              child: Text(
                                visible && controller.value == 0
                                    ? 'More'
                                    : 'Close',
                                style: labelTextStyle,
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
                        CustomActionChip(
                          padding: EdgeInsets.zero,
                          margin: itemVerticalPadding,
                          onTap: widget.items[i].onTap,
                          icon: Icon(widget.items[i].icon, size: 18),
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
                            CustomActionChip(
                              padding: EdgeInsets.zero,
                              margin: itemVerticalPadding,
                              onTap: widget.items[i].onTap,
                              icon: Icon(widget.items[i].icon, size: 18),
                            ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.isCompleted
                          ? controller.reverse()
                          : controller.forward(),
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: -.5).animate(controller),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          margin: itemVerticalPadding,
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

class EffectItem {
  const EffectItem({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
}
