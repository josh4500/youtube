import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';

part 'player_tap_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<PlayerTapActor> playerTap(PlayerTapRef ref) {
  return ref.watch(playerRepositoryProvider).playerTapStream;
}
