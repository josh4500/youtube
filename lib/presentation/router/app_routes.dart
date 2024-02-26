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
  static final shortsLive = RouteInfo(
    name: 'live subscription',
    path: '/shorts/live',
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
