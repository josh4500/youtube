import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/settings/view_models/pref_option.dart';

import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

class AutoPlaySettingsScreen extends StatelessWidget {
  const AutoPlaySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: SettingsListView(
        children: [
          SettingsTile(
            title: 'Autoplay next video',
            summary: 'When you finish a video, another plays automatically',
            onTap: () {},
          ),
          SettingsTile(
            title: 'Mobile phone/tablet',
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
