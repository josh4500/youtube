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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/preferences.dart';
import 'package:youtube_clone/presentation/screens/settings/view_models/pref_option.dart';

import 'widgets/round_check_item.dart';
import 'widgets/settings_list_view.dart';
import 'widgets/settings_popup_container.dart';
import 'widgets/settings_tile.dart';

class AccessibilitySettingsScreen extends ConsumerStatefulWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  ConsumerState<AccessibilitySettingsScreen> createState() =>
      _AccessibilitySettingsScreenState();
}

class _AccessibilitySettingsScreenState
    extends ConsumerState<AccessibilitySettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(preferencesProvider);
    return Material(
      type: MaterialType.canvas,
      child: SettingsListView(
        children: [
          SettingsTile(
            title: 'Accessibility player',
            summary: 'Display accessibility control in the player',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: preferences.accessibilityPreferences.enabled,
              onToggle: () {
                ref.read(preferencesProvider.notifier).changeAccessibility(
                      enabled: !preferences.accessibilityPreferences.enabled,
                    );
              },
            ),
            onTap: () {
              ref.read(preferencesProvider.notifier).changeAccessibility(
                    enabled: !preferences.accessibilityPreferences.enabled,
                  );
            },
          ),
          SettingsTile(
            title: 'Hide player controls',
            summary: 'Never',
            onGenerateSummary: (pref) {
              return generateHideDuration(pref.value);
            },
            prefOption: PrefOption(
              type: PrefOptionType.options,
              value: preferences.accessibilityPreferences.hideDuration,
            ),
            enabled: preferences.accessibilityPreferences.enabled,
            onTap: _onChangeHideDuration,
          ),
        ],
      ),
    );
  }

  Future<void> _onChangeHideDuration() async {
    final hideDurations = [-2, 3, 5, 10, 30, -1];
    final result = await showDialog<int>(
      context: context,
      builder: (_) {
        return SettingsPopupContainer<int>.builder(
          title: 'Hide player controls',
          subtitle: 'Choose when player controls are hidden',
          itemBuilder: (_, index) {
            final hideDuration = hideDurations[index];
            final title = generateHideDuration(hideDuration);

            return Consumer(
              builder: (context, ref, _) {
                final preferences = ref.watch(preferencesProvider);
                return RoundCheckItem<int>(
                  title: title,
                  subtitle: hideDuration == -2
                      ? const Text(
                          'Manage your "Time to take action" in device settings',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        )
                      : null,
                  value: hideDuration,
                  groupValue: preferences.accessibilityPreferences.hideDuration,
                  onChange: (value) {
                    if (value != null) {
                      context.pop(value);
                    }
                  },
                );
              },
            );
          },
          itemCount: hideDurations.length,
        );
      },
    );
    ref.read(preferencesProvider.notifier).changeAccessibility(
          hideDuration: result,
        );
  }

  String generateHideDuration(int hideDuration) {
    switch (hideDuration) {
      case -1:
        return 'Never';
      case -2:
        return 'Use device settings';
    }
    return 'After $hideDuration seconds';
  }
}
