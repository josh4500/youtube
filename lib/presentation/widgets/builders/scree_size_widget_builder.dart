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
    final maxWidth = MediaQuery.sizeOf(context).shortestSide;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // final size = MediaQuery.sizeOf(context).shortestSide;
        return builder(
          context,
          maxWidth > 800,
          maxWidth > 500 && maxWidth <= 800,
          maxWidth > 300 && maxWidth <= 500,
        );
      },
    );
  }
}
