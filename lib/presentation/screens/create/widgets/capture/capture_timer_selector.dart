import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/core.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../provider/short_recording_state.dart';

class CaptureTimerSelector extends StatelessWidget {
  const CaptureTimerSelector({super.key, this.onStart});
  final ValueChanged<int>? onStart;

  @override
  Widget build(BuildContext context) {
    final countdowns = [3, 10, 20];
    int selectedIndex = 0;
    return Material(
      color: AppPalette.black,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Timer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? _) {
                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(shortRecordingProvider.notifier)
                            .updateCountdownStoppage(null);
                        context.pop();
                      },
                      child: const Icon(
                        YTIcons.close_outlined,
                        color: Colors.white70,
                        size: 20,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Countdown'),
            const SizedBox(height: 8),
            RangeSelector(
              initialIndex: selectedIndex,
              indicatorHeight: 40,
              backgroundColor: Colors.white12,
              selectedColor: Colors.white12,
              itemBuilder: (
                BuildContext context,
                int selectedIndex,
                int index,
              ) {
                return Text(
                  '${countdowns[index]}s',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFont.youTubeSans,
                  ),
                );
              },
              onChanged: (int index) => selectedIndex = index,
              itemCount: countdowns.length,
            ),
            const SizedBox(height: 24),
            const Text(
              'Drag to change where recording stops',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),
            const CountdownRangeSlider(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  onStart?.call(countdowns[selectedIndex]);
                  context.pop();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateColor.resolveWith(
                    (_) => context.theme.primaryColor,
                  ),
                  overlayColor: WidgetStateColor.resolveWith(
                    (_) => Colors.white12,
                  ),
                  textStyle: WidgetStateTextStyle.resolveWith(
                    (_) => const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                child: const Text(
                  'START',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class CountdownRangeSlider extends ConsumerWidget {
  const CountdownRangeSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shortsRecording = ref.read(shortRecordingProvider);
    final start = shortsRecording.duration.inSeconds /
        shortsRecording.recordDuration.inSeconds;

    const textStyle = TextStyle(fontSize: 14, color: Colors.white24);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('0s', style: textStyle),
            Text(
              '${shortsRecording.recordDuration.inSeconds}s',
              style: textStyle,
            ),
          ],
        ),
        OneWayRangeSlider(
          value: RangeValue(start: start, end: 1),
          onChanged: (double value) {
            final milli = shortsRecording.recordDuration.inMilliseconds;
            final stopMilliseconds = (milli * value).ceil() -
                shortsRecording.duration.inMilliseconds;

            final duration = Duration(milliseconds: stopMilliseconds);

            ref.read(shortRecordingProvider.notifier).updateCountdownStoppage(
                  stopMilliseconds == 0 || value == 1 ? null : duration,
                );
          },
        ),
      ],
    );
  }
}
