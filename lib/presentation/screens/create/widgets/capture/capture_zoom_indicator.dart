import 'package:flutter/material.dart';

class CaptureZoomIndicator extends StatelessWidget {
  const CaptureZoomIndicator({super.key, required this.controller});
  final ValueNotifier<double> controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (
        BuildContext context,
        double value,
        Widget? _,
      ) {
        return CustomPaint(
          size: Size(24, MediaQuery.sizeOf(context).height * .45),
          painter: ZoomPainter(value: value),
        );
      },
    );
  }
}

class ZoomPainter extends CustomPainter {
  ZoomPainter({super.repaint, required this.value});

  final double value;
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..strokeWidth = 2
      ..color = Colors.white;
    canvas.drawLine(
      Offset((size.width / 2) - 2, size.height),
      Offset((size.width / 2) - 2, size.height * (1 - value)),
      linePaint,
    );

    final line2Paint = Paint()
      ..strokeWidth = 1
      ..color = Colors.white70;
    canvas.drawLine(
      Offset((size.width / 2) - 2, size.height * (1 - value)),
      Offset((size.width / 2) - 2, 0),
      line2Paint,
    );

    final thumbPaint = Paint()
      ..strokeWidth = 2
      ..color = Colors.white;
    canvas.drawCircle(
      Offset(size.width / 2 - 2, size.height * (1 - value)),
      8,
      thumbPaint,
    );
  }

  @override
  bool shouldRepaint(ZoomPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
