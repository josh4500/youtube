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
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

class NotificationOption extends StatelessWidget {
  final String? title;
  final Alignment? alignment;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;

  const NotificationOption({
    super.key,
    this.title,
    this.alignment,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TappableArea(
      padding: EdgeInsets.zero,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Container(
        alignment: alignment,
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_active),
            if (title != null) ...[
              const SizedBox(width: 4),
              Text(title!, style: textStyle),
            ],
            const SizedBox(width: 4),
            const RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
