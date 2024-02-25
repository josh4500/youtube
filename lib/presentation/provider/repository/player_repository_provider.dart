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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:youtube_clone/presentation/provider/state/player_state_provider.dart';

final _playerOverlayStateProvider = StateProvider<bool>((ref) => false);

final playerOverlayStateProvider = Provider(
  (ref) {
    return ref.watch(_playerOverlayStateProvider);
  },
);

class PlayerRepository {
  final Ref _ref;

  late final _videoPlayer = Player();
  late final _videoController = VideoController(_videoPlayer);
  VideoController get videoController => _videoController;

  late final _shortsPlayer = Player();
  late final _shortsController = VideoController(_shortsPlayer);
  VideoController get shortsController => _shortsController;

  PlayerRepository({required Ref ref}) : _ref = ref;

  void openPlayerScreen() {
    _ref.read(_playerOverlayStateProvider.notifier).state = true;
  }

  void closePlayerScreen() {
    _ref.read(_playerOverlayStateProvider.notifier).state = false;
  }

  void minimizeVideo() {
    _ref.read(playerNotifierProvider.notifier).toggleMinimized();
  }

  void minimizeAndPauseVideo() {
    _ref.read(playerNotifierProvider.notifier).toggleMinimized();
    _ref.read(playerNotifierProvider.notifier).togglePlaying();
  }

  Future<void> pauseVideo() async {
    // await _videoPlayer.pause();
    _ref.read(playerNotifierProvider.notifier).pause();
  }

  Future<void> playVideo() async {
    // await _videoPlayer.pause();
    _ref.read(playerNotifierProvider.notifier).play();
  }

  void hideControls() {
    _ref.read(playerNotifierProvider.notifier).hideControls();
  }

  void showControls() {
    _ref.read(playerNotifierProvider.notifier).showControls();
  }

  void toggleControlsHidden() {
    if (_ref.read(playerNotifierProvider).controlsHidden) {
      _ref.read(playerNotifierProvider.notifier).showControls();
    } else {
      _ref.read(playerNotifierProvider.notifier).hideControls();
    }
  }
}

final playerRepositoryProvider = Provider((ref) => PlayerRepository(ref: ref));
