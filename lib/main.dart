import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

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
  PhotoManager.clearFileCache();
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
  // TODO(Josh): Create a static class that has methods to assign local and remote data repository
  // like assignRemote(...) or assignLocal(...).

  // (This might seem confusing though). May need rework
  // Can be used like DataRepository.remote.use<AccountRepository>() in other Repository
  // Note: Limit/reduce dependencies between DataSources, that should be the work of backend or client use cases.
  // DataSources should be discrete

  // Note: DataResource instance is not recommended for use in Provider repositories,
  // UseCases should be usd instead
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
