import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:youtube_clone/presentation/themes.dart';

import 'core.dart';
import 'data.dart';
import 'domain.dart';
import 'generated/l10n.dart';
import 'infrastructure.dart';
import 'presentation/app.dart';

Future<void> main() async {
  await setup();
  await PlatformInfoCollector.instance.initialize();
  final errorReporter = ErrorReporter(
    platform: PlatformInfoCollector.instance.platformInfo,
    clients: [
      ConsoleReporterClient(),
      // Uncommented till when Firebase setup is complete
      // FirebaseReporterClient(),
      LocalFileReporterClient(LegacyCache.errorFile.value),
    ],
  );
  AppLogger.init(
    shouldLog: () => true,
    shouldLogException: (Object error) {
      const List<Type> ignoreTypes = <Type>[
        SocketException,
        HandshakeException,
        TimeoutException,
      ];
      return !ignoreTypes.contains(error.runtimeType);
    },
    onException: errorReporter.reportError,
    onLog: (Object? message) => debugPrint(message?.toString()),
  );

  runApp(
    ErrorBoundary(
      // TODO(josh4500): Create a screen for error
      errorViewBuilder: (_) => const SizedBox(),
      onCrash: errorReporter.reportCrash,
      onException: (_, __) {},
      child: const App(),
    ),
  );
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  PhotoManager.clearFileCache();
  await SharedPref.init();

  await Future.wait([
    setupSystemUITheme(),
    setupSystemLocale(),
    InternetConnectivity.instance.initialize(),
  ]);

  // Initialize services and repository depending on the environment
  // Recommended for infrastructure and Domain
  switch (environment) {
    case Environment.dev:
      await Firebase.initializeApp();
      setupDevRepositories();
      break;
    case Environment.prod:
      break;
    case Environment.testing:
      break;
  }
}

Future<void> setupSystemUITheme() async {
  final themeMode = LegacyCache.themeMode.value;
  final brightness = themeMode.isSystem
      ? ui.PlatformDispatcher.instance.platformBrightness
      : themeMode.isDark
          ? Brightness.dark
          : Brightness.light;
  AppTheme.setSystemOverlayStyle(brightness);
}

Future<void> setupSystemLocale() async {
  // Load default locale
  final Locale locale = S.delegate.supportedLocales.firstWhere(
    (Locale locale) {
      final userCacheValue = LegacyCache.locale.value;
      return locale.languageCode.split('_').first ==
              userCacheValue.languageCode ||
          locale.languageCode == userCacheValue.languageCode;
    },
    orElse: () => kDefaultLocale,
  );
  await S.load(locale);
}

void setupDevRepositories() {
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
