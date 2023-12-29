import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/settings/view_models/pref_option.dart';
import 'package:youtube_clone/presentation/theme/app_color.dart';

import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

class VideoQualitySettingsScreen extends StatelessWidget {
  const VideoQualitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: SettingsListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Text(
              'Select your default streaming quality for all videos. You can change streaming quality in player options for single videos.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFAAAAAA),
              ),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'VIDEO QUALITY ON MOBILE NETWORKS',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SettingsTile(
            title: 'Auto (recommend)',
            summary:
                'Adjust to give you the best experience for your conditions',
            onTap: () {},
          ),
          SettingsTile(
            title: 'Higher picture quality',
            summary: 'User more data',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          SettingsTile(
            title: 'Data saver',
            summary: 'Lower quality picture',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'VIDEO QUALITY ON WIFI',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SettingsTile(
            title: 'Auto (recommend)',
            summary:
                'Adjust to give you the best experience for your conditions',
            onTap: () {},
          ),
          SettingsTile(
            title: 'Higher picture quality',
            summary: 'User more data',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          SettingsTile(
            title: 'Data saver',
            summary: 'Lower quality picture',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
        ],
      ),
    );
  }
}
