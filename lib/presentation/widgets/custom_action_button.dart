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
import 'package:youtube_clone/presentation/themes.dart';

import 'gestures/tappable_area.dart';

class CustomActionButton extends StatelessWidget {
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
    this.trailingIcon,
    this.textStyle,
    this.onTap,
    this.title,
    this.useTappable = true,
    this.enableFeedback = true,
  });
  final String? title;
  final Widget? icon, trailingIcon;
  final double? leadingWidth;
  final Alignment alignment;
  final EdgeInsets? padding, margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Border? border;
  final VoidCallback? onTap;
  final bool useTappable, enableFeedback;

  @override
  Widget build(BuildContext context) {
    final CustomActionButtonStyle theme =
        context.theme.appStyles.customActionButtonStyle;
    final buttonContent = Container(
      alignment: alignment,
      padding: padding ?? theme.padding,
      decoration: BoxDecoration(
        border: border,
        color: backgroundColor ?? theme.backgroundColor,
        borderRadius: borderRadius ?? theme.borderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            icon!,
            if (title != null) const SizedBox(width: 5),
          ],
          if (leadingWidth != null) SizedBox(width: leadingWidth),
          if (title != null) Text(title!, style: textStyle ?? theme.textStyle),
          if (trailingIcon != null) ...[
            const SizedBox(width: 5),
            trailingIcon!,
          ],
        ],
      ),
    );

    return Container(
      margin: margin,
      child: useTappable
          ? TappableArea(
              onTap: onTap,
              enableFeedback: enableFeedback,
              borderRadius: borderRadius ?? theme.borderRadius,
              child: buttonContent,
            )
          : InkWell(
              onTap: onTap,
              enableFeedback: enableFeedback,
              borderRadius: borderRadius ?? theme.borderRadius,
              splashFactory: NoSplash.splashFactory,
              child: buttonContent,
            ),
    );
  }
}
