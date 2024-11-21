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
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/screens/settings/view_models/pref_option.dart';

import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

class DataSavingSettingsScreen extends ConsumerWidget {
  const DataSavingSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PreferenceState preferences = ref.watch(preferencesProvider);
    final DataSavingPreferences dataSavingPreferences =
        preferences.dataSavingPreferences;
    return Material(
      child: SettingsListView(
        children: <Widget>[
          SettingsTile(
            title: 'Data Saving mode',
            summary: 'Automatically adjusts settings to save mobile data',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          const SizedBox(height: 28),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Text(
              'Default settings',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SettingsTile(
            title: 'Reduce video quality',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: dataSavingPreferences.reduceVideoQuality,
              onToggle: () =>
                  _changeReduceVideoQuality(dataSavingPreferences, ref),
            ),
            onTap: () => _changeReduceVideoQuality(dataSavingPreferences, ref),
          ),
          SettingsTile(
            title: 'Reduce download quality',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: dataSavingPreferences.reduceDownloadQuality,
              onToggle: () =>
                  _changeReduceDownloadQuality(dataSavingPreferences, ref),
            ),
            onTap: () =>
                _changeReduceDownloadQuality(dataSavingPreferences, ref),
          ),
          SettingsTile(
            title: 'Reduce Smart downloads quality',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: dataSavingPreferences.reduceSmartDownloadQuality,
              onToggle: () =>
                  _changeReduceSmartQuality(dataSavingPreferences, ref),
            ),
            onTap: () => _changeReduceSmartQuality(dataSavingPreferences, ref),
          ),
          SettingsTile(
            title: 'Only download over Wi-Fi and unrestricted mobile data',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: dataSavingPreferences.onlyWifiUpload,
              onToggle: () => _changeOnlyWifiUpload(dataSavingPreferences, ref),
            ),
            onTap: () => _changeOnlyWifiUpload(dataSavingPreferences, ref),
          ),
          SettingsTile(
            title: 'Upload over Wi-Fi only',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: dataSavingPreferences.onlyWifiUpload,
              onToggle: () => _changeOnlyWifiUpload(dataSavingPreferences, ref),
            ),
            onTap: () => _changeOnlyWifiUpload(dataSavingPreferences, ref),
          ),
          SettingsTile(
            title: 'Muted playback in feeds over Wi-Fi only',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: dataSavingPreferences.mutedPlaybackOnWifi,
              onToggle: () =>
                  _changeMutedPlaybackOnWifi(dataSavingPreferences, ref),
            ),
            onTap: () => _changeMutedPlaybackOnWifi(dataSavingPreferences, ref),
          ),
          const Divider(
            thickness: 4,
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4,
            ),
            child: Text(
              'Data monitoring & control',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SettingsTile(
            title: 'Select quality for every video',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: dataSavingPreferences.selectVideoQuality,
              onToggle: () =>
                  _changeSelectVideoQuality(dataSavingPreferences, ref),
            ),
            onTap: () => _changeSelectVideoQuality(dataSavingPreferences, ref),
          ),
          SettingsTile(
            title: 'Mobile data usage reminder',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: dataSavingPreferences.usageReminder,
              onToggle: () => _changeUsageReminder(dataSavingPreferences, ref),
            ),
            onTap: () => _changeUsageReminder(dataSavingPreferences, ref),
          ),
        ],
      ),
    );
  }

  _changeReduceVideoQuality(
    DataSavingPreferences dataSavingPreferences,
    WidgetRef ref,
  ) {
    ref.read(preferencesProvider.notifier).dataSaving =
        dataSavingPreferences.copyWith(
      reduceVideoQuality: !dataSavingPreferences.reduceVideoQuality,
    );
  }

  _changeUsageReminder(
    DataSavingPreferences dataSavingPreferences,
    WidgetRef ref,
  ) {
    ref.read(preferencesProvider.notifier).dataSaving =
        dataSavingPreferences.copyWith(
      usageReminder: !dataSavingPreferences.usageReminder,
    );
  }

  _changeSelectVideoQuality(
    DataSavingPreferences dataSavingPreferences,
    WidgetRef ref,
  ) {
    ref.read(preferencesProvider.notifier).dataSaving =
        dataSavingPreferences.copyWith(
      selectVideoQuality: !dataSavingPreferences.selectVideoQuality,
    );
  }

  _changeMutedPlaybackOnWifi(
    DataSavingPreferences dataSavingPreferences,
    WidgetRef ref,
  ) {
    ref.read(preferencesProvider.notifier).dataSaving =
        dataSavingPreferences.copyWith(
      mutedPlaybackOnWifi: !dataSavingPreferences.mutedPlaybackOnWifi,
    );
  }

  _changeOnlyWifiUpload(
    DataSavingPreferences dataSavingPreferences,
    WidgetRef ref,
  ) {
    ref.read(preferencesProvider.notifier).dataSaving =
        dataSavingPreferences.copyWith(
      onlyWifiUpload: !dataSavingPreferences.onlyWifiUpload,
    );
  }

  _changeReduceSmartQuality(
    DataSavingPreferences dataSavingPreferences,
    WidgetRef ref,
  ) {
    ref.read(preferencesProvider.notifier).dataSaving =
        dataSavingPreferences.copyWith(
      reduceSmartDownloadQuality:
          !dataSavingPreferences.reduceSmartDownloadQuality,
    );
  }

  _changeReduceDownloadQuality(
    DataSavingPreferences dataSavingPreferences,
    WidgetRef ref,
  ) {
    ref.read(preferencesProvider.notifier).dataSaving =
        dataSavingPreferences.copyWith(
      reduceDownloadQuality: !dataSavingPreferences.reduceDownloadQuality,
    );
  }
}
