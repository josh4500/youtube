import 'package:flutter/material.dart';

const double kRecordCircleWidth = 3.5;
const double kRecordCircleSize = 66.0;
const double kRecordButtonSize = 56.0;

class CaptureDragZoomButton extends StatelessWidget {
  const CaptureDragZoomButton({
    super.key,
    required this.animation,
    required this.isRecording,
  });
  final AnimationController animation;
  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    final sizeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInCubic,
    );
    return AnimatedBuilder(
      animation: sizeAnimation,
      builder: (BuildContext context, Widget? _) {
        return CustomPaint(
          size: const Size.square(kRecordCircleSize),
          foregroundPainter: CircledButton(
            sizeFactor: sizeAnimation.value,
            color: isRecording ? const Color(0xFFFF0000) : Colors.white,
          ),
        );
      },
    );
  }
}

class CircledButton extends CustomPainter {
  const CircledButton({
    super.repaint,
    required this.sizeFactor,
    required this.color,
  });

  final double sizeFactor;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint1 = Paint()
      ..color = Colors.black12
      ..strokeWidth = 0
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      (size.width / 2) + (10 * sizeFactor),
      paint1,
    );

    final paint2 = Paint()
      ..strokeWidth = kRecordCircleWidth
      ..style = PaintingStyle.stroke
      ..color = color;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      (size.width / 2) + (10 * sizeFactor),
      paint2,
    );
  }

  @override
  bool shouldRepaint(CircledButton oldDelegate) {
    return oldDelegate.sizeFactor != sizeFactor || oldDelegate.color != color;
  }
}

class CaptureButton extends StatelessWidget {
  const CaptureButton({super.key, required this.isRecording});

  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: EdgeInsets.all(isRecording ? 12 : 0),
      width: isRecording ? kRecordButtonSize - 24 : kRecordButtonSize,
      height: isRecording ? kRecordButtonSize - 24 : kRecordButtonSize,
      decoration: BoxDecoration(
        color: const Color(0xFFFF0000),
        borderRadius: BorderRadius.circular(
          isRecording ? 4 : kRecordButtonSize,
        ),
      ),
    );
  }
}
