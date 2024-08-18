import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../notifications/capture_notification.dart';
import '../video_effect_options.dart';

enum CaptureEffect {
  flip,
  speed,
  timer,
  effect,
  greenScreen,
  retouch,
  filter,
  align,
  lighting,
  flash,
  trim;

  String get stringValue {
    return switch (this) {
      CaptureEffect.flip => 'Flip',
      CaptureEffect.speed => 'Speed',
      CaptureEffect.timer => 'Timer',
      CaptureEffect.effect => 'Effects',
      CaptureEffect.greenScreen => 'Green Screen',
      CaptureEffect.retouch => 'Retouch',
      CaptureEffect.filter => 'Filter',
      CaptureEffect.align => 'Align',
      CaptureEffect.lighting => 'Lighting',
      CaptureEffect.flash => 'Flash',
      CaptureEffect.trim => 'Trim',
    };
  }
}

class CaptureEffects extends StatelessWidget {
  const CaptureEffects({super.key, this.controller});
  final EffectController? controller;
  @override
  Widget build(BuildContext context) {
    return VideoEffectOptions(
      controller: controller,
      onOpenChanged: (bool isOpened) {
        isOpened
            ? HideControlsNotification().dispatch(context)
            : ShowControlsNotification().dispatch(context);
      },
      labelGetter: (Enum enumValue) => (enumValue as CaptureEffect).stringValue,
      items: const <EffectOption>[
        EffectOption(
          icon: YTIcons.flip_camera,
          animation: EffectTapAnimation.rotate,
          value: CaptureEffect.flip,
        ),
        EffectOption(
          icon: YTIcons.speed,
          value: CaptureEffect.speed,
        ),
        EffectOption(
          icon: Icons.timer_sharp,
          value: CaptureEffect.timer,
        ),
        EffectOption(
          icon: YTIcons.sparkle,
          value: CaptureEffect.effect,
        ),
        EffectOption(
          icon: YTIcons.green_screen,
          value: CaptureEffect.greenScreen,
        ),
        EffectOption(
          icon: YTIcons.retouch,
          value: CaptureEffect.retouch,
        ),
        EffectOption(
          icon: YTIcons.filter_photo,
          value: CaptureEffect.filter,
        ),
        EffectOption(
          icon: YTIcons.align,
          value: CaptureEffect.align,
        ),
        EffectOption(
          icon: YTIcons.lighting,
          activeIcon: Icons.light_mode,
          value: CaptureEffect.lighting,
        ),
        EffectOption(
          icon: YTIcons.flash_off,
          activeIcon: Icons.flash_on,
          value: CaptureEffect.flash,
        ),
        EffectOption(
          icon: YTIcons.trim,
          value: CaptureEffect.trim,
        ),
      ],
    );
  }
}
