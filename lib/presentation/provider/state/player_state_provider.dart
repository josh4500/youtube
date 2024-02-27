import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_state_provider.g.dart';

class PlayerState {
  final bool loading;
  final bool playing;
  final bool expanded;
  final bool fullscreen;
  final bool minimized;
  final bool ended;
  final bool ambientMode;

  const PlayerState({
    required this.loading,
    required this.playing,
    required this.expanded,
    required this.fullscreen,
    required this.minimized,
    required this.ended,
    required this.ambientMode,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerState &&
          runtimeType == other.runtimeType &&
          loading == other.loading &&
          playing == other.playing &&
          expanded == other.expanded &&
          fullscreen == other.fullscreen &&
          minimized == other.minimized &&
          ended == other.ended &&
          ambientMode == other.ambientMode;

  @override
  int get hashCode =>
      loading.hashCode ^
      playing.hashCode ^
      expanded.hashCode ^
      fullscreen.hashCode ^
      minimized.hashCode ^
      ended.hashCode ^
      ambientMode.hashCode;

  PlayerState copyWith({
    bool? loading,
    bool? playing,
    bool? expanded,
    bool? fullscreen,
    bool? minimized,
    bool? ended,
    bool? ambientMode,
  }) {
    return PlayerState(
      loading: loading ?? this.loading,
      playing: playing ?? this.playing,
      expanded: expanded ?? this.expanded,
      fullscreen: fullscreen ?? this.fullscreen,
      minimized: minimized ?? this.minimized,
      ended: ended ?? this.ended,
      ambientMode: ambientMode ?? this.ambientMode,
    );
  }
}

@Riverpod(keepAlive: true)
class PlayerNotifier extends _$PlayerNotifier {
  @override
  PlayerState build() {
    return const PlayerState(
      loading: true,
      playing: false,
      expanded: false,
      minimized: false,
      fullscreen: false,
      ambientMode: false,
      ended: false,
    );
  }

  void pause() {
    state = state.copyWith(playing: false, loading: false);
  }

  void play() {
    state = state.copyWith(playing: true, loading: false);
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

  void end() {
    state = state.copyWith(ended: true, playing: false);
  }

  void restart() {
    state = state.copyWith(ended: false, playing: true);
  }

  void showControls() {
    state = state.copyWith(ended: false);
  }

  void minimize() {
    state = state.copyWith(minimized: false);
  }

  void maximize() {
    state = state.copyWith(minimized: false);
  }

  void expand() {
    state = state.copyWith(expanded: true);
  }

  void deExpand() {
    state = state.copyWith(expanded: false);
  }

  void reset() {
    state = const PlayerState(
      loading: true,
      playing: false,
      expanded: false,
      minimized: false,
      fullscreen: false,
      ambientMode: false,
      ended: false,
    );
  }
}
