import 'package:flutter/material.dart';

import 'over_scroll_glow_behavior.dart';
import 'tappable_area.dart';

class DynamicTab extends StatefulWidget {
  final int initialIndex;
  final List<String> options;
  final Widget? leading;
  final Widget? trailing;
  final ValueChanged<int>? onChanged;
  const DynamicTab({
    super.key,
    this.leading,
    this.trailing,
    this.onChanged,
    required this.initialIndex,
    required this.options,
  });

  @override
  State<DynamicTab> createState() => _DynamicTabState();
}

class _DynamicTabState extends State<DynamicTab> {
  late final ValueNotifier<int> _selectedIndexNotifier =
      ValueNotifier<int>(widget.initialIndex);
  int get _totalItems =>
      widget.options.length +
      (widget.leading != null ? 1 : 0) +
      (widget.trailing != null ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const OverScrollGlowBehavior(enabled: false),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemBuilder: (context, index) {
          if (widget.leading != null && index == 0) {
            return widget.leading;
          } else if (widget.trailing != null && index == _totalItems - 1) {
            return widget.trailing;
          }

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: TappableArea(
              onPressed: () {
                _selectedIndexNotifier.value = index;
                if (widget.onChanged != null) {
                  widget.onChanged!(index);
                }
              },
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(8),
              child: ValueListenableBuilder(
                  valueListenable: _selectedIndexNotifier,
                  builder: (context, selectedIndex, childWidget) {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12.5,
                      ),
                      decoration: BoxDecoration(
                        color: index == selectedIndex
                            ? Colors.white
                            : Colors.white12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.options[index],
                        style: TextStyle(
                          color: index == selectedIndex
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    );
                  }),
            ),
          );
        },
        itemCount: _totalItems,
      ),
    );
  }
}
