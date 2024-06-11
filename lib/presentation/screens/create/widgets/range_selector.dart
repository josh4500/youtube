import 'package:flutter/material.dart';

class RangeSelector extends StatefulWidget {
  const RangeSelector({super.key});

  @override
  State<RangeSelector> createState() => _RangeSelectorState();
}

class _RangeSelectorState extends State<RangeSelector>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  final notifier = ValueNotifier<Alignment>(Alignment.center);
  final selected = ValueNotifier<int>(2);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    notifier.dispose();
    selected.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> _tweenAnimateNotifier(Alignment value) async {
    final Animation<Alignment> tween = AlignmentTween(
      begin: notifier.value,
      end: value,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInCubic,
      ),
    );
    tween.addListener(() => notifier.value = tween.value);

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
              final selectedValue = (value * 5).floor();
              await _tweenAnimateNotifier(
                Alignment.lerp(
                  Alignment.centerLeft,
                  Alignment.centerRight,
                  (selectedValue / 4).clamp(0, 1),
                )!,
              );
              selected.value = selectedValue;
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
                      listenable: notifier,
                      builder: (BuildContext context, Widget? childWidget) {
                        return Align(
                          alignment: notifier.value,
                          child: childWidget,
                        );
                      },
                      child: Container(
                        width: constraints.maxWidth / 6,
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
                    children: List.generate(5, (index) {
                      return ValueListenableBuilder<int>(
                        valueListenable: selected,
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
                            child: Text(
                              '${index + 1}X',
                              style: TextStyle(
                                color: index == selectedIndex
                                    ? Colors.black
                                    : null,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
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
