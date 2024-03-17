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
import 'package:youtube_clone/presentation/widgets/roulette_scroll.dart';

class FrequencyPicker extends StatefulWidget {
  const FrequencyPicker({
    super.key,
    required this.onChange,
    required this.initialDuration,
  });
  final ValueChanged<Duration> onChange;
  final Duration initialDuration;

  @override
  State<FrequencyPicker> createState() => _FrequencyPickerState();
}

class _FrequencyPickerState extends State<FrequencyPicker> {
  final PageController _hourController = PageController(
    viewportFraction: 0.33,
    initialPage: 4,
  );
  final PageController _minuteController = PageController(
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
        children: <Widget>[
          const SizedBox(height: 16),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Hours'),
                    const SizedBox(height: 5),
                    Expanded(
                      child: RouletteScroll<int>(
                        // Items are generated between 0 to 23 hours
                        items: List.generate(24, (int index) => index),
                        initialValue: _hourDuration.inHours,
                        controller: _hourController,
                        onPageChange: (int hourValue) {
                          _hourDuration = Duration(hours: hourValue);
                          widget.onChange(_hourDuration + _minuteDuration);
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Minutes'),
                    const SizedBox(height: 5),
                    Expanded(
                      child: RouletteScroll<int>(
                        // Items are generated between 5 to 55 minutes
                        items: List.generate(12, (int index) => index * 5),
                        controller: _minuteController,
                        initialValue: _minuteDuration.inMinutes,
                        onPageChange: (int minuteValue) {
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
