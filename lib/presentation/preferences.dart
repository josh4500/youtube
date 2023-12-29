import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core/enums/settings_enums.dart';
import 'package:youtube_clone/infrastructure/services/cache/hive_cache_provider.dart';

import '../infrastructure/services/cache/read_write_value.dart';

class Preferences extends Notifier<PreferenceState> {
  /// Dynamic Preference [HiveCacheProvider]
  final _prefBox = HiveCacheProvider('preferences');

  late final _themeMode = ReadWriteEnum<ThemeMode>(
    'themeMode',
    ThemeMode.system,
    _prefBox,
    ThemeMode.values,
  );

  late final _locale = ReadWriteValue<Locale>(
    'locale',
    const Locale('en'),
    _prefBox,
    encoder: (locale) => locale.languageCode,
    decoder: (languageCode) => Locale(languageCode),
  );

  late final _remindForBreak = ReadWriteValue<RemindForBreak>(
    'remindForBreak',
    RemindForBreak.defaultPref,
    _prefBox,
    encoder: (value) => value.toJson(),
    decoder: (value) => RemindForBreak.fromJson(value),
  );

  late final _remindForBedtime = ReadWriteValue<RemindForBedtime>(
    'remindForBedtime',
    RemindForBedtime.defaultPref,
    _prefBox,
    encoder: (value) => value.toJson(),
    decoder: (value) => RemindForBedtime.fromJson(value),
  );

  late final _playbackInFeeds = ReadWriteEnum<PlaybackInFeeds>(
    'playbackInFeeds',
    PlaybackInFeeds.wifiOnly,
    _prefBox,
    PlaybackInFeeds.values,
  );

  late final _doubleTapSeek = ReadWriteValue<int>(
    'doubleTapToSeek',
    10,
    _prefBox,
  );

  late final _zoomFillScreen = ReadWriteValue<bool>(
    'zoomFillScreen',
    false,
    _prefBox,
  );

  late final _voiceSearchLocale = ReadWriteValue<Locale>(
    'voiceSearchLocale',
    const Locale('en'),
    _prefBox,
    encoder: (locale) => locale.languageCode,
    decoder: (languageCode) => Locale(languageCode),
  );

  late final _restrictedMode = ReadWriteValue<bool>(
    'restrictedMode',
    false,
    _prefBox,
  );

  late final _enableStatForNerds = ReadWriteValue<bool>(
    'enableStatForNerds',
    false,
    _prefBox,
  );

  late final _enableDataSaving = ReadWriteValue<bool>(
    'enableDataSaving',
    false,
    _prefBox,
  );

  late final Country _location;

  late final _uploadNetwork = ReadWriteEnum<UploadNetwork>(
    'uploadNetwork',
    UploadNetwork.onlyWifi,
    _prefBox,
    UploadNetwork.values,
  );

  late final _dataSaving = ReadWriteValue<DataSavingPreferences>(
    'dataSaving',
    DataSavingPreferences.defaultPref,
    _prefBox,
    encoder: (pref) => pref.toJson(),
    decoder: (prefJson) => DataSavingPreferences.fromJson(prefJson),
  );

  late final _videoQuality = ReadWriteValue<VideoQualityPreferences>(
    'videoQuality',
    VideoQualityPreferences.defaultPref,
    _prefBox,
    encoder: (pref) => pref.toJson(),
    decoder: (prefJson) => VideoQualityPreferences.fromJson(prefJson),
  );

  late final _downloads = ReadWriteValue<DownloadPreferences>(
    'downloads',
    DownloadPreferences.defaultPref,
    _prefBox,
    encoder: (pref) => pref.toJson(),
    decoder: (prefJson) => DownloadPreferences.fromJson(prefJson),
  );

  late final _accessibility = ReadWriteValue<AccessibilityPreferences>(
    'accessibility',
    AccessibilityPreferences.defaultPref,
    _prefBox,
    encoder: (pref) => pref.toJson(),
    decoder: (prefJson) => AccessibilityPreferences.fromJson(prefJson),
  );

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

  set zoomFillScreen(bool zoomFillScreen) {
    _zoomFillScreen.value = zoomFillScreen;
    state = state.copyWith(zoomFillScreen: zoomFillScreen);
  }

  set doubleTapSeek(int doubleTapSeek) {
    _doubleTapSeek.value = doubleTapSeek;

    state = state.copyWith(doubleTapSeek: doubleTapSeek);
  }

  set themeMode(ThemeMode themeMode) {
    _themeMode.value = themeMode;
    state = state.copyWith(themeMode: themeMode);
  }

  set locale(Locale locale) {
    _locale.value = locale;
    state = state.copyWith(locale: locale);
  }

  void changeRemindForBreak({Duration? frequency, bool? enabled}) {
    if (frequency == null && enabled == null) return;

    // Set enabled to false if duration chosen is Duration.zero
    enabled = frequency != null && frequency.inSeconds == 0 ? false : enabled;
    // Set frequency to null if duration chosen is Duration.zero
    frequency =
        frequency != null && frequency.inSeconds == 0 ? null : frequency;

    _remindForBreak.value = _remindForBreak.value.copyWith(
      frequency: frequency,
      enabled: enabled,
    );

    state = state.copyWith(remindForBreak: _remindForBreak.value);
  }

  void changeRemindForBedTime({
    bool? onDeviceBedtime,
    DateTime? customStartSchedule,
    DateTime? customStopSchedule,
    bool? waitTillFinishVideo,
    bool? enable,
  }) {
    if (onDeviceBedtime == null &&
        customStartSchedule == null &&
        customStopSchedule == null &&
        waitTillFinishVideo == null &&
        enable == null) {
      return;
    }

    _remindForBedtime.value = _remindForBedtime.value.copyWith(
      onDeviceBedtime: onDeviceBedtime,
      customStartSchedule: customStartSchedule,
      customStopSchedule: customStopSchedule,
      waitTillFinishVideo: waitTillFinishVideo,
      enabled: enable,
    );
    state = state.copyWith(remindForBedtime: _remindForBedtime.value);
  }

  @override
  PreferenceState build() {
    return PreferenceState(
      themeMode: _themeMode.value,
      locale: _locale.value,
      remindForBreak: _remindForBreak.value,
      remindForBedtime: _remindForBedtime.value,
      playbackInFeeds: _playbackInFeeds.value,
      doubleTapSeek: _doubleTapSeek.value,
      zoomFillScreen: _zoomFillScreen.value,
      uploadNetwork: _uploadNetwork.value,
      restrictedMode: _restrictedMode.value,
      enableStatsForNerds: _enableStatForNerds.value,
    );
  }
}

class PreferenceState {
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

  PreferenceState({
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
  });

  PreferenceState copyWith({
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
  }) {
    return PreferenceState(
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
    );
  }
}

class RemindForBreak {
  final Duration frequency;
  final bool enabled;

  const RemindForBreak({required this.frequency, required this.enabled});

  static const defaultPref = RemindForBreak(
    frequency: Duration(hours: 1, minutes: 15),
    enabled: false,
  );

  String toJson() {
    return jsonEncode({
      'frequency': frequency.inMilliseconds,
      'enabled': enabled,
    });
  }

  factory RemindForBreak.fromJson(String source) {
    final Map<String, dynamic> map = jsonDecode(source);
    return RemindForBreak(
      frequency: Duration(milliseconds: map['frequency'] as int),
      enabled: map['enabled'] as bool,
    );
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
  final bool onDeviceBedtime;
  final DateTime customStartSchedule;
  final DateTime customStopSchedule;
  final bool waitTillFinishVideo;
  final bool enabled;

  static final defaultPref = RemindForBedtime(
    onDeviceBedtime: false,
    customStartSchedule: DateTime.now().copyWith(hour: 23),
    customStopSchedule: DateTime.now().copyWith(hour: 5),
    waitTillFinishVideo: true,
    enabled: false,
  );

  const RemindForBedtime({
    required this.onDeviceBedtime,
    required this.customStartSchedule,
    required this.customStopSchedule,
    required this.waitTillFinishVideo,
    required this.enabled,
  });

  String toJson() {
    return jsonEncode({
      'onDeviceBedtime': onDeviceBedtime,
      'customStartSchedule': customStartSchedule.toIso8601String(),
      'customStopSchedule': customStopSchedule.toIso8601String(),
      'waitTillFinishVideo': waitTillFinishVideo,
      'enabled': enabled,
    });
  }

  factory RemindForBedtime.fromJson(String source) {
    final Map<String, dynamic> map = jsonDecode(source);
    return RemindForBedtime(
      onDeviceBedtime: map['onDeviceBedtime'] as bool,
      customStartSchedule: DateTime.parse(map['customStartSchedule']),
      customStopSchedule: DateTime.parse(map['customStopSchedule']),
      waitTillFinishVideo: map['waitTillFinishVideo'] as bool,
      enabled: map['enabled'] as bool,
    );
  }

  RemindForBedtime copyWith({
    bool? onDeviceBedtime,
    DateTime? customStartSchedule,
    DateTime? customStopSchedule,
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
  final bool reduceVideoQuality;
  final bool reduceDownloadQuality;
  final bool reduceSmartDownloadQuality;
  final bool onlyWifiUpload;
  final bool mutedPlaybackOnWifi;
  final bool selectVideoQuality;
  final bool usageReminder;

  const DataSavingPreferences({
    required this.reduceVideoQuality,
    required this.reduceDownloadQuality,
    required this.reduceSmartDownloadQuality,
    required this.onlyWifiUpload,
    required this.mutedPlaybackOnWifi,
    required this.selectVideoQuality,
    required this.usageReminder,
  });

  static const defaultPref = DataSavingPreferences(
    reduceVideoQuality: true,
    reduceDownloadQuality: false,
    reduceSmartDownloadQuality: false,
    onlyWifiUpload: true,
    mutedPlaybackOnWifi: true,
    selectVideoQuality: false,
    usageReminder: false,
  );

  String toJson() {
    return jsonEncode({
      'reduceVideoQuality': reduceVideoQuality,
      'reduceDownloadQuality': reduceDownloadQuality,
      'reduceSmartDownloadQuality': reduceSmartDownloadQuality,
      'onlyWifiUpload': onlyWifiUpload,
      'mutedPlaybackOnWifi': mutedPlaybackOnWifi,
      'selectVideoQuality': selectVideoQuality,
      'usageReminder': usageReminder,
    });
  }

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
}

class VideoQualityPreferences {
  final VideoQuality mobile;
  final VideoQuality wifi;

  const VideoQualityPreferences({
    required this.mobile,
    required this.wifi,
  });

  static const defaultPref = VideoQualityPreferences(
    mobile: VideoQuality.auto,
    wifi: VideoQuality.auto,
  );

  String toJson() {
    return jsonEncode({
      'mobile': mobile,
      'wifi': wifi,
    });
  }

  factory VideoQualityPreferences.fromJson(String source) {
    final Map<String, dynamic> map = jsonDecode(source);
    return VideoQualityPreferences(
      mobile: map['mobile'] as VideoQuality,
      wifi: map['wifi'] as VideoQuality,
    );
  }
}

class DownloadPreferences {
  final int quality;
  final bool wifiOnly;
  final bool recommend;

  static const defaultPref = DownloadPreferences(
    quality: 0,
    wifiOnly: true,
    recommend: false,
  );

//<editor-fold desc="Data Methods">
  const DownloadPreferences({
    required this.quality,
    required this.wifiOnly,
    required this.recommend,
  });

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
    return jsonEncode({
      'quality': quality,
      'wifiOnly': wifiOnly,
      'recommend': recommend,
    });
  }

  factory DownloadPreferences.fromJson(String source) {
    final Map<String, dynamic> map = jsonDecode(source);
    return DownloadPreferences(
      quality: map['quality'] as int,
      wifiOnly: map['wifiOnly'] as bool,
      recommend: map['recommend'] as bool,
    );
  }
}

class AccessibilityPreferences {
  final bool enabled;
  // -1 = Never; -2 = Use device settings;
  final int hideDuration;

  static const defaultPref = AccessibilityPreferences(
    enabled: false,
    hideDuration: -1,
  );

//<editor-fold desc="Data Methods">
  const AccessibilityPreferences({
    required this.enabled,
    required this.hideDuration,
  });

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
    return jsonEncode({'enabled': enabled, 'hideDuration': hideDuration});
  }

  factory AccessibilityPreferences.fromJson(String source) {
    final Map<String, dynamic> map = jsonDecode(source);
    return AccessibilityPreferences(
      enabled: map['enabled'] as bool,
      hideDuration: map['hideDuration'] as int,
    );
  }
}

/// TODO: Add country selector package
class Country {}

extension IsDarkExtension on ThemeMode {
  bool get isDark => this == ThemeMode.dark;
  bool get isSystem => this == ThemeMode.system;
}

final preferencesProvider = NotifierProvider<Preferences, PreferenceState>(
  () => Preferences(),
);
