// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `English`
  String get language {
    return Intl.message(
      'English',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Hello World!`
  String get helloWorld {
    return Intl.message(
      'Hello World!',
      name: 'helloWorld',
      desc: 'The conventional newborn programmer greeting',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: 'General settings',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Data Saving`
  String get dataSaving {
    return Intl.message(
      'Data Saving',
      name: 'dataSaving',
      desc: '',
      args: [],
    );
  }

  /// `Autoplay`
  String get autoPlay {
    return Intl.message(
      'Autoplay',
      name: 'autoPlay',
      desc: '',
      args: [],
    );
  }

  /// `Video quality preferences`
  String get videoQualityPref {
    return Intl.message(
      'Video quality preferences',
      name: 'videoQualityPref',
      desc: '',
      args: [],
    );
  }

  /// `Downloads`
  String get downloads {
    return Intl.message(
      'Downloads',
      name: 'downloads',
      desc: '',
      args: [],
    );
  }

  /// `Privacy`
  String get privacy {
    return Intl.message(
      'Privacy',
      name: 'privacy',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Live chat`
  String get liveChat {
    return Intl.message(
      'Live chat',
      name: 'liveChat',
      desc: '',
      args: [],
    );
  }

  /// `Captions`
  String get captions {
    return Intl.message(
      'Captions',
      name: 'captions',
      desc: '',
      args: [],
    );
  }

  /// `Accessibility`
  String get accessibility {
    return Intl.message(
      'Accessibility',
      name: 'accessibility',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Add account`
  String get addAccount {
    return Intl.message(
      'Add account',
      name: 'addAccount',
      desc: '',
      args: [],
    );
  }

  /// `Watch on TV`
  String get watchOnTv {
    return Intl.message(
      'Watch on TV',
      name: 'watchOnTv',
      desc: '',
      args: [],
    );
  }

  /// `Manage all history`
  String get manageAllHistory {
    return Intl.message(
      'Manage all history',
      name: 'manageAllHistory',
      desc: '',
      args: [],
    );
  }

  /// `Your data in Youtube`
  String get yourDataInYT {
    return Intl.message(
      'Your data in Youtube',
      name: 'yourDataInYT',
      desc: '',
      args: [],
    );
  }

  /// `Try experimental new features`
  String get tryExperimental {
    return Intl.message(
      'Try experimental new features',
      name: 'tryExperimental',
      desc: '',
      args: [],
    );
  }

  /// `Purchases and memberships`
  String get purchases {
    return Intl.message(
      'Purchases and memberships',
      name: 'purchases',
      desc: '',
      args: [],
    );
  }

  /// `Billing & payments`
  String get billsAndPayment {
    return Intl.message(
      'Billing & payments',
      name: 'billsAndPayment',
      desc: '',
      args: [],
    );
  }

  /// `Connected apps`
  String get connectedApps {
    return Intl.message(
      'Connected apps',
      name: 'connectedApps',
      desc: '',
      args: [],
    );
  }

  /// `Search YouTube`
  String get searchYoutube {
    return Intl.message(
      'Search YouTube',
      name: 'searchYoutube',
      desc: '',
      args: [],
    );
  }

  /// `Search downloads`
  String get searchDownloads {
    return Intl.message(
      'Search downloads',
      name: 'searchDownloads',
      desc: '',
      args: [],
    );
  }

  /// `Playback`
  String get playback {
    return Intl.message(
      'Playback',
      name: 'playback',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
