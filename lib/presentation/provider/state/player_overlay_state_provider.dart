import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_overlay_state_provider.g.dart';

@Riverpod(keepAlive: true)
bool playerOverlayState(Ref ref) {
  return false;
}
