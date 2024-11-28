import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../notifications/capture_notification.dart';
import '../video_effect_options.dart';

enum EditorEffect {
  text,
  trim,
  filter,
  voiceOver,
  stickers,
  ;

  String get stringValue {
    return switch (this) {
      EditorEffect.text => 'Text',
      EditorEffect.trim => 'Trim',
      EditorEffect.filter => 'Filter',
      EditorEffect.voiceOver => 'Voice Over',
      EditorEffect.stickers => 'Stickers',
    };
  }
}

class EditorEffects extends StatelessWidget {
  const EditorEffects({super.key, this.controller});
  final EffectController? controller;
  @override
  Widget build(BuildContext context) {
    return VideoEffectOptions(
      controller: controller,
      maxShowMore: 5,
      onOpenChanged: (bool isOpened) {
        isOpened
            ? HideControlsNotification().dispatch(context)
            : ShowControlsNotification().dispatch(context);
      },
      labelGetter: (Enum enumValue) => (enumValue as EditorEffect).stringValue,
      items: const <EffectOption>[
        EffectOption(
          icon: Icons.text_decrease,
          value: EditorEffect.text,
        ),
        EffectOption(
          icon: YTIcons.trim,
          value: EditorEffect.trim,
        ),
        EffectOption(
          icon: YTIcons.filter_photo,
          value: EditorEffect.filter,
        ),
        EffectOption(
          icon: YTIcons.mic_outlined,
          value: EditorEffect.voiceOver,
        ),
        EffectOption(
          icon: Icons.sticky_note_2,
          value: EditorEffect.stickers,
        ),
      ],
    );
  }
}
