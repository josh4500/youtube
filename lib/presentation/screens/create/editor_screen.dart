import 'package:flutter/material.dart';
import 'package:youtube_clone/core.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/add_music_button.dart';
import 'widgets/create_close_button.dart';
import 'widgets/editor/editor_effects.dart';
import 'widgets/editor/editor_elements.dart';
import 'widgets/editor/editor_nav_buttons.dart';
import 'widgets/editor/editor_sticker_input.dart';
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
  final ValueNotifier<bool> hideTopButtons = ValueNotifier<bool>(false);
  final ValueNotifier<bool> hideEditorEffects = ValueNotifier<bool>(false);
  final ValueNotifier<(Type, StickerElement?)?> _stickerElementNotifier =
      ValueNotifier(
    null,
  );
  final elementsNotifier = ValueNotifier<List<VideoElementData>>([]);
  final ValueNotifier<TextElement?> _textElementNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    effectsController.addStatusListener(effectStatusListener);
  }

  @override
  void dispose() {
    effectsController.removeStatusListener(effectStatusListener);
    _stickerElementNotifier.dispose();
    _textElementNotifier.dispose();
    elementsNotifier.dispose();
    textEditorController.dispose();
    hideTopButtons.dispose();
    hideNavButtons.dispose();
    hideEditorEffects.dispose();
    timelineSizeAnimation.dispose();
    super.dispose();
  }

  Future<void> _futureHideShowNavButtons(
    Future<bool> Function() callback,
  ) async {
    hideNavButtons.value = 0;
    final result = await Future.wait([
      callback(),
      Future.delayed(
        Durations.medium1,
        () => hideEditorEffects.value = true,
      ),
    ]);
    if (result.first) {
      hideEditorEffects.value = false;
      hideNavButtons.value = 1;
    }
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
    _textElementNotifier.value = null;
    hideNavButtons.value = 1;
  }

  Future<void> _openStickerEditor([Type? elementType]) async {
    if (elementType != null) {
      assert(
        elementType == QaStickerElement ||
            elementType == AddYStickerElement ||
            elementType == PollStickerElement,
        'Must be a StickerElement',
      );

      final previousStickerElement = elementsNotifier.value.firstWhereOrNull(
        (element) => element is StickerElement,
      ) as StickerElement?;

      if (previousStickerElement != null) {
        final oldElements = elementsNotifier.value;
        oldElements.removeWhere(
          (element) => element is StickerElement,
        );
        elementsNotifier.value = [...oldElements];
      }

      hideTopButtons.value = true;
      hideNavButtons.value = 0;
      hideEditorEffects.value = true;
      _stickerElementNotifier.value = (elementType, previousStickerElement);
    }
  }

  Future<void> _closeStickerEditor() async {
    _stickerElementNotifier.value = null;

    hideTopButtons.value = false;
    hideNavButtons.value = 1;
    hideEditorEffects.value = false;
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
        return true;
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
        return true;
      },
    );
  }

  Future<void> _showStickerSelector() async {
    _futureHideShowNavButtons(
      () async {
        final result = await showModalBottomSheet<Type>(
          context: context,
          isDismissible: false,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            return ModelBinding<StickerElement?>(
              model: elementsNotifier.value.firstWhereOrNull(
                (element) => element is StickerElement,
              ) as StickerElement?,
              child: const EditorStickerSelector(),
            );
          },
        );
        _openStickerEditor(result);
        return result == null;
      },
    );
  }

  bool handleEditorNotification(EditorNotification notification) {
    if (notification is OpenTimelineNotification) {
      _openTimeline();
    } else if (notification is CloseTimelineNotification) {
      _closeTimeline();
    } else if (notification is OpenTextEditorNotification) {
      _textElementNotifier.value = notification.element;
      _openTextEditor();
    } else if (notification is OpenStickerEditorNotification) {
      _openStickerEditor(notification.type);
    } else if (notification is CloseElementEditorNotification) {
      _closeTextEditor();
      _closeStickerEditor();
    } else if (notification is CreateElementNotification) {
      _closeTextEditor();
      _closeStickerEditor();

      bool add = true;
      final previousStickerElement = elementsNotifier.value.firstWhereOrNull(
        (element) => element is StickerElement,
      );

      if (notification.element is StickerElement) {
        if (previousStickerElement != null) {
          add = false;
        }
      } else if (previousStickerElement != null) {
        elementsNotifier.value.removeWhere(
          (element) => element is StickerElement,
        );
      }

      if (add) {
        // Add element to list
        elementsNotifier.value = [
          ...elementsNotifier.value,
          notification.element,
          if (previousStickerElement != null) previousStickerElement,
        ];
      }
    } else if (notification is UpdateElementNotification) {
      assert(elementsNotifier.value.isNotEmpty, 'Cannot update empty Elements');
      // Do a swap of location
      if (notification.swapToLast) {
        final last = elementsNotifier.value.last;
        if (notification.element.id != last.id) {
          elementsNotifier.value.removeWhere(
            (element) => element.id == notification.element.id,
          );
          elementsNotifier.value = [
            ...elementsNotifier.value,
            notification.element,
          ];
        }

        // Receiving this notification means user starts dragging
        hideTopButtons.value = true;
        hideNavButtons.value = 0;
        hideEditorEffects.value = true;
      } else {
        // Receiving this notification means user ends dragging
        hideTopButtons.value = false;
        hideNavButtons.value = 1;
        hideEditorEffects.value = false;

        final StickerElement? stickerElement;
        if (notification.element is! StickerElement) {
          stickerElement = elementsNotifier.value.firstWhereOrNull(
            (element) => element is StickerElement,
          ) as StickerElement?;
        } else {
          stickerElement = null;
        }
        elementsNotifier.value.removeWhere(
          (element) =>
              element.id == notification.element.id ||
              (element is StickerElement),
        );

        elementsNotifier.value = [
          ...elementsNotifier.value,
          notification.element,
          if (stickerElement != null) stickerElement,
        ];
      }
    } else if (notification is DeleteElementNotification) {
      final oldElements = elementsNotifier.value;
      oldElements.removeWhere(
        (element) => element.id == notification.elementId,
      );
      elementsNotifier.value = [...oldElements];

      // Receiving this notification means user ends dragging
      hideTopButtons.value = false;
      hideNavButtons.value = 1;
      hideEditorEffects.value = false;
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
                                  color: Colors.white10,
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
                          child: ModelBinding(
                            model: elementsNotifier,
                            child: const EditorElements(),
                          ),
                        ),
                        ListenableBuilder(
                          listenable: _textElementNotifier,
                          builder: (BuildContext context, Widget? _) {
                            return AnimatedVisibility(
                              animation: textEditorController,
                              keepAlive: true,
                              child: ModelBinding<TextElement?>(
                                model: _textElementNotifier.value,
                                child: const EditorTextInput(),
                              ),
                            );
                          },
                        ),
                        ListenableBuilder(
                          listenable: _stickerElementNotifier,
                          builder: (BuildContext context, Widget? _) {
                            final data = _stickerElementNotifier.value;
                            return AnimatedValuedVisibility(
                              visible: data != null,
                              keepState: false,
                              duration: Durations.short2,
                              child: ModelBinding(
                                model: data,
                                child: const EditorStickerInput(),
                              ),
                            );
                          },
                        ),
                        AnimatedVisibility(
                          animation: ReverseAnimation(
                            textEditorController,
                          ),
                          child: Column(
                            children: [
                              HiddenListenableWidget(
                                listenable: hideTopButtons,
                                hideCallback: () => hideTopButtons.value,
                                child: const Padding(
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
                    keepAlive: true,
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