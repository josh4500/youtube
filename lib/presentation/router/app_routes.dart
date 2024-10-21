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

import 'router_info.dart';

abstract class AppRoutes {
  static final RouteInfo dashboard = RouteInfo(
    name: 'Dashboard',
    path: '/',
  );

  ///
  /// Home
  ///

  static final RouteInfo home = RouteInfo(
    name: 'home',
    path: '/feed',
  );
  static final RouteInfo fashionAndBeauty = RouteInfo(
    name: 'Fashion and Beauty',
    path: 'feed/f_and_b',
  );
  static final RouteInfo gaming = RouteInfo(
    name: 'Gaming',
    path: 'feed/gaming',
  );
  static final RouteInfo podcasts = RouteInfo(
    name: 'Podcast',
    path: 'feed/podcasts',
  );
  static final RouteInfo learning = RouteInfo(
    name: 'Learning',
    path: 'feed/learning',
  );
  static final RouteInfo live = RouteInfo(
    name: 'Live',
    path: 'feed/live',
  );
  static final RouteInfo music = RouteInfo(
    name: 'Music',
    path: 'feed/music',
  );
  static final RouteInfo news = RouteInfo(
    name: 'News',
    path: 'feed/news',
  );
  static final RouteInfo sports = RouteInfo(
    name: 'Sports',
    path: 'feed/sports',
  );
  static final RouteInfo trending = RouteInfo(
    name: 'Trending',
    path: 'feed/trending',
  );

  static final RouteInfo shorts = RouteInfo(
    name: 'shorts',
    path: '/shorts',
  );
  static final RouteInfo shortsSubscription = RouteInfo(
    name: 'shorts subscription',
    path: '/shorts/subscription',
  );
  static final RouteInfo shortsLive = RouteInfo(
    name: 'live subscription',
    path: '/shorts/live',
  );

  ///
  ///
  /// Channel
  ///
  ///
  static final RouteInfo channel = RouteInfo(
    name: 'channel',
    path: 'channel',
  );

  static final RouteInfo channelDescription = RouteInfo(
    name: 'channel description',
    path: 'channel/description',
  );

  ///
  ///
  /// Subscriptions
  ///
  ///

  static final RouteInfo subscriptions = RouteInfo(
    name: 'subscriptions',
    path: '/subscriptions',
  );

  static final RouteInfo allSubscriptions = RouteInfo(
    name: 'all subscriptions',
    path: 'subscriptions/all',
  );

  ///
  ///
  /// Accounts
  ///
  ///

  static final RouteInfo accounts = RouteInfo(
    name: 'accounts',
    path: '/accounts',
  );
  static final RouteInfo accountChannel = RouteInfo(
    name: 'accounts channel',
    path: 'accounts/channel',
  );
  static final RouteInfo watchHistory = RouteInfo(
    name: 'watch history',
    path: 'accounts/watch-history',
  );
  static final RouteInfo accountPlaylists = RouteInfo(
    name: 'account playlists',
    path: 'accounts/playlists',
  );
  static final RouteInfo yourClips = RouteInfo(
    name: 'account clips',
    path: 'accounts/clips',
  );
  static final RouteInfo yourMovies = RouteInfo(
    name: 'account movies',
    path: 'accounts/movies',
  );
  static final RouteInfo yourVideos = RouteInfo(
    name: 'account videos',
    path: 'accounts/videos',
  );
  static final RouteInfo downloads = RouteInfo(
    name: 'account downloads',
    path: 'accounts/downloads',
  );

  ///
  ///
  /// Create
  ///
  ///

  static final RouteInfo create = RouteInfo(
    name: 'create',
    path: '/create',
  );

  ///
  ///
  /// Comments
  ///
  ///

  static final RouteInfo comments = RouteInfo(
    name: 'comments',
    path: '/comments',
  );

  static final RouteInfo replies = RouteInfo(
    name: 'replies',
    path: '/replies',
  );

  ///
  ///
  /// Playlist
  ///
  ///

  static final RouteInfo playlist = RouteInfo(
    name: 'playlist',
    path: 'playlist',
  );

  ///
  ///
  /// Watch on TV
  ///
  ///
  static final RouteInfo watchOnTv = RouteInfo(
    name: 'watchOnTv',
    path: '/watchOnTv',
  );
  static final RouteInfo linkTv = RouteInfo(
    name: 'linkTv',
    path: '/linkTv',
  );

  ///
  ///
  /// Settings
  ///
  ///
  static final RouteInfo settings = RouteInfo(
    name: 'settings',
    path: '/settings',
  );

  static final tryExperimental = RouteInfo(
    name: 'tryExperimental',
    path: '/tryExperimental',
  );

  ///
  ///
  /// Search
  ///
  ///

  static final RouteInfo search = RouteInfo(
    name: 'search',
    path: '/search',
  );

  static final RouteInfo searchVoiceRequest = RouteInfo(
    name: 'search voice request',
    path: '/search/voice_request',
  );

  static final RouteInfo notifications = RouteInfo(
    name: 'notifications',
    path: '/notifications',
  );
}
