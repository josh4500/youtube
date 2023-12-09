import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'core/environment.dart';
import 'generated/l10n.dart';
import 'infrastructure/services/internet_connectivity/internet_connectivity.dart';
import 'presentation/app.dart';

Future<void> main() async {
  await setup();
  runApp(const App());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final appPath = dir.path;

  // Set Hive default directory
  Hive.defaultDirectory = appPath;

  // Load default locale
  await S.load(const Locale('en'));

  InternetConnectivity.instance.initialize();

  // Initialize services and repository depending on the environment
  switch (environment) {
    case Environment.dev:
      break;
    case Environment.prod:
      break;
    case Environment.testing:
      break;
  }
}
