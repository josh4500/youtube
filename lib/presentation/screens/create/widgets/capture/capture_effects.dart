import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../notifications/capture_notification.dart';
import '../video_effect_options.dart';

class CaptureEffects extends StatelessWidget {
  const CaptureEffects({super.key, this.controller});
  final VideoEffectOptionsController? controller;
  @override
  Widget build(BuildContext context) {
    return VideoEffectOptions(
      controller: controller,
      onExpand: (bool isOpened) {
        isOpened
            ? HideCaptureControlsNotification().dispatch(context)
            : ShowCaptureControlsNotification().dispatch(context);
      },
      items: const <EffectOption>[
        EffectOption(
          icon: YTIcons.flip_camera,
          label: 'Flip',
        ),
        EffectOption(
          icon: YTIcons.speed,
          label: 'Speed',
        ),
        EffectOption(
          icon: Icons.timer_sharp,
          label: 'Timer',
        ),
        EffectOption(
          icon: YTIcons.sparkle,
          label: 'Effects',
        ),
        EffectOption(
          icon: YTIcons.green_screen,
          label: 'Green Screen',
        ),
        EffectOption(
          icon: YTIcons.retouch,
          label: 'Retouch',
        ),
        EffectOption(
          icon: YTIcons.filter_photo,
          label: 'Filter',
        ),
        EffectOption(
          icon: YTIcons.align,
          label: 'Align',
        ),
        EffectOption(
          icon: YTIcons.lighting,
          activeIcon: Icons.light_mode,
          label: 'Lighting',
        ),
        EffectOption(
          icon: YTIcons.flash_off,
          activeIcon: Icons.flash_on,
          label: 'Flash',
        ),
        EffectOption(
          icon: YTIcons.trim,
          label: 'Flash',
        ),
      ],
    );
  }
}
