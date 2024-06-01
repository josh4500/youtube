import 'package:flutter/material.dart';

typedef LayoutWidgetBuilder = Widget Function(
  BuildContext context,
  bool isBigScreen,
  bool isMediumScreen,
  bool isSmallScreen,
);

class ScreenSizeWidgetBuilder extends StatelessWidget {
  const ScreenSizeWidgetBuilder({super.key, required this.builder});
  final LayoutWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return builder(
          context,
          constraints.maxWidth > 800,
          constraints.maxWidth > 500 && constraints.maxWidth <= 800,
          constraints.maxWidth > 300 && constraints.maxWidth <= 500,
        );
      },
    );
  }
}
