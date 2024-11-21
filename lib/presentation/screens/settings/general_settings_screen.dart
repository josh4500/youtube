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
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/core/enums/settings_enums.dart';
import 'package:youtube_clone/core/utils/duration.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'view_models/pref_option.dart';
import 'widgets/date_range_picker.dart';
import 'widgets/frequency_picker.dart';
import 'widgets/round_check_item.dart';
import 'widgets/settings_list_view.dart';
import 'widgets/settings_tile.dart';

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
    final PreferenceState preferences = ref.watch(preferencesProvider);
    return Material(
      child: SettingsListView(
        children: <Widget>[
          SettingsTile(
            title: 'Remind me to take a break',
            onGenerateSummary: (_) {
              final RemindForBreak remindForBreak = preferences.remindForBreak;
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
                      enabled: !preferences.remindForBreak.enabled,
                    );
              },
            ),
            onTap: _onChangeRemindForBreak,
          ),
          SettingsTile(
            title: 'Remind me when it\'s bedtime',
            accountRequired: true,
            onGenerateSummary: (_) {
              final RemindForBedtime remindForBedtime =
                  preferences.remindForBedtime;
              if (remindForBedtime.enabled) {
                if (remindForBedtime.onDeviceBedtime) {
                  return 'When my phone\'s bedtime mode is on';
                } else {
                  final Duration start = remindForBedtime.customStartSchedule;
                  final Duration stop = remindForBedtime.customStopSchedule;
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
    final PreferenceState preferences = ref.read(preferencesProvider);

    // Set the initial value to the controller
    final PopupContainerController<Duration> controller =
        PopupContainerController(
      value: preferences.remindForBreak.frequency,
    );

    final Duration? affirmedChanges = await showDialog<Duration>(
      context: context,
      builder: (_) {
        return PopupContainer<Duration>(
          controller: controller,
          title: 'Reminder frequency',
          density: VisualDensity.compact,
          showAffirmButton: true,
          child: FrequencyPicker(
            onChange: (Duration frequency) {
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
    final PreferenceState preferences = ref.read(preferencesProvider);
    // Controller popup
    final PopupContainerController<RemindForBedtime> controller =
        PopupContainerController<RemindForBedtime>(
      value: preferences.remindForBedtime,
    );
    // State value for popup
    RemindForBedtime remindForBedTimeState = preferences.remindForBedtime;
    final RemindForBedtime? affirmedChanges =
        await showDialog<RemindForBedtime>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return PopupContainer<RemindForBedtime>(
              title: 'Remind me when it\'s bedtime',
              showAffirmButton: true,
              controller: controller,
              child: Column(
                children: <Widget>[
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
                    onChange: (TwoState? value) {
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
                    onChange: (TwoState? value) {
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
                      onStartChange: (Duration duration) {
                        setState(() {
                          controller.value = remindForBedTimeState =
                              remindForBedTimeState.copyWith(
                            customStartSchedule: duration,
                          );
                        });
                      },
                      onStopChange: (Duration duration) {
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
                      children: <Widget>[
                        Checkbox(
                          value: remindForBedTimeState.waitTillFinishVideo,
                          onChanged: (bool? value) {
                            setState(() {
                              remindForBedTimeState = remindForBedTimeState
                                  .copyWith(waitTillFinishVideo: value);
                              controller.value = remindForBedTimeState;
                            });
                          },
                        ),
                        const Text(
                          'Wait until I finish video to show reminder',
                        ),
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
    final ThemeMode? result = await showAdaptiveDialog<ThemeMode>(
      context: context,
      builder: (BuildContext context) {
        return PopupContainer<ThemeMode>.builder(
          title: 'Appearance',
          capitalizeDismissButtons: true,
          itemBuilder: (BuildContext _, int index) {
            final ThemeMode themeMode = ThemeMode.values[index];
            final String title = themeMode.isDark
                ? 'Dark theme'
                : themeMode.isSystem
                    ? 'Use system theme'
                    : 'Light theme';

            return Consumer(
              builder: (BuildContext context, WidgetRef ref, _) {
                final preferences = ref.watch(preferencesProvider);
                return RoundCheckItem<ThemeMode>(
                  title: title,
                  value: themeMode,
                  groupValue: preferences.themeMode,
                  onChange: (ThemeMode? value) {
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
    final PlaybackInFeeds? result = await showDialog<PlaybackInFeeds>(
      context: context,
      builder: (_) {
        return PopupContainer<PlaybackInFeeds>.builder(
          title: 'Playback in feeds',
          itemBuilder: (_, int index) {
            final PlaybackInFeeds playbackInFeeds =
                PlaybackInFeeds.values[index];
            final String title = playbackInFeeds == PlaybackInFeeds.alwaysOn
                ? 'Always on'
                : playbackInFeeds == PlaybackInFeeds.wifiOnly
                    ? 'Wi-Fi only'
                    : 'Off';
            return Consumer(
              builder: (BuildContext context, WidgetRef ref, _) {
                final PreferenceState preferences =
                    ref.watch(preferencesProvider);
                return RoundCheckItem<PlaybackInFeeds>(
                  title: title,
                  value: playbackInFeeds,
                  groupValue: preferences.playbackInFeeds,
                  onChange: (PlaybackInFeeds? value) {
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
    final int? result = await showDialog<int>(
      context: context,
      builder: (_) {
        return PopupContainer<int>.builder(
          title: 'Double-tap to seek',
          itemBuilder: (_, int index) {
            final int seekSeconds = <int>[5, 10, 15, 20, 30, 60][index];
            return Consumer(
              builder: (BuildContext context, WidgetRef ref, _) {
                final PreferenceState preferences =
                    ref.watch(preferencesProvider);
                return RoundCheckItem<int>(
                  title: '$seekSeconds',
                  value: seekSeconds,
                  groupValue: preferences.doubleTapSeek,
                  onChange: (int? value) {
                    if (value != null) {
                      context.pop(value);
                    }
                  },
                );
              },
            );
          },
          itemCount: <int>[5, 10, 15, 20, 30, 60].length,
        );
      },
    );
    if (result != null) {
      ref.read(preferencesProvider.notifier).doubleTapSeek = result;
    }
  }

  void _onChangeZoomFill(bool value) {
    debugPrint('Change Zoom Fill');
    ref.read(preferencesProvider.notifier).zoomFillScreen = value;
  }

  Future<void> _onChangeUploads() async {
    final UploadNetwork? result = await showDialog<UploadNetwork>(
      context: context,
      builder: (_) {
        return PopupContainer<UploadNetwork>.builder(
          title: 'Uploads',
          itemBuilder: (_, int index) {
            final UploadNetwork uploadNetwork = UploadNetwork.values[index];
            final String title = uploadNetwork == UploadNetwork.onlyWifi
                ? 'Only when on Wi-Fi'
                : 'On any network';

            return Consumer(
              builder: (BuildContext context, WidgetRef ref, _) {
                final PreferenceState preferences =
                    ref.watch(preferencesProvider);
                return RoundCheckItem<UploadNetwork>(
                  title: title,
                  value: uploadNetwork,
                  groupValue: preferences.uploadNetwork,
                  onChange: (UploadNetwork? value) {
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
      _showDataSettingsAffect();
    }
  }

  void _showDataSettingsAffect() {
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

  void _changeRestrictedMode(bool value) {
    debugPrint('Changed Restricted Mode');
    ref.read(preferencesProvider.notifier).restrictedMode = value;
  }

  void _changeEnableStatsForNerds(bool value) {
    debugPrint('Changed stats');
    ref.read(preferencesProvider.notifier).enableStatsForNerds = value;
  }
}

enum TwoState { first, second }
