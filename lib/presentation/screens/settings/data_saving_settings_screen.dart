import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/settings/view_models/pref_option.dart';

import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

class DataSavingSettingsScreen extends StatelessWidget {
  const DataSavingSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: SettingsListView(
        children: [
          SettingsTile(
            title: 'Data Saving mode',
            summary: 'Automatically adjusts settings to save mobile data',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          const SizedBox(height: 28),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Text(
              'Default settings',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SettingsTile(
            title: 'Reduce video quality',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          SettingsTile(
            title: 'Reduce download quality',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          SettingsTile(
            title: 'Reduce Smart downloads quality',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          SettingsTile(
            title: 'Only download over Wi-Fi and unrestricted mobile data',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          SettingsTile(
            title: 'Upload over Wi-Fi only',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          SettingsTile(
            title: 'Muted playback in feeds over Wi-Fi only',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          const Divider(
            thickness: 4,
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4,
            ),
            child: Text(
              'Data monitoring & control',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SettingsTile(
            title: 'Select quality for every video',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          SettingsTile(
            title: 'Mobile data usage reminder',
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
