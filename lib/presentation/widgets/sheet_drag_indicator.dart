import 'package:flutter/material.dart';

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
          color: Colors.white24,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
