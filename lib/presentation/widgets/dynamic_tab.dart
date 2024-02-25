// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/material.dart';

import 'over_scroll_glow_behavior.dart';
import 'tappable_area.dart';

class DynamicTab extends StatefulWidget {
  final int initialIndex;
  final bool useTappable;
  final List<String> options;
  final Widget? leading;
  final double? leadingWidth;
  final Widget? trailing;
  final TextStyle? textStyle;
  final ValueChanged<int>? onChanged;

  const DynamicTab({
    super.key,
    this.useTappable = false,
    this.leading,
    this.leadingWidth,
    this.trailing,
    this.onChanged,
    this.textStyle,
    required this.initialIndex,
    required this.options,
  });

  @override
  State<DynamicTab> createState() => _DynamicTabState();
}

class _DynamicTabState extends State<DynamicTab> {
  late final ValueNotifier<int> _selectedIndexNotifier = ValueNotifier<int>(
    widget.initialIndex,
  );
  int get _totalItems =>
      widget.options.length +
      (widget.leading != null ? 1 : 0) +
      (widget.trailing != null ? 1 : 0);

  @override
  void didUpdateWidget(covariant DynamicTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedIndexNotifier.value = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const OverScrollGlowBehavior(enabled: false),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemBuilder: (context, index) {
          if (widget.leading != null && index == 0) {
            return Row(
              children: [
                widget.leading!,
                SizedBox(width: widget.leadingWidth),
              ],
            );
          } else if (widget.trailing != null && index == _totalItems - 1) {
            return widget.trailing!;
          }
          index -= (widget.leading != null ? 1 : 0);
          final child = ValueListenableBuilder(
            valueListenable: _selectedIndexNotifier,
            builder: (context, selectedIndex, childWidget) {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12.5,
                ),
                decoration: BoxDecoration(
                  color: index == selectedIndex ? Colors.white : Colors.white12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.options[index],
                  style: widget.textStyle?.copyWith(
                        color: index == selectedIndex
                            ? Colors.black
                            : Colors.white,
                      ) ??
                      TextStyle(
                        color: index == selectedIndex
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              );
            },
          );
          if (widget.useTappable) {
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
                child: child,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  _selectedIndexNotifier.value = index;
                  if (widget.onChanged != null) {
                    widget.onChanged!(index);
                  }
                },
                child: child,
              ),
            );
          }
        },
        itemCount: _totalItems,
      ),
    );
  }
}
