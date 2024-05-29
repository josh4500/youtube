import 'package:flutter/material.dart';

class CaptureDragZoomButton extends StatelessWidget {
  const CaptureDragZoomButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 42.5,
        horizontal: 12,
      ),
      child: CustomPaint(
        size: const Size(66, 66),
        foregroundPainter: CircledButton(),
      ),
    );
  }
}

class CircledButton extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..color = Colors.white;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
