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

  late final _autoPlay = ReadWriteValue<bool>(
    'autoPlay',
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

    final newValue = _remindForBreak.value = _remindForBreak.value.copyWith(
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
      final newValue = _remindForBedtime.value =
          (remindForBedtime ?? _remindForBedtime.value)
              .copyWith(enabled: enabled);
      state = state.copyWith(remindForBedtime: newValue);
    }
  }

  void changeVideoQuality({VideoQuality? mobile, VideoQuality? wifi}) {
    final newValue = _videoQuality.value = _videoQuality.value.copyWith(
      mobile: mobile,
      wifi: wifi,
    );

    state = state.copyWith(videoQualityPreferences: newValue);
  }

  void changeAccessibility({bool? enabled, int? hideDuration}) {
    final newValue = _accessibility.value = _accessibility.value.copyWith(
      enabled: enabled,
      hideDuration: hideDuration,
    );
    state = state.copyWith(accessibilityPreferences: newValue);
  }

  void changeDownloadsPref({int? quality, bool? wifiOnly, bool? recommend}) {
    final newValue = _downloads.value = _downloads.value.copyWith(
      quality: quality,
      wifiOnly: wifiOnly,
      recommend: recommend,
    );

    state = state.copyWith(downloadPreferences: newValue);
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
      videoQualityPreferences: _videoQuality.value,
      downloadPreferences: _downloads.value,
      accessibilityPreferences: _accessibility.value,
      autoplay: _autoPlay.value,
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
  final VideoQualityPreferences videoQualityPreferences;
  final DownloadPreferences downloadPreferences;
  final AccessibilityPreferences accessibilityPreferences;
  final bool autoplay;

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
    required this.videoQualityPreferences,
    required this.downloadPreferences,
    required this.accessibilityPreferences,
    required this.autoplay,
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
    VideoQualityPreferences? videoQualityPreferences,
    DownloadPreferences? downloadPreferences,
    AccessibilityPreferences? accessibilityPreferences,
    bool? autoplay,
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
      videoQualityPreferences:
          videoQualityPreferences ?? this.videoQualityPreferences,
      downloadPreferences: downloadPreferences ?? this.downloadPreferences,
      accessibilityPreferences:
          accessibilityPreferences ?? this.accessibilityPreferences,
      autoplay: autoplay ?? this.autoplay,
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
  final Duration customStartSchedule;
  final Duration customStopSchedule;
  final bool waitTillFinishVideo;
  final bool enabled;

  static const defaultPref = RemindForBedtime(
    onDeviceBedtime: false,
    customStartSchedule: Duration(hours: 12, minutes: 15),
    customStopSchedule: Duration(hours: 17, minutes: 15),
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
      'customStartSchedule': customStartSchedule.inSeconds,
      'customStopSchedule': customStopSchedule.inSeconds,
      'waitTillFinishVideo': waitTillFinishVideo,
      'enabled': enabled,
    });
  }

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
      'mobile': mobile.name,
      'wifi': wifi.name,
    });
  }

  factory VideoQualityPreferences.fromJson(String source) {
    final Map<String, dynamic> map = jsonDecode(source);
    return VideoQualityPreferences(
      mobile: VideoQuality.values.firstWhere(
        (element) => element.name == map['mobile'],
      ),
      wifi: VideoQuality.values.firstWhere(
        (element) => element.name == map['wifi'],
        orElse: () => VideoQuality.auto,
      ),
    );
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

  /// -1 = Never; -2 = Use device settings;
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
