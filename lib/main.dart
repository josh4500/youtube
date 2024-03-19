import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path_provider/path_provider.dart';

import 'core.dart';
import 'data.dart';
import 'domain.dart';
import 'generated/l10n.dart';
import 'infrastructure.dart';
import 'presentation/app.dart';

Future<void> main() async {
  await setup();
  runApp(const App());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final Directory dir = await getApplicationDocumentsDirectory();
  final String appPath = dir.path;

  // Set Hive default directory
  Hive.defaultDirectory = appPath;

  // Load default locale
  final Locale locale = S.delegate.supportedLocales.firstWhere(
    (Locale locale) {
      return locale.languageCode.split('_').first == Platform.localeName ||
          locale.languageCode == Platform.localeName;
    },
    orElse: () => kDefaultLocale,
  );
  await S.load(locale);
  await InternetConnectivity.instance.initialize();
  setupRepositories();
}

// TODO(Josh): Inject repositories
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

  final DataRepository remoteDataRepository = RemoteDataRepository();
  final GrpcResourceClient grpcResourceClient = GrpcResourceClient();

  remoteDataRepository
    ..registerResource<AccountRepository>(
      AccountRepository(grpcResourceClient),
      useCases: [
        // TODO(Josh): Lazy load use cases
        FetchAccountUseCase(),
        CreateChannelUseCase(),
      ],
    )
    ..registerResource<AuthenticationRepository>(
      AuthenticationRepository(grpcResourceClient),
    );

  remoteDataRepository.getUseCase<FetchAccountUseCase>().runTestFuc();
}
