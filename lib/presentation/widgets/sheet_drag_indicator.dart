import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

class SheetDragIndicator extends StatelessWidget {
  const SheetDragIndicator({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 4,
        width: 44,
        decoration: BoxDecoration(
          color: context.theme.highlightColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
