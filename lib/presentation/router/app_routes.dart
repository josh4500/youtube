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

class RouteInfo {
  final String name;
  final String path;

  RouteInfo({required this.name, required this.path});

  RouteInfo withPrefixParent(RouteInfo parent) {
    return RouteInfo(
      name: name,
      path: '${parent.path.replaceFirst('/', '')}/$path',
    );
  }
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
  static final shortsSubscription = RouteInfo(
    name: 'shorts subscription',
    path: '/shorts/subscription',
  );

  ///
  ///
  /// Channel
  ///
  ///
  static final channel = RouteInfo(
    name: 'channel',
    path: 'channel',
  );

  static final channelDescription = RouteInfo(
    name: 'channel description',
    path: 'channel/description',
  );

  ///
  ///
  /// Subscriptions
  ///
  ///

  static final subscriptions = RouteInfo(
    name: 'subscriptions',
    path: '/subscriptions',
  );

  static final allSubscriptions = RouteInfo(
    name: 'all subscriptions',
    path: 'subscriptions/all',
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
