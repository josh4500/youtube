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
