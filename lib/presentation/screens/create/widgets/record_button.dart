import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

const double kRecordButtonStrokeWidth = 4;
const double kRecordOuterButtonSize = 66.0;
const double kRecordInnerButtonSize = 55.5;

class RecordDragButton extends StatelessWidget {
  const RecordDragButton({
    super.key,
    required this.animation,
    required this.isRecording,
    this.isDragging = false,
    this.enabled = true,
  });
  final Animation animation;
  final bool isRecording;
  final bool isDragging;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? _) {
        return CustomPaint(
          size: const Size.square(kRecordOuterButtonSize),
          foregroundPainter: CircledButton(
            sizeFactor: animation.value,
            scale: isDragging ? 1.35 : 1.15,
            color: (isRecording ? const Color(0xFFFF0000) : Colors.white)
                .withValues(alpha: enabled ? 1 : .5),
          ),
        );
      },
    );
  }
}

class CaptureCountdownButton extends StatelessWidget {
  const CaptureCountdownButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 4, color: Colors.white),
      ),
      child: Container(
        width: kRecordOuterButtonSize - 8,
        height: kRecordOuterButtonSize - 8,
        margin: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black87,
        ),
        child: const Icon(YTIcons.cancel_outlined),
      ),
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

class RecordButton extends StatelessWidget {
  const RecordButton({
    super.key,
    this.isRecording = false,
    this.enabled = true,
  });
  final bool enabled;
  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.all(isRecording ? 12 : 0),
      width: isRecording ? kRecordInnerButtonSize / 2 : kRecordInnerButtonSize,
      height: isRecording ? kRecordInnerButtonSize / 2 : kRecordInnerButtonSize,
      decoration: BoxDecoration(
        color: enabled ? const Color(0xFFFF0000) : const Color(0x55FF0000),
        borderRadius: BorderRadius.circular(
          isRecording ? 4 : kRecordInnerButtonSize,
        ),
      ),
    );
  }
}
