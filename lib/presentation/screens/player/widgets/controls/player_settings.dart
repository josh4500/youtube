import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/constants/values.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/controls/player_notifications.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

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

class PlayerSettingsSwitch extends StatelessWidget {
  const PlayerSettingsSwitch({
    super.key,
    required this.selected,
    this.thumbSize = 24,
  });

  final bool selected;
  final double thumbSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: thumbSize * 2,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: selected ? Colors.white : const Color(0xFFAAAAAA),
        borderRadius: BorderRadius.circular(64),
      ),
      child: Align(
        alignment: selected ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: thumbSize,
          height: thumbSize,
          decoration: BoxDecoration(
            color: const Color(0xFF212121),
            borderRadius: BorderRadius.circular(64),
          ),
        ),
      ),
    );
  }
}
