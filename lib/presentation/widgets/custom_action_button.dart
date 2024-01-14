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

class CustomActionButton extends StatelessWidget {
  final String? title;
  final Widget? icon;
  final double? leadingWidth;
  final Alignment alignment;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Border? border;
  final VoidCallback? onTap;

  const CustomActionButton({
    super.key,
    this.padding,
    this.margin,
    this.leadingWidth,
    this.alignment = Alignment.centerLeft,
    this.borderRadius,
    this.backgroundColor,
    this.border,
    this.icon,
    this.textStyle,
    this.onTap,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(32),
        border: border,
      ),
      child: TappableArea(
        behavior: HitTestBehavior.opaque,
        onPressed: onTap,
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 11.5,
            ),
        borderRadius: borderRadius ?? BorderRadius.circular(32),
        child: Align(
          alignment: alignment,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                if (title != null) const SizedBox(width: 5),
              ],
              if (leadingWidth != null) SizedBox(width: leadingWidth),
              if (title != null)
                Text(
                  title!,
                  style: textStyle ??
                      const TextStyle(
                        fontSize: 12,
                      ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
