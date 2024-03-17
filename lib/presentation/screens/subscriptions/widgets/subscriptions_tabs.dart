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
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

import '../subscriptions_screen.dart';

class SubscriptionsTabs extends StatefulWidget {
  const SubscriptionsTabs({
    super.key,
    required this.onChange,
    required this.valueListenable,
  });
  final ValueNotifier<int?> valueListenable;
  final ValueChanged<int?> onChange;

  @override
  State<SubscriptionsTabs> createState() => _SubscriptionsTabsState();
}

class _SubscriptionsTabsState extends State<SubscriptionsTabs> {
  ValueNotifier<int?> get _selectedChannel => widget.valueListenable;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ScrollConfiguration(
            behavior: const OverScrollGlowBehavior(
              enabled: false,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemBuilder: (BuildContext context, int index) {
                final GlobalObjectKey<State<StatefulWidget>> key =
                    GlobalObjectKey(index.hashCode);
                return ValueListenableBuilder<int?>(
                  key: key,
                  valueListenable: _selectedChannel,
                  builder: (
                    BuildContext context,
                    int? selected,
                    Widget? childWidget,
                  ) {
                    final double opacity =
                        selected != null && selected != index ? 0.3 : 1.0;
                    return Container(
                      color: selected == index
                          ? Colors.blue.withOpacity(0.5)
                          : Colors.transparent,
                      child: Opacity(
                        opacity: opacity,
                        child: childWidget,
                      ),
                    );
                  },
                  child: TappableArea(
                    onPressed: () {
                      final int? prevSelected = _selectedChannel.value;
                      if (prevSelected == index) {
                        _selectedChannel.value = null;
                      } else {
                        Scrollable.ensureVisible(
                          key.currentContext!,
                          alignment: 0.55,
                          curve: Curves.easeInOut,
                        );
                        _selectedChannel.value = index;
                      }
                      widget.onChange(index);
                    },
                    child: const SubscriptionAvatar(),
                  ),
                );
              },
              itemCount: 10,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TappableArea(
            onPressed: () {
              context.goto(AppRoutes.allSubscriptions);
            },
            padding: const EdgeInsets.all(4.0),
            child: const Text(
              'All',
              style: TextStyle(
                color: Colors.blueAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
