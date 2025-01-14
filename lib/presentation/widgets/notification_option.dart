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

import 'custom_action_button.dart';
import 'dynamic_sheet.dart';

class SubscribedChannelButton extends StatelessWidget {
  const SubscribedChannelButton({
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
    return CustomActionButton(
      title: title,
      alignment: Alignment.center,
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
      onTap: () => onButtonClicked(context),
      textStyle: textStyle,
      icon: Icon(SubscriptionNotificationType.personalized.icon),
      trailingIcon: const Icon(YTIcons.chevron_down),
    );
  }

  Future<void> onButtonClicked(BuildContext context) async {
    await showDynamicSheet<SubscriptionNotificationType>(
      context,
      title: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Text(
          'Notification',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      items: [
        for (final type in SubscriptionNotificationType.values) ...[
          if (type == SubscriptionNotificationType.unsubscribe)
            const DynamicSheetSection(
              child: Divider(height: 0, thickness: 1),
            ),
          DynamicSheetOptionItem<SubscriptionNotificationType>(
            value: type,
            title: type.text,
            leading: Icon(type.icon),
            trailing: DynamicSheetItemCheck(
              selected: type == SubscriptionNotificationType.all,
              color: const Color(0xFFAAAAAA),
              size: 18,
            ),
          ),
        ],
      ],
    );
  }
}

enum SubscriptionNotificationType {
  all,
  personalized,
  none,
  unsubscribe;

  String get text {
    return switch (this) {
      all => 'All',
      personalized => 'Personalized',
      none => 'None',
      unsubscribe => 'Unsubscribe',
    };
  }

  IconData get icon {
    return switch (this) {
      all => YTIcons.notification_all_filled,
      personalized => YTIcons.notification_outlined,
      none => YTIcons.notifications_off_outlined,
      unsubscribe => YTIcons.unsubscribe_outlined,
    };
  }
}
