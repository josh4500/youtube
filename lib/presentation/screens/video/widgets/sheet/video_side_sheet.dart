import 'package:flutter/material.dart';

class PlayerSideSheet extends StatelessWidget {
  const PlayerSideSheet({
    super.key,
    required this.visibleListenable,
    required this.sizeFactor,
    required this.constraints,
    this.child,
  });
  final ValueNotifier<bool> visibleListenable;
  final Animation<double> sizeFactor;
  final BoxConstraints constraints;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: visibleListenable,
      builder: (
        BuildContext context,
        bool showSheet,
        Widget? childWidget,
      ) {
        return Visibility(
          visible: showSheet,
          child: Align(
            alignment: Alignment.topRight,
            child: SizeTransition(
              axis: Axis.horizontal,
              sizeFactor: sizeFactor,
              child: ConstrainedBox(
                constraints: constraints,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
