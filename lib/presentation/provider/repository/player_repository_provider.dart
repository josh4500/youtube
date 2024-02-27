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

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:youtube_clone/core/utils/progress.dart';
import 'package:youtube_clone/infrastructure/services/cache/in_memory_cache.dart';
import 'package:youtube_clone/presentation/provider/state/player_state_provider.dart';
import 'package:youtube_clone/presentation/widgets.dart';

final _playerOverlayStateProvider = StateProvider<bool>((ref) => false);

final playerOverlayStateProvider = Provider(
  (ref) {
    return ref.watch(_playerOverlayStateProvider);
  },
);

enum PlayerTapActor {
  none,
  user,
  control;
}

class PlayerRepository {
  final Ref _ref;

  final _positionMemory = InMemoryCache<Duration>('PositionMemory');

  late final _videoPlayer = Player();
  late final _videoController = VideoController(_videoPlayer);
  VideoController get videoController => _videoController;

  Stream<Progress> get currentVideoProgress => _videoPlayer.stream.progress;
  Duration get currentVideoDuration => _videoPlayer.state.duration;
  Duration get currentVideoPosition => _videoPlayer.state.position;
  Stream<Duration> get positionStream => _videoPlayer.stream.position;

  late final _shortsPlayer = Player();
  late final _shortsController = VideoController(_shortsPlayer);
  VideoController get shortsController => _shortsController;

  final _playerTapController = StreamController<PlayerTapActor>.broadcast();
  Stream<PlayerTapActor> get playerTapStream => _playerTapController.stream;

  PlayerRepository({required Ref ref}) : _ref = ref {
    _videoPlayer.stream.completed.listen((hasEnded) {
      if (hasEnded) {
        _ref.read(playerNotifierProvider.notifier).end();
        _positionMemory.delete('video');
      }
    });

    _videoPlayer.stream.playing.listen((playing) {
      if (playing) {
        _ref.read(playerNotifierProvider.notifier).play();
      } else {
        _ref.read(playerNotifierProvider.notifier).pause();
      }
    });

    _videoPlayer.stream.position.listen((position) {
      _positionMemory.write('video', position);
    });
  }

  void openPlayerScreen() {
    _ref.read(_playerOverlayStateProvider.notifier).state = true;
  }

  void closePlayerScreen() {
    _videoPlayer.stop();
    _ref.read(_playerOverlayStateProvider.notifier).state = false;
  }

  Future<void> seek(Duration duration, {bool reverse = false}) async {
    final position = reverse
        ? _videoPlayer.state.position - duration
        : _videoPlayer.state.position + duration;
    await _videoPlayer.seek(position);
  }

  Future<void> seekTo(Duration position) async {
    await _videoPlayer.seek(position);
  }

  Future<void> setSpeed([double rate = 2]) async {
    await _videoPlayer.setRate(rate);
  }

  void minimize() {
    _ref.read(playerNotifierProvider.notifier).minimize();
  }

  void minimizeAndPauseVideo() {
    _ref.read(playerNotifierProvider.notifier).toggleMinimized();
    _ref.read(playerNotifierProvider.notifier).togglePlaying();
  }

  void expand() {
    _ref.read(playerNotifierProvider.notifier).expand();
  }

  void deExpand() {
    _ref.read(playerNotifierProvider.notifier).deExpand();
  }

  Future<void> pauseVideo() async {
    await _videoPlayer.pause();
  }

  Future<void> restartVideo() async {
    _ref.read(playerNotifierProvider.notifier).restart();
    await seekTo(Duration.zero);
    await playVideo();
  }

  Future<void> openVideo() async {
    _ref.read(playerNotifierProvider.notifier).reset();
    await _videoPlayer.open(
      Media(
        'https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4',
      ),
      play: true,
    );
  }

  Future<void> playVideo() async {
    await _videoPlayer.play();
  }

  void showControls() {
    _ref.read(playerNotifierProvider.notifier).showControls();
  }

  void tapPlayer(PlayerTapActor actor) {
    _playerTapController.sink.add(actor);
  }

  void toggleFullscreen() {
    _ref.read(playerNotifierProvider.notifier).toggleFullScreen();
  }

  void maximize() {
    _ref.read(playerNotifierProvider.notifier).maximize();
  }
}

final playerRepositoryProvider = Provider((ref) => PlayerRepository(ref: ref));
