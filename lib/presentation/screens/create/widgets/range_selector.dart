import 'package:flutter/material.dart';
import 'package:youtube_clone/core/utils/normalization.dart';

class RangeSelector extends StatefulWidget {
  const RangeSelector({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.initialIndex,
    this.onChanged,
    this.backgroundColor,
    this.selectedColor,
    this.indicatorHeight = 36,
  });
  final int? initialIndex;
  final Widget Function(BuildContext context, int selectedIndex, int index)
      itemBuilder;
  final int itemCount;
  final double indicatorHeight;
  final ValueChanged<int>? onChanged;
  final Color? backgroundColor;
  final Color? selectedColor;

  @override
  State<RangeSelector> createState() => _RangeSelectorState();
}

class _RangeSelectorState<T> extends State<RangeSelector>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final alignmentNotifier = ValueNotifier<Alignment>(
    Alignment(
      ((widget.initialIndex ?? widget.itemCount ~/ 2) / (itemCount - 1))
          .normalizeRange(-1, 1),
      0,
    ),
  );
  late final indexNotifier = ValueNotifier<int>(
    widget.initialIndex ?? widget.itemCount ~/ 2,
  );

  int get itemCount => widget.itemCount;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void didUpdateWidget(RangeSelector oldWidget) {
    if (oldWidget.initialIndex != widget.initialIndex) {
      indexNotifier.value = widget.initialIndex ?? widget.itemCount ~/ 2;
    }
    super.didUpdateWidget(oldWidget);
  }

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
        curve: Curves.linearToEaseOut,
      ),
    );
    tween.addListener(() => alignmentNotifier.value = tween.value);

    // Reset the animation controller to its initial state
    controller.reset();

    // Start the animation by moving it forward
    await controller.forward();
  }

  int _getIndexFromPosition(double position, double width) {
    return (position.clamp(0, width) / (width / itemCount))
        .floor()
        .clamp(0, itemCount - 1);
  }

  Future<void> _updateAlignment(double position, double width) async {
    final value = _getIndexFromPosition(position, width);

    _updateSelected(value);
    await _tweenAnimateNotifier(
      Alignment((value / (itemCount - 1)).normalizeRange(-1, 1), 0),
    );
  }

  void _updateSelected(int selectedValue) {
    selectedValue = selectedValue.clamp(0, itemCount - 1);
    indexNotifier.value = selectedValue;
    widget.onChanged?.call(selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          onTapDown: (details) async {
            _updateAlignment(details.localPosition.dx, constraints.maxWidth);
          },
          onHorizontalDragUpdate: (details) async {
            final value = details.localPosition.dx / constraints.maxWidth;
            alignmentNotifier.value = Alignment(
              value.clamp(0, 1).toDouble().normalizeRange(-1, 1),
              0,
            );
            final selectedValue = (value * itemCount).floor();
            _updateSelected(selectedValue);
          },
          onHorizontalDragEnd: (DragEndDetails details) async {
            _updateAlignment(details.localPosition.dx, constraints.maxWidth);
          },
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                ListenableBuilder(
                  listenable: alignmentNotifier,
                  builder: (BuildContext context, Widget? childWidget) {
                    return Align(
                      alignment: alignmentNotifier.value,
                      child: childWidget,
                    );
                  },
                  child: Container(
                    height: widget.indicatorHeight,
                    width: (constraints.maxWidth / itemCount) - 8,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: widget.selectedColor ?? Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Row(
                  children: List.generate(itemCount, (index) {
                    return Container(
                      height: widget.indicatorHeight,
                      width: (constraints.maxWidth / itemCount) - 8,
                      margin: const EdgeInsets.all(4),
                      alignment: Alignment.center,
                      child: ValueListenableBuilder<int>(
                        valueListenable: indexNotifier,
                        builder: (
                          BuildContext context,
                          int selectedIndex,
                          Widget? _,
                        ) {
                          return widget.itemBuilder(
                            context,
                            selectedIndex,
                            index,
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
