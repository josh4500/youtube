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
