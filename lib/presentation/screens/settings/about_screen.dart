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

import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: SettingsListView(
        children: [
          SettingsTile(
            title: 'Help',
            summary: 'Find answers to your YouTube questions here',
            onTap: () {},
          ),
          SettingsTile(
            title: 'Send feedback',
            summary: 'Help us make YouTube better',
            onTap: () {},
          ),
          SettingsTile(
            title: 'YouTube Terms of Service',
            summary: 'Read Youtube\'s Terms of Service',
            onTap: () {},
          ),
          SettingsTile(
            title: 'Google Privacy Policy',
            summary: ' Read Mobile Privacy Policy',
            onTap: () {},
          ),
          SettingsTile(
            title: 'Open source licences',
            summary: 'Licence details for open source software',
            onTap: () {},
          ),
          SettingsTile(
            title: 'App version',
            summary: '18.49.34',
            onTap: () {},
          ),
          SettingsTile(
            title: 'YouTube, a Google company',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
