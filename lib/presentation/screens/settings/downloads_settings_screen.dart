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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/preferences.dart';
import 'package:youtube_clone/presentation/screens/settings/view_models/pref_option.dart';

import '../../widgets/download_storage_usage.dart';
import 'widgets/round_check_item.dart';
import 'widgets/settings_list_view.dart';
import 'widgets/settings_popup_container.dart';
import 'widgets/settings_tile.dart';

class DownloadsSettingsScreen extends ConsumerStatefulWidget {
  const DownloadsSettingsScreen({super.key});

  @override
  ConsumerState<DownloadsSettingsScreen> createState() =>
      _DownloadsSettingsScreenState();
}

class _DownloadsSettingsScreenState
    extends ConsumerState<DownloadsSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(preferencesProvider);
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
            onGenerateSummary: (pref) {
              return generateDownloadQualityTitle(pref.value);
            },
            prefOption: PrefOption<int>(
              type: PrefOptionType.options,
              value: preferences.downloadPreferences.quality,
            ),
            onTap: _onChangeDownloadQuality,
          ),
          SettingsTile(
            title: 'Download over Wi-Fi',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              onToggle: _changeWifiOnly,
              value: preferences.downloadPreferences.wifiOnly,
            ),
            onTap: _changeWifiOnly,
          ),
          SettingsTile(
            title: 'Recommend downloads',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              onToggle: _changeWifiOnly,
              value: preferences.downloadPreferences.recommend,
            ),
            onTap: _changeRecommend,
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

  void _changeWifiOnly() {
    final wifiOnly =
        !ref.read(preferencesProvider).downloadPreferences.wifiOnly;
    ref
        .read(preferencesProvider.notifier)
        .changeDownloadsPref(wifiOnly: wifiOnly);
  }

  void _changeRecommend() {
    final recommend =
        !ref.read(preferencesProvider).downloadPreferences.recommend;
    ref
        .read(preferencesProvider.notifier)
        .changeDownloadsPref(recommend: recommend);
  }

  Future<void> _onChangeDownloadQuality() async {
    final qualities = [0, 1080, 720, 360, 144];
    final result = await showDialog<int>(
      context: context,
      builder: (_) {
        return SettingsPopupContainer<int>.builder(
          title: 'Download quality',
          itemBuilder: (_, index) {
            final quality = qualities[index];
            final title = generateDownloadQualityTitle(quality);

            return Consumer(
              builder: (context, ref, _) {
                final preferences = ref.watch(preferencesProvider);
                return RoundCheckItem<int>(
                  title: title,
                  value: quality,
                  groupValue: preferences.downloadPreferences.quality,
                  onChange: (value) {
                    if (value != null) {
                      context.pop(value);
                    }
                  },
                );
              },
            );
          },
          itemCount: qualities.length,
        );
      },
    );
    ref.read(preferencesProvider.notifier).changeDownloadsPref(quality: result);
  }

  String generateDownloadQualityTitle(int quality) {
    switch (quality) {
      case 1080:
        return 'Full HD (1080p)';
      case 720:
        return 'High (720p)';
      case 360:
        return 'Medium (360p)';
      case 144:
        return 'Low (144p)';
    }
    return 'Ask each time';
  }
}
