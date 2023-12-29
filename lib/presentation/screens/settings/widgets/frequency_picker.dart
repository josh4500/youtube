import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/roulette_scroll.dart';

class FrequencyPicker extends StatefulWidget {
  final ValueChanged<Duration> onChange;
  final Duration initialDuration;

  const FrequencyPicker({
    super.key,
    required this.onChange,
    required this.initialDuration,
  });

  @override
  State<FrequencyPicker> createState() => _FrequencyPickerState();
}

class _FrequencyPickerState extends State<FrequencyPicker> {
  final _hourController = PageController(
    viewportFraction: 0.33,
    initialPage: 4,
  );
  final _minuteController = PageController(
    viewportFraction: 0.33,
    initialPage: 4,
  );

  late Duration _hourDuration;
  late Duration _minuteDuration;

  @override
  void initState() {
    super.initState();
    // Set the initial duration for hour
    _hourDuration = Duration(
      hours: (widget.initialDuration.inMinutes / 60).floor(),
    );

    // Set the initial duration of minute
    _minuteDuration = Duration(
      minutes: widget.initialDuration.inMinutes.remainder(60),
    );
  }

  @override
  void dispose() {
    // Disposing scroll controllers
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.3,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Hours'),
                    const SizedBox(height: 5),
                    Expanded(
                      child: RouletteScroll<int>(
                        // Items are generated between 0 to 23 hours
                        items: List.generate(24, (index) => index),
                        initialValue: _hourDuration.inHours,
                        controller: _hourController,
                        onPageChange: (hourValue) {
                          _hourDuration = Duration(hours: hourValue);
                          widget.onChange(_hourDuration + _minuteDuration);
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Minutes'),
                    const SizedBox(height: 5),
                    Expanded(
                      child: RouletteScroll<int>(
                        // Items are generated between 5 to 55 minutes
                        items: List.generate(12, (index) => index * 5),
                        controller: _minuteController,
                        initialValue: _minuteDuration.inMinutes,
                        onPageChange: (minuteValue) {
                          _minuteDuration = Duration(minutes: minuteValue);
                          widget.onChange(_hourDuration + _minuteDuration);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
