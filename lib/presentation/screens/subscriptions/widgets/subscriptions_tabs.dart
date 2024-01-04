import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

import '../subscriptions_screen.dart';

class SubscriptionsTabs extends StatefulWidget {
  final ValueNotifier<int?> valueListenable;
  final ValueChanged<int?> onChange;
  const SubscriptionsTabs({
    super.key,
    required this.onChange,
    required this.valueListenable,
  });

  @override
  State<SubscriptionsTabs> createState() => _SubscriptionsTabsState();
}

class _SubscriptionsTabsState extends State<SubscriptionsTabs> {
  ValueNotifier<int?> get _selectedChannel => widget.valueListenable;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ScrollConfiguration(
            behavior: const OverScrollGlowBehavior(
              enabled: false,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemBuilder: (context, index) {
                return ValueListenableBuilder<int?>(
                  valueListenable: _selectedChannel,
                  builder: (context, selected, childWidget) {
                    final opacity =
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
                      final prevSelected = _selectedChannel.value;
                      if (prevSelected == index) {
                        _selectedChannel.value = null;
                      } else {
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
