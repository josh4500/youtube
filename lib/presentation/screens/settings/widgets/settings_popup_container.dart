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
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/theme/app_theme.dart';

class SettingsPopupContainer<T> extends StatelessWidget {
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
    bool capitalizeDismissButtons = false,
  }) {
    return SettingsPopupContainer(
      key: key,
      title: title,
      subtitle: subtitle,
      showTitle: showTitle,
      showDismissButtons: showDismissButtons,
      showAffirmButton: showAffirmButton,
      capitalizeDismissButtons: capitalizeDismissButtons,
      child: Scrollbar(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return itemBuilder!(context, index);
          },
          itemCount: itemCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveController =
        controller ?? SettingsPopupContainerController();
    final width = density == null
        ? MediaQuery.sizeOf(context).width * 0.85
        : density == VisualDensity.compact
            ? MediaQuery.sizeOf(context).width * 0.5
            : MediaQuery.sizeOf(context).width * 0.85;
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.8,
          ),
          width: width,
          decoration: BoxDecoration(
            color: context.theme.appColors.settingsPopupBackgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: ListenableBuilder(
            listenable: effectiveController,
            builder: (context, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showTitle)
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, right: 16, left: 16),
                      child: Column(
                        crossAxisAlignment: density == VisualDensity.compact
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(fontSize: 18),
                              ),
                              if (action != null) action!,
                            ],
                          ),
                          if (subtitle != null) ...[
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
                  Align(
                    alignment: alignment,
                    child: child,
                  ),
                  if (showDismissButtons)
                    Container(
                      padding: const EdgeInsets.only(right: 16),
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                                  onAffirm!(effectiveController.value);
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
