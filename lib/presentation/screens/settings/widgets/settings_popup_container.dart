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
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/theme/app_theme.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class SettingsPopupContainer<T> extends StatelessWidget {
  const SettingsPopupContainer({
    super.key,
    this.action,
    this.density,
    this.subtitle,
    this.controller,
    required this.title,
    this.showTitle = true,
    this.showDismissButtons = true,
    this.showAffirmButton = false,
    this.alignment = Alignment.centerLeft,
    this.capitalizeDismissButtons = false,
    this.onAffirm,
    required this.child,
  });

  factory SettingsPopupContainer.builder({
    Key? key,
    required String title,
    String? subtitle,
    bool showTitle = true,
    bool showDismissButtons = true,
    bool showAffirmButton = false,
    required Widget Function(BuildContext context, int index)? itemBuilder,
    required int? itemCount,
    VisualDensity? density,
    bool capitalizeDismissButtons = false,
  }) {
    return SettingsPopupContainer(
      key: key,
      title: title,
      subtitle: subtitle,
      showTitle: showTitle,
      density: density,
      showDismissButtons: showDismissButtons,
      showAffirmButton: showAffirmButton,
      capitalizeDismissButtons: capitalizeDismissButtons,
      child: ScrollConfiguration(
        behavior: const OverScrollGlowBehavior(
          enabled: false,
        ),
        child: Scrollbar(
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return itemBuilder!(context, index);
            },
            itemCount: itemCount,
          ),
        ),
      ),
    );
  }
  final String title;
  final String? subtitle;
  final Widget? action;
  final bool showTitle;
  final VisualDensity? density;
  final Alignment alignment;
  final SettingsPopupContainerController<T>? controller;
  final bool showDismissButtons;
  final bool showAffirmButton;
  final bool capitalizeDismissButtons;
  final ValueChanged<T?>? onAffirm;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final SettingsPopupContainerController<T> effectiveController =
        controller ?? SettingsPopupContainerController();
    final double width = density == null
        ? MediaQuery.sizeOf(context).width * 0.85
        : density == VisualDensity.compact
            ? MediaQuery.sizeOf(context).width * 0.65
            : MediaQuery.sizeOf(context).width * 0.85;
    return Center(
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16.0),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: context.theme.appColors.settingsPopupBackgroundColor,
          child: ListenableBuilder(
            listenable: effectiveController,
            builder: (BuildContext context, Widget? _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (showTitle)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                        right: 16,
                        left: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: density == VisualDensity.compact
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: action == null
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (action != null) ...[
                                const SizedBox(width: 8),
                                action!,
                              ],
                            ],
                          ),
                          if (subtitle != null) ...<Widget>[
                            const SizedBox(height: 16),
                            Text(
                              subtitle!,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  Align(alignment: alignment, child: child),
                  if (showDismissButtons)
                    Container(
                      padding: const EdgeInsets.only(right: 16),
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            onPressed: context.pop,
                            style:
                                context.theme.appStyles.settingsTextButtonStyle,
                            child: Text(
                              capitalizeDismissButtons
                                  ? 'Cancel'.toUpperCase()
                                  : 'Cancel',
                              style: context
                                  .theme.appStyles.settingsTextButtonTextStyle,
                            ),
                          ),
                          if (showAffirmButton)
                            TextButton(
                              onPressed: () {
                                if (onAffirm != null) {
                                  onAffirm?.call(effectiveController.value);
                                }
                                context.pop(effectiveController.value);
                              },
                              style: context
                                  .theme.appStyles.settingsTextButtonStyle,
                              child: Text(
                                capitalizeDismissButtons
                                    ? 'Okay'.toUpperCase()
                                    : 'Ok',
                                style: context.theme.appStyles
                                    .settingsTextButtonTextStyle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class SettingsPopupContainerController<T> extends ValueNotifier<T?> {
  SettingsPopupContainerController({T? value}) : super(value);
}
