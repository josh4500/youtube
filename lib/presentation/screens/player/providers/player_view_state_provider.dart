import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';

part 'player_view_state_provider.g.dart';

@Riverpod(
  keepAlive: true,
  dependencies: [playerRepository],
)
Set<PlayerViewState> playerViewState(PlayerViewStateRef ref) {
  final playerRepository = ref.watch(playerRepositoryProvider);
  return playerRepository.playerViewState;
}
