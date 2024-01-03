class RouteInfo {
  final String name;
  final String path;

  RouteInfo({required this.name, required this.path});
}

class AppRoutes {
  static final dashboard = RouteInfo(
    name: 'Dashboard',
    path: '/',
  );

  static final home = RouteInfo(
    name: 'home',
    path: '/home',
  );

  static final shorts = RouteInfo(
    name: 'shorts',
    path: '/shorts',
  );

  static final subscriptions = RouteInfo(
    name: 'subscriptions',
    path: '/subscriptions',
  );

  ///
  ///
  /// Accounts
  ///
  ///

  static final accounts = RouteInfo(
    name: 'accounts',
    path: '/accounts',
  );
  static final accountChannel = RouteInfo(
    name: 'accounts channel',
    path: 'accounts/channel',
  );
  static final watchHistory = RouteInfo(
    name: 'watch history',
    path: 'accounts/watch-history',
  );
  static final accountPlaylists = RouteInfo(
    name: 'account playlists',
    path: 'accounts/playlists',
  );
  static final yourClips = RouteInfo(
    name: 'account clips',
    path: 'accounts/clips',
  );
  static final yourMovies = RouteInfo(
    name: 'account movies',
    path: 'accounts/movies',
  );
  static final yourVideos = RouteInfo(
    name: 'account videos',
    path: 'accounts/videos',
  );
  static final downloads = RouteInfo(
    name: 'account downloads',
    path: 'accounts/downloads',
  );

  ///
  ///
  /// Playlist
  ///
  ///

  static final playlist = RouteInfo(
    name: 'playlist',
    path: 'playlist',
  );

  ///
  ///
  /// Watch on TV
  ///
  ///
  static final watchOnTv = RouteInfo(
    name: 'watchOnTv',
    path: '/watchOnTv',
  );
  static final linkTv = RouteInfo(
    name: 'linkTv',
    path: '/linkTv',
  );

  ///
  ///
  /// Settings
  ///
  ///
  static final settings = RouteInfo(
    name: 'settings',
    path: '/settings',
  );
}
