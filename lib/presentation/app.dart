// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
        builder: (BuildContext context, WidgetRef ref, _) {
          final PreferenceState preferences = ref.watch(preferencesProvider);
          return DeviceTheme.fromView(
            view: View.of(context),
            child: MaterialApp.router(
              title: 'Youtube',
              restorationScopeId: 'app',
              themeAnimationStyle: AnimationStyle(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInCubic,
                reverseCurve: Curves.easeOutCubic,
              ),
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const <LocalizationsDelegate>[
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
              builder: (BuildContext context, Widget? child) {
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
