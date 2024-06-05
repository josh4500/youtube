import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/preferences.dart';

class PlayerAmbient extends ConsumerWidget {
  const PlayerAmbient({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool ambientMode = ref.watch(
      preferencesProvider.select((PreferenceState value) => value.ambientMode),
    );
    if (!ambientMode) {
      return const SizedBox();
    }
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.13),
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
            Colors.transparent,
          ],
          stops: const [0.4, 0.6, 0.8, 1.0],
        ),
      ),
    );
  }
}
