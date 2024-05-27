import 'package:flutter/material.dart';

class PlayerDraggableSheet extends StatelessWidget {
  const PlayerDraggableSheet({
    super.key,
    required this.controller,
    required this.opacity,
    required this.visibleListenable,
    required this.snapSizes,
    required this.builder,
  });

  final DraggableScrollableController controller;
  final Animation<double> opacity;
  final ValueNotifier<bool> visibleListenable;
  final List<double> snapSizes;
  final Widget Function(
    BuildContext context,
    ScrollController scrollController,
  ) builder;

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
          child: DraggableScrollableSheet(
            snap: true,
            minChildSize: 0,
            initialChildSize: 0,
            snapSizes: snapSizes,
            shouldCloseOnMinExtent: false,
            controller: controller,
            snapAnimationDuration: const Duration(milliseconds: 300),
            builder: (
              BuildContext context,
              ScrollController controller,
            ) {
              return FadeTransition(
                opacity: opacity,
                child: builder(context, controller),
              );
            },
          ),
        );
      },
    );
  }
}
