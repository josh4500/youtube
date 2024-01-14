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
