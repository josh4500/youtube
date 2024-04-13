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

import 'tappable_area.dart';

class NotificationOption extends StatelessWidget {
  const NotificationOption({
    super.key,
    this.title,
    this.alignment,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
  });

  final String? title;
  final Alignment? alignment;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;

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
          children: <Widget>[
            const Icon(YTIcons.notification_all_filled),
            if (title != null) ...<Widget>[
              const SizedBox(width: 4),
              Text(title!, style: textStyle),
            ],
            const SizedBox(width: 4),
            const RotatedBox(
              quarterTurns: 1,
              child: Icon(YTIcons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
