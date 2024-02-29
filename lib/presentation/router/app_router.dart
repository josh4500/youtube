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
              GoRoute(
                name: AppRoutes.shortsLive.name,
                path: AppRoutes.shortsLive.path,
                builder: (BuildContext context, GoRouterState state) {
                  return ShortsScreen(
                    key: state.pageKey,
                    isLive: true,
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
      GoRoute(
        name: AppRoutes.playerLandscapeScreen.name,
        path: AppRoutes.playerLandscapeScreen.path,
        parentNavigatorKey: rootKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 200),
            reverseTransitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: const PlayerLandscapeScreen(),
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
