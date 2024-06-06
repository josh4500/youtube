import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/preferences.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../controls/player_settings.dart';

Future<dynamic> openSettingsSheet(BuildContext context) async {
  dynamic selection = await showDynamicSheet(
    context,
    items: [
      const DynamicSheetOptionItem(
        leading: Icon(YTIcons.tune_outlined),
        title: 'Quality',
        value: 'Quality',
        trailing: Row(
          children: [
            Text(
              'Auto (360p)',
              style: TextStyle(color: Color(0xFFAAAAAA)),
            ),
            Icon(
              YTIcons.chevron_right,
              size: 16,
              color: Color(0xFFAAAAAA),
            ),
          ],
        ),
      ),
      DynamicSheetOptionItem(
        leading: const Icon(YTIcons.playback_speed_outlined),
        title: 'Playback speed',
        value: 'Playback speed',
        trailing: Row(
          children: [
            Consumer(
              builder: (
                BuildContext context,
                WidgetRef ref,
                Widget? _,
              ) {
                final currentSpeed = ref.read(playerRepositoryProvider).speed;
                return Text(
                  currentSpeed.sRate,
                  style: const TextStyle(color: Color(0xFFAAAAAA)),
                );
              },
            ),
            const Icon(
              YTIcons.chevron_right,
              size: 16,
              color: Color(0xFFAAAAAA),
            ),
          ],
        ),
      ),
      const DynamicSheetOptionItem(
        leading: Icon(Icons.closed_caption_off),
        title: 'Captions',
        value: 'Captions',
        enabled: false,
      ),
      const DynamicSheetOptionItem(
        leading: Icon(YTIcons.private_circle_outlined),
        title: 'Lock screen',
        value: 'Lock screen',
      ),
      const DynamicSheetOptionItem(
        leading: Icon(YTIcons.settings_outlined),
        title: 'Additional settings',
        value: 'Additional settings',
        trailing: Icon(
          YTIcons.chevron_right,
          size: 16,
          color: Color(0xFFAAAAAA),
        ),
      ),
    ],
  );

  if (selection == 'Quality' && context.mounted) {
    await showDynamicSheet(
      context,
      title: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text.rich(
          TextSpan(
            text: 'Quality for current video',
            children: [
              TextSpan(
                text: kDotSeparator,
                style: TextStyle(fontSize: 16, color: Color(0xFFAAAAAA)),
              ),
              TextSpan(
                text: '360',
                style: TextStyle(fontSize: 16, color: Color(0xFFAAAAAA)),
              ),
            ],
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      trailing: const Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(thickness: 1, height: 0),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Text.rich(
              TextSpan(
                text:
                    'This selection only applies to the current video. For all videos, go to',
                children: [
                  TextSpan(
                    text: ' Settings > Video Quality Preferences.',
                    style: TextStyle(color: Color(0xFF3EA6FF)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      items: [
        for (final (title, subtitle) in <(String, String)>[
          (
            'Auto (recommended)',
            'Adjust to give the best experience for your conditions',
          ),
          ('Higher picture quality', 'Uses more data'),
          ('Data saver', 'Lower picture quality'),
          ('Advanced', 'Select a specific resolution'),
        ])
          DynamicSheetOptionItem(
            leading: DynamicSheetItemCheck(
              selected: title == 'Auto (recommended)',
            ),
            title: title,
            subtitle: subtitle,
          ),
      ],
    );
  } else if (selection == 'Playback speed' && context.mounted) {
    selection = await showDynamicSheet(
      context,
      items: [
        for (final speed in PlayerSpeed.values)
          DynamicSheetOptionItem(
            leading: Consumer(
              builder: (
                BuildContext context,
                WidgetRef ref,
                Widget? _,
              ) {
                final currentSpeed = ref.read(playerRepositoryProvider).speed;
                return DynamicSheetItemCheck(selected: speed == currentSpeed);
              },
            ),
            title: speed.sRate,
            value: speed,
          ),
      ],
    );
  } else if (selection == 'Captions' && context.mounted) {
    await showDynamicSheet(
      context,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text('Captions', style: TextStyle(fontSize: 16)),
          ),
          Divider(thickness: 1, height: 0),
        ],
      ),
      trailing: const Column(
        children: [
          Divider(thickness: 1, height: 0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text.rich(
              TextSpan(
                text:
                    'To keep captions on by default, adjust captions visibility in your',
                children: [
                  TextSpan(
                    text: ' device settings.',
                    style: TextStyle(color: Color(0xFF3EA6FF)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      items: [
        for (final title in [
          'Turn off captions',
          'English (auto-generated)',
          'Auto translate',
        ])
          DynamicSheetOptionItem(
            leading: DynamicSheetItemCheck(
              selected: title == 'Turn off captions',
            ),
            title: title,
          ),
      ],
    );
  } else if (selection == 'Additional settings' && context.mounted) {
    selection = await showDynamicSheet(
      context,
      trailing: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        child: Column(
          children: [
            Divider(thickness: 1, height: 0),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(YTIcons.help_outlined),
                SizedBox(width: 16),
                Text('Help & feedback', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
      items: [
        const DynamicSheetOptionItem(
          leading: Icon(YTIcons.loop_outlined),
          title: 'Loop video',
          trailing: PlayerSettingsSwitch(selected: false),
        ),
        DynamicSheetOptionItem(
          leading: const Icon(YTIcons.ambient_mode_outlined),
          title: 'Ambient mode',
          value: 'Ambient mode',
          trailing: Consumer(
            builder: (
              BuildContext context,
              WidgetRef ref,
              Widget? childWidget,
            ) {
              final ambientModeEnabled = ref.watch(
                preferencesProvider.select(
                  (preferences) => preferences.ambientMode,
                ),
              );
              return PlayerSettingsSwitch(selected: ambientModeEnabled);
            },
          ),
        ),
        const DynamicSheetOptionItem(
          leading: Icon(Icons.video_stable),
          title: 'Stable volume',
          enabled: false,
          trailing: PlayerSettingsSwitch(selected: true),
        ),
        const DynamicSheetOptionItem(
          leading: Icon(YTIcons.youtube_music_outlined),
          title: 'Listen with YouTube Music',
          trailing: Icon(YTIcons.external_link_rounded_outlined),
        ),
      ],
    );
  }

  return selection;
}
