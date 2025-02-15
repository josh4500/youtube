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
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core.dart';
import 'package:youtube_clone/core/utils/normalization.dart';
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/screens/video/widgets/video_notification.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/controls/player_notifications.dart';
import 'widgets/player/mini_player.dart';
import 'widgets/player/player_annotations_wrapper.dart';
import 'widgets/player/player_components_wrapper.dart';
import 'widgets/player/player_view.dart';
import 'widgets/sheet/player_settings_sheet.dart';
import 'widgets/sheet/video_chapters_sheet.dart';
import 'widgets/sheet/video_clip_sheet.dart';
import 'widgets/sheet/video_comment_sheet.dart';
import 'widgets/sheet/video_description_sheet.dart';
import 'widgets/sheet/video_membership_sheet.dart';
import 'widgets/sheet/video_playlist_sheet.dart';
import 'widgets/sheet/video_thanks_sheet.dart';
import 'widgets/video_details_section.dart';
import 'widgets/video_playlist_section.dart';

class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({
    super.key,
    required this.width,
    required this.height,
  });
  final double height;
  final double width;

  @override
  ConsumerState<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen>
    with
        TickerProviderStateMixin,
        WidgetsBindingObserver,
        PageDraggableSizeListenerMixin {
  final GlobalKey _interactivePlayerKey = GlobalKey();
  VelocityTracker? _infoVelocityTracker;
  double _slideOffsetYValue = 0;
  late final _viewController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
  );
  late final Animation<Offset> _playerLandscapeSlideAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, .05),
  ).animate(_viewController);
  late final Animation<double> _playerLandscapeScaleAnimation =
      _viewController.drive(
    Tween<double>(begin: 1, end: 0.95),
  );

  final _detailsScrollController = ScrollController();
  final _detailsScrollPhysics = CustomScrollPhysics(
    parent: const AlwaysScrollableScrollPhysics(),
  );

  final _transformationController = TransformationController();
  late final _zoomPanAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  late final _playerDismissController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 125),
  );
  late final Animation<double> _playerFadeAnimation = ReverseAnimation(
    CurvedAnimation(
      parent: _playerDismissController,
      curve: Curves.easeInCubic,
    ),
  );
  late final Animation<Offset> _playerSlideAnimation = Tween(
    begin: Offset.zero,
    end: const Offset(0, 1),
  ).animate(_playerDismissController);

  late final _playerOpacityController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  late final Animation<double> _playerOpacityAnimation = ReverseAnimation(
    CurvedAnimation(parent: _playerOpacityController, curve: Curves.easeIn),
  );

  late final _detailsOpacityController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  late final Animation<double> _detailsOpacityAnimation = CurvedAnimation(
    parent: ReverseAnimation(_detailsOpacityController),
    curve: Curves.easeIn,
  );
  late final _playlistOffsetController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  late final _playlistOffsetAnimation = Tween<ui.Offset>(
    begin: const ui.Offset(0, 1),
    end: ui.Offset.zero,
  ).animate(_playlistOffsetController);

  late final _playerAddedHeightNotifier = AnimationNotifier<double>(
    value: ui.clampDouble(
      (screenHeight * (1 - kAvgVideoViewPortHeight)) -
          (screenHeight * (1 - playerHeightToScreenRatio)),
      minAdditionalHeight,
      maxAdditionalHeight,
    ),
    vsync: this,
    duration: const Duration(milliseconds: 125),
  );

  late final _playerMarginNotifier = ValueNotifier<double>(0);

  late final _screenHeightAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 125),
  );
  late final _screenHeightNotifier = AnimationNotifier<double>(
    value: kMinVideoViewPortWidthPortrait,
    vsync: this,
    duration: const Duration(milliseconds: 125),
  );

  late final _screenWidthNotifier = AnimationNotifier<double>(
    value: 1,
    vsync: this,
    duration: const Duration(milliseconds: 125),
  );

  late final _playerWidthNotifier = AnimationNotifier<double>(
    value: kMinVideoViewPortWidthPortrait,
    vsync: this,
    duration: const Duration(milliseconds: 125),
  );

  late final _playerHeightNotifier = ValueNotifier<double>(
    kMinVideoViewPortWidthPortrait.normalize(
      kMinVideoViewPortWidthPortrait,
      1,
    ),
  );
  late final _hideGraphicsNotifier = ValueNotifier<bool>(true);

  final _transcriptController = PageDraggableOverlayChildController(
    title: 'Transcript',
  );
  final _replyController = PageDraggableOverlayChildController(
    title: 'Replies',
  );

  /// PlayerSignal StreamSubscription
  StreamSubscription<PlayerSignal>? _playerSignalSubscription;

  Timer? _orientationTimer;

  bool _controlWasTempHidden = false;

  double get screenWidth => widget.width;
  double get screenHeight => widget.height;

  double get minPlayerHeightRatio {
    return context.orientation.isPortrait
        ? 60 / screenHeight
        : kMinPlayerHeightLandscape;
  }

  double get minScreenWidthRatio {
    return 0.6;
  }

  double get minVideoViewPortWidthRatio {
    return context.orientation.isPortrait
        ? kMinVideoViewPortWidthPortrait
        : kMinVideoViewPortWidthLandscape;
  }

  // TODO(josh4500): Needs to be computed
  double get playerHeightToScreenRatio {
    return kAvgVideoViewPortHeight;
  }

  /// Player View Max Height
  double get playerMaxHeight {
    return screenHeight * playerHeightToScreenRatio;
  }

  /// Player View Min Height
  double get playerMinHeight => 60;

  double get initialDraggableSnapSize => 1 - playerHeightToScreenRatio;

  /// Player View width
  ///
  /// NOTE: Depends on [_playerWidthNotifier], make to wrap with [ListenableBuilder]
  /// to see changes.
  double get playerWidth {
    return _playerWidthNotifier.value * screenWidth;
  }

  /// Player Height
  ///
  /// NOTE: Depends on [_playerHeightNotifier], make to wrap with [ListenableBuilder]
  /// to see changes.
  double get playerHeight {
    return _playerHeightNotifier.value.normalizeRange(
      playerMinHeight,
      playerMaxHeight,
    );
  }

  /// Player parent box height with added height
  ///
  /// NOTE: Depends on [_playerAddedHeightNotifier], make to wrap with [ListenableBuilder]
  /// to see changes.
  double? get playerBoxHeight {
    return playerAddedHeight <= 0 ? null : playerMaxHeight + playerAddedHeight;
  }

  /// Player Added Height
  ///
  /// NOTE: Depends on [_playerAddedHeightNotifier], make to wrap with [ListenableBuilder]
  /// to see changes.
  double get playerAddedHeight {
    return _playerAddedHeightNotifier.value;
  }

  /// Player Margin
  ///
  /// See [_onDragExpandedPlayer]
  /// NOTE: Depends on [_playerMarginNotifier], make to wrap with [ListenableBuilder]
  double get playerMargin {
    return _playerMarginNotifier.value;
  }

  bool get _isResizableExpandingMode {
    return playerHeightToScreenRatio != kAvgVideoViewPortHeight;
  }

  double get maxVerticalMargin {
    return screenHeight * (1 - playerHeightToScreenRatio);
  }

  double get minAdditionalHeight => 0;

  double get maxAdditionalHeight {
    return screenHeight * (1 - playerHeightToScreenRatio);
  }

  double get midAdditionalHeight {
    return screenHeight * (1 - playerHeightToScreenRatio) / 2;
  }

  double get additionalHeight => _playerAddedHeightNotifier.value;

  /// Whether video was temporary paused
  bool _wasTempPaused = false;

  /// [MiniPlayer] PlaybackProgress indicator opacity value
  ///
  /// NOTE: Value depends on WidthNotifier
  double get miniPlayerOpacity {
    return context.orientation.isPortrait
        ? _playerWidthNotifier.value
            .normalize(minVideoViewPortWidthRatio, 1)
            .invertByOne
        : _screenWidthNotifier.value.normalize(0.6, 1).invertByOne;
  }

  /// Indicates whether the player is expanded or not.
  bool get _isExpanded {
    return ref.read(playerViewStateProvider).isExpanded;
  }

  /// Indicates whether screen was forced to fullscreen
  static bool _isForcedFullscreen = false;
  static bool _ensuredForcedFullscreenKept = false;

  /// Indicates whether the player is expanded or not.
  bool get _isFullscreen {
    return context.orientation.isLandscape;
  }

  /// Indicates whether the player is minimized or not.
  bool get _isMinimized {
    return ref.read(playerViewStateProvider).isMinimized;
  }

  /// Indicates whether active zoom panning is in progress.
  bool _activeZoomPanning = false;

  /// Indicates whether player can be dismissed/closed by swiping down
  bool _preventPlayerDismiss = true;

  /// Indicates whether player dismissing
  bool _isDismissing = false;

  /// Indicates whether pointer has been released since resizing player screen
  bool _releasedPlayerPointer = true;

  /// Indicates the direction of player dragging. True if dragging down,
  /// otherwise null.
  bool? _isPlayerDraggingDown;

  /// Prevents player from being dragged up when set to true.
  bool _preventPlayerDragUp = false;

  /// Prevents player from being dragged down when set to true.
  bool _preventPlayerDragDown = false;

  /// Prevents player margin changes
  bool _preventPlayerMarginUpdate = false;

  /// Whether player is seeking
  bool _isSeeking = false;

  /// Allows or disallows dragging for info. Set to true by default.
  bool _allowInfoDrag = true;

  bool _preventGestures = false;

  final Map<VideoBottomSheet, ValueNotifier<bool>> _draggableNotifiers = {};
  final Map<VideoBottomSheet, AnimationController> _draggableAnimationOpacity =
      {};
  final Map<VideoBottomSheet, AnimationController> _draggableAnimationSize = {};
  final Map<VideoBottomSheet, DraggableScrollableController>
      _draggableControllers = {};
  bool get _hasMoreThanOneOpened => _openedDraggableState.length > 1;
  bool get _hasAtLeastOneOpened => _openedDraggableState.isNotEmpty;
  final List<VideoBottomSheet> _openedDraggableState = [];

  /// Creates controllers for [VideoBottomSheet]
  /// - AnimationControllers (Size and Opacity)
  /// - DraggableController
  /// - ValueNotifier (for hiding and showing)
  void _createDraggableControllers(List<VideoBottomSheet> sheets) {
    for (final VideoBottomSheet sheet in sheets) {
      _draggableNotifiers.putIfAbsent(
        sheet,
        () => ValueNotifier<bool>(false),
      );
    }

    for (final VideoBottomSheet sheet in sheets) {
      _draggableAnimationOpacity.putIfAbsent(
        sheet,
        () => AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 250),
        ),
      );
    }

    for (final VideoBottomSheet sheet in sheets) {
      _draggableControllers.putIfAbsent(
        sheet,
        () => DraggableScrollableController()
          ..addListener(
            () => _onSheetSizeChange(sheet),
          ),
      );
    }

    for (final VideoBottomSheet sheet in sheets) {
      if (_sideSheet.contains(sheet)) {
        _draggableAnimationSize.putIfAbsent(
          sheet,
          () => AnimationController(
            vsync: this,
            value: 0,
            duration: const Duration(milliseconds: 100),
          ),
        );
      }
    }
  }

  void _disposeDraggableControllers() {
    _draggableNotifiers.forEach((sheet, notifier) {
      notifier.dispose();
    });
    _draggableNotifiers.clear();
    _draggableAnimationOpacity.forEach((sheet, animationController) {
      animationController.dispose();
    });
    _draggableAnimationOpacity.clear();
    _draggableAnimationSize.forEach((sheet, animationController) {
      animationController.dispose();
    });
    _draggableAnimationSize.clear();
    _draggableControllers.forEach((sheet, controllers) {
      controllers.removeListener(() => _onSheetSizeChange(sheet));
      controllers.dispose();
    });
    _draggableControllers.clear();
  }

  ValueNotifier<bool> _getSheetNotifier(VideoBottomSheet sheet) {
    return _draggableNotifiers[sheet]!;
  }

  AnimationController _getSheetAnimationOpacity(VideoBottomSheet sheet) {
    return _draggableAnimationOpacity[sheet]!;
  }

  AnimationController _getSheetAnimationSize(VideoBottomSheet sheet) {
    return _draggableAnimationSize[sheet]!;
  }

  DraggableScrollableController _getSheetController(VideoBottomSheet sheet) {
    return _draggableControllers[sheet]!;
  }

  void _onSheetSizeChange(VideoBottomSheet sheet) {
    final double size = _draggableControllers[sheet]!.size;

    // Ensures Sheet is removed or re-added while dragging
    if (!(_isPlayerDraggingDown ?? false)) {
      if (size < (initialDraggableSnapSize / 2)) {
        _openedDraggableState.remove(sheet);
      } else if (!_openedDraggableState.contains(sheet)) {
        _openedDraggableState.add(sheet);
      }
    }

    if (_availableSheet.contains(VideoBottomSheet.playlist)) {
      _playlistOffsetController.value = size.normalize(0, .25).invertByOne;
    }

    final isNotifierValue = _draggableNotifiers[sheet]?.value ?? false;
    if (isNotifierValue && context.orientation.isPortrait) {
      _commonDraggableListenerCallback(size);
    }
    // TODO(josh4500): Uncomment when solution to pointer leave Draggable found
    // final prevSheetIndex = _openedDraggableState.indexOf(sheet) - 1;
    // if (prevSheetIndex >= 0) {
    //   _draggableAnimationOpacity[_openedDraggableState[prevSheetIndex]]?.value =
    //       size.normalize(0, 1 - playerHeightToScreenRatio);
    // }
  }

  final List<VideoBottomSheet> _availableSheet = [
    VideoBottomSheet.comment,
    VideoBottomSheet.chapter,
    VideoBottomSheet.description,
    VideoBottomSheet.playlist,
    VideoBottomSheet.thanks,
    VideoBottomSheet.membership,
    VideoBottomSheet.clip,
  ];

  final List<VideoBottomSheet> _sideSheet = [
    VideoBottomSheet.description,
    VideoBottomSheet.comment,
    VideoBottomSheet.playlist,
  ];

  @override
  void initState() {
    super.initState();
    _createDraggableControllers(_availableSheet);

    // Init disable scrolling on Info when _isResizableExpandingMode is true
    if (_isResizableExpandingMode) {
      _detailsScrollPhysics.canScroll = false;
    }

    // Adding callbacks
    _screenHeightNotifier.addListener(_screenHeightListenerCallback);
    _playerDismissController.addListener(_playerDismissListenerCallback);
    _transformationController.addListener(_interactiveZoomListenerCallback);
    _playerAddedHeightNotifier.addListener(_playerAddedHeightListenerCallback);

    Future(() {
      // Initial changes
      _showHideNavigationBar(_screenHeightNotifier.value);

      // Opens and play video
      // TODO(josh4500): Reconsider to always call this method mount widget
      // ref.read(playerRepositoryProvider).openVideo();
    });

    // NOTE: Do not remove
    WidgetsBinding.instance.addObserver(this);
  }

  ui.FlutterView? _view;
  static const double kOrientationLockBreakpoint = 600;
  static bool localExpanded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _view = View.maybeOf(context);

    _animatePlayerWidth(1);
    _animateScreenHeight(1);
  }

  @override
  void didChangeMetrics() {
    final ui.Display? display = _view?.display;
    if (display == null) {
      return;
    }

    if (_isForcedFullscreen == false && localExpanded == false) {
      if (display.size.width / display.devicePixelRatio <
          kOrientationLockBreakpoint) {
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: SystemUiOverlay.values,
        );
      } else {
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.immersiveSticky,
          overlays: <SystemUiOverlay>[],
        );
      }
    }
  }

  final Set<ui.AppLifecycleState> _lastLifecycleStates = {};

  @override
  void didChangeAppLifecycleState(ui.AppLifecycleState state) {
    _lastLifecycleStates.add(state);
    final wasHidden = _lastLifecycleStates.contains(
      ui.AppLifecycleState.hidden,
    );
    final wasPaused = _lastLifecycleStates.contains(
      ui.AppLifecycleState.hidden,
    );
    if (state == ui.AppLifecycleState.resumed && (wasHidden || wasPaused)) {
      if (_isForcedFullscreen &&
          !_ensuredForcedFullscreenKept &&
          !_preventGestures) {
        _exitFullscreenMode();
      } else if (_ensuredForcedFullscreenKept) {
        _ensuredForcedFullscreenKept = false;
      }
      _lastLifecycleStates.clear();

      if (localExpanded) {
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.immersiveSticky,
          overlays: <SystemUiOverlay>[],
        );
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    // NOTE: Do not remove
    WidgetsBinding.instance.removeObserver(this);

    _screenHeightNotifier.removeListener(_screenHeightListenerCallback);
    _playerDismissController.removeListener(_playerDismissListenerCallback);
    _transformationController.removeListener(_interactiveZoomListenerCallback);
    _playerAddedHeightNotifier
        .removeListener(_playerAddedHeightListenerCallback);

    _orientationTimer?.cancel();
    _viewController.dispose();
    _playerSignalSubscription?.cancel();
    _hideGraphicsNotifier.dispose();
    _playerDismissController.dispose();

    _zoomPanAnimationController.dispose();
    _transformationController.dispose();

    _disposeDraggableControllers();

    _detailsScrollController.dispose();
    _detailsOpacityController.dispose();

    _screenHeightAnimationController.dispose();

    _playerWidthNotifier.dispose();
    _screenHeightNotifier.dispose();
    _playerMarginNotifier.dispose();
    _playerAddedHeightNotifier.dispose();

    _transcriptController.dispose();
    _replyController.dispose();

    resetOrientation();

    super.dispose();
  }

  void _screenHeightListenerCallback() {
    final screenHeightRatio = _screenHeightNotifier.value;

    _playerHeightNotifier.value = screenHeightRatio.normalize(
      minPlayerHeightRatio,
      1,
    );

    _showHideNavigationBar(screenHeightRatio);
    _recomputeOpacityAndHeight(screenHeightRatio);

    if (screenHeightRatio == 1) {
      ref
          .read(playerViewStateProvider.notifier)
          .addState(ViewState.visibleBuffer);
    } else {
      ref
          .read(playerViewStateProvider.notifier)
          .removeState(ViewState.visibleBuffer);
    }

    // Hide or Show infographics
    _hideGraphicsNotifier.value = screenHeightRatio < 1;
    if (_availableSheet.contains(VideoBottomSheet.playlist)) {
      _playlistOffsetController.value = screenHeightRatio.normalize(.8, 1);
    }
  }

  void _playerDismissListenerCallback() {
    final value = _playerDismissController.value;
    _changePlayerPitch(value);
  }

  void _interactiveZoomListenerCallback() {
    final double scale = _transformationController.value.getMaxScaleOnAxis();

    if (scale != kMinPlayerScale) {
      _activeZoomPanning = true;
    } else {
      _activeZoomPanning = false;
    }
  }

  void _playerAddedHeightListenerCallback() {
    if (_availableSheet.contains(VideoBottomSheet.playlist)) {
      _playlistOffsetController.value = _playerAddedHeightNotifier.value
          .normalize(minAdditionalHeight, maxAdditionalHeight / 2)
          .invertByOne;
    }
  }

  void _commonDraggableListenerCallback(double size) {
    if (!_hasMoreThanOneOpened) {
      _changePlayerOpacityOnDraggable(size);
      _changeInfoOpacityOnDraggable(size);
    }
    _checkDraggableSizeToPause(size);
  }

  Future<void> _animateScreenHeight(double to) async {
    if (_screenHeightNotifier.value != to) {
      _screenHeightNotifier.animate(end: to);
    }
  }

  Future<void> _animateScreenWidth(double to) async {
    if (_screenWidthNotifier.value != to) {
      _screenWidthNotifier.animate(end: to);
    }
  }

  Future<void> _animatePlayerWidth(double to) async {
    if (_playerWidthNotifier.value != to) {
      _playerWidthNotifier.animate(end: to);
    }
  }

  Future<void> _animateAdditionalHeight(double to) async {
    if (_playerAddedHeightNotifier.value != to) {
      _playerAddedHeightNotifier.animate(end: to);
    }
  }

  /// Callback to pause and play video when draggable sheets change its size
  void _checkDraggableSizeToPause(double size) {
    if (size == 1) {
      if (ref.read(playerNotifierProvider).playing) {
        _wasTempPaused = true;
        ref.read(playerRepositoryProvider).pauseVideo();
      }
    } else if (size <= 1 - minPlayerHeightRatio) {
      if (_wasTempPaused) {
        _wasTempPaused = false;
        ref.read(playerRepositoryProvider).playVideo();
      }
    }
  }

  /// Callback to change Player's pitch when dismissing
  void _changePlayerPitch(double value) {
    ref.read(playerRepositoryProvider).setPitch(value);
  }

  /// Callback to updates the info opacity when draggable sheets changes its size
  void _changePlayerOpacityOnDraggable(double size) {
    if (size > initialDraggableSnapSize) {
      _hideControls(true);

      _playerOpacityController.value = size.normalize(
        initialDraggableSnapSize,
        1,
      );
    }
  }

  /// Callback to updates the info opacity when draggable sheets changes its size
  void _changeInfoOpacityOnDraggable(double size) {
    if (_screenHeightNotifier.value == 1) {
      _detailsOpacityController.value =
          ui.clampDouble(size / (1 - playerHeightToScreenRatio), 0, 1);
    }
  }

  /// Callback to show or hide feed screen navigation bar
  void _showHideNavigationBar(double value) {
    // ref.read(homeRepositoryProvider).updateNavBarPosition(
    //       value.normalize(minPlayerHeightRatio, 1).invertByOne,
    //     );
  }

  /// Callback to change Draggable heights when the Player height changes
  /// (via [_screenHeightNotifier])
  void _recomputeOpacityAndHeight(double value) {
    final double newSizeValue = ui.clampDouble(
      1 -
          (((playerHeight + additionalHeight) + ((1 - value) * screenHeight)) /
              screenHeight),
      0,
      1 - playerHeightToScreenRatio,
    );

    final double opacityValue = newSizeValue
        .normalize(
          0,
          1 - playerHeightToScreenRatio,
        )
        .invertByOne;
    if (_hasAtLeastOneOpened) {
      // Changes the opacity level of the last draggable sheets
      _draggableAnimationOpacity[_openedDraggableState.last]?.value =
          opacityValue;
    } else {
      // Changes info opacity when neither of the draggable sheet are opened
      _detailsOpacityController.value = (opacityValue - .225).clamp(0, 1);
    }

    for (final openedSheet in _openedDraggableState) {
      if (_screenHeightNotifier.value == minPlayerHeightRatio) {
        _draggableControllers[openedSheet]?.jumpTo(0);
      } else {
        _draggableControllers[openedSheet]?.jumpTo(newSizeValue);
      }
    }
  }

  /// Handles zooming and panning based on a swipe gesture.
  ///
  /// Parameters:
  ///   - scaleFactor: The scaling factor to be applied based on the swipe gesture.
  void _swipeZoomPan(double scaleFactor) {
    // Retrieve the last scale value from the transformation controller
    final double lastScaleValue =
        _transformationController.value.getMaxScaleOnAxis();

    // Check if the last scale value is below a certain threshold
    if (lastScaleValue <= kMinPlayerScale + 0.5) {
      // Ensure a minimum scale to avoid zooming in too much
      scaleFactor = ui.clampDouble(
        lastScaleValue + scaleFactor,
        kMinPlayerScale,
        kMinPlayerScale + 0.5,
      );

      // Create a new identity matrix and apply scaling
      final Matrix4 updatedMatrix = Matrix4.identity();
      updatedMatrix.scale(kMinPlayerScale * scaleFactor);

      // Update the transformation controller with the new matrix
      _transformationController.value = updatedMatrix;
    }
  }

  /// Reverses the zoom and pan effect using an animation.
  Future<void> _reverseZoomPan() async {
    // Create a Matrix4Tween for the animation
    final Animation<Matrix4> tween = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(_zoomPanAnimationController);

    // Listener to update the transformation controller during the animation
    tween.addListener(() {
      _transformationController.value = tween.value;
    });

    // Reset the animation controller to its initial state
    _zoomPanAnimationController.reset();

    // Start the animation by moving it forward
    await _zoomPanAnimationController.forward();
  }

  Future<void> setLandscapeMode() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: <SystemUiOverlay>[],
    );
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> resetOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.restoreSystemUIOverlays();
  }

  /// Opens the video in fullscreen mode by sending a video signal to the
  /// repository.
  Future<void> _enterFullscreenMode() async {
    _orientationTimer?.cancel(); // Cancel existing timer

    _isForcedFullscreen = true;
    _ensuredForcedFullscreenKept = true;

    _hideControls();

    _hideGraphicsNotifier.value = true;

    await setLandscapeMode();

    _hideGraphicsNotifier.value = false;
    _showControls();
  }

  Future<void> _exitFullscreenMode() async {
    _preventGestures = false;
    if (_isForcedFullscreen == false) {
      _hideControls();
      // If we change the Orientations to portraitUp this will make it permanent
      // and video will not react when flipped to landscape
      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      );

      _orientationTimer?.cancel();
      _orientationTimer = Timer(const Duration(seconds: 30), () {
        SystemChrome.setPreferredOrientations(
          DeviceOrientation.values,
        );
      });

      _showControls(true);
      return;
    }

    _isForcedFullscreen = false;
    _hideControls();

    _hideGraphicsNotifier.value = true;
    _detailsOpacityController.reverse();
    await resetOrientation();

    _showControls(true);
  }

  /// Hides the player controls and save state whether control will be temporary
  /// hidden.
  ///
  /// Use [force], to hide controls without changing temporary flag
  void _hideControls([bool force = false]) {
    final bool hide = ref.read(playerViewStateProvider).showControls;
    if (hide || force) {
      _controlWasTempHidden = true && !force;
      ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
        PlayerSignal.hideControls,
        PlayerSignal.hidePlaybackProgress,
      ]);
    } else if (context.orientation.isPortrait) {
      ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
        PlayerSignal.hidePlaybackProgress,
      ]);
    }
  }

  /// Shows the player controls if it was temporary hidden.
  ///
  /// Use [force], to show controls regardless
  void _showControls([bool force = false]) {
    if ((_controlWasTempHidden || force) && !_preventGestures) {
      _controlWasTempHidden = false;
      if (!_isMinimized) {
        ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
          PlayerSignal.showControls,
          if (context.orientation.isPortrait) PlayerSignal.showPlaybackProgress,
        ]);
      }
    } else if (!_isMinimized && context.orientation.isPortrait) {
      ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
        if (!localExpanded) PlayerSignal.showPlaybackProgress,
      ]);
    }
  }

  /// Toggles the visibility of player controls based on the current state.
  void _toggleControls() {
    if (ref.read(playerViewStateProvider).showControls) {
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal(<PlayerSignal>[PlayerSignal.hideControls]);
    } else {
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal(<PlayerSignal>[PlayerSignal.showControls]);
    }
  }

  /// Handles tap events on the player.
  Future<void> _onTapPlayer() async {
    if (_isSeeking) return; // Do not show controls when seeking

    if (_preventGestures) {
      ref.read(playerRepositoryProvider).sendPlayerSignal(
        [PlayerSignal.showUnlock],
      );
      return;
    }

    // If the player screen is maximized toggle controls
    if (_screenHeightNotifier.value == 1) {
      _toggleControls();
    }

    // Maximizes player
    if (_playerWidthNotifier.value != 1 && _screenHeightNotifier.value != 1) {
      _exitMinimizedMode();
    }

    // Adjust additional height if within limits
    if (_isResizableExpandingMode) {
      // Set additional height to its maximum value
      _animateAdditionalHeight(minAdditionalHeight);

      // Ensure bottom sheets are opened, animate to the appropriate position
      _recomputeOpacityAndHeight(
        (playerHeight + additionalHeight) / screenHeight,
      );
    }
  }

  /// Handles drag updates for an expanded player.
  ///
  /// Parameters:
  ///   - details: The drag update details containing information about the drag.
  void _onDragExpandedPlayer(DragUpdateDetails details) {
    // Check the direction of the drag
    if (details.delta.dy < 0) {
      // If dragging up
      if (_playerMarginNotifier.value > 0) {
        // Prevent player from being dragged up beyond the top
        _preventPlayerDragUp = true;

        // Adjust player view margin within valid limits
        _playerMarginNotifier.value = ui.clampDouble(
          _playerMarginNotifier.value + details.delta.dy,
          0,
          maxVerticalMargin,
        );
      } else if (!_preventPlayerDragUp) {
        _hideGraphicsNotifier.value = true;
        // If not preventing drag up, adjust _playerAddedHeightNotifier
        _playerAddedHeightNotifier.value = ui.clampDouble(
          _playerAddedHeightNotifier.value + details.delta.dy,
          minAdditionalHeight,
          maxAdditionalHeight,
        );
      }
    } else {
      // If dragging down
      if (!_preventPlayerDragDown) {
        if (additionalHeight >= maxAdditionalHeight) {
          if (!_preventPlayerMarginUpdate) {
            // Adjust player view margin within valid limits
            _playerMarginNotifier.value = ui.clampDouble(
              _playerMarginNotifier.value + details.delta.dy,
              0,
              maxVerticalMargin,
            );
          }
        } else {
          _preventPlayerMarginUpdate = true;
          _playerAddedHeightNotifier.value = ui.clampDouble(
            _playerAddedHeightNotifier.value + details.delta.dy,
            minAdditionalHeight,
            maxAdditionalHeight,
          );
        }
      } else {
        // If preventing drag down, adjust _additionalHeightNotifier
        _playerAddedHeightNotifier.value = ui.clampDouble(
          _playerAddedHeightNotifier.value + details.delta.dy,
          minAdditionalHeight,
          maxAdditionalHeight,
        );
      }
    }
  }

  /// Handles drag updates for a not expanded player.
  ///
  /// Parameters:
  ///   - details: The drag update details containing information about the drag.
  void _onDragNotExpandedPlayer(DragUpdateDetails details) {
    // Determine the drag direction (down or not)
    _isPlayerDraggingDown ??= details.delta.dy > 0;

    if (!_preventPlayerDismiss) {
      if (details.delta.dy > 0 &&
          _screenHeightNotifier.value == minPlayerHeightRatio) {
        // Ensures that the first drag down by the from [minVideoViewPortHeight]
        // will be dismissing player if user pointer was recently released
        _isDismissing = true && _releasedPlayerPointer;
      }

      if (_isDismissing) {
        final val = details.delta.dy *
            kPlayerDismissRate /
            (minPlayerHeightRatio * screenHeight);
        _playerDismissController.value += val;
        return;
      }
    }
    // Player has not released pointer
    _releasedPlayerPointer = false;

    // If dragging down
    if (_isPlayerDraggingDown ?? false) {
      // Adjust height and width based on the drag delta
      _screenHeightNotifier.value = ui.clampDouble(
        _screenHeightNotifier.value - (details.delta.dy / screenHeight),
        minPlayerHeightRatio,
        1,
      );

      if (context.orientation.isLandscape) {
        _screenWidthNotifier.value = ui.clampDouble(
          _screenHeightNotifier.value / playerHeightToScreenRatio,
          minVideoViewPortWidthRatio,
          1,
        );
      }

      _playerWidthNotifier.value = ui.clampDouble(
        _screenHeightNotifier.value / playerHeightToScreenRatio,
        minVideoViewPortWidthRatio,
        1,
      );
    } else {
      if (_isMinimized) {
      } else {
        // Start zoom panning on swipe up
        _swipeZoomPan(
          -(details.delta.dy / (screenHeight * playerHeightToScreenRatio)),
        );
      }
    }
  }

  Future<void> _onDragEndExpandedPlayer(DragEndDetails details) async {
    // This condition is for case when player is dragged down
    if (_playerMarginNotifier.value > maxAdditionalHeight / 4) {
      _exitExpandedMode();
    }

    // These conditions are for cases when player is dragged up
    else if (additionalHeight > maxAdditionalHeight / 2) {
      _enterExpandedMode();
    } else {
      _exitExpandedMode();
    }

    _hideGraphicsNotifier.value = false;
    _playerMarginNotifier.value = 0;
    _detailsScrollPhysics.canScroll = true;
  }

  Future<void> _onDragEndNotExpandedPlayer(DragEndDetails details) async {
    // Set to false because the user pointer events will no longer be updated
    _isDismissing = false;

    if (_isPlayerDraggingDown ?? false) {
      final double latestHeightVal = _screenHeightNotifier.value;
      final double velocityY = details.velocity.pixelsPerSecond.dy;

      if (latestHeightVal >= 0.5) {
        await Future.wait([
          _animateScreenHeight(
            velocityY >= kMaxDragVelocity ? minPlayerHeightRatio : 1,
          ),
          _animatePlayerWidth(
            velocityY >= kMaxDragVelocity ? minVideoViewPortWidthRatio : 1,
          ),
        ]);
      } else {
        await Future.wait([
          _animateScreenHeight(
            velocityY <= -kMaxDragVelocity ? 1 : minPlayerHeightRatio,
          ),
          _animatePlayerWidth(
            velocityY <= -150 ? 1 : minVideoViewPortWidthRatio,
          ),
        ]);
      }
    }

    if (_screenHeightNotifier.value > minPlayerHeightRatio) {
      _isPlayerDraggingDown = null;
      _preventPlayerDismiss = true;
    } else {
      _preventPlayerDismiss = false;
    }

    if (_playerDismissController.value >= 0.7) {
      _playerDismissController.value = 1;
      ref.read(playerRepositoryProvider).closePlayerScreen();
    } else {
      _playerDismissController.value = 0;
    }

    if (_screenHeightNotifier.value == minPlayerHeightRatio) {
      ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
        PlayerSignal.minimize,
        PlayerSignal.hidePlaybackProgress,
      ]);
    } else {
      ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
        PlayerSignal.maximize,
        PlayerSignal.showPlaybackProgress,
      ]);
    }

    _detailsScrollPhysics.canScroll = true;

    if (_activeZoomPanning) {
      final double velocityY = details.velocity.pixelsPerSecond.dy;
      if (velocityY < -kMaxDragVelocity) {
        _enterFullscreenMode();
      }
    }
  }

  void _onDragFullscreenPlayer(DragUpdateDetails details) {
    _slideOffsetYValue += details.delta.dy;

    _viewController.value = ui.clampDouble(
      _slideOffsetYValue / 100,
      0,
      1,
    );
  }

  Future<void> _onDragFullscreenPlayerEnd(DragEndDetails details) async {
    if (_viewController.value >= 1) {
      _exitFullscreenMode();
    }

    _slideOffsetYValue = 0;
    _viewController.value = 0;
  }

  void _onDragStartPlayer(DragStartDetails details) {
    if (_preventGestures || _isSeeking) return;

    // Hide controls
    _hideControls();
  }

  /// Handles drag updates for the player, determining the drag behavior based on
  /// it state.
  void _onDragUpdatePlayer(DragUpdateDetails details) {
    if (_preventGestures || _isSeeking) return;

    // If active zoom panning is in progress, update zoom panning and return
    if (_activeZoomPanning) {
      _swipeZoomPan(
        -(details.delta.dy / (screenHeight * playerHeightToScreenRatio)),
      );
      return;
    }

    // If preventing player drag up or down, return without further processing
    if (details.delta.dy > 0 && _preventPlayerDragUp) {
      return;
    }
    if (details.delta.dy < 0 && _preventPlayerDragDown) {
      return;
    }

    if (_isFullscreen) {
      _isMinimized
          ? _onDragNotExpandedPlayer(details)
          : _onDragFullscreenPlayer(details);
    } else {
      _isExpanded
          ? _onDragExpandedPlayer(details)
          : _onDragNotExpandedPlayer(details);
    }
  }

  Future<void> _onDragEndPlayer(DragEndDetails details) async {
    if (_preventGestures) return;

    _releasedPlayerPointer = true;

    if (!_isSeeking) {
      _preventPlayerDragUp = false;
      _preventPlayerDragDown = false;
      _preventPlayerMarginUpdate = false;
    }

    if (_isExpanded) {
      _onDragEndExpandedPlayer(details);
    } else {
      await _onDragEndNotExpandedPlayer(details);
    }

    // For fullscreen video
    _onDragFullscreenPlayerEnd(details);

    // Reversing zoom due to swiping up
    final lastScaleValue = _transformationController.value.getMaxScaleOnAxis();
    if (lastScaleValue <= kMinPlayerScale + 0.5 && lastScaleValue > 1.0) {
      if (lastScaleValue == kMinPlayerScale + 0.5) _enterFullscreenMode();
      await _reverseZoomPan();
    }

    // Shows controls if it was temporary hidden and avoids showing controls
    // when screen is minimized
    _showControls();
  }

  Future<void> _enterExpandedMode([bool animate = true]) async {
    localExpanded = true;
    _hideControls();

    if (_isResizableExpandingMode) {
      animate
          ? await _animateAdditionalHeight(maxAdditionalHeight)
          : _playerAddedHeightNotifier.value = maxAdditionalHeight;
    } else {
      animate
          ? await _animateAdditionalHeight(maxAdditionalHeight)
          : _playerAddedHeightNotifier.value = maxAdditionalHeight;
    }

    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: <SystemUiOverlay>[],
    );

    if (_isExpanded == false) {
      ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
        PlayerSignal.enterExpanded,
      ]);
    }

    _hideGraphicsNotifier.value = false;
    _showControls();
  }

  /// Handles exiting expanded mode
  ///
  /// Use [animate] to determine if Additional Height value animates
  Future<void> _exitExpandedMode([bool animate = true]) async {
    localExpanded = false;
    _hideControls();
    if (_isResizableExpandingMode) {
      animate
          ? await _animateAdditionalHeight(midAdditionalHeight)
          : _playerAddedHeightNotifier.value = midAdditionalHeight;
    } else {
      animate
          ? await _animateAdditionalHeight(minAdditionalHeight)
          : _playerAddedHeightNotifier.value = minAdditionalHeight;
    }

    ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
      PlayerSignal.exitExpanded,
    ]);

    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    _hideGraphicsNotifier.value = false;
    _showControls();
  }

  void _enterMinimizedMode() {
    // Note: Do not remove
    // We set to true to emulate player was dragged down to minimize
    _isPlayerDraggingDown = true;
    _preventPlayerDismiss = false;

    if (_isExpanded) {
      _exitExpandedMode(false); // Avoids animation by passing false
    }

    _hideControls(true);

    ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
      PlayerSignal.minimize,
      PlayerSignal.hidePlaybackProgress,
    ]);

    Future.wait([
      _animateScreenHeight(minPlayerHeightRatio),
      _animatePlayerWidth(minVideoViewPortWidthRatio),
      if (context.orientation.isLandscape)
        _animateScreenWidth(minScreenWidthRatio),
    ]);
  }

  void _exitMinimizedMode() {
    _isSeeking = false;
    _preventPlayerDragDown = false;
    _preventPlayerDragUp = false;

    // Set height and width to maximum
    Future.wait([
      _animateScreenHeight(1),
      _animatePlayerWidth(1),
      if (context.orientation.isPortrait) _animateScreenWidth(1),
    ]).then((value) {
      ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
        PlayerSignal.maximize,
        PlayerSignal.showPlaybackProgress,
      ]);

      _showControls(ref.read(playerNotifierProvider).ended);
    });
  }

  Future<void> _openCommentTextfield() async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return const CommentTextField();
      },
    );
  }

  Future<void> _openBottomSheet(VideoBottomSheet sheet) async {}

  void _closeBottomSheet(VideoBottomSheet sheet) {
    if (sheet == VideoBottomSheet.comment) {
      if (_replyController.isOpened) {
        _replyController.close();
        return;
      }
    }

    if (sheet == VideoBottomSheet.description) {
      if (_transcriptController.isOpened) {
        _transcriptController.close();
        return;
      }
    }

    _openedDraggableState.remove(sheet);
    _getSheetController(sheet).animateTo(
      0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
    );

    // TODO(josh4500): Uncomment when solution to pointer leave Draggable found
    // final prevSheetIndex = _openedDraggableState.indexOf(sheet) - 1;
    // if (prevSheetIndex >= 0) {
    //   _draggableAnimationOpacity[_openedDraggableState[prevSheetIndex]]
    //       ?.animateTo(1);
    // }

    _getSheetAnimationSize(sheet).reverse();

    if (_isResizableExpandingMode && additionalHeight > 0) {
      _animateAdditionalHeight(minAdditionalHeight);
    }

    ref.read(playerViewStateProvider.notifier).removeState(
          switch (sheet) {
            VideoBottomSheet.chapter => ViewState.visibleChapters,
            VideoBottomSheet.description => ViewState.visibleDescription,
            _ => null,
          },
        );
  }

  Future<void> _openSettings() async {
    // TODO(josh4500): Create Model for settings final option
    final selection = await openSettingsSheet(context);
    if (selection == 'Lock screen' && context.mounted) {
      _preventGestures = true;
      ref.read(playerRepositoryProvider).sendPlayerSignal(
        [PlayerSignal.lockScreen, PlayerSignal.hidePlaybackProgress],
      );
      await Future.delayed(const Duration(milliseconds: 250));
      await _enterFullscreenMode();
    } else if (selection == 'Ambient mode') {
      ref.read(playerRepositoryProvider).toggleAmbientMode();
    } else if (selection is PlayerSpeed) {
      ref.read(playerRepositoryProvider).setSpeed(selection);
    }
  }

  void _onPointerDownOn(PointerDownEvent event) {
    _infoVelocityTracker = VelocityTracker.withKind(event.kind);
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_preventGestures) return;

    if (_detailsScrollController.offset == 0 ||
        (_isResizableExpandingMode && event.delta.dy < 0)) {
      _infoVelocityTracker?.addPosition(event.timeStamp, event.localPosition);
      if (_allowInfoDrag) {
        _detailsScrollPhysics.canScroll = false;
        _playerAddedHeightNotifier.value = ui.clampDouble(
          _playerAddedHeightNotifier.value + event.delta.dy,
          minAdditionalHeight,
          maxAdditionalHeight,
        );

        if (additionalHeight > 0) {
          // Hides the playback progress while animating "to" expanded view
          ref.read(playerRepositoryProvider).sendPlayerSignal(
            <PlayerSignal>[PlayerSignal.hidePlaybackProgress],
          );

          _hideControls();
          _hideGraphicsNotifier.value = true;
        }
      }
    }

    if (event.delta.dy < 0 && _detailsScrollController.offset > 0) {
      _allowInfoDrag = false;
    }

    if (_playerAddedHeightNotifier.value == 0) {
      _detailsScrollPhysics.canScroll = true;
    }
  }

  Future<void> _onPointerUp(PointerUpEvent event) async {
    if (_preventGestures) return;

    if (_allowInfoDrag) {
      final velocity = _infoVelocityTracker?.getVelocity();
      final aboveMaxVelocity =
          velocity != null && velocity.pixelsPerSecond.dy > kMaxDragVelocity;

      if (additionalHeight > maxAdditionalHeight / 2 ||
          aboveMaxVelocity && event.delta.dy < 1) {
        _enterExpandedMode();
      } else {
        _exitExpandedMode();

        _detailsScrollPhysics.canScroll = true;
      }
    }

    if (_detailsScrollController.offset == 0) {
      _allowInfoDrag = true;
    }
    _infoVelocityTracker = null;
  }

  /// Callback for when scroll notifications are received in info section
  bool _onScrollDetailsScrollNotification(ScrollNotification notification) {
    // Prevents info to be dragged down while scrolling in DynamicTab
    if (notification.depth >= 1) {
      if (notification is ScrollStartNotification) {
        _allowInfoDrag = false;

        if (_playerAddedHeightNotifier.value > 0) {
          // No need for animation
          _playerAddedHeightNotifier.value = minAdditionalHeight;
        }
      } else if (notification is ScrollEndNotification) {
        _allowInfoDrag = true;
      }
    }
    return true;
  }

  void _handlePlayerControlNotification(PlayerNotification notification) {
    if (notification is MinimizePlayerNotification) {
      _enterMinimizedMode();
    } else if (notification is EnterExpandPlayerNotification) {
      _enterExpandedMode();
    } else if (notification is ExitExpandPlayerNotification) {
      _exitExpandedMode();
    } else if (notification is EnterFullscreenPlayerNotification) {
      _enterFullscreenMode();
    } else if (notification is ExitFullscreenPlayerNotification) {
      _exitFullscreenMode();
    } else if (notification is SettingsPlayerNotification) {
      _openSettings();
    } else if (notification is RotatePlayerNotification) {
      if (context.orientation.isLandscape) {
        _exitFullscreenMode().then((_) => _enterExpandedMode(false));
        // _enterExpandedMode();
      } else {
        _enterFullscreenMode();
      }
    } else if (notification is SeekStartPlayerNotification) {
      _preventPlayerDragUp = true;
      _preventPlayerDragDown = true;
      _isSeeking = true;
    } else if (notification is SeekEndPlayerNotification) {
      _isSeeking = false;
      _preventPlayerDragUp = false;
      _preventPlayerDragDown = false;
    }
  }

  /// Handles when back navigation system tries to pop route
  Future<void> _handleBackButtonPressed<T>(bool didPop, T? result) async {
    if (_openedDraggableState.contains(VideoBottomSheet.comment)) {
      _closeBottomSheet(VideoBottomSheet.comment);
      return;
    } else if (_openedDraggableState.contains(VideoBottomSheet.description)) {
      _closeBottomSheet(VideoBottomSheet.description);
      return;
    } else if (_openedDraggableState.contains(VideoBottomSheet.chapter)) {
      _closeBottomSheet(VideoBottomSheet.chapter);
      return;
    } else if (!_isMinimized) {
      _enterMinimizedMode();
      return;
    }

    // Closes screen when Player is minimized
    if (_isMinimized) ref.read(playerRepositoryProvider).closePlayerScreen();
  }

  bool _handleScreenNotification(VideoScreenNotification notification) {
    if (notification is OpenBottomSheetNotification) {
      _openBottomSheet(notification.sheet);
    } else if (notification is CloseBottomSheetNotification) {
      _closeBottomSheet(notification.sheet);
    } else if (notification is OpenCommentNotification) {
      _openCommentTextfield();
    }
    return true;
  }

  @override
  void didChangePageDraggableSize(double size) {
    // TODO: implement didChangePageDraggableSize
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = context.orientation;
    final Axis layoutDirection =
        orientation.isPortrait ? Axis.vertical : Axis.horizontal;

    final interactivePlayerView = Theme(
      data: AppTheme.dark,
      child: PlayerComponentsWrapper(
        key: _interactivePlayerKey,
        handleNotification: _handlePlayerControlNotification,
        child: ListenableBuilder(
          listenable: _transformationController,
          builder: (BuildContext context, Widget? childWidget) {
            return InteractiveViewer(
              minScale: kMinPlayerScale,
              maxScale: kMaxPlayerScale,
              alignment: Alignment.center,
              transformationController: _transformationController,
              child: childWidget!,
            );
          },
          child: const PlayerView(),
        ),
      ),
    );

    final miniPlayerProgress = ListenableBuilder(
      listenable: Listenable.merge([
        if (orientation.isLandscape) _screenWidthNotifier,
        _playerWidthNotifier,
      ]),
      builder: (
        BuildContext context,
        Widget? childWidget,
      ) {
        return Visibility(
          visible: miniPlayerOpacity > 0,
          child: SizedBox(
            width: orientation.isLandscape
                ? screenWidth * _screenWidthNotifier.value
                : screenWidth,
            child: Opacity(
              opacity: miniPlayerOpacity,
              child: childWidget,
            ),
          ),
        );
      },
      child: Builder(
        builder: (context) {
          final playerRepo = ref.read(playerRepositoryProvider);
          return PlaybackProgress(
            progress: playerRepo.videoProgressStream,
            // TODO(Josh): Revisit this code
            start: playerRepo.currentVideoProgress ?? Progress.zero,
            // TODO(Josh): Get ready value
            end: const Duration(minutes: 1),
            showBuffer: false,
            backgroundColor: Colors.transparent,
          );
        },
      ),
    );

    final miniPlayer = SlideTransition(
      position: _screenWidthNotifier.toAnimation(
        transformer: (incomingValue) {
          // TODO(josh4500): Avoid explicit value
          return orientation.isLandscape ? incomingValue.normalize(0.6, 1) : 0;
        },
      ).drive(
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, 1),
        ),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: Opacity(
          opacity: miniPlayerOpacity,
          child: SizedBox(
            height: playerMinHeight,
            child: const MiniPlayer(),
          ),
        ),
      ),
    );

    Widget createPlayerView(Widget playerView) {
      if (orientation.isLandscape) {
        return ListenableBuilder(
          listenable: Listenable.merge([
            _playerWidthNotifier,
          ]),
          builder: (
            BuildContext context,
            Widget? childWidget,
          ) {
            return Container(
              constraints: BoxConstraints(
                minHeight: playerMinHeight,
              ),
              width: playerWidth,
              height: screenHeight * _screenHeightNotifier.value,
              child: childWidget,
            );
          },
          child: SlideTransition(
            position: _playerLandscapeSlideAnimation,
            child: ScaleTransition(
              scale: _playerLandscapeScaleAnimation,
              child: playerView,
            ),
          ),
        );
      }

      // Portrait player
      return ListenableBuilder(
        listenable: Listenable.merge([
          _playerWidthNotifier,
          _playerHeightNotifier,
          _playerAddedHeightNotifier,
          _playerMarginNotifier,
        ]),
        builder: (
          BuildContext context,
          Widget? childWidget,
        ) {
          return SizedBox(
            height: playerBoxHeight,
            child: Container(
              constraints: BoxConstraints(
                minHeight: playerMinHeight,
                maxHeight: playerMaxHeight,
              ),
              padding: EdgeInsets.only(
                top: playerMargin,
                left: playerMargin.clamp(0, 10),
                right: playerMargin.clamp(0, 10),
              ),
              width: playerWidth,
              height: playerHeight,
              child: playerView,
            ),
          );
        },
      );
    }

    final mainPlayer = createPlayerView(interactivePlayerView);

    final infoScrollview = Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: _onScrollDetailsScrollNotification,
          child: VideoDetailsSection(
            physics: _detailsScrollPhysics,
            controller: _detailsScrollController,
          ),
        ),
        AnimatedBuilder(
          animation: _playlistOffsetAnimation,
          builder: (BuildContext context, Widget? child) {
            return FractionalTranslation(
              translation: _playlistOffsetAnimation.value,
              child: child,
            );
          },
          child: const VideoPlaylistSection(),
        ),
      ],
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _handleBackButtonPressed,
      child: NotificationListener<VideoScreenNotification>(
        onNotification: _handleScreenNotification,
        child: Material(
          color: Colors.transparent,
          type: MaterialType.transparency,
          child: SlideTransition(
            position: _playerSlideAnimation,
            child: FadeTransition(
              opacity: _playerFadeAnimation,
              child: ListenableBuilder(
                listenable: Listenable.merge(
                  [
                    if (context.orientation.isLandscape) _screenWidthNotifier,
                    _screenHeightNotifier,
                  ],
                ),
                builder: (
                  BuildContext context,
                  Widget? screenWidget,
                ) {
                  return SizedBox(
                    width: context.orientation.isLandscape
                        ? screenWidth * _screenWidthNotifier.value
                        : null,
                    height: screenHeight * _screenHeightNotifier.value,
                    child: screenWidget,
                  );
                },
                child: Flex(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: layoutDirection,
                  children: [
                    Expanded(
                      flex: orientation.isPortrait ? 0 : 1,
                      child: FadeTransition(
                        opacity: _playerOpacityAnimation,
                        child: PlayerAnnotationsWrapper(
                          child: GestureDetector(
                            onTap: _onTapPlayer,
                            onVerticalDragStart: _onDragStartPlayer,
                            onVerticalDragUpdate: _onDragUpdatePlayer,
                            onVerticalDragEnd: _onDragEndPlayer,
                            behavior: HitTestBehavior.opaque,
                            child: Material(
                              child: Stack(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      mainPlayer,
                                      Expanded(child: miniPlayer),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: miniPlayerProgress,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (orientation.isPortrait)
                      Flexible(
                        child: Material(
                          child: Listener(
                            onPointerDown: _onPointerDownOn,
                            onPointerMove: _onPointerMove,
                            onPointerUp: _onPointerUp,
                            child: AnimatedBuilder(
                              animation: _detailsOpacityAnimation,
                              builder: (
                                BuildContext context,
                                Widget? childWidget,
                              ) {
                                return Opacity(
                                  opacity: _detailsOpacityAnimation.value,
                                  child: childWidget,
                                );
                              },
                              child: infoScrollview,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
