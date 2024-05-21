import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_state_provider.g.dart';

// enum PlayerStateEnum{
//   ended,
//   playing,
//   loading,
//   buffering,
//   hasNext,
//   hasPrevious,
// }

class PlayerState {
  const PlayerState({
    required this.loading,
    required this.buffering,
    required this.playing,
    required this.ended,
  });

  final bool loading;
  final bool buffering;
  final bool playing;
  final bool ended;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerState &&
          runtimeType == other.runtimeType &&
          loading == other.loading &&
          playing == other.playing &&
          buffering == other.buffering &&
          ended == other.ended;

  @override
  int get hashCode =>
      loading.hashCode ^ playing.hashCode ^ ended.hashCode ^ buffering.hashCode;

  PlayerState copyWith({
    bool? loading,
    bool? buffering,
    bool? playing,
    bool? ended,
  }) {
    return PlayerState(
      loading: loading ?? this.loading,
      buffering: buffering ?? this.buffering,
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
      buffering: true,
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

  void buffering() {
    state = state.copyWith(buffering: true);
  }

  void bufferingEnd() {
    state = state.copyWith(buffering: false);
  }

  void restart([bool playing = true]) {
    state = state.copyWith(ended: false, playing: playing);
  }

  void reset() {
    state = const PlayerState(
      loading: true,
      buffering: true,
      playing: false,
      ended: false,
    );
  }
}
