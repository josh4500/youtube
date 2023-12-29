import 'package:flutter/material.dart';
import 'package:youtube_clone/core/utils/duration.dart';
import 'package:youtube_clone/presentation/screens/settings/widgets/settings_popup_container.dart';
import 'package:youtube_clone/presentation/widgets/roulette_scroll.dart';

class DateRangePicker extends StatefulWidget {
  const DateRangePicker({super.key});

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  final startController = PageController(
    viewportFraction: 0.33,
    initialPage: 4,
  );
  final stopController = PageController(
    viewportFraction: 0.33,
    initialPage: 4,
  );

  @override
  void dispose() {
    startController.dispose();
    stopController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0) + const EdgeInsets.only(left: 40.0),
      child: Column(
        children: [
          InkWell(
            onTap: _showStartStop,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Start time'),
                  Text('23:00'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _showStartStop(false),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Stop time'),
                  Text('23:00'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStartStop([bool start = true]) {
    showDialog(
      context: context,
      builder: (_) {
        return SettingsPopupContainer(
          title: '${start ? 'Start' : 'Stop'} time',
          showAffirmButton: true,
          alignment: Alignment.center,
          density: VisualDensity.compact,
          capitalizeDismissButtons: true,
          child: Container(
            height: 150,
            margin: const EdgeInsets.all(32),
            child: RouletteScroll<String>(
              items: List.generate(
                24 * 4,
                (index) {
                  return Duration(minutes: index * 15).hoursMinutes;
                },
              ),
              controller: start ? startController : stopController,
              onPageChange: (hourValue) {},
            ),
          ),
        );
      },
    );
  }
}
