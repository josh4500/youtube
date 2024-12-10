import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/core.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/screens/create/provider/short_recording_state.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'provider/shorts_create_state.dart';
import 'provider/voice_over_state.dart';
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
import 'widgets/editor/element.dart';
import 'widgets/filter_selector.dart';
import 'widgets/notifications/editor_notification.dart';
import 'widgets/pre_exit_options_sheet.dart';
import 'widgets/video_effect_options.dart';

class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen>
    with TickerProviderStateMixin {
  final EffectController _effectsController = EffectController();
  final _EditorStateNotifier _editorState = _EditorStateNotifier();
  late final AnimationController _timelineSizeController = AnimationController(
    vsync: this,
    duration: Durations.medium2,
  );
  @override
  void initState() {
    super.initState();
    _effectsController.addStatusListener(effectStatusListener);
  }

  @override
  void dispose() {
    _effectsController.removeStatusListener(effectStatusListener);
    _timelineSizeController.dispose();
    _editorState.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _editorState.createVoiceoverState(
      ref.read(shortRecordingProvider).duration,
    );
    _restoreState();
  }

  void _restoreState() {
    // TODO(josh4500): Looks bad Future does not solve the problem, it silence it
    // Future(() {
    //   final editingState = ref.read(shortsCreateProvider).editingState;
    //   if (editingState != null) {
    //     ref.read(voiceOverStateProvider.notifier).restore(
    //           editingState.voiceRecording,
    //         );
    //     _elementsNotifier.value = editingState.elements;
    //   }
    // });
  }

  void _updateEditState() {
    ref.read(shortsCreateProvider.notifier).updateEditState(
          voiceRecording: _editorState.voiceover,
          elements: _editorState.elements,
        );
  }

  Future<void> _openTimeline() async {
    _editorState._hideButtons();
    await _timelineSizeController.forward();
  }

  Future<void> _closeTimeline() async {
    await _timelineSizeController.reverse();
    _editorState._showButtons();
  }

  void effectStatusListener(
    EffectAction action,
    EffectOption option,
  ) {
    final effect = option.value as EditorEffect;
    switch (effect) {
      case EditorEffect.text:
        _editorState.openTextEditor();
      case EditorEffect.trim:
        _openTrimmerScreen();
      case EditorEffect.filter:
        _showFilterSelector();
      case EditorEffect.voiceOver:
        _showVoiceoverSheet();
      case EditorEffect.stickers:
        _showStickerSelector();
    }
  }

  Future<void> _openTrimmerScreen() async {
    await context.goto(AppRoutes.shortsTrimmer);
  }

  Future<void> _showFilterSelector() async {
    _editorState.wrapForHideShowButtons(
      () async {
        await showModalBottomSheet(
          context: context,
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
    _editorState.wrapForHideShowButtons(
      () async {
        await showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            return const EditorVoiceoverRecorder();
          },
        );
        _updateEditState();
        return true;
      },
    );
  }

  Future<void> _showStickerSelector() async {
    _editorState.wrapForHideShowButtons(
      () async {
        final result = await showModalBottomSheet<Type>(
          context: context,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            return ModelBinding<StickerElement?>(
              model: _editorState.elements.firstWhereOrNull(
                (element) => element is StickerElement,
              ) as StickerElement?,
              child: const EditorStickerSelector(),
            );
          },
        );
        if (result != null) _editorState.openStickerEditor(result);
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
      _editorState.openTextEditor(notification.element);
    } else if (notification is OpenStickerEditorNotification) {
      _editorState.openStickerEditor(notification.type);
    } else if (notification is CloseElementEditorNotification) {
      _editorState.closeTextEditor();
      _editorState.closeStickerEditor();
    } else if (notification is CreateElementNotification) {
      _editorState.createElement(
        notification.element,
        onCreate: _updateEditState,
      );
    } else if (notification is UpdateElementNotification) {
      _editorState.updateElements(
        notification.element,
        swapToLast: notification.swapToLast,
        onUpdate: _updateEditState,
      );
    } else if (notification is DeleteElementNotification) {
      _editorState.removeElement(
        notification.elementId,
        onRemove: _updateEditState,
      );
    }

    return true;
  }

  bool _onPopInvoked() {
    final shortsCreateState = ref.read(shortsCreateProvider);
    if (!(shortsCreateState.editingState?.isEmpty ?? true)) {
      showPreExitSheet(
        context,
        items: [
          PreExitEntry(
            label: 'Discard edits',
            icon: const Icon(YTIcons.undo_arrow),
            action: PreExitAction.discard,
            onTap: () {
              ref.read(shortsCreateProvider.notifier).updateEditState();
              _editorState.clear();
              // TODO(josh4500): proper remove of state
            },
          ),
          PreExitEntry(
            label: 'Save as draft',
            icon: const Icon(Icons.drafts),
            action: PreExitAction.save,
            onTap: _updateEditState,
          ),
        ],
      ).then((PreExitAction? action) {
        if (action != null && action == PreExitAction.save && mounted) {
          context.pop();
        }
      });

      return false;
    }
    return true;
  }

  void _onPopInvokedWithResult<T>(bool didPop, T? result) {
    if (_onPopInvoked()) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: SafeArea(
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: const ColoredBox(
                              color: Colors.white10,
                              child: SizedBox.expand(),
                            ),
                          ),
                          NotifierSelector(
                            notifier: _editorState,
                            selector: (state) => (
                              state.showTextElementEditor,
                              state.showStickerElementEditor,
                              state.elements
                            ),
                            builder: (
                              BuildContext context,
                              (bool, bool, List<ElementData>) elements,
                              Widget? childWidget,
                            ) {
                              return AnimatedValuedVisibility(
                                visible: !(elements.$1 || elements.$2),
                                child: ModelBinding(
                                  model: elements.$3,
                                  child: const EditorElements(),
                                ),
                              );
                            },
                          ),
                          NotifierSelector(
                            notifier: _editorState,
                            selector: (state) => state.showTextElementEditor,
                            builder: (
                              BuildContext context,
                              bool showTextElementEditor,
                              Widget? childWidget,
                            ) {
                              return AnimatedValuedVisibility(
                                visible: showTextElementEditor,
                                child: ModelBinding(
                                  model: _editorState.editingTextElement,
                                  child: const EditorTextInput(),
                                ),
                              );
                            },
                          ),
                          NotifierSelector(
                            notifier: _editorState,
                            selector: (state) => state.editingStickerElement,
                            builder: (
                              BuildContext context,
                              (Type, StickerElement?)? data,
                              Widget? childWidget,
                            ) {
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
                          NotifierSelector(
                            notifier: _editorState,
                            selector: (state) => state.showTopButtons,
                            builder: (
                              BuildContext context,
                              bool showTopButtons,
                              Widget? childWidget,
                            ) {
                              return AnimatedValuedVisibility(
                                visible: showTopButtons,
                                keepAlive: true,
                                child: childWidget,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CreateCloseButton(
                                    onPopInvoked: _onPopInvoked,
                                    icon: YTIcons.arrow_back_outlined,
                                  ),
                                  const AddMusicButton(),
                                  const VoiceoverSettings(),
                                ],
                              ),
                            ),
                          ),
                          NotifierSelector(
                            notifier: _editorState,
                            selector: (state) => state.showEditorEffects,
                            builder: (
                              BuildContext context,
                              bool showEditorEffects,
                              Widget? childWidget,
                            ) {
                              return AnimatedValuedVisibility(
                                visible: showEditorEffects,
                                keepAlive: true,
                                child: childWidget,
                              );
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: EditorEffects(
                                  controller: _effectsController,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: math.max(
                            0,
                            MediaQuery.viewInsetsOf(context).bottom - 134,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 72),
                    NotifierSelector(
                      notifier: _editorState,
                      selector: (state) => state.showNavButtons,
                      builder: (
                        BuildContext context,
                        bool showNavButtons,
                        Widget? childWidget,
                      ) {
                        return AnimatedValuedVisibility(
                          keepAlive: true,
                          visible: showNavButtons,
                          child: const EditorNavButtons(),
                        );
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: NotifierSelector(
                    notifier: _editorState,
                    selector: (state) {
                      return state.elements.whereType<TextElement>().toList();
                    },
                    builder: (
                      BuildContext _,
                      List<TextElement> textElements,
                      Widget? childWidget,
                    ) {
                      return ModelBinding(
                        model: textElements,
                        child: childWidget!,
                      );
                    },
                    child: SizeTransition(
                      axisAlignment: -1,
                      sizeFactor: _timelineSizeController,
                      child: SizedBox(
                        height: 384.h,
                        width: double.infinity,
                        child: const EditorTimeline(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VoiceoverSettings extends ConsumerWidget {
  const VoiceoverSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(voiceOverStateProvider);
    if (state.recordings.isNotEmpty) {
      return CustomInkWell(
        onTap: () {},
        padding: const EdgeInsets.all(8),
        splashFactory: NoSplash.splashFactory,
        child: const Icon(YTIcons.tune_outlined),
      );
    }
    return const SizedBox(width: 48);
  }
}

class _EditorStateNotifier extends ChangeNotifier {
  bool _showNavButtons = true;
  bool _showTopButtons = true;
  bool _showEditorEffects = true;
  List<ElementData> _elements = <ElementData>[];
  TextElement? _editingTextElement;
  (Type, StickerElement?)? _editingStickerElement;
  late RecordingState<VoiceRecording> _voiceover;

  bool _showTextElementEditor = false;
  bool get showTextElementEditor => _showTextElementEditor;

  bool _showStickerElementEditor = false;
  bool get showStickerElementEditor => _showStickerElementEditor;

  bool get showNavButtons => _showNavButtons;
  bool get showTopButtons => _showTopButtons;
  bool get showEditorEffects => _showEditorEffects;
  List<ElementData> get elements => List.unmodifiable(_elements);
  TextElement? get editingTextElement => _editingTextElement;
  (Type, StickerElement?)? get editingStickerElement => _editingStickerElement;
  RecordingState<VoiceRecording> get voiceover => _voiceover;

  void createVoiceoverState(Duration duration) {
    _voiceover = RecordingState<VoiceRecording>(recordDuration: duration);
  }

  void openTextEditor([TextElement? element]) {
    _editingTextElement = element;
    _showTextElementEditor = true;
    _hideButtons();
  }

  void closeTextEditor() async {
    _editingTextElement = null;
    _showTextElementEditor = false;

    _showButtons();
  }

  void openStickerEditor(Type elementType) {
    assert(
      elementType == QaStickerElement ||
          elementType == AddYStickerElement ||
          elementType == PollStickerElement,
      'Must be a StickerElement type',
    );

    final previousStickerElement = _elements.firstWhereOrNull(
      (ElementData element) => element is StickerElement,
    ) as StickerElement?;

    if (previousStickerElement != null) {
      _elements.removeWhere(
        (element) => element is StickerElement,
      );
      notifyListeners();
    }
    _showStickerElementEditor = true;
    _editingStickerElement = (elementType, previousStickerElement);
    _hideButtons();
  }

  Future<void> closeStickerEditor() async {
    _editingStickerElement = null;
    _showStickerElementEditor = false;
    _showButtons();
  }

  void createElement(ElementData element, {VoidCallback? onCreate}) {
    final previousStickerElement = _elements.lastWhereOrNull(
      (ElementData element) => element is StickerElement,
    );

    if (element is StickerElement && previousStickerElement != null) {
      _elements.removeWhere((ElementData element) => element is StickerElement);
    }

    // Add element to list
    _elements.add(element);

    _editingTextElement = null;
    _editingStickerElement = null;
    _showTextElementEditor = false;
    _showStickerElementEditor = false;

    onCreate?.call();
    _showButtons();
  }

  void updateElements(
    ElementData newElement, {
    required bool swapToLast,
    VoidCallback? onUpdate,
  }) {
    assert(_elements.isNotEmpty, 'Cannot update empty Elements');
    // Do a swap of location
    if (swapToLast) {
      if (_elements.length > 1) {
        final last = _elements.last;
        if (newElement.id != last.id) {
          _elements
            ..removeWhere((element) => element.id == newElement.id)
            ..add(newElement);
        }
      }
      // Receiving this notification means user starts dragging
      _hideButtons();
    } else {
      final StickerElement? stickerElement;
      if (newElement is! StickerElement) {
        stickerElement = _elements.firstWhereOrNull(
          (ElementData element) => element is StickerElement,
        ) as StickerElement?;
      } else {
        stickerElement = null;
      }

      _elements.removeWhere(
        (element) => element.id == newElement.id || (element is StickerElement),
      );

      _elements = [
        ..._elements,
        newElement,
        if (stickerElement != null) stickerElement,
      ];
      onUpdate?.call();
      // Receiving this notification means user ends dragging
      _showButtons();
    }
  }

  void removeElement(int elementId, {VoidCallback? onRemove}) {
    _elements.removeWhere((ElementData element) => element.id == elementId);
    onRemove?.call();
    // Receiving this notification means user ends dragging
    _showButtons();
  }

  void _showButtons() {
    _showTopButtons = true;
    _showNavButtons = true;
    _showEditorEffects = true;

    notifyListeners();
  }

  void _hideButtons() {
    _showTopButtons = false;
    _showNavButtons = false;
    _showEditorEffects = false;
    notifyListeners();
  }

  Future<void> wrapForHideShowButtons(
    Future<bool> Function() callback,
  ) async {
    _showNavButtons = false;
    notifyListeners();
    final result = await Future.wait([
      callback(),
      Future.delayed(
        Durations.medium1,
        () {
          _showTopButtons = false;
          _showEditorEffects = false;
          notifyListeners();
          return true;
        },
      ),
    ]);
    if (result.first) {
      _showButtons();
    }
  }

  void clear() {
    _elements.clear();
    notifyListeners();
  }
}
