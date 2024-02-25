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
