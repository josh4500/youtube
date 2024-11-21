// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/generated/l10n.dart';
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'about_screen.dart';
import 'accessibility_settings_screen.dart';
import 'auto_play_settings_screen.dart';
import 'bills_and_payments_screen.dart';
import 'data_saving_settings_screen.dart';
import 'downloads_settings_screen.dart';
import 'general_settings_screen.dart';
import 'live_chat_settings_screen.dart';
import 'notifications_settings_screen.dart';
import 'privacy_settings_screen.dart';
import 'video_quality_settings_screen.dart';
import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsTab _currentScreen = SettingsTab.settings;

  final List<Widget> _settingsPages = const <Widget>[
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

  Future<void> _showSettingsPrefScreen(SettingsTab tab) async {
    if (tab == SettingsTab.account) {
      await showAccountDialog(context);
      return;
    } else if (tab == SettingsTab.watchOnTv) {
      context.goto(AppRoutes.watchOnTv);
      return;
    } else if (tab == SettingsTab.tryExperimental) {
      context.replaceScreen(AppRoutes.tryExperimental);
    }

    _currentScreen = tab;
    setState(() {});
  }

  void _onNavigateBack() {
    if (!_currentScreen.isSettings && context.orientation.isPortrait) {
      _currentScreen = SettingsTab.settings;
      setState(() {});
      return;
    }
    context.pop();
  }

  bool _isSelected(SettingsTab tab) {
    if (context.orientation.isLandscape) {
      if (tab.index == 1 && _currentScreen == SettingsTab.settings) {
        _currentScreen = SettingsTab.general;
      }
      return _currentScreen == tab;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final SettingsListView settingsList = SettingsListView(
      children: <Widget>[
        SettingsSection(
          title: 'Account',
          divide: false,
          children: [
            SettingsTile(
              leadingIcon: YTIcons.settings_outlined,
              title: S.current.general,
              onTap: () => _showSettingsPrefScreen(SettingsTab.general),
              selected: _isSelected(SettingsTab.general),
            ),
            SettingsTile(
              leadingIcon: YTIcons.switch_accounts,
              title: S.current.account,
              onTap: () => _showSettingsPrefScreen(SettingsTab.account),
              networkRequired: true,
            ),
            SettingsTile(
              title: 'Family Center',
              onTap: () {},
            ),
            SettingsTile(
              leadingIcon: YTIcons.notification_outlined,
              title: S.current.notifications,
              networkRequired: true,
              onTap: () => _showSettingsPrefScreen(SettingsTab.notifications),
              selected: _isSelected(SettingsTab.notifications),
            ),
            SettingsTile(
              leadingIcon: YTIcons.purchases_outlined,
              title: S.current.purchases,
              networkRequired: true,
              accountRequired: true,
            ),
            SettingsTile(
              leadingIcon: YTIcons.billing_outlined,
              title: S.current.billsAndPayment,
              networkRequired: true,
              accountRequired: true,
              onTap: () => _showSettingsPrefScreen(SettingsTab.billsAndPayment),
              selected: _isSelected(SettingsTab.billsAndPayment),
            ),
            SettingsTile(
              leadingIcon: YTIcons.history_outlined,
              title: S.current.manageAllHistory,
              networkRequired: true,
              accountRequired: true,
            ),
            SettingsTile(
              leadingIcon: YTIcons.privacy_person_outlined,
              title: S.current.yourDataInYT,
              networkRequired: true,
              accountRequired: true,
            ),
            SettingsTile(
              leadingIcon: YTIcons.private_circle_outlined,
              title: S.current.privacy,
              networkRequired: true,
              accountRequired: true,
              onTap: () => _showSettingsPrefScreen(SettingsTab.privacy),
              selected: _isSelected(SettingsTab.privacy),
            ),
            SettingsTile(
              leadingIcon: YTIcons.connected_outlined,
              title: S.current.connectedApps,
              networkRequired: true,
              accountRequired: true,
            ),
            SettingsTile(
              title: S.current.tryExperimental,
              onTap: () => _showSettingsPrefScreen(SettingsTab.tryExperimental),
              networkRequired: true,
            ),
          ],
        ),
        SettingsSection(
          title: 'Video and audio preferences',
          children: [
            SettingsTile(
              leadingIcon: Icons.high_quality_outlined,
              title: S.current.videoQualityPref,
              onTap: () => _showSettingsPrefScreen(
                SettingsTab.videoQualityPref,
              ),
              selected: _isSelected(SettingsTab.videoQualityPref),
            ),
            SettingsTile(
              leadingIcon: YTIcons.play_arrow,
              title: S.current.playback,
              onTap: () => _showSettingsPrefScreen(SettingsTab.playback),
              selected: _isSelected(SettingsTab.playback),
              networkRequired: true,
            ),
            SettingsTile(
              leadingIcon: Icons.closed_caption_off,
              title: S.current.captions,
            ),
            SettingsTile(
              leadingIcon: YTIcons.tune_outlined,
              title: S.current.dataSaving,
              onTap: () => _showSettingsPrefScreen(SettingsTab.dataSaving),
              selected: _isSelected(SettingsTab.dataSaving),
            ),
            SettingsTile(
              leadingIcon: YTIcons.download_outlined,
              title: S.current.downloads,
              onTap: () => _showSettingsPrefScreen(SettingsTab.downloads),
              selected: _isSelected(SettingsTab.downloads),
              accountRequired: true,
            ),
            SettingsTile(
              leadingIcon: YTIcons.live_outlined,
              title: S.current.liveChat,
              networkRequired: true,
              accountRequired: true,
              onTap: () => _showSettingsPrefScreen(SettingsTab.liveChat),
              selected: _isSelected(SettingsTab.liveChat),
            ),
            SettingsTile(
              title: S.current.accessibility,
              onTap: () => _showSettingsPrefScreen(SettingsTab.accessibility),
              selected: _isSelected(SettingsTab.accessibility),
            ),
            SettingsTile(
              title: S.current.watchOnTv,
              onTap: () => _showSettingsPrefScreen(SettingsTab.watchOnTv),
            ),
          ],
        ),
        SettingsSection(
          title: 'Help and Policy',
          children: [
            SettingsTile(
              leadingIcon: YTIcons.help_outlined,
              title: 'Help',
              onTap: () {},
            ),
            SettingsTile(
              leadingIcon: YTIcons.feedbck_outlined,
              title: 'YouTube Terms of Service',
              onTap: () {},
            ),
            SettingsTile(
              leadingIcon: YTIcons.feedbck_outlined,
              title: 'Send feedback',
              onTap: () {},
            ),
            SettingsTile(
              leadingIcon: YTIcons.info_outlined,
              title: S.current.about,
              onTap: () => _showSettingsPrefScreen(SettingsTab.about),
              selected: _isSelected(SettingsTab.about),
            ),
          ],
        ),
        const SettingsSection(title: 'Developer preferences', children: []),
      ],
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: <T>(bool canPop, T? result) => _onNavigateBack(),
      child: Scaffold(
        appBar: AppBar(
          leading: CustomBackButton(onPressed: _onNavigateBack),
          title: Text(_getScreenName(_currentScreen)),
        ),
        body: CustomOrientationBuilder(
          onPortrait: (BuildContext _, Widget? child) {
            return LazyIndexedStack(
              index: _currentScreen.index,
              children: <Widget>[
                settingsList,
                ..._settingsPages,
              ],
            );
          },
          onLandscape: (BuildContext context, Widget? child) {
            final settingsTileSize = context.deviceTheme.settingsTileSize;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: settingsTileSize.widthValueOf(context),
                  child: settingsList,
                ),
                Expanded(
                  child: LazyIndexedStack(
                    index: (_currentScreen.index - 1).clamp(
                      0,
                      SettingsTab.values.length,
                    ),
                    children: _settingsPages,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getScreenName(SettingsTab tab) {
    return switch (tab) {
      SettingsTab.settings => S.current.settings,
      SettingsTab.general => S.current.general,
      SettingsTab.dataSaving => S.current.dataSaving,
      SettingsTab.playback => S.current.playback,
      SettingsTab.videoQualityPref => S.current.videoQualityPref,
      SettingsTab.downloads => S.current.downloads,
      SettingsTab.privacy => S.current.privacy,
      SettingsTab.billsAndPayment => S.current.billsAndPayment,
      SettingsTab.notifications => S.current.notifications,
      SettingsTab.liveChat => S.current.liveChat,
      SettingsTab.accessibility => S.current.accessibility,
      SettingsTab.about => S.current.about,
      _ => S.current.settings,
    };
  }
}

enum SettingsTab {
  settings,
  general,
  dataSaving,
  playback,
  videoQualityPref,
  downloads,
  privacy,
  billsAndPayment,
  notifications,
  liveChat,
  accessibility,
  about,
  captions,
  account,
  addAccount,
  watchOnTv,
  manageAllHistory,
  yourDataInYT,
  tryExperimental,
  purchases,
  connectedApps;

  bool get isSettings => this == settings;
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.divide = true,
  });

  final String title;
  final bool divide;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (divide) ...[
          const Divider(height: 0),
          const SizedBox(height: 12),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4.0,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

Future<void> showAccountDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (_) {
      return PopupContainer(
        title: S.current.account,
        showDismissButtons: false,
        action: const Icon(YTIcons.add_outlined),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: SettingsTile(
            title: S.current.addAccount,
            networkRequired: true,
            onTap: () {},
          ),
        ),
      );
    },
  );
}
