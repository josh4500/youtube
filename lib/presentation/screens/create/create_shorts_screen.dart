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
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../widgets/camera/camera_controller.dart';
import '../../widgets/camera/camera_preview.dart';
import 'widgets/capture/capture_button.dart';
import 'widgets/capture/capture_drag_zoom_button.dart';
import 'widgets/capture/capture_effects.dart';
import 'widgets/capture/capture_progress_control.dart';
import 'widgets/capture/capture_shorts_duration_timer.dart';
import 'widgets/capture/capture_zoom_indicator.dart';
import 'widgets/check_permission.dart';
import 'widgets/create_close_button.dart';
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
    duration: const Duration(milliseconds: 300),
  );

  final latestControlMessage = ValueNotifier<String>('');
  Timer? controlMessageTimer;

  final effectsController = VideoEffectOptionsController();

  final ValueNotifier<int?> hasInitCamera = ValueNotifier(null);

  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

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
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    controller?.dispose();
    hasInitCamera.dispose();

    controlMessageTimer?.cancel();
    latestControlMessage.dispose();
    effectsController.dispose();

    hideController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      final CreateCameraState? cameraState =
          ref.read(_checkMicrophoneCameraPerm).value;
      if (cameraState != null && cameraState.cameras.isNotEmpty) {
        onNewCameraSelected(cameraState.cameras.first);
      }
    });
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
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
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

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        // TODO(josh4500): Avoid this
        // setState(() {}); 'Might always need to rebuild Preview Widget'
        hasInitCamera.value = controller?.cameraId;
      }
      if (cameraController.value.hasError) {
        // TODO(josh4500):  'Camera error ${cameraController.value.errorDescription}',
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(
        <Future<Object?>>[
          cameraController.getMinExposureOffset().then(
                (double value) => _minAvailableExposureOffset = value,
              ),
          cameraController.getMaxExposureOffset().then(
                (double value) => _maxAvailableExposureOffset = value,
              ),
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

    hasInitCamera.value = controller?.cameraId;
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
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

  void handleOnTapCameraView() {
    if (_controlHidden) {
      effectsController.close();
      return;
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
          ValueListenableBuilder(
            valueListenable: hasInitCamera,
            builder: (BuildContext context, int? cameraId, Widget? _) {
              if (controller == null) {
                return const SizedBox();
              } else {
                return Listener(
                  child: LayoutBuilder(
                    builder: (
                      BuildContext context,
                      BoxConstraints constraints,
                    ) {
                      return CameraPreview(
                        controller!,
                        child: GestureDetector(
                          onTap: handleOnTapCameraView,
                          behavior: HitTestBehavior.opaque,
                          child: const SizedBox.expand(),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                AnimatedVisibility(
                  animation: hideAnimation,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 4.0,
                    ),
                    child: Column(
                      children: [
                        CreateProgress(),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CreateCloseButton(),
                            CaptureMusicButton(),
                            CaptureShortsDurationTimer(),
                          ],
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
                  child: const CaptureZoomIndicator(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: CaptureEffects(controller: effectsController),
                ),
                AnimatedVisibility(
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
                      const CaptureProgressControl(),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
                AnimatedVisibility(
                  animation: hideAnimation,
                  alignment: Alignment.bottomCenter,
                  child: const CaptureDragZoomButton(),
                ),
                AnimatedVisibility(
                  animation: hideAnimation,
                  alignment: Alignment.bottomCenter,
                  child: const CaptureButton(),
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
        color: Colors.white24,
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
                  return const CheckPermission();
                } else {
                  return SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.all(48.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'To record, let YouTube access your camera and microphone',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 12),
                              CreateListReason(
                                icon: YTIcons.info_outlined,
                                title: 'Why is this needed?',
                                subtitle:
                                    'So you can take photos, record videos, and preview effects',
                              ),
                              SizedBox(height: 12),
                              CreateListReason(
                                icon: YTIcons.settings_outlined,
                                title: 'You are in control',
                                subtitle:
                                    'Change your permissions any time in Settings',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
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
                                  vertical: 12,
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

class CreateListReason extends StatelessWidget {
  const CreateListReason({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.white70,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Colors.white70,
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
