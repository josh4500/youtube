import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/settings/view_models/pref_option.dart';

import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: SettingsListView(
        children: [
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
