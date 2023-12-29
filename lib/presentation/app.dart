import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/theme/app_theme.dart';
import 'package:youtube_clone/presentation/theme/device_theme.dart';

import '../generated/l10n.dart';
import 'preferences.dart';
import 'router/app_router.dart';
import 'widgets/error_overlay.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          final preferences = ref.watch(preferencesProvider);
          return DeviceTheme.fromView(
            view: View.of(context),
            child: MaterialApp.router(
              title: 'Youtube',
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: preferences.locale,
              supportedLocales: S.delegate.supportedLocales,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: preferences.themeMode,
              themeAnimationCurve: Curves.easeIn,
              builder: (context, child) {
                return ErrorOverlay(
                  child: child!,
                );
              },
              routerConfig: AppRouter.routerConfig,
            ),
          );
        },
      ),
    );
  }
}
