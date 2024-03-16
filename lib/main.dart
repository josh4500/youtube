import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_clone/core/constants/constants.dart';
import 'package:youtube_clone/data/remote_repository/remote_data_repository.dart';
import 'package:youtube_clone/domain/repositories/account_repository.dart';
import 'package:youtube_clone/domain/repositories/authentication_repository.dart';

import 'core/environment.dart';
import 'data/local_repository/local_data_repository.dart';
import 'generated/l10n.dart';
import 'infrastructure/services/internet_connectivity/internet_connectivity.dart';
import 'presentation/app.dart';

Future<void> main() async {
  await setup();
  runApp(const App());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final appPath = dir.path;

  // Set Hive default directory
  Hive.defaultDirectory = appPath;

  // Load default locale
  final locale = S.delegate.supportedLocales.firstWhere(
    (locale) {
      return locale.languageCode.split('_').first == Platform.localeName ||
          locale.languageCode == Platform.localeName;
    },
    orElse: () => defaultLocale,
  );
  await S.load(locale);
  await InternetConnectivity.instance.initialize();
}

void setupRepositories() {
  // Initialize services and repository depending on the environment
  // Recommended for infrastructure and Domain
  switch (environment) {
    case Environment.dev:
      break;
    case Environment.prod:
      break;
    case Environment.testing:
      break;
  }

  final localDataRepository = LocalDataRepository();
  final remoteDataRepository = RemoteDataRepository();

  remoteDataRepository
    ..registerResource<AccountRepository>(AccountRepository())
    ..registerResource<AuthenticationRepository>(AuthenticationRepository());
}
