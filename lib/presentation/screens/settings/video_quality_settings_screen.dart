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
import 'package:youtube_clone/core/enums/settings_enums.dart';
import 'package:youtube_clone/presentation/preferences.dart';
import 'package:youtube_clone/presentation/screens/settings/view_models/pref_option.dart';

import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

class VideoQualitySettingsScreen extends ConsumerWidget {
  const VideoQualitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesProvider);
    return Material(
      type: MaterialType.canvas,
      child: SettingsListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Text(
              'Select your default streaming quality for all videos. You can change streaming quality in player options for single videos.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFAAAAAA),
              ),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'VIDEO QUALITY ON MOBILE NETWORKS',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SettingsTile(
            title: 'Auto (recommend)',
            summary:
                'Adjust to give you the best experience for your conditions',
            prefOption: PrefOption(
              type: PrefOptionType.radio,
              value: VideoQuality.auto,
              groupValue: preferences.videoQualityPreferences.mobile,
              onToggle: () => _changeMobileVideoQuality(VideoQuality.auto, ref),
            ),
            onTap: () => _changeMobileVideoQuality(VideoQuality.auto, ref),
          ),
          SettingsTile(
            title: 'Higher picture quality',
            summary: 'User more data',
            prefOption: PrefOption(
              type: PrefOptionType.radio,
              value: VideoQuality.higher,
              groupValue: preferences.videoQualityPreferences.mobile,
              onToggle: () =>
                  _changeMobileVideoQuality(VideoQuality.higher, ref),
            ),
            onTap: () => _changeMobileVideoQuality(VideoQuality.higher, ref),
          ),
          SettingsTile(
            title: 'Data saver',
            summary: 'Lower quality picture',
            prefOption: PrefOption(
              type: PrefOptionType.radio,
              value: VideoQuality.saver,
              groupValue: preferences.videoQualityPreferences.mobile,
              onToggle: () =>
                  _changeMobileVideoQuality(VideoQuality.saver, ref),
            ),
            onTap: () => _changeMobileVideoQuality(VideoQuality.saver, ref),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'VIDEO QUALITY ON WIFI',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SettingsTile(
            title: 'Auto (recommend)',
            summary:
                'Adjust to give you the best experience for your conditions',
            prefOption: PrefOption(
              type: PrefOptionType.radio,
              value: VideoQuality.auto,
              groupValue: preferences.videoQualityPreferences.wifi,
              onToggle: () => _changeWifiVideoQuality(VideoQuality.auto, ref),
            ),
            onTap: () => _changeWifiVideoQuality(VideoQuality.auto, ref),
          ),
          SettingsTile(
            title: 'Higher picture quality',
            summary: 'User more data',
            prefOption: PrefOption(
              type: PrefOptionType.radio,
              value: VideoQuality.higher,
              groupValue: preferences.videoQualityPreferences.wifi,
              onToggle: () => _changeWifiVideoQuality(VideoQuality.higher, ref),
            ),
            onTap: () => _changeWifiVideoQuality(VideoQuality.higher, ref),
          ),
          SettingsTile(
            title: 'Data saver',
            summary: 'Lower quality picture',
            prefOption: PrefOption(
              type: PrefOptionType.radio,
              value: VideoQuality.saver,
              groupValue: preferences.videoQualityPreferences.wifi,
              onToggle: () => _changeWifiVideoQuality(VideoQuality.saver, ref),
            ),
            onTap: () => _changeWifiVideoQuality(VideoQuality.saver, ref),
          ),
        ],
      ),
    );
  }

  void _changeWifiVideoQuality(VideoQuality quality, WidgetRef ref) {
    ref.read(preferencesProvider.notifier).changeVideoQuality(wifi: quality);
  }

  void _changeMobileVideoQuality(VideoQuality quality, WidgetRef ref) {
    ref.read(preferencesProvider.notifier).changeVideoQuality(mobile: quality);
  }
}
