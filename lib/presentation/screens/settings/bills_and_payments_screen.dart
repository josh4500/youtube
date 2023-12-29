import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/settings/view_models/pref_option.dart';

import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

class BillingAndPaymentsScreen extends StatelessWidget {
  const BillingAndPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: SettingsListView(
        children: [
          SettingsTile(
            title: 'Enable quick purchases',
            summary:
                'Make YouTube purchases on all devices without verifying your account',
            prefOption: PrefOption(
              type: PrefOptionType.toggleWithOptions,
              value: false,
              onToggle: () {},
            ),
            accountRequired: true,
            onTap: () {},
          ),
          SettingsTile(
            title: 'On this device, my preferred verification is:',
            prefOption: PrefOption(
              type: PrefOptionType.options,
            ),
            summary: 'Account password',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
