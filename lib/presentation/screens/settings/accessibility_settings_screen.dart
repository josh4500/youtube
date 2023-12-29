import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/settings/view_models/pref_option.dart';

import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

class AccessibilitySettingsScreen extends StatelessWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: SettingsListView(
        children: [
          SettingsTile(
            title: 'Accessibility player',
            summary: 'Display accessibility control in the player',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Hide player controls',
            summary: 'Never',
            prefOption: PrefOption(
              type: PrefOptionType.options,
              value: false,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
