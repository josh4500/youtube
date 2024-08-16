import 'package:flutter/material.dart';

class RangeSelector extends StatefulWidget {
  const RangeSelector({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.initialIndex,
    this.onChanged,
  });
  final int? initialIndex;
  final Widget Function(BuildContext context, int selectedIndex, int index)
      itemBuilder;
  final int itemCount;
  final ValueChanged<int>? onChanged;

  @override
  State<RangeSelector> createState() => _RangeSelectorState();
}

class _RangeSelectorState<T> extends State<RangeSelector>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  final alignmentNotifier = ValueNotifier<Alignment>(Alignment.center);
  late final indexNotifier = ValueNotifier<int>(
    widget.initialIndex ?? widget.itemCount ~/ 2,
  );

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  int get itemCount => widget.itemCount;
  @override
  void dispose() {
    alignmentNotifier.dispose();
    indexNotifier.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> _tweenAnimateNotifier(Alignment value) async {
    final Animation<Alignment> tween = AlignmentTween(
      begin: alignmentNotifier.value,
      end: value,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInCubic,
      ),
    );
    tween.addListener(() => alignmentNotifier.value = tween.value);

    // Reset the animation controller to its initial state
    controller.reset();

    // Start the animation by moving it forward
    await controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return GestureDetector(
            onTapDown: (details) async {
              final value = details.localPosition.dx / constraints.maxWidth;
              final selectedValue = (value * itemCount).floor();
              await _tweenAnimateNotifier(
                Alignment.lerp(
                  Alignment.centerLeft,
                  Alignment.centerRight,
                  (selectedValue / (itemCount - 1)).clamp(0, 1),
                )!,
              );
              indexNotifier.value = selectedValue;
              widget.onChanged?.call(selectedValue);
            },
            onHorizontalDragUpdate: (details) async {
              // TODO(josh4500): Cancel duplicate future and enable code
              // final value = details.localPosition.dx / constraints.maxWidth;
              // final selectedValue = (value * 5).floor();
              // if (selected.value != selectedValue) {
              //   await _tweenAnimateNotifier(
              //     Alignment.lerp(
              //       Alignment.centerLeft,
              //       Alignment.centerRight,
              //       (selectedValue / 4).clamp(0, 1),
              //     )!,
              //   );
              //   selected.value = selectedValue;
              // }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ListenableBuilder(
                      listenable: alignmentNotifier,
                      builder: (BuildContext context, Widget? childWidget) {
                        return Align(
                          alignment: alignmentNotifier.value,
                          child: childWidget,
                        );
                      },
                      child: Container(
                        width: constraints.maxWidth / (itemCount + 1),
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(itemCount, (index) {
                      return ValueListenableBuilder<int>(
                        valueListenable: indexNotifier,
                        builder: (
                          BuildContext context,
                          int selectedIndex,
                          Widget? _,
                        ) {
                          return Container(
                            width: constraints.maxWidth / 6,
                            height: 36,
                            margin: const EdgeInsets.all(2),
                            alignment: Alignment.center,
                            child: widget.itemBuilder(
                              context,
                              selectedIndex,
                              index,
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
