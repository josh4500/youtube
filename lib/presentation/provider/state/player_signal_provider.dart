import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';

part 'player_signal_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<PlayerSignal> playerSignal(PlayerSignalRef ref) {
  return ref.watch(playerRepositoryProvider).playerSignalStream;
}
