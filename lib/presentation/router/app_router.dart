// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/screens.dart';

import 'app_routes.dart';

class AppRouter {
  static final rootKey = GlobalKey<NavigatorState>();
  static final homeShellRoute = GlobalKey<NavigatorState>();

  static final routerConfig = GoRouter(
    navigatorKey: rootKey,
    initialLocation: AppRoutes.home.path,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomePage(
            key: state.pageKey,
            child: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: homeShellRoute,
            routes: <RouteBase>[
              GoRoute(
                name: AppRoutes.home.name,
                path: AppRoutes.home.path,
                builder: (BuildContext context, GoRouterState state) {
                  return HomeScreen(
                    key: state.pageKey,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoutes.shorts.name,
                path: AppRoutes.shorts.path,
                builder: (BuildContext context, GoRouterState state) {
                  return ShortsScreen(
                    key: state.pageKey,
                  );
                },
              ),
              GoRoute(
                name: AppRoutes.shortsSubscription.name,
                path: AppRoutes.shortsSubscription.path,
                builder: (BuildContext context, GoRouterState state) {
                  return ShortsScreen(
                    key: state.pageKey,
                    isSubscription: true,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: AppRoutes.subscriptions.name,
                path: AppRoutes.subscriptions.path,
                builder: (BuildContext context, GoRouterState state) {
                  return SubscriptionsScreen(
                    key: state.pageKey,
                  );
                },
                routes: <RouteBase>[
                  GoRoute(
                    name: AppRoutes.allSubscriptions.name,
                    path: AppRoutes.allSubscriptions.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return const NoTransitionPage(
                        child: AllSubscriptionsScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    name: AppRoutes.channel.name,
                    path: AppRoutes.channel
                        .withPrefixParent(AppRoutes.subscriptions)
                        .path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return const NoTransitionPage(
                        child: ChannelScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: AppRoutes.channelDescription
                        .withPrefixParent(AppRoutes.subscriptions)
                        .path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return const NoTransitionPage(
                        child: ChannelDescriptionScreen(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: AppRoutes.accounts.name,
                path: AppRoutes.accounts.path,
                builder: (BuildContext context, GoRouterState state) {
                  return AccountsScreen(
                    key: state.pageKey,
                  );
                },
                routes: <RouteBase>[
                  GoRoute(
                    name: AppRoutes.accountChannel.name,
                    path: AppRoutes.accountChannel.path,
                    builder: (BuildContext context, GoRouterState state) {
                      return const AccountChannelScreen();
                    },
                  ),
                  GoRoute(
                    name: AppRoutes.watchHistory.name,
                    path: AppRoutes.watchHistory.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return const NoTransitionPage(
                        child: WatchHistoryScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    name: AppRoutes.accountPlaylists.name,
                    path: AppRoutes.accountPlaylists.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return const NoTransitionPage(
                        child: AccountPlaylistsScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    name: AppRoutes.playlist.name,
                    path: AppRoutes.playlist.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return const NoTransitionPage(
                        child: PlaylistScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    name: AppRoutes.yourClips.name,
                    path: AppRoutes.yourClips.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return const NoTransitionPage(
                        child: YourClipsScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    name: AppRoutes.yourVideos.name,
                    path: AppRoutes.yourVideos.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return const NoTransitionPage(
                        child: YourVideosScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    name: AppRoutes.yourMovies.name,
                    path: AppRoutes.yourMovies.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return const NoTransitionPage(
                        child: YourMoviesScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    name: AppRoutes.downloads.name,
                    path: AppRoutes.downloads.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return const NoTransitionPage(
                        child: DownloadsScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    name: AppRoutes.channelDescription.name,
                    path: AppRoutes.channelDescription
                        .withPrefixParent(AppRoutes.accounts)
                        .path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return const NoTransitionPage(
                        child: ChannelDescriptionScreen(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: AppRoutes.settings.name,
        path: AppRoutes.settings.path,
        parentNavigatorKey: rootKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 200),
            reverseTransitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: const Offset(0, 0),
                  ),
                ),
                child: child,
              );
            },
            child: const SettingsScreen(),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.watchOnTv.name,
        path: AppRoutes.watchOnTv.path,
        parentNavigatorKey: rootKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 200),
            reverseTransitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: const Offset(0, 0),
                  ),
                ),
                child: child,
              );
            },
            child: const WatchOnTvScreen(),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.linkTv.name,
        path: AppRoutes.linkTv.path,
        parentNavigatorKey: rootKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 200),
            reverseTransitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: const Offset(0, 0),
                  ),
                ),
                child: child,
              );
            },
            child: const LinkTvScreen(),
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
  Future<Object?> goto(
    RouteInfo routeInfo, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) async {
    return pushNamed(
      routeInfo.name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }
}
