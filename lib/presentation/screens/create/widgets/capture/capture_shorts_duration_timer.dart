import 'package:flutter/material.dart';

class CaptureShortsDurationTimer extends StatefulWidget {
  const CaptureShortsDurationTimer({
    super.key,
  });

  @override
  State<CaptureShortsDurationTimer> createState() =>
      _CaptureShortsDurationTimerState();
}

class _CaptureShortsDurationTimerState
    extends State<CaptureShortsDurationTimer> {
  int time = 15;
  static const int minTime = 15;
  static const int maxTime = 60;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        time == minTime ? time = maxTime : time = minTime;
      }),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${time}s',
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          CircularProgressIndicator(
            color: Colors.white,
            value: time / maxTime,
            strokeWidth: 2,
          ),
        ],
      ),
    );
  }
}
