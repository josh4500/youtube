import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_state_provider.g.dart';

class PlayerState {
  final bool loading;
  final bool playing;
  final bool ended;

  const PlayerState({
    required this.loading,
    required this.playing,
    required this.ended,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerState &&
          runtimeType == other.runtimeType &&
          loading == other.loading &&
          playing == other.playing &&
          ended == other.ended;

  @override
  int get hashCode => loading.hashCode ^ playing.hashCode ^ ended.hashCode;

  PlayerState copyWith({
    bool? loading,
    bool? playing,
    bool? ended,
  }) {
    return PlayerState(
      loading: loading ?? this.loading,
      playing: playing ?? this.playing,
      ended: ended ?? this.ended,
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
      ended: false,
    );
  }

  void pause() {
    state = state.copyWith(playing: false, loading: false);
  }

  void play() {
    state = state.copyWith(playing: true, loading: false);
  }

  void end() {
    state = state.copyWith(ended: true, playing: false);
  }

  void restart() {
    state = state.copyWith(ended: false, playing: true);
  }

  void reset() {
    state = const PlayerState(
      loading: true,
      playing: false,
      ended: false,
    );
  }
}
