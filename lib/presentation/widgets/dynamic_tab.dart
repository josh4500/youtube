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

import 'dart:math';

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
