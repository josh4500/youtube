import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/settings/widgets/settings_tile.dart';

import '../../../generated/l10n.dart';
import '../../theme/device_theme.dart';
import '../../widgets/orientation_builder.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsTileSize = DeviceTheme.of(context).settingsTileSize;
    final settingsList = Scrollbar(
      child: ListView(
        children: [
          SettingsTile(title: S.current.general),
          const SettingsTile(title: 'Account'),
          const SettingsTile(title: 'Data Saving'),
          const SettingsTile(title: 'Autoplay'),
          const SettingsTile(title: 'Video quality preferences'),
          const SettingsTile(title: 'Downloads'),
          const SettingsTile(title: 'Watch on TV'),
          const SettingsTile(title: 'Manage all history'),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Settings'),
      ),
      body: CustomOrientationBuilder(
        onPortrait: (_, child) {
          return settingsList;
        },
        onLandscape: (_, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: settingsTileSize.widthValueOf(_),
                child: settingsList,
              ),
            ],
          );
        },
      ),
    );
  }
}
