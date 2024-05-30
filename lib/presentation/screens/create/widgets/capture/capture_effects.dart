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
      onExpand: (bool closed) {
        closed
            ? ShowCaptureControlsNotification().dispatch(context)
            : HideCaptureControlsNotification().dispatch(context);
      },
      items: const <EffectItem>[
        EffectItem(
          icon: YTIcons.flip_camera,
          label: 'Flip',
        ),
        EffectItem(
          icon: YTIcons.speed,
          label: 'Speed',
        ),
        EffectItem(
          icon: Icons.timer_sharp,
          label: 'Timer',
        ),
        EffectItem(
          icon: YTIcons.sparkle,
          label: 'Effects',
        ),
        EffectItem(
          icon: YTIcons.green_screen,
          label: 'Green Screen',
        ),
        EffectItem(
          icon: YTIcons.retouch,
          label: 'Retouch',
        ),
        EffectItem(
          icon: YTIcons.filter_photo,
          label: 'Filter',
        ),
        EffectItem(
          icon: YTIcons.lighting,
          label: 'Lighting',
        ),
        EffectItem(
          icon: YTIcons.flash_off,
          label: 'Flash',
        ),
      ],
    );
  }
}
