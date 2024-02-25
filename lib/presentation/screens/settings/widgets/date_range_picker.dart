// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'package:flutter/material.dart';
import 'package:youtube_clone/core/utils/duration.dart';
import 'package:youtube_clone/presentation/screens/settings/widgets/settings_popup_container.dart';
import 'package:youtube_clone/presentation/widgets/roulette_scroll.dart';

class DateRangePicker extends StatefulWidget {
  final Duration? initialStart;
  final Duration? initialStop;
  final ValueChanged<Duration> onStartChange;
  final ValueChanged<Duration> onStopChange;

  const DateRangePicker({
    super.key,
    required this.onStartChange,
    required this.onStopChange,
    this.initialStart,
    this.initialStop,
  });

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  late Duration startDuration = widget.initialStart ?? Duration.zero;
  late Duration stopDuration = widget.initialStop ?? Duration.zero;

  final startController = PageController(
    viewportFraction: 0.33,
    initialPage: 4,
  );
  final stopController = PageController(
    viewportFraction: 0.33,
    initialPage: 4,
  );
  final List<String> timeList = List.generate(
    24 * 4,
    (index) {
      return Duration(minutes: index * 15).hoursMinutes;
    },
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Start time'),
                  Text(
                    '${startDuration.hourPart.toString().padLeft(2, '0')}:${startDuration.minutesPart.toString().padLeft(2, '0')}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _showStartStop(false),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Stop time'),
                  Text(
                    '${stopDuration.hourPart.toString().padLeft(2, '0')}:${stopDuration.minutesPart.toString().padLeft(2, '0')}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStartStop([bool start = true]) async {
    final controller = SettingsPopupContainerController(
      value: start ? startDuration : stopDuration,
    );
    final duration = await showDialog(
      context: context,
      builder: (_) {
        return SettingsPopupContainer<Duration>(
          controller: controller,
          title: '${start ? 'Start' : 'Stop'} time',
          showAffirmButton: true,
          alignment: Alignment.center,
          density: VisualDensity.compact,
          capitalizeDismissButtons: true,
          child: Container(
            height: 150,
            margin: const EdgeInsets.all(32),
            child: RouletteScroll<String>(
              items: timeList,
              controller: start ? startController : stopController,
              initialValue: start
                  ? startDuration.hoursMinutes
                  : stopDuration.hoursMinutes,
              onPageChange: (hourMinute) {
                final index = timeList.indexWhere(
                  (element) => element == hourMinute,
                );
                controller.value = Duration(minutes: index * 15);
              },
            ),
          ),
        );
      },
    );

    if (duration != null) {
      if (start) {
        startDuration = duration!;
        widget.onStartChange(duration!);
      } else {
        stopDuration = duration!;
        widget.onStopChange(duration!);
      }
      setState(() {});
    }
  }
}
