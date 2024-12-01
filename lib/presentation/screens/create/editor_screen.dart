import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/add_music_button.dart';
import 'widgets/create_close_button.dart';
import 'widgets/editor/editor_effects.dart';
import 'widgets/editor/editor_elements.dart';
import 'widgets/editor/editor_nav_buttons.dart';
import 'widgets/editor/editor_sticker_selector.dart';
import 'widgets/editor/editor_text_input.dart';
import 'widgets/editor/editor_timeline.dart';
import 'widgets/editor/editor_voiceover_recorder.dart';
import 'widgets/editor/elements/element.dart';
import 'widgets/filter_selector.dart';
import 'widgets/notifications/editor_notification.dart';
import 'widgets/video_effect_options.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen>
    with TickerProviderStateMixin {
  final effectsController = EffectController();
  late final AnimationController timelineSizeAnimation = AnimationController(
    vsync: this,
    duration: Durations.medium2,
  );
  late final AnimationController textEditorController = AnimationController(
    vsync: this,
    duration: Durations.short3,
  );
  final ValueNotifier<double> hideNavButtons = ValueNotifier<double>(1);
  final ValueNotifier<bool> hideEditorEffects = ValueNotifier<bool>(false);
  final elementsNotifier = ValueNotifier<List<VideoElementData>>([]);

  @override
  void initState() {
    super.initState();
    effectsController.addStatusListener(effectStatusListener);
  }

  @override
  void dispose() {
    effectsController.removeStatusListener(effectStatusListener);
    elementsNotifier.dispose();
    textEditorController.dispose();
    hideNavButtons.dispose();
    hideEditorEffects.dispose();
    timelineSizeAnimation.dispose();
    super.dispose();
  }

  Future<void> _futureHideShowNavButtons(
    Future<void> Function() callback,
  ) async {
    hideNavButtons.value = 0;
    await Future.wait([
      callback(),
      Future.delayed(
        Durations.medium1,
        () => hideEditorEffects.value = true,
      ),
    ]);
    hideEditorEffects.value = false;
    hideNavButtons.value = 1;
  }

  Future<void> _openTimeline() async {
    hideNavButtons.value = 0;
    await timelineSizeAnimation.forward();
    hideEditorEffects.value = true;
  }

  Future<void> _closeTimeline() async {
    await timelineSizeAnimation.reverse();
    hideNavButtons.value = 1;
    hideEditorEffects.value = false;
  }

  void effectStatusListener(
    EffectAction action,
    EffectOption option,
  ) {
    final effect = option.value as EditorEffect;
    switch (effect) {
      case EditorEffect.text:
        _openTextEditor();
      case EditorEffect.trim:
      // TODO: Handle this case.
      case EditorEffect.filter:
        _showFilterSelector();
      case EditorEffect.voiceOver:
        _showVoiceoverSheet();
      case EditorEffect.stickers:
        _showStickerSelector();
    }
  }

  Future<void> _openTextEditor() async {
    hideNavButtons.value = 0;
    textEditorController.forward();
  }

  Future<void> _closeTextEditor() async {
    await textEditorController.reverse();
    hideNavButtons.value = 1;
  }

  Future<void> _showFilterSelector() async {
    _futureHideShowNavButtons(
      () async {
        await showModalBottomSheet(
          context: context,
          isDismissible: false,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            return const FilterSelector(isEditing: true);
          },
        );
      },
    );
  }

  Future<void> _showVoiceoverSheet() async {
    _futureHideShowNavButtons(
      () async {
        await showModalBottomSheet(
          context: context,
          isDismissible: false,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            return const EditorVoiceoverRecorder();
          },
        );
      },
    );
  }

  Future<void> _showStickerSelector() async {
    _futureHideShowNavButtons(
      () async {
        await showModalBottomSheet(
          context: context,
          isDismissible: false,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            return const EditorStickerSelector();
          },
        );
      },
    );
  }

  bool handleEditorNotification(EditorNotification notification) {
    if (notification is OpenTimelineNotification) {
      _openTimeline();
    } else if (notification is CloseTimelineNotification) {
      _closeTimeline();
    } else if (notification is CreateElementNotification) {
      if (notification.element is TextElement) {
        elementsNotifier.value = [
          ...elementsNotifier.value,
          notification.element,
        ];
        _closeTextEditor();
      }
    } else if (notification is DeleteElementNotification) {
      elementsNotifier.value = [];
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.black,
        child: NotificationListener<EditorNotification>(
          onNotification: handleEditorNotification,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizeTransition(
                                axisAlignment: -1,
                                sizeFactor: timelineSizeAnimation,
                                child: const SizedBox(
                                  width: double.infinity,
                                  height: 384 - 134,
                                ),
                              ),
                            ),
                          ],
                        ),
                        AnimatedVisibility(
                          animation: ReverseAnimation(
                            textEditorController,
                          ),
                          child: EditorElements(data: elementsNotifier),
                        ),
                        AnimatedVisibility(
                          animation: textEditorController,
                          child: const EditorTextInput(),
                        ),
                        AnimatedVisibility(
                          animation: ReverseAnimation(
                            textEditorController,
                          ),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CreateCloseButton(
                                      icon: YTIcons.arrow_back_outlined,
                                    ),
                                    AddMusicButton(),
                                    SizedBox(width: 48),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: HiddenListenableWidget(
                                  listenable: hideEditorEffects,
                                  hideCallback: () => hideEditorEffects.value,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: EditorEffects(
                                        controller: effectsController,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 72),
                  AnimatedVisibility(
                    keepSize: true,
                    animation: Animation.fromValueListenable(
                      hideNavButtons,
                    ),
                    child: const EditorNavButtons(),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizeTransition(
                  axisAlignment: -1,
                  sizeFactor: timelineSizeAnimation,
                  child: const SizedBox(
                    height: 384,
                    width: double.infinity,
                    child: EditorTimeline(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
