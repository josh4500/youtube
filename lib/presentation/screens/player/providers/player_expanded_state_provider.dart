import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';

part 'player_expanded_state_provider.g.dart';

@Riverpod(keepAlive: true, dependencies: [playerRepository])
Stream<PlayerSignal> playerExpandedState(PlayerExpandedStateRef ref) {
  return ref.watch(playerRepositoryProvider).playerSignalStream.where(
        (event) =>
            event == PlayerSignal.enterExpanded ||
            event == PlayerSignal.exitExpanded,
      );
}
