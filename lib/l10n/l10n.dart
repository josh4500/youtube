import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// General settings
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @dataSaving.
  ///
  /// In en, this message translates to:
  /// **'Data Saving'**
  String get dataSaving;

  /// No description provided for @autoPlay.
  ///
  /// In en, this message translates to:
  /// **'Autoplay'**
  String get autoPlay;

  /// No description provided for @videoQualityPref.
  ///
  /// In en, this message translates to:
  /// **'Video quality preferences'**
  String get videoQualityPref;

  /// No description provided for @downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloads;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Live chat'**
  String get liveChat;

  /// No description provided for @captions.
  ///
  /// In en, this message translates to:
  /// **'Captions'**
  String get captions;

  /// No description provided for @accessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibility;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get addAccount;

  /// No description provided for @watchOnTv.
  ///
  /// In en, this message translates to:
  /// **'Watch on TV'**
  String get watchOnTv;

  /// No description provided for @manageAllHistory.
  ///
  /// In en, this message translates to:
  /// **'Manage all history'**
  String get manageAllHistory;

  /// No description provided for @yourDataInYT.
  ///
  /// In en, this message translates to:
  /// **'Your data in Youtube'**
  String get yourDataInYT;

  /// No description provided for @tryExperimental.
  ///
  /// In en, this message translates to:
  /// **'Try experimental new features'**
  String get tryExperimental;

  /// No description provided for @purchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases and memberships'**
  String get purchases;

  /// No description provided for @billsAndPayment.
  ///
  /// In en, this message translates to:
  /// **'Billing & payments'**
  String get billsAndPayment;

  /// No description provided for @connectedApps.
  ///
  /// In en, this message translates to:
  /// **'Connected apps'**
  String get connectedApps;

  /// No description provided for @searchYoutube.
  ///
  /// In en, this message translates to:
  /// **'Search YouTube'**
  String get searchYoutube;

  /// No description provided for @searchDownloads.
  ///
  /// In en, this message translates to:
  /// **'Search downloads'**
  String get searchDownloads;

  /// No description provided for @playback.
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get playback;

  /// No description provided for @yourWatchHistoryIsOff.
  ///
  /// In en, this message translates to:
  /// **'Your watch history is off'**
  String get yourWatchHistoryIsOff;

  /// No description provided for @trySearchingToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Try searching to get started'**
  String get trySearchingToGetStarted;

  /// No description provided for @startWatchingVideos.
  ///
  /// In en, this message translates to:
  /// **'Start watching videos to help us build a feed of videos you\'ll love.'**
  String get startWatchingVideos;

  /// No description provided for @youCanChangeSettings.
  ///
  /// In en, this message translates to:
  /// **'You can change setting at any time to get the latest videos tailored to you.'**
  String get youCanChangeSettings;

  /// No description provided for @updateSetting.
  ///
  /// In en, this message translates to:
  /// **'Update Setting'**
  String get updateSetting;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get learnMore;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return L10nEn();
    case 'es':
      return L10nEs();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
