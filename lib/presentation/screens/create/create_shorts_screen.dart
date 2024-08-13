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

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_clone/core/utils/normalization.dart';
import 'package:youtube_clone/presentation/theme/icon/y_t_icons_icons.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../widgets/camera/camera_controller.dart';
import '../../widgets/camera/camera_preview.dart';
import 'widgets/capture/capture_button.dart';
import 'widgets/capture/capture_effects.dart';
import 'widgets/capture/capture_focus_indicator.dart';
import 'widgets/capture/capture_shorts_duration_timer.dart';
import 'widgets/capture/capture_timeline_control.dart';
import 'widgets/capture/capture_zoom_indicator.dart';
import 'widgets/check_permission.dart';
import 'widgets/create_close_button.dart';
import 'widgets/create_permission_reason.dart';
import 'widgets/create_progress.dart';
import 'widgets/notifications/capture_notification.dart';
import 'widgets/notifications/create_notification.dart';
import 'widgets/range_selector.dart';
import 'widgets/video_effect_options.dart';

final _checkMicrophoneCameraPerm =
    FutureProvider.autoDispose<CreateCameraState>(
  (ref) async {
    final result = await Future.wait([
      Permission.camera.isGranted,
      Permission.microphone.isGranted,
    ]);

    final hasPermission = result.fold<bool>(
      true,
      (value, element) => value && element,
    );

    CreateCameraState state = CreateCameraState(
      hasPermissions: hasPermission,
    );

    if (hasPermission) {
      final cameras = await availableCameras();
      state = state.copyWith(cameras: cameras);
    }

    return state;
  },
);

class CreateCameraState {
  CreateCameraState({
    required this.hasPermissions,
    this.cameras = const <CameraDescription>[],
  });

  final bool hasPermissions;
  final List<CameraDescription> cameras;

  CreateCameraState copyWith({
    bool? hasPermissions,
    List<CameraDescription>? cameras,
  }) {
    return CreateCameraState(
      hasPermissions: hasPermissions ?? this.hasPermissions,
      cameras: cameras ?? this.cameras,
    );
  }
}

class CreateShortsScreen extends StatelessWidget {
  const CreateShortsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer(
        builder: (context, ref, child) {
          final permResult = ref.watch(_checkMicrophoneCameraPerm);
          return permResult.when(
            data: (CreateCameraState state) {
              if (state.hasPermissions && state.cameras.isNotEmpty) {
                return const CaptureShortsView();
              }
              return const CreateShortsPermissionRequest(checking: false);
            },
            error: (e, _) => const CreateShortsPermissionRequest(),
            loading: CreateShortsPermissionRequest.new,
          );
        },
      ),
    );
  }
}

class CaptureShortsView extends ConsumerStatefulWidget {
  const CaptureShortsView({
    super.key,
  });

  @override
  ConsumerState<CaptureShortsView> createState() => _CaptureShortsViewState();
}

class _CaptureShortsViewState extends ConsumerState<CaptureShortsView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
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

    controller?.dispose();
    hasInitCameraNotifier.dispose();

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

  Offset getCenterButtonPosition(BoxConstraints constraints) {
    return Offset(
      (constraints.maxWidth / 2) - (kRecordInnerButtonSize / 2) + 0.625,
      (constraints.maxHeight) - kRecordOuterButtonSize + bottomOffset,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (hasInitCameraNotifier.value == null) {
      Future.microtask(() {
        final cameraState = ref.read(_checkMicrophoneCameraPerm).value;
        if (cameraState != null && cameraState.cameras.isNotEmpty) {
          onNewCameraSelected(cameraState.cameras.first);
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
      hasInitCameraNotifier.value = null;
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  void effectStatusListener(EffectAction action, EffectOption option) {
    if (option.label == 'Flip') {
      _flipCamera();
    } else if (option.label == 'Speed') {
      if (action == EffectAction.add) {
        hideSpeedController.forward();
      } else {
        hideSpeedController.reverse();
      }
    } else if (option.label == 'Lighting') {
      if (action == EffectAction.add) {
        setExposureOffset(
          .75.normalizeRange(
            _minAvailableExposureOffset,
            _maxAvailableExposureOffset,
          ),
        );
      } else {
        setExposureOffset(_minAvailableExposureOffset);
      }
    } else if (option.label == 'Flash') {
      if (action == EffectAction.add) {
        setFlashMode(FlashMode.torch);
      } else {
        setFlashMode(FlashMode.off);
      }
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
      mediaSettings: const MediaSettings(
        resolutionPreset: ResolutionPreset.veryHigh,
        fps: 30,
        videoBitrate: 200000,
        audioBitrate: 32000,
      ),
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
    final List<CameraDescription>? cameras =
        ref.read(_checkMicrophoneCameraPerm).value?.cameras;

    if (cameras.isNotNull && cameras!.length > 1) {
      onNewCameraSelected(
        cameras.firstWhere(
          (camera) => camera != hasInitCameraNotifier.value,
          orElse: () => cameras.first,
        ),
      );
    }
  }

  void handleOnTapRecordButton() {
    dragRecordNotifier.value = false; // Not dragging

    final recording = !recordingNotifier.value;
    disableDragMode = recording;
    recordingNotifier.value = recording;
    recording
        ? recordOuterButtonController.forward(from: .7)
        : recordOuterButtonController.reverse(from: .7);

    CreateNotification(hideNavigator: recording).dispatch(context);
  }

  void handleLongPressStartRecordButton(LongPressStartDetails details) {
    if (disableDragMode) return;

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
    if (disableDragMode) return;

    droppedButton = false;

    dragRecordNotifier.value = false;
    recordingNotifier.value = false;
    hideZoomController.reverse();

    // Reset positions
    recordOuterButtonPosition.value = getDragCircleInitPosition(constraints);
    recordInnerButtonPosition.value = getCenterButtonPosition(constraints);

    recordOuterButtonController.reverse();
  }

  void handleLongPressUpdateRecordButton(
    LongPressMoveUpdateDetails details,
    BoxConstraints constraints,
  ) {
    if (disableDragMode) return;

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
      recordInnerButtonPosition.value = getCenterButtonPosition(constraints);
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
    } on CameraException catch (e) {
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
    } on CameraException catch (e) {
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
    } on CameraException catch (e) {
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
    } on CameraException catch (e) {
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
    } on CameraException catch (e) {
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
                      position ??= getCenterButtonPosition(constraints);

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
                              CaptureShortsDurationTimer(),
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
                            child: const RangeSelector(),
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
  const CaptureMusicButton({
    super.key,
  });

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

class OldCreateShortsPermissionRequest extends StatelessWidget {
  const OldCreateShortsPermissionRequest({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CreateProgress(),
        const SizedBox(height: 24),
        const CreateCloseButton(),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Create a Short',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Allow access to your camera and microphone',
                  style: TextStyle(color: Colors.white24),
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 12),
                Consumer(
                  builder: (context, ref, child) {
                    return GestureDetector(
                      onTap: () async {
                        await Permission.camera.request();
                        await Permission.microphone.request();

                        ref.refresh(_checkMicrophoneCameraPerm);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 9,
                          horizontal: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: const Text(
                          'Allow access',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
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
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        image: checking
            ? null
            : const DecorationImage(
                image: CustomNetworkImage(''),
              ),
      ),
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
                  return SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Padding(
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
                        const SizedBox(height: 12),
                        Consumer(
                          builder: (context, ref, child) {
                            return GestureDetector(
                              onTap: () async {
                                await Permission.camera.request();
                                await Permission.microphone.request();

                                ref.refresh(_checkMicrophoneCameraPerm);
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
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
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
