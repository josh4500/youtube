import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'player_notifications.dart';

class PlayerSettings extends StatelessWidget {
  const PlayerSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return AppbarAction(
      icon: YTIcons.settings_outlined,
      onTap: () => SettingsPlayerNotification().dispatch(context),
    );
  }
}

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    super.key,
    required this.selected,
    this.thumbSize = 18,
  });

  final bool selected;
  final double thumbSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: thumbSize * 2,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: selected
            ? context.theme.colorScheme.surface
            : context.theme.colorScheme.surface.withOpacity(.2),
        borderRadius: BorderRadius.circular(64),
      ),
      child: Align(
        alignment: selected ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: thumbSize,
          height: thumbSize,
          decoration: BoxDecoration(
            color: context.theme.colorScheme.inverseSurface.withOpacity(.9),
            borderRadius: BorderRadius.circular(64),
          ),
        ),
      ),
    );
  }
}
