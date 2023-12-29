import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/screens/settings/settings_screen.dart';

import 'app_routes.dart';

class AppRouter {
  static final key = GlobalKey<NavigatorState>();
  static final routerConfig = GoRouter(
    navigatorKey: key,
    initialLocation: AppRoutes.home.path,
    routes: [
      GoRoute(
        name: AppRoutes.home.name,
        path: AppRoutes.home.path,
        parentNavigatorKey: key,
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const SettingsScreen(),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.settings.name,
        path: AppRoutes.settings.path,
        parentNavigatorKey: key,
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const SettingsScreen(),
          );
        },
      ),
    ],
  );
}

extension GotoExtension on BuildContext {
  /// Navigate to a given [RouteInfo]
  ///
  /// Note: It uses the GoRouter [goNamed]
  void goto(
    RouteInfo routeInfo, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    return goNamed(
      routeInfo.name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }
}
