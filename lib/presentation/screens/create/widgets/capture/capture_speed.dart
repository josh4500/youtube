import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/current_timeline_state.dart';
import '../range_selector.dart';

class CaptureSpeed extends ConsumerWidget {
  const CaptureSpeed({super.key});

  static const List<num> speeds = [0.3, 0.5, 1, 2, 3];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeline = ref.watch(currentTimelineProvider);
    return RangeSelector(
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
      },
    );
  }
}
