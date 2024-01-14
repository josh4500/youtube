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
import 'package:youtube_clone/presentation/screens/settings/view_models/pref_option.dart';

import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

class DataSavingSettingsScreen extends StatelessWidget {
  const DataSavingSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: SettingsListView(
        children: [
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
              value: false,
            ),
          ),
          SettingsTile(
            title: 'Reduce download quality',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          SettingsTile(
            title: 'Reduce Smart downloads quality',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          SettingsTile(
            title: 'Only download over Wi-Fi and unrestricted mobile data',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          SettingsTile(
            title: 'Upload over Wi-Fi only',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
          SettingsTile(
            title: 'Muted playback in feeds over Wi-Fi only',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
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
              value: false,
            ),
          ),
          SettingsTile(
            title: 'Mobile data usage reminder',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: false,
            ),
          ),
        ],
      ),
    );
  }
}
