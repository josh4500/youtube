import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:youtube_clone/core/enums/settings_enums.dart';

import '../core/utils.dart';

class Preferences extends Notifier<PreferenceState> {
  /// Preference HiveBox
  final _prefBox = Hive.box(name: 'preferences');

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

  late final _remindForBreak = ReadWriteValue<bool>(
    'remindForBreak',
    false,
    _prefBox,
  );

  late final _remindForBedtime = ReadWriteValue<bool>(
    'remindForBedtime',
    false,
    _prefBox,
  );

  late final _playbackInFeeds = ReadWriteEnum<PlaybackInFeeds>(
    'playbackInFeeds',
    PlaybackInFeeds.wifiOnly,
    _prefBox,
    PlaybackInFeeds.values,
  );

  late final _doubleTapToSeek = ReadWriteValue<int>(
    'doubleTapToSeek',
    0,
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

  set themeMode(ThemeMode themeMode) {
    _themeMode.value = themeMode;
    state = state.copyWith(themeMode: themeMode);
  }

  set locale(Locale locale) {
    _locale.value = locale;
    state = state.copyWith(locale: locale);
  }

  @override
  PreferenceState build() {
    return PreferenceState(
      themeMode: _themeMode.value,
      locale: _locale.value,
    );
  }
}

class PreferenceState {
  final ThemeMode themeMode;
  final Locale locale;

  const PreferenceState({required this.themeMode, required this.locale});

  PreferenceState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return PreferenceState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
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
    final Map<String, Object> map = jsonDecode(source);
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
    final Map<String, Object> map = jsonDecode(source);
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
    final Map<String, Object> map = jsonDecode(source);
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
    final Map<String, Object> map = jsonDecode(source);
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
}

final preferencesProvider = NotifierProvider<Preferences, PreferenceState>(
  () => Preferences(),
);
