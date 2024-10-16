import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

typedef PageDraggableBuilder = Widget Function(
  BuildContext context,
  ScrollController? scrollController,
);

class VideoDraggableSheet extends StatelessWidget {
  const VideoDraggableSheet({
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
  final PageDraggableBuilder builder;

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
          child: Builder(
            builder: (context) {
              if (context.orientation.isLandscape) {
                return builder(context, null);
              }
              return DraggableScrollableSheet(
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
                  return Material(
                    child: FadeTransition(
                      opacity: ReverseAnimation(opacity),
                      child: builder(context, controller),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
