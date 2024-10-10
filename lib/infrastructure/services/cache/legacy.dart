import 'dart:ui';

import 'package:flutter/material.dart';

import 'read_write_value.dart';
import 'shared_pref_provider.dart';

class LegacyCache {
  LegacyCache._();
  static final _legacyProvider = SharedPrefProvider('legacy');
  static final ReadWriteEnum<ThemeMode> themeMode = ReadWriteEnum<ThemeMode>(
    'themeMode',
    ThemeMode.system,
    _legacyProvider,
    ThemeMode.values,
  );
  static final ReadWriteValue<Locale> locale = ReadWriteValue<Locale>(
    'locale',
    PlatformDispatcher.instance.locale,
    _legacyProvider,
    encoder: (Locale locale) => locale.languageCode,
    decoder: Locale.new,
  );

  static ReadWriteValue<String> errorFile = ReadWriteValue<String>(
    'locale',
    'errors.log',
    _legacyProvider,
  );
}
