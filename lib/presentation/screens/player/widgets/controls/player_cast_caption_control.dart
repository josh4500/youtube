import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/state/player_state_provider.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets/appbar_action.dart';

class PlayerCastCaptionControl extends ConsumerWidget {
  const PlayerCastCaptionControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerNotifier = ref.watch(playerNotifierProvider);
    if (playerNotifier.ended) return const SizedBox();
    return const Row(
      children: [
        AppbarAction(icon: YTIcons.cast_outlined),
        AppbarAction(icon: Icons.closed_caption_off),
      ],
    );
  }
}
