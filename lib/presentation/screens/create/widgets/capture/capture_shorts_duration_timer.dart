import 'package:flutter/material.dart';

import '../notifications/capture_notification.dart';

class CaptureShortsDurationTimer extends StatefulWidget {
  const CaptureShortsDurationTimer({
    super.key,
  });

  @override
  State<CaptureShortsDurationTimer> createState() =>
      _CaptureShortsDurationTimerState();
}

class _CaptureShortsDurationTimerState extends State<CaptureShortsDurationTimer>
    with SingleTickerProviderStateMixin {
  int time = 15;
  static const int minTime = 15;
  static const int maxTime = 60;
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(
      begin: minTime / maxTime,
      end: 1,
    ).animate(controller);
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

        ShowControlsMessageNotification(
          message: '$time seconds',
        ).dispatch(context);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.black38,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${time}s',
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? _) {
              return CircularProgressIndicator(
                color: Colors.white,
                value: animation.value,
                strokeWidth: 2,
              );
            },
          ),
        ],
      ),
    );
  }
}
