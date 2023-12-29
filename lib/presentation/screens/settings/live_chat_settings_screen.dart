import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/settings/view_models/pref_option.dart';

import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

class LiveChatSettingsScreen extends StatelessWidget {
  const LiveChatSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: SettingsListView(
        children: [
          SettingsTile(
            title: 'Hold for review',
            summary:
                'Potentially inappropriate messages will be held for review in your chat',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
