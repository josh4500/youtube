import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';

part 'player_signal_provider.g.dart';

@Riverpod(
  keepAlive: true,
  dependencies: [playerRepository],
)
Stream<PlayerSignal> playerSignal(Ref ref) {
  final playerRepository = ref.watch(playerRepositoryProvider);
  return playerRepository.playerSignalStream;
}
