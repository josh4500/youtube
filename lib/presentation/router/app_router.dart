import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/homepage.dart';
import 'app_routes.dart';

class AppRouter {
  static final routerConfig = GoRouter(
    routes: [
      GoRoute(
        name: AppRoutes.home,
        path: '/',
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const HomePage(),
          );
        },
      ),
    ],
  );
}
