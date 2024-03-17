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

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SettingsListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Mobile notifications',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SettingsTile(
            title: 'Scheduled digest',
            summary:
                'Get all your notifications as a daily digest at 19:00. Tap to customize delivery time',
            prefOption: PrefOption(
              type: PrefOptionType.toggleWithOptions,
              value: true,
            ),
          ),
          SettingsTile(
            title: 'Subscriptions',
            summary:
                'Notify me about activity from the channels I\'m subscribed to',
            prefOption: PrefOption(
              type: PrefOptionType.toggleWithOptions,
              value: true,
            ),
          ),
          SettingsTile(
            title: 'Channel settings',
            summary:
                'Tap here to manage notification settings for each subscribed channel',
            onTap: () {},
          ),
          SettingsTile(
            title: 'Recommended videos',
            summary: 'Notify me of videos I might like based on what I watch',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: true,
            ),
          ),
          SettingsTile(
            title: 'Recommended ways to create',
            summary: 'Notify me with recommended trends and ways to create',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: true,
            ),
          ),
          SettingsTile(
            title: 'Activity on my channel',
            summary:
                'Notify me about comments and other activity on my channel or videos',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: true,
            ),
          ),
          SettingsTile(
            title: 'Replies to my comments',
            summary: 'Notify me about replies to my comments',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: true,
            ),
          ),
          SettingsTile(
            title: 'Mentions',
            summary: 'Notify me when others mention my channel',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: true,
            ),
          ),
          SettingsTile(
            title: 'Shared content',
            summary: 'Notify me when others share my content on their channels',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: true,
            ),
          ),
          SettingsTile(
            title: 'Product updates',
            summary: 'Notify me of new product updates and announcements',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: true,
            ),
          ),
          SettingsTile(
            title: 'Promotional content and offerings',
            summary:
                'Notify me of promotional content and offerings, like members-only perks',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: true,
            ),
          ),
          SettingsTile(
            title: 'Watch on TV',
            summary: 'Suggest videos I might like to watch on TV',
            prefOption: PrefOption(
              type: PrefOptionType.toggle,
              value: true,
            ),
          ),
          SettingsTile(
            title: 'Disable sounds & vibrations',
            summary:
                'Silence notifications during the hours you specify. Tap to customize time.',
            prefOption: PrefOption(
              type: PrefOptionType.toggleWithOptions,
              value: true,
            ),
          ),
        ],
      ),
    );
  }
}
