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
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/core/enums/settings_enums.dart';
import 'package:youtube_clone/core/utils/duration.dart';
import 'package:youtube_clone/presentation/preferences.dart';
import 'package:youtube_clone/presentation/screens/settings/view_models/pref_option.dart';
import 'package:youtube_clone/presentation/screens/settings/widgets/frequency_picker.dart';
import 'package:youtube_clone/presentation/screens/settings/widgets/round_check_item.dart';
import 'package:youtube_clone/presentation/screens/settings/widgets/settings_tile.dart';
import 'package:youtube_clone/presentation/theme/app_style.dart';

import 'widgets/date_range_picker.dart';
import 'widgets/settings_list_view.dart';
import 'widgets/settings_popup_container.dart';

class GeneralSettingsScreen extends ConsumerStatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  ConsumerState<GeneralSettingsScreen> createState() =>
      _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends ConsumerState<GeneralSettingsScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(preferencesProvider);
    return Material(
      type: MaterialType.canvas,
      child: SettingsListView(
        children: [
          SettingsTile(
            title: 'Remind me to take a break',
            onGenerateSummary: (_) {
              final remindForBreak = preferences.remindForBreak;
              if (remindForBreak.enabled) {
                return 'Every ${remindForBreak.frequency.hoursMinutesWords}';
              } else {
                return 'Off';
              }
            },
            prefOption: PrefOption<bool>(
              type: PrefOptionType.toggleWithOptions,
              value: preferences.remindForBreak.enabled,
              onToggle: () {
                // Opens settings anyway
                if (!preferences.remindForBreak.enabled) {
                  _onChangeRemindForBreak();
                }
                ref.read(preferencesProvider.notifier).changeRemindForBreak(
                    enabled: !preferences.remindForBreak.enabled);
              },
            ),
            onTap: _onChangeRemindForBreak,
          ),
          SettingsTile(
            title: 'Remind me when it\'s bedtime',
            onGenerateSummary: (_) {
              final remindForBedtime = preferences.remindForBedtime;
              if (remindForBedtime.enabled) {
                if (remindForBedtime.onDeviceBedtime) {
                  return 'When my phone\'s bedtime mode is on';
                } else {
                  final start = remindForBedtime.customStartSchedule;
                  final stop = remindForBedtime.customStopSchedule;
                  return '${start.hoursMinutes} - ${stop.hoursMinutes}';
                }
              } else {
                return 'Off';
              }
            },
            prefOption: PrefOption<bool>(
              type: PrefOptionType.toggleWithOptions,
              value: preferences.remindForBedtime.enabled,
              onToggle: () async {
                // Opens settings anyway
                if (!preferences.remindForBedtime.enabled) {
                  await _onChangeRemindForBedtime();
                }
                ref.read(preferencesProvider.notifier).changeRemindForBedTime(
                      enabled: !preferences.remindForBedtime.enabled,
                    );
              },
            ),
            onTap: _onChangeRemindForBedtime,
          ),
          SettingsTile(
            title: 'Appearance',
            summary: 'Choose your light or dark theme preference',
            onTap: _onChangeAppearance,
          ),
          const SettingsTile(
            title: 'App language',
            summary: 'English (United States)',
            networkRequired: true,
            disableOnNoNetwork: true,
          ),
          SettingsTile(
            title: 'Playback in feeds',
            summary: 'Choose whether videos play as you browse',
            onTap: _onChangePlaybackInFeeds,
            networkRequired: true,
          ),
          SettingsTile(
            title: 'Double-tap to seek',
            summary: '${preferences.doubleTapSeek} seconds',
            onTap: _onChangeDoubleTapSeek,
          ),
          SettingsTile(
            title: 'Zoom to fill screen',
            summary:
                'Always zoom so that videos fill the screen in full screen',
            prefOption: PrefOption<bool>(
              type: PrefOptionType.toggle,
              value: preferences.zoomFillScreen,
              onToggle: () {
                _onChangeZoomFill(!preferences.zoomFillScreen);
              },
            ),
            onTap: () {
              _onChangeZoomFill(!preferences.zoomFillScreen);
            },
            networkRequired: true,
          ),
          SettingsTile(
            title: 'Uploads',
            summary: 'Specify network preferences for uploads',
            onTap: _onChangeUploads,
          ),
          const SettingsTile(
            title: 'Voice search language',
            summary: 'Default',
          ),
          const SettingsTile(
            title: 'Location',
            summary: 'United States',
            networkRequired: true,
            disableOnNoNetwork: true,
          ),
          SettingsTile(
            title: 'Restricted Mode',
            summary:
                'This helps hide potential mature videos. No filter is 100% accurate. This setting only applies to this app on this device',
            prefOption: PrefOption<bool>(
              type: PrefOptionType.toggle,
              value: preferences.restrictedMode,
              onToggle: () {
                _changeRestrictedMode(!preferences.restrictedMode);
              },
            ),
            onTap: () {
              _changeRestrictedMode(!preferences.restrictedMode);
            },
            networkRequired: true,
          ),
          SettingsTile(
            title: 'Enable stats for nerds',
            prefOption: PrefOption<bool>(
              type: PrefOptionType.toggleWithOptions,
              value: preferences.enableStatsForNerds,
              onToggle: () {
                _changeEnableStatsForNerds(!preferences.enableStatsForNerds);
              },
            ),
            onTap: () {
              _changeEnableStatsForNerds(!preferences.enableStatsForNerds);
            },
          ),
        ],
      ),
    );
  }

  /// Shows a Reminder frequency popup to change remind time settings
  Future<void> _onChangeRemindForBreak() async {
    final preferences = ref.read(preferencesProvider);

    // Set the initial value to the controller
    final controller = SettingsPopupContainerController(
      value: preferences.remindForBreak.frequency,
    );

    final affirmedChanges = await showDialog<Duration>(
      context: context,
      builder: (_) {
        return SettingsPopupContainer<Duration>(
          controller: controller,
          title: 'Reminder frequency',
          density: VisualDensity.compact,
          showAffirmButton: true,
          child: FrequencyPicker(
            onChange: (frequency) {
              controller.value = frequency;
            },
            initialDuration: preferences.remindForBreak.frequency,
          ),
        );
      },
    );

    // Note: Use the value from the affirmedChanges instead controller because it contains
    // value of affirmed changes
    ref.read(preferencesProvider.notifier).changeRemindForBreak(
          frequency: affirmedChanges,
          enabled:
              affirmedChanges != null || preferences.remindForBreak.enabled,
        );
  }

  Future<void> _onChangeRemindForBedtime() async {
    final preferences = ref.read(preferencesProvider);
    // Controller popup
    final controller = SettingsPopupContainerController<RemindForBedtime>(
      value: preferences.remindForBedtime,
    );
    // State value for popup
    RemindForBedtime remindForBedTimeState = preferences.remindForBedtime;
    final affirmedChanges = await showDialog<RemindForBedtime>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SettingsPopupContainer<RemindForBedtime>(
              title: 'Remind me when it\'s bedtime',
              showAffirmButton: true,
              controller: controller,
              child: Column(
                children: [
                  RoundCheckItem<TwoState>(
                    title: 'When my phone\'s bedtime mode is on',
                    value: TwoState.first,
                    subtitle: remindForBedTimeState.onDeviceBedtime
                        ? const Text(
                            'Manage device settings',
                          )
                        : null,
                    groupValue: remindForBedTimeState.onDeviceBedtime
                        ? TwoState.first
                        : TwoState.second,
                    onChange: (value) {
                      setState(() {
                        remindForBedTimeState = remindForBedTimeState.copyWith(
                          onDeviceBedtime: value == TwoState.first,
                        );
                        controller.value = remindForBedTimeState;
                      });
                    },
                  ),
                  RoundCheckItem<TwoState>(
                    title: 'Use custom schedule',
                    value: TwoState.second,
                    groupValue: remindForBedTimeState.onDeviceBedtime
                        ? TwoState.first
                        : TwoState.second,
                    onChange: (value) {
                      setState(() {
                        remindForBedTimeState = remindForBedTimeState.copyWith(
                          onDeviceBedtime: value == TwoState.first,
                        );
                        controller.value = remindForBedTimeState;
                      });
                    },
                  ),
                  if (!remindForBedTimeState.onDeviceBedtime)
                    DateRangePicker(
                      initialStart: remindForBedTimeState.customStartSchedule,
                      initialStop: remindForBedTimeState.customStopSchedule,
                      onStartChange: (duration) {
                        setState(() {
                          controller.value = remindForBedTimeState =
                              remindForBedTimeState.copyWith(
                            customStartSchedule: duration,
                          );
                        });
                      },
                      onStopChange: (duration) {
                        setState(() {
                          controller.value = remindForBedTimeState =
                              remindForBedTimeState.copyWith(
                            customStopSchedule: duration,
                          );
                        });
                      },
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: remindForBedTimeState.waitTillFinishVideo,
                          onChanged: (value) {
                            setState(() {
                              remindForBedTimeState = remindForBedTimeState
                                  .copyWith(waitTillFinishVideo: value);
                              controller.value = remindForBedTimeState;
                            });
                          },
                        ),
                        const Text('Wait until I finish video to show reminder')
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );

    ref.read(preferencesProvider.notifier).changeRemindForBedTime(
          remindForBedtime: affirmedChanges,
          enabled:
              affirmedChanges != null || preferences.remindForBreak.enabled,
        );
  }

  Future<void> _onChangeAppearance() async {
    final result = await showDialog<ThemeMode>(
      context: context,
      builder: (_) {
        return SettingsPopupContainer<ThemeMode>.builder(
          title: 'Appearance',
          capitalizeDismissButtons: true,
          itemBuilder: (_, index) {
            final themeMode = ThemeMode.values[index];
            final title = themeMode.isDark
                ? 'Dark theme'
                : themeMode.isSystem
                    ? 'Use system theme'
                    : 'Light theme';

            return Consumer(
              builder: (context, ref, _) {
                final preferences = ref.watch(preferencesProvider);
                return RoundCheckItem<ThemeMode>(
                  title: title,
                  value: themeMode,
                  groupValue: preferences.themeMode,
                  onChange: (value) {
                    if (value != null) {
                      context.pop(value);
                    }
                  },
                );
              },
            );
          },
          itemCount: ThemeMode.values.length,
        );
      },
    );
    if (result != null) {
      ref.read(preferencesProvider.notifier).themeMode = result;
    }
  }

  Future<void> _onChangePlaybackInFeeds() async {
    final result = await showDialog<PlaybackInFeeds>(
      context: context,
      builder: (_) {
        return SettingsPopupContainer<PlaybackInFeeds>.builder(
          title: 'Playback in feeds',
          itemBuilder: (_, index) {
            final playbackInFeeds = PlaybackInFeeds.values[index];
            final title = playbackInFeeds == PlaybackInFeeds.alwaysOn
                ? 'Always on'
                : playbackInFeeds == PlaybackInFeeds.wifiOnly
                    ? 'Wi-Fi only'
                    : 'Off';
            return Consumer(
              builder: (context, ref, _) {
                final preferences = ref.watch(preferencesProvider);
                return RoundCheckItem<PlaybackInFeeds>(
                  title: title,
                  value: playbackInFeeds,
                  groupValue: preferences.playbackInFeeds,
                  onChange: (value) {
                    if (value != null) {
                      context.pop(value);
                    }
                  },
                );
              },
            );
          },
          itemCount: PlaybackInFeeds.values.length,
        );
      },
    );
    if (result != null) {
      ref.read(preferencesProvider.notifier).playbackInFeeds = result;
    }
  }

  Future<void> _onChangeDoubleTapSeek() async {
    final result = await showDialog<int>(
      context: context,
      builder: (_) {
        return SettingsPopupContainer<int>.builder(
          title: 'Double-tap to seek',
          itemBuilder: (_, index) {
            final seekSeconds = [5, 10, 15, 20, 30, 60][index];
            return Consumer(
              builder: (context, ref, _) {
                final preferences = ref.watch(preferencesProvider);
                return RoundCheckItem<int>(
                  title: '$seekSeconds',
                  value: seekSeconds,
                  groupValue: preferences.doubleTapSeek,
                  onChange: (value) {
                    if (value != null) {
                      context.pop(value);
                    }
                  },
                );
              },
            );
          },
          itemCount: [5, 10, 15, 20, 30, 60].length,
        );
      },
    );
    if (result != null) {
      ref.read(preferencesProvider.notifier).doubleTapSeek = result;
    }
  }

  void _onChangeZoomFill(bool value) {
    ref.read(preferencesProvider.notifier).zoomFillScreen = value;
  }

  Future<void> _onChangeUploads() async {
    final result = await showDialog<UploadNetwork>(
      context: context,
      builder: (_) {
        return SettingsPopupContainer<UploadNetwork>.builder(
          title: 'Uploads',
          itemBuilder: (_, index) {
            final uploadNetwork = UploadNetwork.values[index];
            final title = uploadNetwork == UploadNetwork.onlyWifi
                ? 'Only when on Wi-Fi'
                : 'On any network';

            return Consumer(
              builder: (context, ref, _) {
                final preferences = ref.watch(preferencesProvider);
                return RoundCheckItem<UploadNetwork>(
                  title: title,
                  value: uploadNetwork,
                  groupValue: preferences.uploadNetwork,
                  onChange: (value) {
                    if (value != null) {
                      context.pop(value);
                    }
                  },
                );
              },
            );
          },
          itemCount: UploadNetwork.values.length,
        );
      },
    );
    if (result != null) {
      ref.read(preferencesProvider.notifier).uploadNetwork = result;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            dismissDirection: DismissDirection.down,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            content: const Text(
              'This changes will affect your data saving settings',
            ),
            action: SnackBarAction(
              label: 'View',
              textColor: AppStyle.settingsTextButtonTextStyle.light.color,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  void _changeRestrictedMode(bool value) {
    ref.read(preferencesProvider.notifier).restrictedMode = value;
  }

  void _changeEnableStatsForNerds(bool value) {
    ref.read(preferencesProvider.notifier).enableStatsForNerds = value;
  }
}

enum TwoState { first, second }
