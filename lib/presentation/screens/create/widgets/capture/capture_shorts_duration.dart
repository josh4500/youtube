import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/screens/create/provider/short_recording_state.dart';

import '../notifications/capture_notification.dart';

class CaptureShortsDuration extends ConsumerStatefulWidget {
  const CaptureShortsDuration({super.key});

  @override
  ConsumerState<CaptureShortsDuration> createState() =>
      _CaptureShortsDurationTimerState();
}

class _CaptureShortsDurationTimerState
    extends ConsumerState<CaptureShortsDuration>
    with SingleTickerProviderStateMixin {
  int time = 15;
  static const int minTime = 15;
  static const int maxTime = 60;
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );

  late final animation = Tween<double>(
    begin: minTime / maxTime,
    end: 1,
  ).animate(controller);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (time == minTime) {
          time = maxTime;
          setState(() {});
          controller.forward();
        } else {
          time = minTime;
          setState(() {});
          controller.reverse();
        }

        ref.read(shortRecordingProvider.notifier).updateDuration(
              Duration(seconds: time),
            );

        ShowControlsMessageNotification(
          message: '$time seconds',
        ).dispatch(context);
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.black38,
              shape: BoxShape.circle,
            ),
            child: Text('${time}s', style: const TextStyle(fontSize: 14)),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? _) {
                return CustomPaint(
                  size: const Size(32, 32), // Size of the canvas
                  painter: CircleProgressPainter(
                    progress: animation.value,
                    strokeWidth: 1.8,
                  ), // Set progress here
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  CircleProgressPainter({
    required this.progress,
    this.color = Colors.white,
    this.backgroundColor = Colors.transparent,
    this.strokeWidth = 2,
  });
  final double strokeWidth;
  // Value between 0 and 1
  final double progress;

  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint basePaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double radius = min(size.width / 2, size.height / 2);
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw the base circle
    canvas.drawCircle(center, radius, basePaint);

    // Calculate the sweep angle based on the progress
    final double sweepAngle = 2 * pi * progress;

    // Draw the progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start at the top
      sweepAngle, // Sweep clockwise
      false, // Not a filled arc
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
