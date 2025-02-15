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
import 'package:youtube_clone/core.dart';
import 'package:youtube_clone/core/utils/normalization.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'provider/current_recording_state.dart';
import 'provider/short_recording_state.dart';
import 'provider/shorts_create_state.dart';
import 'widgets/add_music_button.dart';
import 'widgets/capture/capture_draft_decision.dart';
import 'widgets/capture/capture_effects.dart';
import 'widgets/capture/capture_focus_indicator.dart';
import 'widgets/capture/capture_permission_request.dart';
import 'widgets/capture/capture_recording_control.dart';
import 'widgets/capture/capture_shorts_duration.dart';
import 'widgets/capture/capture_speed.dart';
import 'widgets/capture/capture_timer_selector.dart';
import 'widgets/capture/capture_zoom_indicator.dart';
import 'widgets/create_close_button.dart';
import 'widgets/create_progress.dart';
import 'widgets/filter_selector.dart';
import 'widgets/notifications/capture_notification.dart';
import 'widgets/notifications/create_notification.dart';
import 'widgets/pre_exit_options_sheet.dart';
import 'widgets/record_button.dart';
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
    return Material(
      child: FutureBuilder<CreateCameraState>(
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
                return CaptureShortsPermissionRequest(
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
  late final recordOuterButtonPosition = AnimationNotifier<Offset>(
    value: Offset.zero,
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late final recordInnerButtonPosition = AnimationNotifier<Offset>(
    value: Offset.zero,
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
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

  final CallOutLink callOutLink = CallOutLink();

  final ValueNotifier<bool> hideEffectsNotifier = ValueNotifier<bool>(false);

  BoxConstraints? viewConstraints;

  /// Prevents initializing or disposing camera.
  ///
  /// Its changed when on `InitCameraNotification` or DisposeCameraNotification is dispatch.
  bool _preventInitDispose = false;

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

    hideEffectsNotifier.dispose();
    super.dispose();
  }

  Offset getOuterButtonInitPosition(BoxConstraints constraints) {
    return Offset(
      (constraints.maxWidth / 2) - (kRecordOuterButtonSize / 2),
      (constraints.maxHeight) - kRecordOuterButtonSize - bottomPadding,
    );
  }

  static const double offsetYFromCircle =
      (kRecordOuterButtonSize - kRecordInnerButtonSize) / 2;

  static const bottomOffset = offsetYFromCircle - bottomPadding;

  Offset getInnerButtonInitPosition(BoxConstraints constraints) {
    return Offset(
      (constraints.maxWidth / 2) - (kRecordInnerButtonSize / 2),
      (constraints.maxHeight) - kRecordOuterButtonSize + bottomOffset,
    );
  }

  bool get _guardRecording => ref.read(shortRecordingProvider).isCompleted;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initCamera(true);
  }

  void _initCamera([bool screenInit = false]) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null ||
        !cameraController.value.isInitialized ||
        _preventInitDispose) {
      if (!screenInit) return;
    }

    if (hasInitCameraNotifier.value == null) {
      final cameraDescription = cameraController?.description ??
          context.provide<CreateCameraState>().cameras.first;
      onNewCameraSelected(cameraDescription).then((_) {
        if (screenInit) {
          // Re-add effects that was previously removed when controller was disposed
          for (final effect in _enabledCaptureEffects) {
            _onUpdateCaptureEffect(effect, true);
          }
          _showDraftDecision();
        }
      });
    }
  }

  void _disposeCamera() {
    final CameraController? cameraController = controller;
    if (cameraController == null ||
        !cameraController.value.isInitialized ||
        _preventInitDispose) {
      return;
    }
    hasInitCameraNotifier.value = null;
    cameraController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (currentTabIndex != CreateTab.shorts) return;
    if (state == AppLifecycleState.resumed) {
      _initCamera();
      if (_hasFailedRecording) {
        _hasFailedRecording = false;
        _showErrorSnackbar('Last recording failed.');
      }
    } else if (state == AppLifecycleState.inactive) {
      _disposeCamera();
      _handleFailedRecording();
    }
  }

  @override
  void didTabIndexChanged(int newIndex) {
    if (newIndex == CreateTab.shorts.index) {
      _initCamera();
    } else {
      _disposeCamera();
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
    if (hasDraft && mounted) {
      final startOver = await showDialog<bool?>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const CaptureDraftDecision(),
      );
      if (startOver != null && startOver) {
        ref.read(shortRecordingProvider.notifier).clear();
      } else if (mounted) {
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
    if (shortsRecording.recordings.isNotEmpty) {
      showPreExitSheet(
        context,
        items: [
          PreExitEntry(
            label: 'Delete',
            icon: const Icon(YTIcons.delete_outlined),
            action: PreExitAction.discard,
            onTap: () {
              ref.read(currentRecordingProvider.notifier).clear();
              ref.read(shortRecordingProvider.notifier).clear();
              CreateNotification(hideNavigator: false).dispatch(context);
            },
          ),
          PreExitEntry(
            label: 'Save and Exit',
            icon: const RotatedBox(
              quarterTurns: -2,
              child: Icon(YTIcons.exit_outlined),
            ),
            action: PreExitAction.save,
            onTap: () async {
              CreateNotification(hideNavigator: false).dispatch(context);
              ref.read(shortRecordingProvider.notifier).save();
            },
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
        _openTrimmer();
    }
  }

  void effectStatusListener(
    EffectAction action,
    EffectOption option,
  ) {
    final effect = option.value as CaptureEffect;
    final isAdded = action == EffectAction.add;

    _onUpdateCaptureEffect(effect, isAdded);

    if ([
      CaptureEffect.flip,
      CaptureEffect.speed,
      CaptureEffect.timer,
      CaptureEffect.filter,
      CaptureEffect.trim,
    ].contains(effect)) {
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
      switch (e.code) {
        case 'CameraAccessDenied' ||
              'CameraAccessDeniedWithoutPrompt' ||
              'CameraAccessRestricted':
          ModelBinding.update<CreateCameraState>(
            context,
            (state) => state.copyWith(permissionsDenied: true),
          );
        case 'AudioAccessDenied' ||
              'AudioAccessDeniedWithoutPrompt' ||
              'AudioAccessRestricted':
          ModelBinding.update<CreateCameraState>(
            context,
            (state) => state.copyWith(permissionsDenied: true),
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
    final cameraState = context.provide<CreateCameraState>();
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
    hideEffectsNotifier.value = true;
    // Hiding widget should use one notifier
    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const FilterSelector();
      },
    );
    hideEffectsNotifier.value = false;
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

  bool _guardCamera() {
    final CameraController? cameraController = controller;
    return cameraController == null || !cameraController.value.isInitialized;
  }

  void _startCountdown(int countdownSeconds) {
    if (_guardCamera()) return;

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
    if (!ref.read(shortRecordingProvider).canUndo) {
      CreateNotification(hideNavigator: false).dispatch(context);
    }
  }

  void _updateRecordState() {
    ref.read(shortsCreateProvider.notifier).updateRecordState(
          ref.read(shortRecordingProvider),
        );
  }

  Future<void> _startRecording() async {
    if (_guardCamera()) return;

    // await cameraController.startVideoRecording(
    //   onAvailable: (CameraImage cameraImage) {},
    // );

    ref
        .read(currentRecordingProvider.notifier)
        .startRecording((VideoRecording recording) {
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

    if (revertDrag) {
      dragRecordNotifier.value = false;
      recordingNotifier.value = false;
      hideZoomController.reverse();

      _resetButtonPositions(viewConstraints);
    }
  }

  Future<void> _stopRecording([bool addRecording = true]) async {
    // TODO(josh4500): Recording should be paused instead, creating a
    // single file. bool value should
    // final XFile xFile = await controller!.stopVideoRecording();
    // xFile.saveTo('path');
    ref.read(currentRecordingProvider.notifier).stopRecording();
    if (addRecording) {
      final VideoRecording recording = ref.read(currentRecordingProvider);
      ref.read(shortRecordingProvider.notifier).addRecording(recording);
      _updateRecordState();
    }
  }

  void _resetButtonPositions(BoxConstraints? constraints) {
    if (constraints != null) {
      recordOuterButtonPosition.animate(
        end: getOuterButtonInitPosition(constraints),
        updateWhen: (_) => !dragRecordNotifier.value,
      );

      if (!droppedButton) {
        recordInnerButtonPosition.animate(
          end: getInnerButtonInitPosition(constraints),
          updateWhen: (value) {
            if (value == getInnerButtonInitPosition(constraints)) {
              droppedButton = false;
            }
            return !droppedButton && !dragRecordNotifier.value;
          },
        );
      } else {
        recordInnerButtonPosition.value = getInnerButtonInitPosition(
          constraints,
        );
        droppedButton = false;
      }
    } else {
      recordOuterButtonPosition.value = Offset.zero;
      recordInnerButtonPosition.value = Offset.zero;
    }

    recordOuterButtonController.reverse();
  }

  void handleOnTapRecordButton() {
    if (_guardRecording) return;
    dragRecordNotifier.value = false; // Not dragging

    final isRecording = !recordingNotifier.value;

    // Start or Stop recording
    isRecording ? _startRecording() : _stopRecording();

    if (_guardCamera()) return;

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

    if (_guardCamera()) return;

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

    dragRecordNotifier.value = false;
    recordingNotifier.value = false;
    hideZoomController.reverse();

    _resetButtonPositions(constraints);
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

    if (position.dy <= maxHeight * .8) {
      if (droppedButton == false) {
        recordInnerButtonPosition.animate(
          begin: recordInnerButtonPosition.value,
          end: getInnerButtonInitPosition(constraints),
          updateWhen: (_) => droppedButton,
        );
      }
      droppedButton = true;
    } else {
      droppedButton = false;
    }

    if (droppedButton == false) {
      recordInnerButtonPosition.value = Offset(
        position.dx - kRecordInnerButtonSize / 2,
        position.dy - kRecordInnerButtonSize - offsetYFromCircle,
      );
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

  FutureOr<T> _waitCamera<T>(FutureOr<T> Function() callback) async {
    _disposeCamera();
    _preventInitDispose = true;
    final value = await callback();
    _preventInitDispose = false;
    _initCamera();
    return value;
  }

  Future<void> _openTrimmer() async {
    await _waitCamera(
      () async => context.goto(AppRoutes.shortsTrimmer),
    );
  }

  Future<void> _proceedToEdit() async {
    ref.read(shortsCreateProvider.notifier).setEditing(true);
    await _waitCamera(() async => context.goto(AppRoutes.shortsEditor));
    ref.read(shortsCreateProvider.notifier).setEditing(false);
  }

  bool handleCaptureNotification(CaptureNotification notification) {
    if (notification is HideControlsNotification) {
      _controlHidden = true;
      hideController.forward();
      CreateNotification(hideNavigator: true).dispatch(context);
    } else if (notification is ShowControlsNotification) {
      _controlHidden = false;
      hideController.reverse();
      if (!ref.read(shortRecordingProvider).canUndo) {
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
      if (!ref.read(shortRecordingProvider).canUndo) {
        CreateNotification(hideNavigator: false).dispatch(context);
      }
    } else if (notification is InitCameraNotification) {
      _preventInitDispose = false;
      _initCamera();
    } else if (notification is DisposeCameraNotification) {
      _disposeCamera();
      _preventInitDispose = true;
    } else if (notification is CompleteNotification) {
      _proceedToEdit();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final speedSelectorScaleAnimation = Tween<double>(
      begin: .9,
      end: 1,
    ).animate(hideSpeedController);
    // TODO(josh4500): Remove
    ref.watch(shortsCreateProvider);
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
                  viewConstraints = constraints;
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
                        ListenableBuilder(
                          listenable: recordOuterButtonPosition,
                          builder: (
                            BuildContext context,
                            Widget? childWidget,
                          ) {
                            Offset? position = recordOuterButtonPosition.value;
                            if (position == Offset.zero) {
                              position = getOuterButtonInitPosition(
                                constraints,
                              );
                            }

                            return Positioned(
                              top: position.dy,
                              left: position.dx,
                              child: childWidget!,
                            );
                          },
                          child: HiddenListenableWidget(
                            listenable: countdownHidden,
                            hideCallback: () => !countdownHidden.value,
                            child: AnimatedVisibility(
                              animation: hideAnimation,
                              alignment: Alignment.bottomCenter,
                              child: ListenableBuilder(
                                listenable: recordingNotifier,
                                builder: (BuildContext context, Widget? _) {
                                  final sizeAnimation = CurvedAnimation(
                                    parent: recordOuterButtonController,
                                    curve: Curves.easeInCubic,
                                  );
                                  return RecordDragButton(
                                    animation: sizeAnimation,
                                    isDragging: dragRecordNotifier.value,
                                    isRecording: recordingNotifier.value,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        ListenableBuilder(
                          listenable: recordInnerButtonPosition,
                          builder: (
                            BuildContext context,
                            Widget? childWidget,
                          ) {
                            Offset position = recordInnerButtonPosition.value;
                            if (position == Offset.zero) {
                              position = getInnerButtonInitPosition(
                                constraints,
                              );
                            }

                            return Positioned(
                              top: position.dy,
                              left: position.dx,
                              child: childWidget!,
                            );
                          },
                          child: HiddenListenableWidget(
                            listenable: countdownHidden,
                            hideCallback: () => !countdownHidden.value,
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
                                    return RecordButton(
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
                                HiddenListenableWidget(
                                  listenable: Listenable.merge(
                                    [countdownHidden, recordingNotifier],
                                  ),
                                  hideCallback: () {
                                    return !countdownHidden.value ||
                                        recordingNotifier.value;
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CreateCloseButton(
                                        onPopInvoked: _onPopInvoked,
                                      ),
                                      const AddMusicButton(),
                                      const CaptureShortsDuration(),
                                    ],
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
                    HiddenListenableWidget(
                      listenable: Listenable.merge(
                        [
                          countdownHidden,
                          recordingNotifier,
                          hideEffectsNotifier,
                        ],
                      ),
                      hideCallback: () {
                        return !countdownHidden.value ||
                            recordingNotifier.value ||
                            hideEffectsNotifier.value;
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CaptureEffects(controller: effectsController),
                      ),
                    ),
                    HiddenListenableWidget(
                      listenable: Listenable.merge(
                        [countdownHidden, recordingNotifier],
                      ),
                      hideCallback: () {
                        return !countdownHidden.value ||
                            recordingNotifier.value;
                      },
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
