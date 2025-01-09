import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/provider/state/player_state_provider.dart';
import 'package:youtube_clone/presentation/screens/video/player_view_controller.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets/appbar_action.dart';

class PlayerCastCaptionControl extends StatelessWidget {
  const PlayerCastCaptionControl({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.provide<PlayerViewController>();
    return NotifierSelector(
      notifier: controller,
      selector: (controller) {
        return !controller.playerState.ended && !controller.playerState.loading;
      },
      builder: (
        BuildContext context,
        bool visible,
        Widget? _,
      ) {
        return Visibility(
          visible: visible,
          child: const Row(
            children: [
              AppbarAction(icon: YTIcons.cast_outlined),
              AppbarAction(
                enabled: false,
                icon: Icons.closed_caption_off,
              ),
            ],
          ),
        );
      },
    );
  }
}
