import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core/environment.dart';
import 'package:youtube_clone/presentation/theme/app_theme.dart';

import '../generated/l10n.dart';
import 'preferences.dart';
import 'screens/homepage.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: Consumer(
      builder: (context, ref, _) {
        final preferences = ref.watch(preferencesProvider);
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: environment.isDev,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: preferences.locale,
          supportedLocales: S.delegate.supportedLocales,
          themeMode: preferences.themeMode,
          theme: preferences.themeMode.isDark ? AppTheme.dark : AppTheme.light,
          home: const HomePage(),
        );
      },
    ));
  }
}
