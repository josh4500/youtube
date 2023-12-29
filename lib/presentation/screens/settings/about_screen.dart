import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/settings/view_models/pref_option.dart';

import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: SettingsListView(
        children: [
          SettingsTile(
            title: 'Help',
            summary: 'Find answers to your YouTube questions here',
            onTap: () {},
          ),
          SettingsTile(
            title: 'Send feedback',
            summary: 'Help us make YouTube better',
            onTap: () {},
          ),
          SettingsTile(
            title: 'YouTube Terms of Service',
            summary: 'Read Youtube\'s Terms of Service',
            onTap: () {},
          ),
          SettingsTile(
            title: 'Google Privacy Policy',
            summary: ' Read Mobile Privacy Policy',
            onTap: () {},
          ),
          SettingsTile(
            title: 'Open source licences',
            summary: 'Licence details for open source software',
            onTap: () {},
          ),
          SettingsTile(
            title: 'App version',
            summary: '18.49.34',
            onTap: () {},
          ),
          SettingsTile(
            title: 'YouTube, a Google company',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
