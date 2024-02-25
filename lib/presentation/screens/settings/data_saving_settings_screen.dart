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
