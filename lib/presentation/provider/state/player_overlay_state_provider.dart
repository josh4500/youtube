import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_overlay_state_provider.g.dart';

@Riverpod(keepAlive: true)
bool playerOverlayState(PlayerOverlayStateRef ref) {
  return false;
}
