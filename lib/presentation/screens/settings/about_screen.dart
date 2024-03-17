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

import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SettingsListView(
        children: <Widget>[
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
