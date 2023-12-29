import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/settings/view_models/pref_option.dart';

import '../../widgets/download_storage_usage.dart';
import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

class DownloadsSettingsScreen extends StatelessWidget {
  const DownloadsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: SettingsListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Downloads',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SettingsTile(
            title: 'Download quality',
            prefOption: PrefOption(
              type: PrefOptionType.options,
            ),
            onTap: () {},
          ),
          SettingsTile(
            title: 'Download over Wi-Fi',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          SettingsTile(
            title: 'Recommend downloads',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          SettingsTile(
            title: 'Downloading help',
            summary: 'Find answers to your questions about downloading videos',
            onTap: () {},
          ),
          SettingsTile(
            title: 'Delete all downloads',
            onTap: () {},
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 4),
            child: Text(
              'Available storage',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(),
          const DownloadStorageUsage(),
        ],
      ),
    );
  }
}
