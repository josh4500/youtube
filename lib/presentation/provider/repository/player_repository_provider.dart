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
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/infrastructure.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/provider/state/preferences.dart';

import '../state/player_state_provider.dart';
import '../state/player_view_state_provider.dart';

part 'player_repository_provider.g.dart';

/// Provider state that defines if the PlayerScreen is overlay in home_Screen
///
/// NOTE: This state should not be exposed but can be listened to,
/// from `playerOverlayStateProvider`
final _playerOverlayStateProvider = StateProvider<bool>((ref) => false);

/// Provider state that defines if the PlayerScreen is overlay in home_Screen
final playerOverlayStateProvider = Provider(
  (ref) {
    return ref.watch(_playerOverlayStateProvider);
  },
);

@Riverpod(keepAlive: true, dependencies: [])
PlayerRepository playerRepository(Ref ref) {
  return PlayerRepository(ref: ref);
}

enum PlayerSignal {
  autoplay,
  lockScreen,
  unlockScreen,
  showUnlock,
  pauseControls,
  showControls,
  hideControls,
  showAmbient,
  hideAmbient,
  minimize,
  maximize,
  enterExpanded,
  exitExpanded,
  hidePlaybackProgress,
  showPlaybackProgress;
}

enum PlayerLockReason {
  progress;
}

class PlayerRepository {
  PlayerRepository({required Ref ref}) : _ref = ref {
    _videoPlayerProgressStream = _videoPlayer.stream.progress;

    _videoPlayer.stream.completed.listen((hasEnded) {
      if (hasEnded) {
        if (!ref.read(playerViewStateProvider).isMinimized) {
          sendPlayerSignal([PlayerSignal.showControls]);
        }

        _ref.read(playerNotifierProvider.notifier).end();
      }
    });

    _videoPlayer.stream.buffering.listen((buffering) {
      if (buffering) {
        _ref.read(playerNotifierProvider.notifier).buffering();
      } else {
        _ref.read(playerNotifierProvider.notifier).bufferingEnd();
      }
    });

    _videoPlayer.stream.playing.listen((playing) {
      if (playing) {
        _ref.read(playerNotifierProvider.notifier).play();
      } else {
        _ref.read(playerNotifierProvider.notifier).pause();
      }
    });

    _videoPlayerProgressStream.listen((progress) {
      _positionMemory.write('video', progress);
      if (!_lock.contains(PlayerLockReason.progress)) {
        _progressController.sink.add(progress);
      }
    });
  }
  final Ref _ref;

  final _positionMemory = InMemoryCache<Progress>('PositionMemory');

  final _videoPlayer = Player();
  late final _videoController = VideoController(_videoPlayer);
  VideoController get videoController => _videoController;

  late final Stream<Progress> _videoPlayerProgressStream;

  Duration get currentVideoDuration => _videoPlayer.state.duration;
  Duration get currentVideoPosition => _videoPlayer.state.position;
  Progress? get currentVideoProgress => _positionMemory.read('video');
  Stream<Duration> get positionStream => _videoPlayer.stream.position;

  final _playerSignalController = StreamController<PlayerSignal>.broadcast();
  Stream<PlayerSignal> get playerSignalStream => _playerSignalController.stream;

  final _progressController = StreamController<Progress>.broadcast();
  Stream<Progress> get videoProgressStream => _progressController.stream;

  // TODO(Josh): May use a Riverpod provider
  final Set<PlayerLockReason> _lock = <PlayerLockReason>{};

  // TODO(Josh): May use a Riverpod provider
  PlayerSettingsViewModel settings = PlayerSettingsViewModel(
    speed: PlayerSpeed.normal,
  );

  PlayerSpeed get speed => settings.speed;

  // TODO(Josh): Should be able open video
  Future<void> openPlayerScreen() async {
    _ref.read(_playerOverlayStateProvider.notifier).state = true;
    // if (_ref.read(playerViewStateProvider).isMinimized) {
    //   sendPlayerSignal([PlayerSignal.maximize]);
    // }
  }

  void closePlayerScreen() {
    _lock.clear();
    _videoPlayer.stop();
    _ref.read(playerNotifierProvider.notifier).reset();
    _ref.read(playerViewStateProvider.notifier).clearState();
    _ref.read(_playerOverlayStateProvider.notifier).state = false;
  }

  Future<void> openVideo() async {
    await _videoPlayer.open(
      Media(
        'https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4',
      ),
    );
  }

  Future<void> playVideo() async => _videoPlayer.play();
  Future<void> pauseVideo() async => _videoPlayer.pause();
  Future<void> seekTo(Duration position) async {
    await _videoPlayer.seek(position);
    if (position < currentVideoDuration) {
      _ref.read(playerNotifierProvider.notifier).restart(
            _ref.read(playerNotifierProvider).playing,
          );
    }
  }

  Future<void> seek(Duration duration, {bool reverse = false}) async {
    final position = reverse
        ? _videoPlayer.state.position - duration
        : _videoPlayer.state.position + duration;
    // Ends if seek position is greater or equal to the video duration
    if (position >= currentVideoDuration) {
      _ref.read(playerNotifierProvider.notifier).end();
    }
    // If already ended and position is below the video duration, it removes end
    // state and change to a pause state
    else if (_ref.read(playerNotifierProvider).ended &&
        position < currentVideoDuration) {
      // Pass argument true make it a pause state
      _ref.read(playerNotifierProvider.notifier).restart(false);
    }
    if (position.isNegative) {
      await _videoPlayer.seek(Duration.zero);
    } else {
      await _videoPlayer.seek(position);
    }
  }

  Future<void> setSpeed([
    PlayerSpeed speed = PlayerSpeed.byTwo,
  ]) async {
    settings = settings.copyWith(speed: speed);
    await _videoPlayer.setRate(speed.dRate);
  }

  Future<void> setPitch(double pitch) async {
    // await _videoPlayer.setPitch(pitch);
  }

  Future<void> restartVideo() async {
    _ref.read(playerNotifierProvider.notifier).restart();
    await seekTo(Duration.zero);
    await playVideo();
  }

  void updatePosition(Duration position, {bool lockProgress = true}) {
    if (lockProgress) {
      _lock.add(PlayerLockReason.progress);
    } else {
      _lock.remove(PlayerLockReason.progress);
    }
    final lastProgress = _positionMemory.read('video') ?? Progress.zero;
    _progressController.sink.add(
      lastProgress.copyWith(position: position),
    );
    _positionMemory.write('video', lastProgress.copyWith(position: position));
  }

  void minimize() => sendPlayerSignal([PlayerSignal.minimize]);

  void minimizeAndPauseVideo() {
    sendPlayerSignal([PlayerSignal.minimize]);
    pauseVideo();
  }

  void sendPlayerSignal(List<PlayerSignal> signals) {
    for (final signal in signals) {
      if (signal case PlayerSignal.minimize) {
        _ref
            .read(playerViewStateProvider.notifier)
            .addState(ViewState.minimized);
      } else if (signal case PlayerSignal.maximize) {
        _ref
            .read(playerViewStateProvider.notifier)
            .removeState(ViewState.minimized);
      } else if (signal case PlayerSignal.enterExpanded) {
        _ref
            .read(playerViewStateProvider.notifier)
            .addState(ViewState.expanded);
      } else if (signal case PlayerSignal.exitExpanded) {
        _ref
            .read(playerViewStateProvider.notifier)
            .removeState(ViewState.expanded);
      } else if (signal case PlayerSignal.showControls) {
        _ref
            .read(playerViewStateProvider.notifier)
            .addState(ViewState.visibleControls);
      } else if (signal case PlayerSignal.hideControls) {
        _ref
            .read(playerViewStateProvider.notifier)
            .removeState(ViewState.visibleControls);
      } else if (signal case PlayerSignal.showAmbient) {
        _ref
            .read(playerViewStateProvider.notifier)
            .addState(ViewState.visibleAmbient);
      } else if (signal case PlayerSignal.hideAmbient) {
        _ref
            .read(playerViewStateProvider.notifier)
            .removeState(ViewState.visibleAmbient);
      }
      _playerSignalController.sink.add(signal);
    }
  }

  void toggleAmbientMode() {
    final prevV = _ref.read(preferencesProvider).ambientMode;
    _ref.read(preferencesProvider.notifier).ambientMode = !prevV;
  }
}
