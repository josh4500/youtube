import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:youtube_clone/core/extensions.dart';

import '../core/utils.dart';

class Preferences extends Notifier<PreferenceState> {
  /// Preference HiveBox
  final _prefBox = Hive.box(name: 'preferences');

  late final ReadWriteValue<ThemeMode> _themeMode;
  late final ReadWriteValue<Locale> _locale;

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
    // Set ReadWriteValue for _themeMode
    _themeMode = ReadWriteValue<ThemeMode>(
      'themeMode',
      ThemeMode.system,
      _prefBox,
      (mode) => mode.name,
      (name) => ThemeMode.values.firstWhereOrNull(
        (element) => element.name == name,
      ),
    );

    // Set ReadWriteValue for _locale
    _locale = ReadWriteValue(
      'locale',
      const Locale('en'),
      _prefBox,
    );

    return PreferenceState(
      themeMode: _themeMode.value,
      locale: _locale.value,
    );
  }
}

class PreferenceState {
  final ThemeMode themeMode;
  final Locale locale;

  PreferenceState({required this.themeMode, required this.locale});

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

extension IsDarkExtension on ThemeMode {
  bool get isDark => this == ThemeMode.dark;
}

final preferencesProvider = NotifierProvider<Preferences, PreferenceState>(
  () => Preferences(),
);
