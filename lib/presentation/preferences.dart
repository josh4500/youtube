import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:youtube_clone/core/extensions.dart';

typedef HiveBox = Box;

class Preferences extends Notifier<PreferenceState> {
  final _prefBox = Hive.box(name: 'preferences');

  set themeMode(ThemeMode themeMode) {
    _getThemeMode.val = themeMode;
    state = state.copyWith(themeMode: themeMode);
  }

  ReadWriteValue<ThemeMode> get _getThemeMode => ReadWriteValue<ThemeMode>(
        'themeMode',
        ThemeMode.system,
        _prefBox,
        (mode) => mode.name,
        (name) => ThemeMode.values.firstWhereOrNull(
          (element) => element.name == name,
        ),
      );

  ReadWriteValue<Locale> get _getLocale => ReadWriteValue(
        'locale',
        const Locale('en'),
        _prefBox,
      );

  @override
  PreferenceState build() {
    return PreferenceState(
      themeMode: _getThemeMode.val,
      locale: _getLocale.val,
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

class ReadWriteValue<T> {
  final String key;
  final T defaultValue;
  final HiveBox? getBox;
  final String Function(T input)? encoder;
  final T? Function(String input)? decoder;

  ReadWriteValue(
    this.key,
    this.defaultValue, [
    this.getBox,
    this.encoder,
    this.decoder,
  ]);

  Box _getRealBox() => getBox ?? Hive.box();

  T get val {
    final value = _getRealBox().get(key);
    if (value != null && decoder != null) {
      return decoder!(value as String)!;
    }
    return value ?? defaultValue;
  }

  set val(T newVal) => _getRealBox().put(
        key,
        encoder != null ? encoder!(newVal) : newVal,
      );
}
