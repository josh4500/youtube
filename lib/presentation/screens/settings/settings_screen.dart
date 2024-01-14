// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/screens/settings/data_saving_settings_screen.dart';
import 'package:youtube_clone/presentation/screens/settings/downloads_settings_screen.dart';
import 'package:youtube_clone/presentation/screens/settings/general_settings_screen.dart';
import 'package:youtube_clone/presentation/screens/settings/notifications_settings_screen.dart';
import 'package:youtube_clone/presentation/screens/settings/privacy_settings_screen.dart';
import 'package:youtube_clone/presentation/screens/settings/video_quality_settings_screen.dart';
import 'package:youtube_clone/presentation/screens/settings/widgets/settings_popup_container.dart';
import 'package:youtube_clone/presentation/screens/settings/widgets/settings_tile.dart';
import 'package:youtube_clone/presentation/theme/app_theme.dart';
import 'package:youtube_clone/presentation/widgets/lazy_indexed_stack.dart';

import '../../../generated/l10n.dart';
import '../../theme/device_theme.dart';
import '../../widgets/builders/orientation_builder.dart';
import 'about_screen.dart';
import 'accessibility_settings_screen.dart';
import 'auto_play_settings_screen.dart';
import 'bills_and_payments_screen.dart';
import 'live_chat_settings_screen.dart';
import 'widgets/settings_list_view.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _currentSettingScreen = 0;
  int _mostRecentSettingScreen = 1;
  String _currentSettingsTitle = 'Settings';

  final List<Widget> _settingsPages = const [
    GeneralSettingsScreen(),
    DataSavingSettingsScreen(),
    AutoPlaySettingsScreen(),
    VideoQualitySettingsScreen(),
    DownloadsSettingsScreen(),
    PrivacySettingsScreen(),
    BillingAndPaymentsScreen(),
    NotificationsSettingsScreen(),
    LiveChatSettingsScreen(),
    AccessibilitySettingsScreen(),
    AboutScreen(),
  ];

  Future<void> _showSettingsPrefScreen(String title) async {
    if (title == S.current.general) {
      _currentSettingScreen = 1;
      _mostRecentSettingScreen = 1;
      _currentSettingsTitle = title;
      setState(() {});
    } else if (title == 'Data Saving') {
      _currentSettingScreen = 2;
      _mostRecentSettingScreen = 2;
      _currentSettingsTitle = title;
      setState(() {});
    } else if (title == 'Autoplay') {
      _currentSettingScreen = 3;
      _mostRecentSettingScreen = 3;
      _currentSettingsTitle = title;
      setState(() {});
    } else if (title == 'Video quality preferences') {
      _currentSettingScreen = 4;
      _mostRecentSettingScreen = 4;
      _currentSettingsTitle = title;
      setState(() {});
    } else if (title == 'Downloads') {
      _currentSettingScreen = 5;
      _mostRecentSettingScreen = 5;
      _currentSettingsTitle = title;
      setState(() {});
    } else if (title == 'Privacy') {
      _currentSettingScreen = 6;
      _mostRecentSettingScreen = 6;
      _currentSettingsTitle = title;
      setState(() {});
    } else if (title == 'Billing & payments') {
      _currentSettingScreen = 7;
      _mostRecentSettingScreen = 7;
      _currentSettingsTitle = title;
      setState(() {});
    } else if (title == 'Notifications') {
      _currentSettingScreen = 8;
      _mostRecentSettingScreen = 8;
      _currentSettingsTitle = title;
      setState(() {});
    } else if (title == 'Live chat') {
      _currentSettingScreen = 9;
      _mostRecentSettingScreen = 9;
      _currentSettingsTitle = title;
      setState(() {});
    } else if (title == 'Accessibility') {
      _currentSettingScreen = 10;
      _mostRecentSettingScreen = 10;
      _currentSettingsTitle = title;
      setState(() {});
    } else if (title == 'About') {
      _currentSettingScreen = 11;
      _mostRecentSettingScreen = 11;
      _currentSettingsTitle = title;
      setState(() {});
    } else if (title == 'Account') {
      await showDialog(
        context: context,
        builder: (_) {
          return SettingsPopupContainer(
            title: title,
            showDismissButtons: false,
            action: InkWell(
              onTap: () {},
              child: const Icon(Icons.add),
            ),
            child: Container(
              color: context.theme.appColors.settingsPopupBackgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SettingsTile(
                title: 'Add account',
                networkRequired: true,
                onTap: () {},
              ),
            ),
          );
        },
      );
    }
  }

  void _onNavigateBack() {
    if (_currentSettingScreen != 0 && context.orientation.isPortrait) {
      _currentSettingScreen = 0;
      _currentSettingsTitle = 'Settings';
      setState(() {});
      return;
    }
    context.pop();
  }

  bool _isSelected(int index) {
    return context.orientation.isLandscape && _currentSettingScreen == index;
  }

  @override
  Widget build(BuildContext context) {
    final settingsTileSize = DeviceTheme.of(context).settingsTileSize;
    final settingsList = SettingsListView(
      children: [
        SettingsTile(
          title: S.current.general,
          onTap: () => _showSettingsPrefScreen(S.current.general),
          selected: _isSelected(1),
        ),
        SettingsTile(
          title: 'Account',
          onTap: () => _showSettingsPrefScreen('Account'),
          networkRequired: true,
        ),
        SettingsTile(
          title: 'Data Saving',
          onTap: () => _showSettingsPrefScreen('Data Saving'),
          selected: _isSelected(2),
        ),
        SettingsTile(
          title: 'Autoplay',
          onTap: () => _showSettingsPrefScreen('Autoplay'),
          selected: _isSelected(3),
          networkRequired: true,
        ),
        SettingsTile(
          title: 'Video quality preferences',
          onTap: () => _showSettingsPrefScreen('Video quality preferences'),
          selected: _isSelected(4),
        ),
        SettingsTile(
          title: 'Downloads',
          onTap: () => _showSettingsPrefScreen('Downloads'),
          selected: _isSelected(5),
          accountRequired: true,
        ),
        const SettingsTile(title: 'Watch on TV'),
        const SettingsTile(
          title: 'Manage all history',
          networkRequired: true,
          accountRequired: true,
        ),
        const SettingsTile(
          title: 'Your data in Youtube',
          networkRequired: true,
          accountRequired: true,
        ),
        SettingsTile(
          title: 'Privacy',
          networkRequired: true,
          accountRequired: true,
          onTap: () => _showSettingsPrefScreen('Privacy'),
          selected: _isSelected(6),
        ),
        const SettingsTile(
          title: 'Try experimental new features',
          networkRequired: true,
        ),
        const SettingsTile(
          title: 'Purchases and memberships',
          networkRequired: true,
          accountRequired: true,
        ),
        SettingsTile(
          title: 'Billing & payments',
          networkRequired: true,
          accountRequired: true,
          onTap: () => _showSettingsPrefScreen('Billing & payments'),
          selected: _isSelected(7),
        ),
        SettingsTile(
          title: 'Notifications',
          networkRequired: true,
          onTap: () => _showSettingsPrefScreen('Notifications'),
          selected: _isSelected(8),
        ),
        const SettingsTile(
          title: 'Connected apps',
          networkRequired: true,
          accountRequired: true,
        ),
        SettingsTile(
          title: 'Live chat',
          networkRequired: true,
          accountRequired: true,
          onTap: () => _showSettingsPrefScreen('Live chat'),
          selected: _isSelected(9),
        ),
        const SettingsTile(title: 'Captions'),
        SettingsTile(
          title: 'Accessibility',
          onTap: () => _showSettingsPrefScreen('Accessibility'),
          selected: _isSelected(10),
        ),
        SettingsTile(
          title: 'About',
          onTap: () => _showSettingsPrefScreen('About'),
          selected: _isSelected(11),
        ),
      ],
    );
    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) => _onNavigateBack(),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: _onNavigateBack),
          title: Text(_currentSettingsTitle),
        ),
        body: CustomOrientationBuilder(
          onPortrait: (_, child) {
            return LazyIndexedStack(
              index: _currentSettingScreen,
              children: [
                settingsList,
                ..._settingsPages,
              ],
            );
          },
          onLandscape: (_, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: settingsTileSize.widthValueOf(_),
                  child: settingsList,
                ),
                Expanded(
                  child: IndexedStack(
                    index: _mostRecentSettingScreen - 1,
                    children: _settingsPages,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
