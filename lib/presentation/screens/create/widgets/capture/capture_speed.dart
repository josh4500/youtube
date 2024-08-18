import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/current_timeline_state.dart';
import '../notifications/capture_notification.dart';
import '../range_selector.dart';

class CaptureSpeed extends ConsumerWidget {
  const CaptureSpeed({super.key});

  static const List<num> speeds = [0.3, 0.5, 1, 2, 3];
  static const List<String> speedMessage = [
    'Very slow',
    'Slow',
    'Normal',
    'Fast',
    'Very fast',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeline = ref.watch(currentTimelineProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: RangeSelector(
        initialIndex: speeds.indexWhere(
          (num item) => item.toDouble() == timeline.speed,
        ),
        itemCount: speeds.length,
        itemBuilder: (BuildContext context, int selectedIndex, int index) {
          return Text(
            '${speeds[index]}X',
            style: TextStyle(
              color: index == selectedIndex ? Colors.black : null,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          );
        },
        onChanged: (int index) {
          ref.read(currentTimelineProvider.notifier).updateSpeed(
                speeds[index].toDouble(),
              );
          ShowControlsMessageNotification(
            message: speedMessage[index],
          ).dispatch(context);
        },
      ),
    );
  }
}
