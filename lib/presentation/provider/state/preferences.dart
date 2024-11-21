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

import 'dart:convert';

import 'package:country_selector/country_selector.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/core.dart';
import 'package:youtube_clone/infrastructure.dart';

part 'preferences.g.dart';

@riverpod
class Preferences extends _$Preferences {
  /// Dynamic Preference [SharedPrefProvider]
  static final SharedPrefProvider _prefBox = SharedPrefProvider('preferences');

  final ReadWriteValue<bool> _ambientMode = ReadWriteValue<bool>(
    'ambientMode',
    false,
    _prefBox,
  );

  final ReadWriteValue<RemindForBreak> _remindForBreak =
      ReadWriteValue<RemindForBreak>(
    'remindForBreak',
    RemindForBreak.defaultPref,
    _prefBox,
    encoder: (RemindForBreak value) => value.toJson(),
    decoder: RemindForBreak.fromJson,
  );

  final ReadWriteValue<RemindForBedtime> _remindForBedtime =
      ReadWriteValue<RemindForBedtime>(
    'remindForBedtime',
    RemindForBedtime.defaultPref,
    _prefBox,
    encoder: (RemindForBedtime value) => value.toJson(),
    decoder: RemindForBedtime.fromJson,
  );

  final ReadWriteEnum<PlaybackInFeeds> _playbackInFeeds =
      ReadWriteEnum<PlaybackInFeeds>(
    'playbackInFeeds',
    PlaybackInFeeds.wifiOnly,
    _prefBox,
    PlaybackInFeeds.values,
  );

  final ReadWriteValue<int> _doubleTapSeek = ReadWriteValue<int>(
    'doubleTapToSeek',
    10,
    _prefBox,
  );

  final ReadWriteValue<bool> _zoomFillScreen = ReadWriteValue<bool>(
    'zoomFillScreen',
    false,
    _prefBox,
  );

  final ReadWriteValue<Locale> _voiceSearchLocale = ReadWriteValue<Locale>(
    'voiceSearchLocale',
    const Locale('en'),
    _prefBox,
    encoder: (Locale locale) => locale.languageCode,
    decoder: Locale.new,
  );

  final ReadWriteValue<bool> _restrictedMode = ReadWriteValue<bool>(
    'restrictedMode',
    false,
    _prefBox,
  );

  final ReadWriteValue<bool> _autoPlay = ReadWriteValue<bool>(
    'autoPlay',
    false,
    _prefBox,
  );

  final ReadWriteValue<bool> _enableStatForNerds = ReadWriteValue<bool>(
    'enableStatForNerds',
    false,
    _prefBox,
  );

  final ReadWriteValue<bool> _enableDataSaving = ReadWriteValue<bool>(
    'enableDataSaving',
    false,
    _prefBox,
  );

  final ReadWriteValue<Country?> _location = ReadWriteValue<Country?>(
    'location',
    null,
    _prefBox,
  );

  final ReadWriteEnum<UploadNetwork> _uploadNetwork =
      ReadWriteEnum<UploadNetwork>(
    'uploadNetwork',
    UploadNetwork.onlyWifi,
    _prefBox,
    UploadNetwork.values,
  );

  final ReadWriteValue<DataSavingPreferences> _dataSaving =
      ReadWriteValue<DataSavingPreferences>(
    'dataSaving',
    DataSavingPreferences.defaultPref,
    _prefBox,
    encoder: (DataSavingPreferences pref) => pref.toJson(),
    decoder: DataSavingPreferences.fromJson,
  );

  final ReadWriteValue<VideoQualityPreferences> _videoQuality =
      ReadWriteValue<VideoQualityPreferences>(
    'videoQuality',
    VideoQualityPreferences.defaultPref,
    _prefBox,
    encoder: (VideoQualityPreferences pref) => pref.toJson(),
    decoder: VideoQualityPreferences.fromJson,
  );

  final ReadWriteValue<DownloadPreferences> _downloads =
      ReadWriteValue<DownloadPreferences>(
    'downloads',
    DownloadPreferences.defaultPref,
    _prefBox,
    encoder: (DownloadPreferences pref) => pref.toJson(),
    decoder: DownloadPreferences.fromJson,
  );

  final ReadWriteValue<AccessibilityPreferences> _accessibility =
      ReadWriteValue<AccessibilityPreferences>(
    'accessibility',
    AccessibilityPreferences.defaultPref,
    _prefBox,
    encoder: (AccessibilityPreferences pref) => pref.toJson(),
    decoder: AccessibilityPreferences.fromJson,
  );

  set autoPlay(bool autoPlay) {
    _autoPlay.value = autoPlay;
    state = state.copyWith(autoplay: autoPlay);
  }

  set playbackInFeeds(PlaybackInFeeds playbackInFeeds) {
    _playbackInFeeds.value = playbackInFeeds;
    state = state.copyWith(playbackInFeeds: playbackInFeeds);
  }

  set enableStatsForNerds(bool enableStatsForNerds) {
    _enableStatForNerds.value = enableStatsForNerds;
    state = state.copyWith(enableStatsForNerds: enableStatsForNerds);
  }

  set restrictedMode(bool restrictedMode) {
    _restrictedMode.value = restrictedMode;
    state = state.copyWith(restrictedMode: restrictedMode);
  }

  set uploadNetwork(UploadNetwork uploadNetwork) {
    _uploadNetwork.value = uploadNetwork;
    state = state.copyWith(uploadNetwork: uploadNetwork);
  }

  set dataSaving(DataSavingPreferences dataSaving) {
    _dataSaving.value = dataSaving;
    state = state.copyWith(dataSaving: dataSaving);
  }

  set zoomFillScreen(bool zoomFillScreen) {
    _zoomFillScreen.value = zoomFillScreen;
    state = state.copyWith(zoomFillScreen: zoomFillScreen);
  }

  set doubleTapSeek(int doubleTapSeek) {
    _doubleTapSeek.value = doubleTapSeek;

    state = state.copyWith(doubleTapSeek: doubleTapSeek);
  }

  set themeMode(ThemeMode themeMode) {
    LegacyCache.themeMode.value = themeMode;
    state = state.copyWith(themeMode: themeMode);
  }

  set locale(Locale locale) {
    LegacyCache.locale.value = locale;
    state = state.copyWith(locale: locale);
  }

  set ambientMode(bool value) {
    _ambientMode.value = value;
    state = state.copyWith(ambientMode: value);
  }

  void changeRemindForBreak({Duration? frequency, bool? enabled}) {
    if (frequency == null && enabled == null) return;

    // Set enabled to false if duration chosen is Duration.zero
    enabled = frequency != null && frequency.inSeconds == 0 ? false : enabled;
    // Set frequency to null if duration chosen is Duration.zero
    frequency =
        frequency != null && frequency.inSeconds == 0 ? null : frequency;

    final RemindForBreak newValue =
        _remindForBreak.value = _remindForBreak.value.copyWith(
      frequency: frequency,
      enabled: enabled,
    );

    state = state.copyWith(remindForBreak: newValue);
  }

  void changeRemindForBedTime({
    RemindForBedtime? remindForBedtime,
    bool? enabled,
  }) {
    if (remindForBedtime != null || enabled != null) {
      final RemindForBedtime newValue = _remindForBedtime.value =
          (remindForBedtime ?? _remindForBedtime.value)
              .copyWith(enabled: enabled);
      state = state.copyWith(remindForBedtime: newValue);
    }
  }

  void changeVideoQuality({VideoQuality? mobile, VideoQuality? wifi}) {
    final VideoQualityPreferences newValue =
        _videoQuality.value = _videoQuality.value.copyWith(
      mobile: mobile,
      wifi: wifi,
    );

    state = state.copyWith(videoQualityPreferences: newValue);
  }

  void changeAccessibility({bool? enabled, int? hideDuration}) {
    final AccessibilityPreferences newValue =
        _accessibility.value = _accessibility.value.copyWith(
      enabled: enabled,
      hideDuration: hideDuration,
    );
    state = state.copyWith(accessibilityPreferences: newValue);
  }

  void changeDownloadsPref({int? quality, bool? wifiOnly, bool? recommend}) {
    final DownloadPreferences newValue =
        _downloads.value = _downloads.value.copyWith(
      quality: quality,
      wifiOnly: wifiOnly,
      recommend: recommend,
    );

    state = state.copyWith(downloadPreferences: newValue);
  }

  @override
  PreferenceState build() {
    return PreferenceState(
      locale: LegacyCache.locale.value,
      themeMode: LegacyCache.themeMode.value,
      ambientMode: _ambientMode.value,
      remindForBreak: _remindForBreak.value,
      remindForBedtime: _remindForBedtime.value,
      playbackInFeeds: _playbackInFeeds.value,
      doubleTapSeek: _doubleTapSeek.value,
      zoomFillScreen: _zoomFillScreen.value,
      uploadNetwork: _uploadNetwork.value,
      restrictedMode: _restrictedMode.value,
      enableStatsForNerds: _enableStatForNerds.value,
      videoQualityPreferences: _videoQuality.value,
      downloadPreferences: _downloads.value,
      accessibilityPreferences: _accessibility.value,
      dataSavingPreferences: _dataSaving.value,
      autoplay: _autoPlay.value,
    );
  }
}

class PreferenceState {
  PreferenceState({
    required this.ambientMode,
    required this.themeMode,
    required this.locale,
    required this.remindForBreak,
    required this.remindForBedtime,
    required this.playbackInFeeds,
    required this.doubleTapSeek,
    required this.zoomFillScreen,
    required this.uploadNetwork,
    required this.restrictedMode,
    required this.enableStatsForNerds,
    required this.videoQualityPreferences,
    required this.downloadPreferences,
    required this.accessibilityPreferences,
    required this.dataSavingPreferences,
    required this.autoplay,
  });
  final bool ambientMode;
  final ThemeMode themeMode;
  final Locale locale;
  final RemindForBreak remindForBreak;
  final RemindForBedtime remindForBedtime;

  final PlaybackInFeeds playbackInFeeds;
  final int doubleTapSeek;
  final bool zoomFillScreen;
  final UploadNetwork uploadNetwork;
  final bool restrictedMode;
  final bool enableStatsForNerds;
  final VideoQualityPreferences videoQualityPreferences;
  final DownloadPreferences downloadPreferences;
  final AccessibilityPreferences accessibilityPreferences;
  final DataSavingPreferences dataSavingPreferences;
  final bool autoplay;

  PreferenceState copyWith({
    bool? ambientMode,
    ThemeMode? themeMode,
    Locale? locale,
    RemindForBreak? remindForBreak,
    RemindForBedtime? remindForBedtime,
    PlaybackInFeeds? playbackInFeeds,
    int? doubleTapSeek,
    bool? zoomFillScreen,
    UploadNetwork? uploadNetwork,
    bool? restrictedMode,
    bool? enableStatsForNerds,
    VideoQualityPreferences? videoQualityPreferences,
    DownloadPreferences? downloadPreferences,
    AccessibilityPreferences? accessibilityPreferences,
    bool? autoplay,
    DataSavingPreferences? dataSaving,
  }) {
    return PreferenceState(
      ambientMode: ambientMode ?? this.ambientMode,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      remindForBreak: remindForBreak ?? this.remindForBreak,
      remindForBedtime: remindForBedtime ?? this.remindForBedtime,
      playbackInFeeds: playbackInFeeds ?? this.playbackInFeeds,
      doubleTapSeek: doubleTapSeek ?? this.doubleTapSeek,
      zoomFillScreen: zoomFillScreen ?? this.zoomFillScreen,
      uploadNetwork: uploadNetwork ?? this.uploadNetwork,
      restrictedMode: restrictedMode ?? this.restrictedMode,
      enableStatsForNerds: enableStatsForNerds ?? this.enableStatsForNerds,
      videoQualityPreferences:
          videoQualityPreferences ?? this.videoQualityPreferences,
      downloadPreferences: downloadPreferences ?? this.downloadPreferences,
      accessibilityPreferences:
          accessibilityPreferences ?? this.accessibilityPreferences,
      autoplay: autoplay ?? this.autoplay,
      dataSavingPreferences: dataSaving ?? this.dataSavingPreferences,
    );
  }
}

class RemindForBreak {
  const RemindForBreak({required this.frequency, required this.enabled});

  factory RemindForBreak.fromJson(String source) {
    final Map<String, dynamic> map = jsonDecode(source);
    return RemindForBreak(
      frequency: Duration(milliseconds: map['frequency'] as int),
      enabled: map['enabled'] as bool,
    );
  }
  final Duration frequency;
  final bool enabled;

  static const RemindForBreak defaultPref = RemindForBreak(
    frequency: Duration(hours: 1, minutes: 15),
    enabled: false,
  );

  String toJson() {
    return jsonEncode(<String, Object>{
      'frequency': frequency.inMilliseconds,
      'enabled': enabled,
    });
  }

  RemindForBreak copyWith({
    Duration? frequency,
    bool? enabled,
  }) {
    return RemindForBreak(
      frequency: frequency ?? this.frequency,
      enabled: enabled ?? this.enabled,
    );
  }
}

class RemindForBedtime {
  const RemindForBedtime({
    required this.onDeviceBedtime,
    required this.customStartSchedule,
    required this.customStopSchedule,
    required this.waitTillFinishVideo,
    required this.enabled,
  });

  factory RemindForBedtime.fromJson(String source) {
    final Map<String, dynamic> map = jsonDecode(source);
    return RemindForBedtime(
      onDeviceBedtime: map['onDeviceBedtime'] as bool,
      customStartSchedule: Duration(seconds: map['customStartSchedule']),
      customStopSchedule: Duration(seconds: map['customStopSchedule']),
      waitTillFinishVideo: map['waitTillFinishVideo'] as bool,
      enabled: map['enabled'] as bool,
    );
  }
  final bool onDeviceBedtime;
  final Duration customStartSchedule;
  final Duration customStopSchedule;
  final bool waitTillFinishVideo;
  final bool enabled;

  static const RemindForBedtime defaultPref = RemindForBedtime(
    onDeviceBedtime: false,
    customStartSchedule: Duration(hours: 12, minutes: 15),
    customStopSchedule: Duration(hours: 17, minutes: 15),
    waitTillFinishVideo: true,
    enabled: false,
  );

  String toJson() {
    return jsonEncode(<String, Object>{
      'onDeviceBedtime': onDeviceBedtime,
      'customStartSchedule': customStartSchedule.inSeconds,
      'customStopSchedule': customStopSchedule.inSeconds,
      'waitTillFinishVideo': waitTillFinishVideo,
      'enabled': enabled,
    });
  }

  RemindForBedtime copyWith({
    bool? onDeviceBedtime,
    Duration? customStartSchedule,
    Duration? customStopSchedule,
    bool? waitTillFinishVideo,
    bool? enabled,
  }) {
    return RemindForBedtime(
      onDeviceBedtime: onDeviceBedtime ?? this.onDeviceBedtime,
      customStartSchedule: customStartSchedule ?? this.customStartSchedule,
      customStopSchedule: customStopSchedule ?? this.customStopSchedule,
      waitTillFinishVideo: waitTillFinishVideo ?? this.waitTillFinishVideo,
      enabled: enabled ?? this.enabled,
    );
  }
}

class DataSavingPreferences {
  const DataSavingPreferences({
    required this.reduceVideoQuality,
    required this.reduceDownloadQuality,
    required this.reduceSmartDownloadQuality,
    required this.onlyWifiUpload,
    required this.mutedPlaybackOnWifi,
    required this.selectVideoQuality,
    required this.usageReminder,
  });

  factory DataSavingPreferences.fromJson(String source) {
    final Map<String, dynamic> map = jsonDecode(source);
    return DataSavingPreferences(
      reduceVideoQuality: map['reduceVideoQuality'] as bool,
      reduceDownloadQuality: map['reduceDownloadQuality'] as bool,
      reduceSmartDownloadQuality: map['reduceSmartDownloadQuality'] as bool,
      onlyWifiUpload: map['onlyWifiUpload'] as bool,
      mutedPlaybackOnWifi: map['mutedPlaybackOnWifi'] as bool,
      selectVideoQuality: map['selectVideoQuality'] as bool,
      usageReminder: map['usageReminder'] as bool,
    );
  }
  final bool reduceVideoQuality;
  final bool reduceDownloadQuality;
  final bool reduceSmartDownloadQuality;
  final bool onlyWifiUpload;
  final bool mutedPlaybackOnWifi;
  final bool selectVideoQuality;
  final bool usageReminder;

  static const DataSavingPreferences defaultPref = DataSavingPreferences(
    reduceVideoQuality: true,
    reduceDownloadQuality: false,
    reduceSmartDownloadQuality: false,
    onlyWifiUpload: true,
    mutedPlaybackOnWifi: true,
    selectVideoQuality: false,
    usageReminder: false,
  );

  String toJson() {
    return jsonEncode(<String, bool>{
      'reduceVideoQuality': reduceVideoQuality,
      'reduceDownloadQuality': reduceDownloadQuality,
      'reduceSmartDownloadQuality': reduceSmartDownloadQuality,
      'onlyWifiUpload': onlyWifiUpload,
      'mutedPlaybackOnWifi': mutedPlaybackOnWifi,
      'selectVideoQuality': selectVideoQuality,
      'usageReminder': usageReminder,
    });
  }

  DataSavingPreferences copyWith({
    bool? reduceVideoQuality,
    bool? reduceDownloadQuality,
    bool? reduceSmartDownloadQuality,
    bool? onlyWifiUpload,
    bool? mutedPlaybackOnWifi,
    bool? selectVideoQuality,
    bool? usageReminder,
  }) {
    return DataSavingPreferences(
      reduceVideoQuality: reduceVideoQuality ?? this.reduceVideoQuality,
      reduceDownloadQuality:
          reduceDownloadQuality ?? this.reduceDownloadQuality,
      reduceSmartDownloadQuality:
          reduceSmartDownloadQuality ?? this.reduceSmartDownloadQuality,
      onlyWifiUpload: onlyWifiUpload ?? this.onlyWifiUpload,
      mutedPlaybackOnWifi: mutedPlaybackOnWifi ?? this.mutedPlaybackOnWifi,
      selectVideoQuality: selectVideoQuality ?? this.selectVideoQuality,
      usageReminder: usageReminder ?? this.usageReminder,
    );
  }
}

class VideoQualityPreferences {
  const VideoQualityPreferences({
    required this.mobile,
    required this.wifi,
  });

  factory VideoQualityPreferences.fromJson(String source) {
    final Map<String, dynamic> map = jsonDecode(source);
    return VideoQualityPreferences(
      mobile: VideoQuality.values.firstWhere(
        (VideoQuality element) => element.name == map['mobile'],
      ),
      wifi: VideoQuality.values.firstWhere(
        (VideoQuality element) => element.name == map['wifi'],
        orElse: () => VideoQuality.auto,
      ),
    );
  }
  final VideoQuality mobile;
  final VideoQuality wifi;

  static const VideoQualityPreferences defaultPref = VideoQualityPreferences(
    mobile: VideoQuality.auto,
    wifi: VideoQuality.auto,
  );

  String toJson() {
    return jsonEncode(<String, String>{
      'mobile': mobile.name,
      'wifi': wifi.name,
    });
  }

  VideoQualityPreferences copyWith({
    VideoQuality? mobile,
    VideoQuality? wifi,
  }) {
    return VideoQualityPreferences(
      mobile: mobile ?? this.mobile,
      wifi: wifi ?? this.wifi,
    );
  }
}

class DownloadPreferences {
//<editor-fold desc="Data Methods">
  const DownloadPreferences({
    required this.quality,
    required this.wifiOnly,
    required this.recommend,
  });

  factory DownloadPreferences.fromJson(String source) {
    final Map<String, dynamic> map = jsonDecode(source);
    return DownloadPreferences(
      quality: map['quality'] as int,
      wifiOnly: map['wifiOnly'] as bool,
      recommend: map['recommend'] as bool,
    );
  }
  final int quality;
  final bool wifiOnly;
  final bool recommend;

  static const DownloadPreferences defaultPref = DownloadPreferences(
    quality: 0,
    wifiOnly: true,
    recommend: false,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadPreferences &&
          runtimeType == other.runtimeType &&
          quality == other.quality &&
          wifiOnly == other.wifiOnly &&
          recommend == other.recommend);

  @override
  int get hashCode => quality.hashCode ^ wifiOnly.hashCode ^ recommend.hashCode;

  DownloadPreferences copyWith({
    int? quality,
    bool? wifiOnly,
    bool? recommend,
  }) {
    return DownloadPreferences(
      quality: quality ?? this.quality,
      wifiOnly: wifiOnly ?? this.wifiOnly,
      recommend: recommend ?? this.recommend,
    );
  }

  String toJson() {
    return jsonEncode(<String, Object>{
      'quality': quality,
      'wifiOnly': wifiOnly,
      'recommend': recommend,
    });
  }
}

class AccessibilityPreferences {
//<editor-fold desc="Data Methods">
  const AccessibilityPreferences({
    required this.enabled,
    required this.hideDuration,
  });

  factory AccessibilityPreferences.fromJson(String source) {
    final Map<String, dynamic> map = jsonDecode(source);
    return AccessibilityPreferences(
      enabled: map['enabled'] as bool,
      hideDuration: map['hideDuration'] as int,
    );
  }
  final bool enabled;

  /// -1 = Never; -2 = Use device settings;
  final int hideDuration;

  static const AccessibilityPreferences defaultPref = AccessibilityPreferences(
    enabled: false,
    hideDuration: -1,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccessibilityPreferences &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled &&
          hideDuration == other.hideDuration);

  @override
  int get hashCode => enabled.hashCode ^ hideDuration.hashCode;

  AccessibilityPreferences copyWith({
    bool? enabled,
    int? hideDuration,
  }) {
    return AccessibilityPreferences(
      enabled: enabled ?? this.enabled,
      hideDuration: hideDuration ?? this.hideDuration,
    );
  }

  String toJson() {
    return jsonEncode(
      <String, Object>{'enabled': enabled, 'hideDuration': hideDuration},
    );
  }
}
