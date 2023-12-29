import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/settings/view_models/pref_option.dart';

import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: SettingsListView(
        children: [
          SettingsTile(
            title: 'Google Ads Settings',
            summary: 'Manage your ads settings from your google Ads Settings',
            prefOption: PrefOption(
              type: PrefOptionType.options,
            ),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Blocked contacts',
            onTap: () {},
          ),
          SettingsTile(
            title: 'Youtube Terms of Service',
            summary: 'Read Youtube\'s Terms of Service',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
