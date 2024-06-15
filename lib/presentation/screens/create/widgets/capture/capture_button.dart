import 'package:flutter/material.dart';

const double kRecordButtonStrokeWidth = 4;
const double kRecordOuterButtonSize = 66.0;
const double kRecordInnerButtonSize = 55.5;

class CaptureDragZoomButton extends StatelessWidget {
  const CaptureDragZoomButton({
    super.key,
    required this.animation,
    required this.isRecording,
    required this.isDragging,
  });
  final AnimationController animation;
  final bool isRecording;
  final bool isDragging;

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
          size: const Size.square(kRecordOuterButtonSize),
          foregroundPainter: CircledButton(
            sizeFactor: sizeAnimation.value,
            scale: isDragging ? 1.35 : 1.15,
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
    required this.scale,
  });

  final double sizeFactor;
  final Color color;
  final double scale;
  @override
  void paint(Canvas canvas, Size size) {
    final scaleSize = (size.width * scale) - size.width;
    final Paint paint1 = Paint()
      ..color = Colors.black26
      ..strokeWidth = 0
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      (size.width / 2) + (scaleSize * sizeFactor),
      paint1,
    );

    final paint2 = Paint()
      ..strokeWidth = kRecordButtonStrokeWidth
      ..style = PaintingStyle.stroke
      ..color = color;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      (size.width / 2) + (scaleSize * sizeFactor),
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
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.all(isRecording ? 12 : 0),
      width: isRecording ? kRecordInnerButtonSize - 24 : kRecordInnerButtonSize,
      height:
          isRecording ? kRecordInnerButtonSize - 24 : kRecordInnerButtonSize,
      decoration: BoxDecoration(
        color: const Color(0xFFFF0000),
        borderRadius: BorderRadius.circular(
          isRecording ? 4 : kRecordInnerButtonSize,
        ),
      ),
    );
  }
}
