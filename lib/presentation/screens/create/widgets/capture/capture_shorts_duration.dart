import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../provider/short_recording_state.dart';
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
  static const int minTime = 15;
  static const int maxTime = 60;
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );

  late final Animation<double> animation = Tween<double>(
    begin: minTime / maxTime,
    end: 1,
  ).animate(controller);

  final _overlayController = OverlayPortalController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      final recordDuration = ref.read(shortRecordingProvider).recordDuration;
      if (recordDuration.inSeconds > minTime) {
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen(
    //   shortRecordingProvider.select(
    //     (state) => state.recordDuration.inSeconds,
    //   ),
    //   (current, next) {
    //     if (current != next) {
    //       next > minTime ? controller.forward() : controller.reverse();
    //     }
    //   },
    // );
    final shortsRecordDuration = ref.watch(
      shortRecordingProvider.select((state) => state.recordDuration.inSeconds),
    );
    final animation = Tween<double>(
      begin: minTime / maxTime,
      end: 1,
    ).animate(controller);
    return GestureDetector(
      onTap: () {
        bool updateValue = true;
        int time = 0;
        if (shortsRecordDuration == minTime) {
          time = maxTime;
          controller.forward();
        } else {
          final shortsRecording = ref.read(shortRecordingProvider);
          if (shortsRecording.duration.inSeconds > minTime) {
            updateValue = false;
            _overlayController.show();
            // TODO(josh4500): This should be controllable outside of this widget
            Timer(const Duration(seconds: 5), _overlayController.hide);
          } else {
            time = minTime;
            controller.reverse();
          }
        }

        if (updateValue) {
          ref.read(shortRecordingProvider.notifier).updateRecordDuration(
                Duration(seconds: time),
              );

          ShowControlsMessageNotification(
            message: '$time seconds',
          ).dispatch(context);
        }
      },
      child: CallOut(
        text: 'Record up to 60s',
        useChildAsTarget: false,
        controller: _overlayController,
        child: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? childWidget) {
            return CustomPaint(
              foregroundPainter: CircleProgressPainter(
                progress: animation.value,
                strokeWidth: 1.8,
              ),
              child: childWidget, // Set progress here
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.black38,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${shortsRecordDuration}s',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
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
