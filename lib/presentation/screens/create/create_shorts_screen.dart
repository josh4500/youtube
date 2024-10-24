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
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/core/utils/normalization.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'add_sound_screen.dart';
import 'provider/current_recording_state.dart';
import 'provider/index_notifier.dart';
import 'provider/short_recording_state.dart';
import 'widgets/capture/capture_button.dart';
import 'widgets/capture/capture_effects.dart';
import 'widgets/capture/capture_focus_indicator.dart';
import 'widgets/capture/capture_recording_control.dart';
import 'widgets/capture/capture_shorts_duration.dart';
import 'widgets/capture/capture_speed.dart';
import 'widgets/capture/capture_zoom_indicator.dart';
import 'widgets/check_permission.dart';
import 'widgets/create_close_button.dart';
import 'widgets/create_permission_reason.dart';
import 'widgets/create_progress.dart';
import 'widgets/notifications/capture_notification.dart';
import 'widgets/notifications/create_notification.dart';
import 'widgets/range_selector.dart';
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
  bool _hasFailedRecording = false;

  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;

  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;

  static const double bottomPadding = 48;

  final Set<CaptureEffect> _enabledCaptureEffects = {};
  Timer? _doubleTapTimer;

  final countdownHidden = ValueNotifier<bool>(true);
  final countdownSeconds = ValueNotifier<int>(0);
  late final AnimationController countdownController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
  Timer? countdownTimer;

  final CallOutLink callOutLink = CallOutLink(
    offset: const Offset(0, 52),
  );

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

    countdownHidden.dispose();
    countdownController.dispose();
    countdownTimer?.cancel();

    controlMessageTimer?.cancel();
    latestControlMessage.dispose();
    effectsController.dispose();

    focusPosition.dispose();
    focusController.dispose();
    _doubleTapTimer?.cancel();

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
      (constraints.maxHeight) - kRecordOuterButtonSize - bottomPadding,
    );
  }

  static const double offsetYFromCircle =
      (kRecordOuterButtonSize - kRecordInnerButtonSize) / 2;

  static const bottomOffset = offsetYFromCircle - bottomPadding;

  Offset getCenterButtonInitPosition(BoxConstraints constraints) {
    return Offset(
      (constraints.maxWidth / 2) - (kRecordInnerButtonSize / 2),
      (constraints.maxHeight) - kRecordOuterButtonSize + bottomOffset,
    );
  }

  bool get _guardRecording => ref.read(shortRecordingProvider).isCompleted;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (hasInitCameraNotifier.value == null) {
      final cameraState = ModelBinding.of<CreateCameraState>(context);
      if (cameraState.cameras.isNotEmpty) {
        onNewCameraSelected(cameraState.cameras.first).then((_) {
          _showDraftDecision();
        });
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
      hasInitCameraNotifier.value = null;
      cameraController.dispose();

      _handleFailedRecording();
    } else if (state == AppLifecycleState.resumed) {
      if (hasInitCameraNotifier.value == null) {
        onNewCameraSelected(cameraController.description).then((_) {
          // Re-add effects that was previously removed when controller was disposed
          for (final effect in _enabledCaptureEffects) {
            _onUpdateCaptureEffect(effect, true);
          }
        });
      }

      if (_hasFailedRecording) {
        _showErrorSnackbar('Last recording failed.');
      }
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
      hasInitCameraNotifier.value = null;
      cameraController.dispose();
    } else if (newIndex == CreateTab.shorts.index) {
      onNewCameraSelected(cameraController.description).then((_) {
        // Re-add effects that was previously removed when controller was disposed
        for (final effect in _enabledCaptureEffects) {
          _onUpdateCaptureEffect(effect, true);
        }
      });
    }
  }

  Future<void> _showErrorSnackbar(String title) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.down,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        content: Text(title),
      ),
    );
  }

  Future<void> _showDraftDecision() async {
    final hasDraft = ref.read(shortRecordingProvider.notifier).loadDraft();
    if (hasDraft && context.mounted) {
      final startOver = await showDialog<bool?>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const DraftDecision(),
      );
      if (startOver != null && startOver) {
        ref.read(shortRecordingProvider.notifier).clear();
      } else if (context.mounted) {
        CreateNotification(hideNavigator: true).dispatch(context);
      }
    }
  }

  bool _onPopInvoked() {
    if (countdownHidden.value == false) {
      _stopCountdown();
      return false;
    }

    if (recordingNotifier.value) {
      _stopRecording();
      _onAutoStopRecording();
      return false;
    }

    final shortsRecording = ref.read(shortRecordingProvider);
    if (shortsRecording.hasRecordings) {
      // Note: Using current screen context
      void showNavigator() {
        CreateNotification(hideNavigator: false).dispatch(context);
      }

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        useRootNavigator: true,
        builder: (BuildContext context) {
          return PreExitCaptureOptionsSheet(
            exit: context.pop,
            showNavigator: showNavigator,
          );
        },
      );

      return false;
    }
    return true;
  }

  void _onPopInvokedWithResult<T>(bool didPop, T? result) {
    if (_onPopInvoked()) context.pop();
  }

  void _handleFailedRecording() {
    if (recordingNotifier.value) {
      _hasFailedRecording = true;

      _stopRecording(false);
      _onAutoStopRecording();
    }
  }

  void _onUpdateCaptureEffect(CaptureEffect effect, bool isAdded) {
    switch (effect) {
      case CaptureEffect.flip:
        _flipCamera();
      case CaptureEffect.speed:
        isAdded ? hideSpeedController.forward() : hideSpeedController.reverse();
      case CaptureEffect.timer:
        _showCountdownSelector();
      case CaptureEffect.effect:
      case CaptureEffect.greenScreen:
      case CaptureEffect.retouch:
      case CaptureEffect.filter:
        _showFilterSelector();
      case CaptureEffect.align:
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
    }
  }

  void effectStatusListener(
    EffectAction action,
    EffectOption option,
  ) {
    final effect = option.value as CaptureEffect;
    final isAdded = action == EffectAction.add;

    _onUpdateCaptureEffect(effect, isAdded);

    if ([CaptureEffect.flip, CaptureEffect.speed, CaptureEffect.timer]
        .contains(effect)) {
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

    try {
      await cameraController.initialize();
      cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);
      Future.wait(
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
      _handleCameraException(e);
    }

    controller = cameraController;
    hasInitCameraNotifier.value = cameraDescription;
  }

  void _handleCameraException(CameraException e) {
    if (context.mounted) {
      final cameraState = ModelBinding.of<CreateCameraState>(context);
      switch (e.code) {
        case 'CameraAccessDenied' ||
              'CameraAccessDeniedWithoutPrompt' ||
              'CameraAccessRestricted':
          ModelBinding.update<CreateCameraState>(
            context,
            cameraState.copyWith(permissionsDenied: true),
          );
        case 'AudioAccessDenied' ||
              'AudioAccessDeniedWithoutPrompt' ||
              'AudioAccessRestricted':
          ModelBinding.update<CreateCameraState>(
            context,
            cameraState.copyWith(permissionsDenied: true),
          );
        case _:
          return;
      }
    }
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

    // Using timer to prevent accidental focus action on double tap
    _doubleTapTimer = Timer(kDoubleTapMinTime * 2, () {
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
    });
  }

  void handleOnDoubleTapCameraView(
    TapDownDetails details,
    BoxConstraints constraints,
  ) {
    if (_controlHidden) {
      effectsController.close();
      return;
    }
    _doubleTapTimer?.cancel();
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

  Future<void> _showFilterSelector() async {
    hideController.forward();
    // TODO(josh4500): Hide CaptureEffects widget
    // Hiding widget should use one notifier
    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const CaptureFilterSelector();
      },
    );
    hideController.reverse();
  }

  Future<void> _showCountdownSelector() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CaptureTimerSelector(onStart: _startCountdown);
      },
    );
  }

  void _startCountdown(int countdownSeconds) {
    countdownHidden.value = false;
    this.countdownSeconds.value = countdownSeconds;
    CreateNotification(hideNavigator: true).dispatch(context);
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (countdownSeconds == 1) {
        countdownHidden.value = true;
        countdownController.reset();

        timer.cancel();
        countdownTimer = null;

        _startRecording();
        _onAutoStartRecording();
        return;
      }

      countdownSeconds -= 1;
      this.countdownSeconds.value = countdownSeconds;
      countdownController.reset();
      countdownController.forward();
    });
  }

  void _stopCountdown() {
    countdownHidden.value = true;
    countdownController.reset();
    countdownTimer?.cancel();
    countdownTimer = null;
    ref.read(shortRecordingProvider.notifier).updateCountdownStoppage(null);
    if (!ref.read(shortRecordingProvider).hasRecordings) {
      CreateNotification(hideNavigator: false).dispatch(context);
    }
  }

  Future<void> _startRecording() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    // await cameraController.startVideoRecording(
    //   onAvailable: (CameraImage cameraImage) {},
    // );

    ref
        .read(currentRecordingProvider.notifier)
        .startRecording((Recording recording) {
      final shortsRecording = ref.read(shortRecordingProvider);
      final totalDuration = shortsRecording.duration + recording.duration;
      final countdownStoppage = shortsRecording.countdownStoppage;

      bool autoStop = false;
      if (countdownStoppage != null &&
          recording.duration >= countdownStoppage) {
        autoStop = true;
        ref
            .read(shortRecordingProvider.notifier)
            .updateCountdownStoppage(null); // Remove Countdown stoppage
      } else if (totalDuration >= shortsRecording.recordDuration) {
        autoStop = true;
      }

      if (autoStop) {
        _stopRecording();
        _onAutoStopRecording();
      }
    });
  }

  void _onAutoStartRecording() {
    dragRecordNotifier.value = false; // Not dragging

    final isRecording = !recordingNotifier.value;
    disableDragMode = isRecording;
    recordingNotifier.value = isRecording;
    isRecording
        ? recordOuterButtonController.forward(from: .7)
        : recordOuterButtonController.reverse(from: .7);
  }

  Future<void> _onAutoStopRecording() async {
    final revertDrag = !disableDragMode;

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

  Future<void> _stopRecording([bool addTimeline = true]) async {
    // final XFile xFile = await controller!.stopVideoRecording();
    // xFile.saveTo('path');
    ref.read(currentRecordingProvider.notifier).stopRecording();
    if (addTimeline) {
      final Recording recording = ref.read(currentRecordingProvider);
      ref.read(shortRecordingProvider.notifier).addRecording(recording);
    }
  }

  void handleOnTapRecordButton() {
    if (_guardRecording) return;
    dragRecordNotifier.value = false; // Not dragging

    final isRecording = !recordingNotifier.value;

    // Start or Stop recording
    isRecording ? _startRecording() : _stopRecording();

    disableDragMode = isRecording;
    recordingNotifier.value = isRecording;
    isRecording
        ? recordOuterButtonController.forward(from: .7)
        : recordOuterButtonController.reverse();

    if (isRecording) CreateNotification(hideNavigator: true).dispatch(context);
  }

  void handleLongPressStartRecordButton(LongPressStartDetails details) {
    if (disableDragMode || _guardRecording) return;

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

    if (position.dy <= maxHeight * .8) {
      droppedButton = true;
      // TODO(josh4500): Animate
      recordInnerButtonPosition.value =
          getCenterButtonInitPosition(constraints);
    } else if (droppedButton &&
        position.dy >=
            maxHeight - (kRecordOuterButtonSize / 2) - bottomPadding) {
      droppedButton = false;
    }
  }

  void handlePointerMoveEvent(
    PointerMoveEvent event,
    BoxConstraints constraints,
  ) {
    if (!disableDragMode && dragRecordNotifier.value) {
      final delta = event.delta.dy;
      final maxHeight = constraints.maxHeight;

      // Update zoom level
      final double oldZoomLevel = dragZoomLevelNotifier.value;
      final double newZoomLevel =
          (oldZoomLevel - (delta / maxHeight)).clamp(0, 1);
      if (oldZoomLevel != newZoomLevel && controller != null) {
        setZoomLevel(newZoomLevel);
        dragZoomLevelNotifier.value = newZoomLevel;
      }
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
    } on CameraException {
      _showErrorSnackbar('Unable to zoom camera');
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFlashMode(mode);
    } on CameraException {
      _showErrorSnackbar('Unable to change flash');
    }
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setExposureMode(mode);
    } on CameraException {
      _showErrorSnackbar('Camera unable to set Exposure Mode');
    }
  }

  Future<void> setExposureOffset(double offset) async {
    if (controller == null) {
      return;
    }

    try {
      offset = await controller!.setExposureOffset(offset);
    } on CameraException {
      _showErrorSnackbar('Camera unable to set lighting');
    }
  }

  Future<void> setFocusMode(FocusMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFocusMode(mode);
    } on CameraException {
      _showErrorSnackbar('Camera unable to focus');
    }
  }

  bool handleCaptureNotification(CaptureNotification notification) {
    if (notification is HideControlsNotification) {
      _controlHidden = true;
      hideController.forward();
      CreateNotification(hideNavigator: true).dispatch(context);
    } else if (notification is ShowControlsNotification) {
      _controlHidden = false;
      hideController.reverse();
      if (!ref.read(shortRecordingProvider).hasRecordings) {
        CreateNotification(hideNavigator: false).dispatch(context);
      }
    } else if (notification is ShowControlsMessageNotification) {
      latestControlMessage.value = notification.message;
      controlMessageTimer?.cancel();
      controlMessageTimer = Timer(
        const Duration(seconds: 2),
        () => latestControlMessage.value = '',
      );
    } else if (notification is StartCountdownNotification) {
      countdownHidden.value = false;
      CreateNotification(hideNavigator: true).dispatch(context);
    } else if (notification is StopCountdownNotification) {
      countdownHidden.value = true;
      if (!ref.read(shortRecordingProvider).hasRecordings) {
        CreateNotification(hideNavigator: false).dispatch(context);
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final speedSelectorScaleAnimation = Tween<double>(
      begin: .9,
      end: 1,
    ).animate(hideSpeedController);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: NotificationListener<CaptureNotification>(
        onNotification: handleCaptureNotification,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              LayoutBuilder(
                builder: (
                  BuildContext context,
                  BoxConstraints constraints,
                ) {
                  return Listener(
                    onPointerMove: (PointerMoveEvent event) {
                      handlePointerMoveEvent(event, constraints);
                    },
                    child: Stack(
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
                                    handleOnDoubleTapCameraView(
                                      details,
                                      constraints,
                                    );
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
                          child: CaptureFocusIndicator(
                            animation: focusController,
                          ),
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
                          child: HideOnCountdown(
                            notifier: countdownHidden,
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
                        ),
                        ValueListenableBuilder(
                          valueListenable: recordInnerButtonPosition,
                          builder: (
                            BuildContext context,
                            Offset? position,
                            Widget? childWidget,
                          ) {
                            position ??=
                                getCenterButtonInitPosition(constraints);

                            return Positioned(
                              top: position.dy,
                              left: position.dx,
                              child: childWidget!,
                            );
                          },
                          child: HideOnCountdown(
                            notifier: countdownHidden,
                            child: AnimatedVisibility(
                              animation: hideAnimation,
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: handleOnTapRecordButton,
                                onLongPressStart:
                                    handleLongPressStartRecordButton,
                                onLongPressEnd: (LongPressEndDetails details) {
                                  handleLongPressEndRecordButton(
                                    details,
                                    constraints,
                                  );
                                },
                                onLongPressMoveUpdate: (
                                  LongPressMoveUpdateDetails details,
                                ) {
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
                        ),
                        ListenableBuilder(
                          listenable: countdownHidden,
                          builder: (BuildContext context, Widget? _) {
                            if (countdownHidden.value) {
                              return const SizedBox();
                            }

                            return Center(
                              child: ScaleTransition(
                                scale:
                                    Tween<double>(begin: 1, end: 1.5).animate(
                                  ReverseAnimation(countdownController),
                                ),
                                child: ListenableBuilder(
                                  listenable: countdownSeconds,
                                  builder: (BuildContext context, Widget? _) {
                                    return Text(
                                      countdownSeconds.value.toString(),
                                      style: const TextStyle(
                                        fontSize: 100,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        ListenableBuilder(
                          listenable: countdownHidden,
                          builder: (BuildContext context, Widget? _) {
                            if (countdownHidden.value) {
                              return const SizedBox();
                            }
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: Transform.translate(
                                offset: const Offset(0, -bottomPadding),
                                child: GestureDetector(
                                  onTap: _stopCountdown,
                                  behavior: HitTestBehavior.opaque,
                                  child: const CaptureCountdownButton(),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
                        child: ModelBinding<CallOutLink>(
                          model: callOutLink,
                          child: CompositedTransformTarget(
                            link: callOutLink.link,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CreateProgress(),
                                const SizedBox(height: 12),
                                HideOnCountdown(
                                  notifier: countdownHidden,
                                  child: HideOnRecording(
                                    notifier: recordingNotifier,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CreateCloseButton(
                                          onPopInvoked: _onPopInvoked,
                                        ),
                                        const CaptureMusicButton(),
                                        const CaptureShortsDuration(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                    HideOnCountdown(
                      notifier: countdownHidden,
                      child: HideOnRecording(
                        notifier: recordingNotifier,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: CaptureEffects(controller: effectsController),
                        ),
                      ),
                    ),
                    HideOnCountdown(
                      notifier: countdownHidden,
                      child: HideOnRecording(
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
                              const CaptureRecordingControl(),
                              const SizedBox(height: bottomPadding),
                            ],
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
      ),
    );
  }
}

class CaptureMusicButton extends StatelessWidget {
  const CaptureMusicButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomActionChip(
      title: 'Add sound',
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => const AddSoundScreen(),
        );
      },
      icon: const Icon(YTIcons.music, size: 18),
      backgroundColor: Colors.black38,
      textStyle: const TextStyle(fontSize: 13),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
        color: Colors.white60,
        fontWeight: FontWeight.w500,
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

class HideOnCountdown extends StatelessWidget {
  const HideOnCountdown({
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
      builder: (BuildContext context, bool hidden, Widget? _) {
        return Offstage(
          offstage: hidden == false,
          child: child,
        );
      },
    );
  }
}

class PreExitCaptureOptionsSheet extends ConsumerWidget {
  const PreExitCaptureOptionsSheet({
    super.key,
    required this.exit,
    required this.showNavigator,
  });
  final VoidCallback exit;
  final VoidCallback showNavigator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(YTIcons.delete_outlined),
            title: const Text('Delete'),
            titleTextStyle: const TextStyle(fontSize: 12.5),
            hoverColor: Colors.white24,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            onTap: () {
              ref.read(currentRecordingProvider.notifier).clear();
              ref.read(shortRecordingProvider.notifier).clear();

              context.pop();
              showNavigator();
            },
          ),
          ListTile(
            leading: const RotatedBox(
              quarterTurns: -2,
              child: Icon(YTIcons.exit_outlined),
            ),
            title: const Text('Save and Exit'),
            titleTextStyle: const TextStyle(fontSize: 12.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            hoverColor: Colors.white24,
            onTap: () async {
              ref.read(shortRecordingProvider.notifier).save();
              context.pop();
              exit();
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(YTIcons.close_outlined),
            title: const Text('Cancel'),
            titleTextStyle: const TextStyle(fontSize: 12.5),
            hoverColor: Colors.white24,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            onTap: context.pop,
          ),
        ],
      ),
    );
  }
}

class CaptureFilterSelector extends StatelessWidget {
  const CaptureFilterSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.black,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    'Filter',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: context.pop,
                    child: Text(
                      'DONE',
                      style: TextStyle(
                        color: context.theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      const SizedBox(height: 4),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            YTIcons.not_interested_outlined,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'No filter',
                        style: TextStyle(fontSize: 10.5),
                      ),
                    ],
                  );
                },
                itemCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CaptureTimerSelector extends StatelessWidget {
  const CaptureTimerSelector({super.key, this.onStart});
  final ValueChanged<int>? onStart;

  @override
  Widget build(BuildContext context) {
    final countdowns = [3, 10, 20];
    int selectedIndex = 0;
    return Material(
      color: AppPalette.black,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Timer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? _) {
                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(shortRecordingProvider.notifier)
                            .updateCountdownStoppage(null);
                        context.pop();
                      },
                      child: const Icon(
                        YTIcons.close_outlined,
                        color: Colors.white70,
                        size: 20,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Countdown'),
            const SizedBox(height: 8),
            RangeSelector(
              initialIndex: selectedIndex,
              indicatorHeight: 40,
              backgroundColor: Colors.white12,
              selectedColor: Colors.white12,
              itemBuilder: (
                BuildContext context,
                int selectedIndex,
                int index,
              ) {
                return Text(
                  '${countdowns[index]}s',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFont.youTubeSans,
                  ),
                );
              },
              onChanged: (int index) => selectedIndex = index,
              itemCount: countdowns.length,
            ),
            const SizedBox(height: 24),
            const Text(
              'Drag to change where recording stops',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),
            const CountdownRangeSlider(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  onStart?.call(countdowns[selectedIndex]);
                  context.pop();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateColor.resolveWith(
                    (_) => context.theme.primaryColor,
                  ),
                  overlayColor: WidgetStateColor.resolveWith(
                    (_) => Colors.white12,
                  ),
                  textStyle: WidgetStateTextStyle.resolveWith(
                    (_) => const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                child: const Text(
                  'START',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class DraftDecision extends StatelessWidget {
  const DraftDecision({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: AppPalette.black,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * .85,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Continue your draft video?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Starting over will discard your last draft.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => context.pop(true),
                      child: Text(
                        'Start over',
                        style: TextStyle(
                          color: context.theme.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    TextButton(
                      onPressed: () => context.pop(false),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: context.theme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CountdownRangeSlider extends ConsumerWidget {
  const CountdownRangeSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shortsRecording = ref.read(shortRecordingProvider);
    final start = shortsRecording.duration.inSeconds /
        shortsRecording.recordDuration.inSeconds;

    const textStyle = TextStyle(fontSize: 14, color: Colors.white24);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('0s', style: textStyle),
            Text(
              '${shortsRecording.recordDuration.inSeconds}s',
              style: textStyle,
            ),
          ],
        ),
        OneWayRangeSlider(
          value: RangeValue(start: start, end: 1),
          onChanged: (double value) {
            final milli = shortsRecording.recordDuration.inMilliseconds;
            final stopMilliseconds = (milli * value).ceil() -
                shortsRecording.duration.inMilliseconds;

            final duration = Duration(milliseconds: stopMilliseconds);

            ref.read(shortRecordingProvider.notifier).updateCountdownStoppage(
                  stopMilliseconds == 0 || value == 1 ? null : duration,
                );
          },
        ),
      ],
    );
  }
}
