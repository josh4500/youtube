// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core/utils/normalization.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/screens/create/provider/current_timeline_state.dart';
import 'package:youtube_clone/presentation/screens/create/provider/index_notifier.dart';
import 'package:youtube_clone/presentation/screens/create/provider/short_recording_state.dart';
import 'package:youtube_clone/presentation/screens/create/widgets/capture/capture_speed.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/capture/capture_button.dart';
import 'widgets/capture/capture_effects.dart';
import 'widgets/capture/capture_focus_indicator.dart';
import 'widgets/capture/capture_shorts_duration.dart';
import 'widgets/capture/capture_timeline_control.dart';
import 'widgets/capture/capture_zoom_indicator.dart';
import 'widgets/check_permission.dart';
import 'widgets/create_close_button.dart';
import 'widgets/create_permission_reason.dart';
import 'widgets/create_progress.dart';
import 'widgets/notifications/capture_notification.dart';
import 'widgets/notifications/create_notification.dart';
import 'widgets/video_effect_options.dart';

class CreateShortsScreen extends StatefulWidget {
  const CreateShortsScreen({super.key});

  @override
  State<CreateShortsScreen> createState() => _CreateShortsScreenState();
}

class _CreateShortsScreenState extends State<CreateShortsScreen> {
  final completer = Completer<CreateCameraState>();

  @override
  void initState() {
    super.initState();
    completer.complete(CreateCameraState.requestCamera());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<CreateCameraState>(
        initialData: CreateCameraState(hasPermissions: false),
        future: completer.future,
        builder: (
          BuildContext context,
          AsyncSnapshot<CreateCameraState> snapshot,
        ) {
          final CreateCameraState state = snapshot.data!;
          return ModelBinding<CreateCameraState>(
            model: state,
            child: Builder(
              builder: (BuildContext context) {
                if (state.hasPermissions && state.cameras.isNotEmpty) {
                  return const CaptureShortsView();
                }
                return CreateShortsPermissionRequest(
                  checking: !state.requested,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CaptureShortsView extends ConsumerStatefulWidget {
  const CaptureShortsView({super.key});

  @override
  ConsumerState<CaptureShortsView> createState() => _CaptureShortsViewState();
}

class _CaptureShortsViewState extends ConsumerState<CaptureShortsView>
    with
        WidgetsBindingObserver,
        TickerProviderStateMixin,
        TabIndexListenerMixin {
  CameraController? controller;

  bool _controlHidden = false;
  late final AnimationController hideController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  late final Animation<double> hideAnimation;

  late final AnimationController hideZoomController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  late final AnimationController hideSpeedController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );

  final ValueNotifier<String> latestControlMessage = ValueNotifier<String>('');
  Timer? controlMessageTimer;

  final effectsController = EffectController();

  final hasInitCameraNotifier = ValueNotifier<CameraDescription?>(null);

  final ValueNotifier<Offset> focusPosition = ValueNotifier(Offset.zero);

  late final AnimationController focusController = AnimationController(
    vsync: this,
    value: 1,
    duration: const Duration(milliseconds: 1000),
  );
  bool disableDragMode = false;
  bool droppedButton = false;
  final recordingNotifier = ValueNotifier<bool>(false);
  final dragRecordNotifier = ValueNotifier<bool>(false);
  final dragZoomLevelNotifier = ValueNotifier<double>(0);
  final recordOuterButtonPosition = ValueNotifier<Offset?>(null);
  final recordInnerButtonPosition = ValueNotifier<Offset?>(null);
  late final recordOuterButtonController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;

  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;

  static const double bottomPaddingHeight = 48;

  final Set<CaptureEffect> _enabledCaptureEffects = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    hideAnimation = ReverseAnimation(
      CurvedAnimation(
        parent: hideController,
        curve: Curves.easeInCubic,
      ),
    );

    effectsController.addStatusListener(effectStatusListener);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    effectsController.removeStatusListener(effectStatusListener);

    hasInitCameraNotifier.value = null;
    hasInitCameraNotifier.dispose();

    controller?.dispose();
    controller = null;

    controlMessageTimer?.cancel();
    latestControlMessage.dispose();
    effectsController.dispose();

    focusPosition.dispose();
    focusController.dispose();

    recordOuterButtonController.dispose();
    recordingNotifier.dispose();
    dragRecordNotifier.dispose();
    dragZoomLevelNotifier.dispose();
    recordOuterButtonPosition.dispose();
    recordInnerButtonPosition.dispose();

    hideController.dispose();
    hideSpeedController.dispose();
    hideZoomController.dispose();
    super.dispose();
  }

  Offset getDragCircleInitPosition(BoxConstraints constraints) {
    return Offset(
      (constraints.maxWidth / 2) - (kRecordOuterButtonSize / 2),
      (constraints.maxHeight) - kRecordOuterButtonSize - bottomPaddingHeight,
    );
  }

  static const double offsetYFromCircle =
      (kRecordOuterButtonSize - kRecordInnerButtonSize) / 2;

  static const bottomOffset = offsetYFromCircle - bottomPaddingHeight;

  Offset getCenterButtonInitPosition(BoxConstraints constraints) {
    return Offset(
      (constraints.maxWidth / 2) - (kRecordInnerButtonSize / 2),
      (constraints.maxHeight) - kRecordOuterButtonSize + bottomOffset,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (hasInitCameraNotifier.value == null) {
      final cameraState = ModelBinding.of<CreateCameraState>(context);
      if (cameraState.cameras.isNotEmpty) {
        onNewCameraSelected(cameraState.cameras.first);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (currentTabIndex != CreateTab.shorts) return;

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
      hasInitCameraNotifier.value = null;
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description).then((_) {
        // Re-add effects that was previously removed when controller was disposed
        for (final effect in _enabledCaptureEffects) {
          _onUpdateCaptureEffect(effect, true);
        }
      });
    }
  }

  @override
  void onIndexChanged(int newIndex) {
    final CameraController? cameraController = controller;

    // Create tab changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (newIndex != CreateTab.shorts.index) {
      cameraController.dispose();
      hasInitCameraNotifier.value = null;
    } else if (newIndex == CreateTab.shorts.index) {
      onNewCameraSelected(cameraController.description);
    }
  }

  void _onUpdateCaptureEffect(CaptureEffect effect, bool isAdded) {
    switch (effect) {
      case CaptureEffect.flip:
        _flipCamera();
      case CaptureEffect.speed:
        isAdded ? hideSpeedController.forward() : hideSpeedController.reverse();
      case CaptureEffect.timer:
      // TODO: Handle this case.
      case CaptureEffect.effect:
      // TODO: Handle this case.
      case CaptureEffect.greenScreen:
      // TODO: Handle this case.
      case CaptureEffect.retouch:
      // TODO: Handle this case.
      case CaptureEffect.filter:
      // TODO: Handle this case.
      case CaptureEffect.align:
      // TODO: Handle this case.
      case CaptureEffect.lighting:
        if (isAdded) {
          setExposureOffset(
            .75.normalizeRange(
              _minAvailableExposureOffset,
              _maxAvailableExposureOffset,
            ),
          );
        } else {
          setExposureOffset(_minAvailableExposureOffset);
        }
      case CaptureEffect.flash:
        isAdded ? setFlashMode(FlashMode.torch) : setFlashMode(FlashMode.off);
      case CaptureEffect.trim:
      // TODO: Handle this case.
    }
  }

  void effectStatusListener(
    EffectAction action,
    EffectOption option,
  ) {
    final effect = option.value as CaptureEffect;
    final isAdded = action == EffectAction.add;

    _onUpdateCaptureEffect(effect, isAdded);

    if ([CaptureEffect.flip, CaptureEffect.speed].contains(effect)) {
      isAdded
          ? _enabledCaptureEffects.add(effect)
          : _enabledCaptureEffects.remove(effect);
    }
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController? oldController = controller;
    if (oldController != null) {
      // `controller` needs to be set to null before getting disposed,
      // to avoid a race condition when we use the controller that is being
      // disposed. This happens when camera permission dialog shows up,
      // which triggers `didChangeAppLifecycleState`, which disposes and
      // re-creates the controller.
      controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.veryHigh,
      fps: 30,
      videoBitrate: 200000,
      audioBitrate: 32000,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    try {
      await cameraController.initialize();
      await Future.wait(
        <Future<Object?>>[
          cameraController
              .getMinExposureOffset()
              .then((double value) => _minAvailableExposureOffset = value),
          cameraController
              .getMaxExposureOffset()
              .then((double value) => _maxAvailableExposureOffset = value),
          cameraController
              .getMaxZoomLevel()
              .then((double value) => _maxAvailableZoom = value),
          cameraController
              .getMinZoomLevel()
              .then((double value) => _minAvailableZoom = value),
        ],
      );
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
        // TODO(josh4500): 'You have denied camera access.'
        case 'CameraAccessDeniedWithoutPrompt':
        // iOS only
        // TODO(josh4500): 'Please go to Settings app to enable camera access.'
        case 'CameraAccessRestricted':
        // iOS only
        // TODO(josh4500): 'Camera access is restricted.'
        case 'AudioAccessDenied':
        // TODO(josh4500): 'You have denied audio access.'
        case 'AudioAccessDeniedWithoutPrompt':
        // iOS only
        // TODO(josh4500): 'Please go to Settings app to enable audio access.'
        case 'AudioAccessRestricted':
        // iOS only
        // TODO(josh4500): 'Audio access is restricted.'
        default:
          // TODO(josh4500): Error
          break;
      }
    }

    hasInitCameraNotifier.value = cameraDescription;
  }

  void handleOnTapCameraView(
    TapDownDetails details,
    BoxConstraints constraints,
  ) {
    if (_controlHidden) {
      effectsController.close();
      return;
    }

    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);

    // Set focus position tapped by user
    focusPosition.value = Offset(
      details.localPosition.dx - kFocusSize,
      details.localPosition.dy - kFocusSize,
    );

    // Show focus points
    focusController.reset();
    focusController.forward();
  }

  void handleOnDoubleTapCameraView(
    TapDownDetails details,
    BoxConstraints constraints,
  ) {
    if (_controlHidden) {
      effectsController.close();
      return;
    }

    _flipCamera();
  }

  void _flipCamera() {
    final cameraState = ModelBinding.of<CreateCameraState>(context);
    final List<CameraDescription> cameras = cameraState.cameras;

    if (cameras.length > 1) {
      onNewCameraSelected(
        cameras.firstWhere(
          (camera) => camera != hasInitCameraNotifier.value,
          orElse: () => cameras.first,
        ),
      );
    }
  }

  bool get _guardRecording => ref.read(shortRecordingProvider).isCompleted;

  Future<void> _startRecording() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    // await cameraController.startVideoRecording(
    //   onAvailable: (CameraImage cameraImage) {},
    // );
    ref
        .read(currentTimelineProvider.notifier)
        .startRecording((Timeline timeline) {
      final shortsRecording = ref.read(shortRecordingProvider);
      final totalDuration = shortsRecording.duration + timeline.duration;
      if (totalDuration >= shortsRecording.recordDuration) {
        _stopRecording();
        _onAutoStopRecording();
      }
    });
  }

  Future<void> _onAutoStopRecording() async {
    final revertDrag = disableDragMode;
    disableDragMode = false;
    recordingNotifier.value = false;
    recordOuterButtonController.reverse(from: .7);
    droppedButton = false;

    if (revertDrag) {
      dragRecordNotifier.value = false;
      recordingNotifier.value = false;
      hideZoomController.reverse();
      // Reset positions
      recordOuterButtonPosition.value = null;
      recordInnerButtonPosition.value = null;
      recordOuterButtonController.reverse();
    }
  }

  Future<void> _stopRecording() async {
    // final XFile xFile = await controller!.stopVideoRecording();
    // xFile.saveTo('path');
    ref.read(currentTimelineProvider.notifier).stopRecording();
    final Timeline timeline = ref.read(currentTimelineProvider);
    ref.read(shortRecordingProvider.notifier).addTimeline(timeline);
  }

  void handleOnTapRecordButton() {
    if (_guardRecording) return;
    dragRecordNotifier.value = false; // Not dragging

    final recording = !recordingNotifier.value;

    // TODO(josh4500): Prevent recoding when it gets to set Duration
    // Start or Stop recording
    recording ? _startRecording() : _stopRecording();

    disableDragMode = recording;
    recordingNotifier.value = recording;
    recording
        ? recordOuterButtonController.forward(from: .7)
        : recordOuterButtonController.reverse(from: .7);

    if (recording) CreateNotification(hideNavigator: true).dispatch(context);
  }

  void handleLongPressStartRecordButton(LongPressStartDetails details) {
    if (disableDragMode || _guardRecording) return;

    // TODO(josh4500): Prevent recoding when it gets to set Duration
    _startRecording();

    dragRecordNotifier.value = true;
    recordingNotifier.value = true;
    hideZoomController.forward();

    CreateNotification(hideNavigator: true).dispatch(context);
    recordOuterButtonController.repeat(min: .8, max: 1, reverse: true);
  }

  void handleLongPressEndRecordButton(
    LongPressEndDetails details,
    BoxConstraints constraints,
  ) async {
    if (disableDragMode || _guardRecording) return;

    _stopRecording();

    droppedButton = false;

    dragRecordNotifier.value = false;
    recordingNotifier.value = false;
    hideZoomController.reverse();

    // Reset positions
    recordOuterButtonPosition.value = getDragCircleInitPosition(constraints);
    recordInnerButtonPosition.value = getCenterButtonInitPosition(constraints);

    recordOuterButtonController.reverse();
  }

  void handleLongPressUpdateRecordButton(
    LongPressMoveUpdateDetails details,
    BoxConstraints constraints,
  ) {
    if (disableDragMode || _guardRecording) return;

    final position = details.globalPosition;
    final maxHeight = constraints.maxHeight;

    recordOuterButtonPosition.value = Offset(
      position.dx - kRecordOuterButtonSize / 2,
      position.dy - kRecordOuterButtonSize,
    );

    if (droppedButton == false) {
      recordInnerButtonPosition.value = Offset(
        position.dx - kRecordInnerButtonSize / 2,
        position.dy - kRecordInnerButtonSize - offsetYFromCircle,
      );
    }

    // Update zoom level
    setZoomLevel(
      (1 -
              (position.dy /
                  (maxHeight - kRecordOuterButtonSize - bottomPaddingHeight)))
          .clamp(0, 1),
    );

    if (position.dy <= maxHeight * .8) {
      droppedButton = true;
      // TODO(josh4500): Animate
      recordInnerButtonPosition.value =
          getCenterButtonInitPosition(constraints);
    } else if (droppedButton &&
        position.dy >=
            maxHeight - (kRecordOuterButtonSize / 2) - bottomPaddingHeight) {
      droppedButton = false;
    }
  }

  Future<void> setZoomLevel(double level) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setZoomLevel(
        level.normalizeRange(_minAvailableZoom, _maxAvailableZoom),
      );
      dragZoomLevelNotifier.value = level;
    } on CameraException {
      // TODO(josh4500): Unable to set zoom level
      rethrow;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFlashMode(mode);
    } on CameraException {
      // TODO(josh4500): Unable to set flash mode
      rethrow;
    }
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setExposureMode(mode);
    } on CameraException {
      // TODO(josh4500): Unable to set exposure mode
      rethrow;
    }
  }

  Future<void> setExposureOffset(double offset) async {
    if (controller == null) {
      return;
    }

    try {
      offset = await controller!.setExposureOffset(offset);
    } on CameraException {
      // TODO(josh4500): Unable to set exposure
      rethrow;
    }
  }

  Future<void> setFocusMode(FocusMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFocusMode(mode);
    } on CameraException {
      // TODO(josh4500): Unable to set focus mode
      rethrow;
    }
  }

  bool handleCaptureNotification(CaptureNotification notification) {
    if (notification is HideCaptureControlsNotification) {
      _controlHidden = true;
      hideController.forward();
      CreateNotification(hideNavigator: true).dispatch(context);
    } else if (notification is ShowCaptureControlsNotification) {
      _controlHidden = false;
      hideController.reverse();
      CreateNotification(hideNavigator: false).dispatch(context);
    } else if (notification is ShowControlsMessageNotification) {
      latestControlMessage.value = notification.message;
      controlMessageTimer?.cancel();
      controlMessageTimer = Timer(
        const Duration(seconds: 2),
        () => latestControlMessage.value = '',
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final speedSelectorScaleAnimation = Tween<double>(
      begin: .9,
      end: 1,
    ).animate(hideSpeedController);
    return NotificationListener<CaptureNotification>(
      onNotification: handleCaptureNotification,
      child: Stack(
        fit: StackFit.expand,
        children: [
          LayoutBuilder(
            builder: (
              BuildContext context,
              BoxConstraints constraints,
            ) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  ValueListenableBuilder(
                    valueListenable: hasInitCameraNotifier,
                    builder: (
                      BuildContext context,
                      CameraDescription? cameraDesc,
                      Widget? _,
                    ) {
                      if (cameraDesc == null) {
                        return const SizedBox();
                      } else {
                        return CameraPreview(
                          controller!,
                          child: GestureDetector(
                            onTapDown: (TapDownDetails details) {
                              handleOnTapCameraView(details, constraints);
                            },
                            onDoubleTapDown: (TapDownDetails details) {
                              handleOnDoubleTapCameraView(details, constraints);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: const SizedBox.expand(),
                          ),
                        );
                      }
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: focusPosition,
                    builder: (
                      BuildContext context,
                      Offset position,
                      Widget? childWidget,
                    ) {
                      return Positioned(
                        top: position.dy,
                        left: position.dx,
                        child: childWidget!,
                      );
                    },
                    child: CaptureFocusIndicator(animation: focusController),
                  ),
                  ValueListenableBuilder(
                    valueListenable: recordOuterButtonPosition,
                    builder: (
                      BuildContext context,
                      Offset? position,
                      Widget? childWidget,
                    ) {
                      position ??= getDragCircleInitPosition(constraints);

                      return Positioned(
                        top: position.dy,
                        left: position.dx,
                        child: childWidget!,
                      );
                    },
                    child: AnimatedVisibility(
                      animation: hideAnimation,
                      alignment: Alignment.bottomCenter,
                      child: ListenableBuilder(
                        listenable: recordingNotifier,
                        builder: (BuildContext context, Widget? _) {
                          return CaptureDragZoomButton(
                            animation: recordOuterButtonController,
                            isDragging: dragRecordNotifier.value,
                            isRecording: recordingNotifier.value,
                          );
                        },
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: recordInnerButtonPosition,
                    builder: (
                      BuildContext context,
                      Offset? position,
                      Widget? childWidget,
                    ) {
                      position ??= getCenterButtonInitPosition(constraints);

                      return Positioned(
                        top: position.dy,
                        left: position.dx,
                        child: childWidget!,
                      );
                    },
                    child: AnimatedVisibility(
                      animation: hideAnimation,
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: handleOnTapRecordButton,
                        onLongPressStart: handleLongPressStartRecordButton,
                        onLongPressEnd: (LongPressEndDetails details) {
                          handleLongPressEndRecordButton(details, constraints);
                        },
                        onLongPressMoveUpdate:
                            (LongPressMoveUpdateDetails details) {
                          handleLongPressUpdateRecordButton(
                            details,
                            constraints,
                          );
                        },
                        child: ListenableBuilder(
                          listenable: Listenable.merge(
                            [
                              recordingNotifier,
                              dragRecordNotifier,
                            ],
                          ),
                          builder: (BuildContext context, Widget? _) {
                            return CaptureButton(
                              isRecording: recordingNotifier.value &&
                                  !dragRecordNotifier.value,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                AnimatedVisibility(
                  animation: hideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 4.0,
                    ),
                    child: Column(
                      children: [
                        const CreateProgress(),
                        const SizedBox(height: 12),
                        HideOnRecording(
                          notifier: recordingNotifier,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CreateCloseButton(),
                              CaptureMusicButton(),
                              CaptureShortsDuration(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: ListenableBuilder(
                    listenable: latestControlMessage,
                    builder: (BuildContext context, Widget? _) {
                      return ControlMessageEvent(
                        message: latestControlMessage.value,
                      );
                    },
                  ),
                ),
                AnimatedVisibility(
                  animation: hideZoomController,
                  alignment: Alignment.centerLeft,
                  child: CaptureZoomIndicator(
                    controller: dragZoomLevelNotifier,
                  ),
                ),
                HideOnRecording(
                  notifier: recordingNotifier,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CaptureEffects(controller: effectsController),
                  ),
                ),
                HideOnRecording(
                  notifier: recordingNotifier,
                  child: AnimatedVisibility(
                    animation: hideAnimation,
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedVisibility(
                          animation: hideSpeedController,
                          child: ScaleTransition(
                            scale: speedSelectorScaleAnimation,
                            child: const CaptureSpeed(),
                          ),
                        ),
                        const SizedBox(height: 36),
                        const CaptureTimelineControl(),
                        const SizedBox(height: bottomPaddingHeight),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CaptureMusicButton extends StatelessWidget {
  const CaptureMusicButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomActionChip(
      title: 'Add sound',
      icon: Icon(YTIcons.music, size: 18),
      backgroundColor: Colors.black38,
      textStyle: TextStyle(fontSize: 13),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    );
  }
}

class ControlMessageEvent extends StatelessWidget {
  const ControlMessageEvent({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(
        fontSize: 36,
        color: Colors.white38,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class CreateShortsPermissionRequest extends StatelessWidget {
  const CreateShortsPermissionRequest({
    super.key,
    this.checking = true,
  });

  final bool checking;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: checking
            ? null
            : const DecorationImage(
                image: CustomNetworkImage(
                  'https://images.pexels.com/photos/26221937/pexels-photo-26221937/free-photo-of-a-woman-taking-a-photo.jpeg?auto=compress&cs=tinysrgb&w=600',
                ),
                fit: BoxFit.cover,
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CreateCloseButton(),
            Expanded(
              child: Builder(
                builder: (BuildContext context) {
                  if (checking) {
                    return const CheckingPermission();
                  } else {
                    return const SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(YTIcons.shorts_outline_outlined, size: 48),
                                SizedBox(height: 48),
                                Text(
                                  'To record, let YouTube access your camera and microphone',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 12),
                                CreatePermissionReason(
                                  icon: YTIcons.info_outlined,
                                  title: 'Why is this needed?',
                                  subtitle:
                                      'So you can take photos, record videos, and preview effects',
                                ),
                                SizedBox(height: 12),
                                CreatePermissionReason(
                                  icon: YTIcons.settings_outlined,
                                  title: 'You are in control',
                                  subtitle:
                                      'Change your permissions any time in Settings',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          PermissionRequestButton(),
                          SizedBox(height: 12),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PermissionRequestButton extends StatelessWidget {
  const PermissionRequestButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ModelBinding.of<CreateCameraState>(context);
    return GestureDetector(
      onTap: () async {
        if (state.permissionsDenied == false) {
          final state = await CreateCameraState.requestCamera();
          if (context.mounted) {
            ModelBinding.update<CreateCameraState>(context, state);
          }
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        alignment: Alignment.center,
        child: Text(
          state.permissionsDenied ? 'Open settings' : 'Continue',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class HideOnRecording extends StatelessWidget {
  const HideOnRecording({
    super.key,
    required this.notifier,
    required this.child,
  });
  final ValueNotifier<bool> notifier;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (BuildContext context, bool recording, Widget? _) {
        return Offstage(
          offstage: recording,
          child: child,
        );
      },
    );
  }
}

extension IfNullExtension<T> on T? {
  bool get isNull => this == null;
  bool get isNotNull => this != null;
}
