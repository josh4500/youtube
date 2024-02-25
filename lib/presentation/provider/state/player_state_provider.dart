import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_state_provider.g.dart';

class PlayerState {
  final bool playing;
  final bool expanded;
  final bool fullscreen;
  final bool minimized;
  final bool controlsHidden;
  final bool ambientMode;

  const PlayerState({
    required this.playing,
    required this.expanded,
    required this.fullscreen,
    required this.minimized,
    required this.controlsHidden,
    required this.ambientMode,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerState &&
          runtimeType == other.runtimeType &&
          playing == other.playing &&
          expanded == other.expanded &&
          fullscreen == other.fullscreen &&
          minimized == other.minimized &&
          controlsHidden == other.controlsHidden &&
          ambientMode == other.ambientMode;

  @override
  int get hashCode =>
      playing.hashCode ^
      expanded.hashCode ^
      fullscreen.hashCode ^
      minimized.hashCode ^
      controlsHidden.hashCode ^
      ambientMode.hashCode;

  PlayerState copyWith({
    bool? playing,
    bool? expanded,
    bool? fullscreen,
    bool? minimized,
    bool? controlsHidden,
    bool? ambientMode,
  }) {
    return PlayerState(
      playing: playing ?? this.playing,
      expanded: expanded ?? this.expanded,
      fullscreen: fullscreen ?? this.fullscreen,
      minimized: minimized ?? this.minimized,
      controlsHidden: controlsHidden ?? this.controlsHidden,
      ambientMode: ambientMode ?? this.ambientMode,
    );
  }
}

@Riverpod(keepAlive: true)
class PlayerNotifier extends _$PlayerNotifier {
  @override
  PlayerState build() {
    return const PlayerState(
      playing: false,
      expanded: false,
      minimized: false,
      fullscreen: false,
      ambientMode: false,
      controlsHidden: false,
    );
  }

  void pause() {
    state = state.copyWith(playing: false);
  }

  void play() {
    state = state.copyWith(playing: true);
  }

  void togglePlaying() {
    state = state.copyWith(playing: !state.playing);
  }

  void toggleExpanded() {
    state = state.copyWith(expanded: !state.expanded);
  }

  void toggleMinimized() {
    state = state.copyWith(minimized: !state.minimized);
  }

  void toggleFullScreen() {
    state = state.copyWith(fullscreen: !state.fullscreen);
  }

  void toggleAmbientMode() {
    state = state.copyWith(ambientMode: !state.ambientMode);
  }

  void hideControls() {
    state = state.copyWith(controlsHidden: true);
  }

  void showControls() {
    state = state.copyWith(controlsHidden: false);
  }

  void maximize() {
    state = state.copyWith(minimized: false);
  }
}
