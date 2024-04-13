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

import 'over_scroll_glow_behavior.dart';
import 'shimmer.dart';
import 'tappable_area.dart';

class DynamicTab extends StatefulWidget {
  const DynamicTab({
    super.key,
    this.height = 48.0,
    this.useTappable = false,
    this.leading,
    this.leadingWidth,
    this.trailing,
    this.onChanged,
    this.textStyle,
    required this.initialIndex,
    required this.options,
  });
  final double height;
  final int initialIndex;
  final bool useTappable;
  final List<String> options;
  final Widget? leading;
  final double? leadingWidth;
  final Widget? trailing;
  final TextStyle? textStyle;
  final ValueChanged<int>? onChanged;

  @override
  State<DynamicTab> createState() => _DynamicTabState();

  static Widget shimmer([int count = 10]) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        itemBuilder: (BuildContext context, _) {
          return Shimmer(
            color: const Color(0xFF272727),
            margin: const EdgeInsets.all(4),
            borderRadius: BorderRadius.circular(8),
            width: 96,
          );
        },
        itemCount: count,
      ),
    );
  }
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
        itemBuilder: (BuildContext context, int index) {
          if (widget.leading != null && index == 0) {
            return Row(
              children: <Widget>[
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
            builder: (
              BuildContext context,
              int selectedIndex,
              Widget? childWidget,
            ) {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: widget.useTappable
                      ? null
                      : index == selectedIndex
                          ? const Color(0xFFF1F1F1)
                          : const Color(0xFF272727),
                ),
                child: Text(
                  widget.options[index],
                  style: widget.textStyle?.copyWith(
                        color: index == selectedIndex
                            ? const Color(0xFF0F0F0F)
                            : const Color(0xFFF1F1F1),
                      ) ??
                      TextStyle(
                        color: index == selectedIndex
                            ? const Color(0xFF0F0F0F)
                            : const Color(0xFFF1F1F1),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              );
            },
          );

          if (widget.useTappable) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ValueListenableBuilder(
                valueListenable: _selectedIndexNotifier,
                builder: (
                  BuildContext context,
                  int selectedIndex,
                  Widget? childWidget,
                ) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ColoredBox(
                      color: index == selectedIndex
                          ? const Color(0xFFF1F1F1)
                          : const Color(0xFF272727),
                      child: childWidget,
                    ),
                  );
                },
                child: TappableArea(
                  onTap: () {
                    _selectedIndexNotifier.value = index;
                    widget.onChanged?.call(index);
                  },
                  padding: EdgeInsets.zero,
                  borderRadius: BorderRadius.circular(8),
                  child: child,
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  _selectedIndexNotifier.value = index;
                  widget.onChanged?.call(index);
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
