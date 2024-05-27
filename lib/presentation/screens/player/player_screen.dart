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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core/utils/normalization.dart';
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/view_models/progress.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/controls/player_notifications.dart';
import 'widgets/player/mini_player.dart';
import 'widgets/player/player_components_wrapper.dart';
import 'widgets/player/player_infographics_wrapper.dart';
import 'widgets/player/player_view.dart';
import 'widgets/player_video_info.dart';
import 'widgets/sheet/player_draggable_sheet.dart';
import 'widgets/sheet/player_settings_sheet.dart';
import 'widgets/sheet/player_side_sheet.dart';
import 'widgets/video_chapters_sheet.dart';
import 'widgets/video_comment_sheet.dart';
import 'widgets/video_description_sheet.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({
    super.key,
    required this.width,
    required this.height,
  });
  final double height;
  final double width;

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey _interactivePlayerKey = GlobalKey();
  final GlobalKey _commentSheetKey = GlobalKey();
  final GlobalKey _descSheetKey = GlobalKey();
  final GlobalKey _chaptersSheetKey = GlobalKey();

  double _slideOffsetYValue = 0;
  late final AnimationController _viewController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  final ScrollController _infoScrollController = ScrollController();
  final CustomScrollableScrollPhysics _infoScrollPhysics =
      const CustomScrollableScrollPhysics(
    parent: AlwaysScrollableScrollPhysics(),
    tag: 'info',
  );

  final TransformationController _transformationController =
      TransformationController();
  late final AnimationController _zoomPanAnimationController;

  late final AnimationController _playerDismissController;
  late final Animation<double> _playerFadeAnimation;
  late final Animation<Offset> _playerSlideAnimation;

  late final AnimationController _playerOpacityController;
  late final Animation<double> _playerOpacityAnimation;

  late final AnimationController _infoOpacityController;
  late final Animation<double> _infoOpacityAnimation;

  late final AnimationController _draggableOpacityController;
  late final Animation<double> _draggableOpacityAnimation;

  late final AnimationController _playerAddedHeightAnimationController;
  late final ValueNotifier<double> _playerAddedHeightNotifier;

  late final ValueNotifier<double> _playerMarginNotifier;

  late final AnimationController _screenHeightAnimationController;
  late final ValueNotifier<double> _screenHeightNotifier;
  late final AnimationController _screenWidthAnimationController;
  late final ValueNotifier<double> _screenWidthNotifier;

  late final AnimationController _playerWidthAnimationController;
  late final ValueNotifier<double> _playerWidthNotifier;

  late final ValueNotifier<double> _playerHeightNotifier;

  late final ValueNotifier<bool> _hideGraphicsNotifier;

  // Video Comment Sheet
  bool _commentIsOpened = false;
  late final AnimationController _commentSizeController;
  late final Animation<double> _commentSizeAnimation;
  final _showCommentDraggable = ValueNotifier<bool>(false);
  final _replyIsOpenedNotifier = ValueNotifier<bool>(false);
  final _commentDraggableController = DraggableScrollableController();

  // Video Description Sheet
  bool _descIsOpened = false;
  late final AnimationController _descSizeController;
  late final Animation<double> _descSizeAnimation;
  final _showDescDraggable = ValueNotifier<bool>(false);
  final _transcriptNotifier = ValueNotifier<bool>(false);
  final _descDraggableController = DraggableScrollableController();

  // Video Chapter Sheet
  bool _chaptersIsOpened = false;
  final _showChaptersDraggable = ValueNotifier<bool>(false);
  final _chaptersDraggableController = DraggableScrollableController();

  /// PlayerSignal StreamSubscription
  StreamSubscription<PlayerSignal>? _playerSignalSubscription;

  Timer? _orientationTimer;

  bool _controlWasTempHidden = false;

  double get screenWidth => widget.width;
  double get screenHeight => widget.height;

  double get minPlayerHeightRatio {
    return context.orientation.isPortrait
        ? kMinPlayerHeightPortrait
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
  double get playerMinHeight {
    return screenHeight * minPlayerHeightRatio;
  }

  double get maxInitialDraggableSnapSize => 1 - playerHeightToScreenRatio;

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
  double? get playerHeight {
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

  @override
  void initState() {
    super.initState();
    _viewController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, .05),
    ).animate(_viewController);

    _scaleAnimation = _viewController.drive(
      Tween<double>(begin: 1, end: 0.95),
    );

    _playerWidthAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
    );
    _screenHeightAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
    );
    _screenWidthAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
    );

    _playerAddedHeightAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
    );

    _playerDismissController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
    );

    _playerFadeAnimation = ReverseAnimation(
      CurvedAnimation(
        parent: _playerDismissController,
        curve: Curves.easeInCubic,
      ),
    );

    _playerSlideAnimation = Tween(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(_playerDismissController);

    _zoomPanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _infoOpacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _infoOpacityAnimation = CurvedAnimation(
      parent: ReverseAnimation(_infoOpacityController),
      curve: Curves.easeIn,
    );

    _playerOpacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _playerOpacityAnimation = ReverseAnimation(
      CurvedAnimation(parent: _playerOpacityController, curve: Curves.easeIn),
    );

    _draggableOpacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _draggableOpacityAnimation = CurvedAnimation(
      parent: ReverseAnimation(_draggableOpacityController),
      curve: Curves.easeIn,
    );

    _playerAddedHeightNotifier = ValueNotifier<double>(
      ui.clampDouble(
        (screenHeight * (1 - kAvgVideoViewPortHeight)) -
            (screenHeight * (1 - playerHeightToScreenRatio)),
        minAdditionalHeight,
        maxAdditionalHeight,
      ),
    );

    // Added a callback to animate info opacity when additional heights changes
    // (i.e when player going in or out of expanded mode)
    // Opacity of info does not need to be updated when either bottom sheets are open
    // (i.e Comment or Description Sheet)
    _playerAddedHeightNotifier.addListener(() {
      double opacityValue;
      if (_isResizableExpandingMode) {
        opacityValue = additionalHeight /
            (screenHeight - (playerHeightToScreenRatio * screenHeight));
        _draggableOpacityController.value = opacityValue;
      } else {
        opacityValue = additionalHeight / maxAdditionalHeight;
        _draggableOpacityController.value = opacityValue;
      }
      if (!_commentIsOpened && !_descIsOpened && !_chaptersIsOpened) {
        _infoOpacityController.value = opacityValue;
      }
    });

    _playerMarginNotifier = ValueNotifier<double>(0);

    // TODO(josh4500): Using portrait first may be an issue
    _playerWidthNotifier = ValueNotifier<double>(
      kMinVideoViewPortWidthPortrait,
    );
    _playerHeightNotifier = ValueNotifier<double>(
      kMinVideoViewPortWidthPortrait.normalize(
        kMinVideoViewPortWidthPortrait,
        1,
      ),
    );
    _screenHeightNotifier = ValueNotifier<double>(
      kMinVideoViewPortWidthPortrait,
    );

    _screenWidthNotifier = ValueNotifier<double>(1);
    _hideGraphicsNotifier = ValueNotifier<bool>(true);

    if (additionalHeight > 0) {
      _infoScrollPhysics.canScroll(false);
    }

    _screenHeightNotifier.addListener(() {
      final screenHeight = _screenHeightNotifier.value;

      // TODO(josh4500): Find a way to apply roc
      _playerHeightNotifier.value =
          screenHeight.normalize(minPlayerHeightRatio, 1);

      _showHideNavigationBar(screenHeight);
      _recomputeDraggableOpacityAndHeight(screenHeight);

      // Hide or Show infographics
      _hideGraphicsNotifier.value = screenHeight < 1;
    });

    _transformationController.addListener(() {
      final double scale = _transformationController.value.getMaxScaleOnAxis();

      if (scale != kMinPlayerScale) {
        _activeZoomPanning = true;
      } else {
        _activeZoomPanning = false;
      }
    });

    _descDraggableController.addListener(() {
      final double size = _descDraggableController.size;
      if (size == 0 && _screenHeightNotifier.value != minPlayerHeightRatio) {
        _descIsOpened = false;
      }
      _changePlayerOpacityOnDraggable(size);
      _changeInfoOpacityOnDraggable(size);
      _checkDraggableSizeToPause(size);
    });

    _commentDraggableController.addListener(() {
      final double size = _commentDraggableController.size;
      if (size == 0 && _screenHeightNotifier.value != minPlayerHeightRatio) {
        _commentIsOpened = false;
      }
      _changePlayerOpacityOnDraggable(size);
      _changeInfoOpacityOnDraggable(size);
      _checkDraggableSizeToPause(size);
    });

    _chaptersDraggableController.addListener(() {
      final double size = _chaptersDraggableController.size;
      if (size == 0 && _screenHeightNotifier.value != minPlayerHeightRatio) {
        _chaptersIsOpened = false;
      }
      _changePlayerOpacityOnDraggable(size);
      _changeInfoOpacityOnDraggable(size);
      _checkDraggableSizeToPause(size);
    });

    _descSizeController = AnimationController(
      vsync: this,
      value: 0,
      duration: const Duration(milliseconds: 100),
    );

    _descSizeAnimation = CurvedAnimation(
      parent: _descSizeController,
      curve: Curves.bounceIn,
      reverseCurve: Curves.bounceInOut,
    );

    _commentSizeController = AnimationController(
      vsync: this,
      value: 0,
      duration: const Duration(milliseconds: 100),
    );

    _commentSizeAnimation = CurvedAnimation(
      parent: _commentSizeController,
      curve: Curves.bounceIn,
      reverseCurve: Curves.bounceInOut,
    );

    Future(() {
      // Initial changes
      _showHideNavigationBar(_screenHeightNotifier.value);

      final PlayerRepository playerRepo = ref.read(playerRepositoryProvider);

      // TODO(josh4500): Reconsider to always call this method mount widget
      playerRepo.openVideo(); // Opens and play video
    });

    // NOTE: Do not remove
    WidgetsBinding.instance.addObserver(this);
  }

  ui.FlutterView? _view;
  static const double kOrientationLockBreakpoint = 600;
  static bool localExpanded = false;

  @override
  void didChangeDependencies() {
    _view = View.of(context);

    _animatePlayerWidth(1);
    _animateScreenHeight(1);

    final PlayerRepository playerRepo = ref.read(playerRepositoryProvider);

    // Listens to PlayerSignal events related to description and comments
    // Events are usually sent from PlayerLandscapeScreen
    _playerSignalSubscription ??= playerRepo.playerSignalStream.listen(
      (PlayerSignal signal) {
        if (signal == PlayerSignal.openDescription) {
          _openDescSheet();
        } else if (signal == PlayerSignal.closeDescription) {
          _closeDescSheet();
        } else if (signal == PlayerSignal.openComments) {
          _openCommentSheet();
        } else if (signal == PlayerSignal.closeComments) {
          _closeCommentSheet();
        } else if (signal == PlayerSignal.openChapters) {
          _openChaptersSheet();
        } else if (signal == PlayerSignal.closeChapters) {
          _closeChaptersSheet();
        }
      },
    );
    super.didChangeDependencies();
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
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    // NOTE: Do not remove
    WidgetsBinding.instance.removeObserver(this);

    _orientationTimer?.cancel();
    _viewController.dispose();
    _playerSignalSubscription?.cancel();
    _hideGraphicsNotifier.dispose();
    _playerDismissController.dispose();

    _draggableOpacityController.dispose();
    _zoomPanAnimationController.dispose();
    _transformationController.dispose();

    _descDraggableController.dispose();
    _commentDraggableController.dispose();
    _chaptersDraggableController.dispose();

    _showDescDraggable.dispose();
    _showCommentDraggable.dispose();
    _showChaptersDraggable.dispose();

    _transcriptNotifier.dispose();
    _replyIsOpenedNotifier.dispose();

    _infoScrollController.dispose();
    _infoOpacityController.dispose();

    _playerWidthAnimationController.dispose();
    _screenWidthAnimationController.dispose();
    _screenHeightAnimationController.dispose();
    _playerAddedHeightAnimationController.dispose();

    _playerWidthNotifier.dispose();
    _screenHeightNotifier.dispose();
    _playerMarginNotifier.dispose();
    _playerAddedHeightNotifier.dispose();

    _descSizeController.dispose();
    _commentSizeController.dispose();

    // TODO(josh4500): Might need to reset orientation
    resetOrientation();

    super.dispose();
  }

  Future<void> _animateScreenHeight(double to) async {
    if (_screenHeightNotifier.value != to) {
      await _tweenAnimateNotifier(
        notifier: _screenHeightNotifier,
        controller: _screenHeightAnimationController,
        value: to,
      );
    }
  }

  Future<void> _animateScreenWidth(double to) async {
    if (_screenWidthNotifier.value != to) {
      await _tweenAnimateNotifier(
        notifier: _screenWidthNotifier,
        controller: _screenWidthAnimationController,
        value: to,
      );
    }
  }

  Future<void> _animatePlayerWidth(double to) async {
    if (_playerWidthNotifier.value != to) {
      await _tweenAnimateNotifier(
        notifier: _playerWidthNotifier,
        controller: _playerWidthAnimationController,
        value: to,
      );
    }
  }

  Future<void> _animateAdditionalHeight(double to) async {
    if (_playerAddedHeightNotifier.value != to) {
      await _tweenAnimateNotifier(
        notifier: _playerAddedHeightNotifier,
        controller: _playerAddedHeightAnimationController,
        value: to,
      );
    }
  }

  Future<void> _tweenAnimateNotifier({
    required ValueNotifier<double> notifier,
    required AnimationController controller,
    required double value,
  }) async {
    final Animation<double> tween = Tween<double>(
      begin: notifier.value,
      end: value,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInCubic,
      ),
    );
    tween.addListener(() => notifier.value = tween.value);

    // Reset the animation controller to its initial state
    controller.reset();

    // Start the animation by moving it forward
    await controller.forward();
  }

  /// Callback to pause and play video when draggable sheets change its size
  void _checkDraggableSizeToPause(double size) {
    if (size == 1) {
      if (ref.read(playerNotifierProvider).playing) {
        _wasTempPaused = true;
        ref.read(playerRepositoryProvider).pauseVideo();
      }
    } else if (size <= 1 - kAvgVideoViewPortHeight) {
      if (_wasTempPaused) {
        ref.read(playerRepositoryProvider).playVideo();
      }
    }
  }

  /// Callback to updates the info opacity when draggable sheets changes its size
  void _changePlayerOpacityOnDraggable(double size) {
    _hideControls(true);
    if (size > maxInitialDraggableSnapSize) {
      _playerOpacityController.value = size.normalize(
        maxInitialDraggableSnapSize,
        1,
      );
    }
  }

  /// Callback to updates the info opacity when draggable sheets changes its size
  void _changeInfoOpacityOnDraggable(double size) {
    if (_screenHeightNotifier.value == 1) {
      _infoOpacityController.value =
          ui.clampDouble(size / (1 - playerHeightToScreenRatio), 0, 1);
    }
  }

  /// Callback to show or hide home screen navigation bar
  void _showHideNavigationBar(double value) {
    ref.read(homeRepositoryProvider).updateNavBarPosition(
          value.normalize(minPlayerHeightRatio, 1).invertByOne,
        );
  }

  /// Callback to change Draggable heights when the Player height changes
  /// (via [_screenHeightNotifier])
  void _recomputeDraggableOpacityAndHeight(double value) {
    // TODO(josh4500): Consider _isResizableExpandedMode
    final double newSizeValue = ui.clampDouble(
      (value - minPlayerHeightRatio) - (value * 0.135),
      0,
      1 - playerHeightToScreenRatio,
    );

    //**************************** Opacity Changes ***************************//
    final double opacityValue =
        1 - (_screenHeightNotifier.value - 0.45) / (1 - 0.45);
    if (!_commentIsOpened && !_descIsOpened && !_chaptersIsOpened) {
      // Changes info opacity when neither of the draggable sheet are opened
      _infoOpacityController.value = (opacityValue - .225).clamp(0, 1);
    } else {
      // Changes the opacity level of all draggable sheets
      _draggableOpacityController.value = opacityValue;
    }

    //**************************** Height Changes ****************************//
    // Changes Comment Draggable height
    if (_commentIsOpened) {
      if (_screenHeightNotifier.value == minPlayerHeightRatio) {
        _commentDraggableController.jumpTo(0);
      } else {
        _commentDraggableController.jumpTo(newSizeValue);
      }
    }

    // Changes Description Draggable height
    if (_descIsOpened) {
      if (_screenHeightNotifier.value == minPlayerHeightRatio) {
        _descDraggableController.jumpTo(0);
      } else {
        _descDraggableController.jumpTo(newSizeValue);
      }
    }

    // Changes Chapters Draggable height
    if (_chaptersIsOpened) {
      if (_screenHeightNotifier.value == minPlayerHeightRatio) {
        _descDraggableController.jumpTo(0);
      } else {
        _descDraggableController.jumpTo(newSizeValue);
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

  /// Opens the player in fullscreen mode by sending a player signal to the
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
      // If we change the Orientations to portraitUp this will make it permanent
      // and player will not react when flipped to landscape
      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      );

      _orientationTimer?.cancel();
      _orientationTimer = Timer(const Duration(seconds: 30), () {
        SystemChrome.setPreferredOrientations(
          DeviceOrientation.values,
        );
      });

      return;
    }
    _isForcedFullscreen = false;
    _hideControls();

    _hideGraphicsNotifier.value = true;
    _infoOpacityController.reverse();
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
    }
  }

  /// Shows the player controls if it was temporary hidden.
  ///
  /// Use [force], to show controls regardless
  void _showControls([bool force = false]) {
    if (_controlWasTempHidden || force) {
      _controlWasTempHidden = false;

      if (!_isMinimized && !_preventGestures) {
        ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
          PlayerSignal.showControls,
          if (context.orientation.isPortrait) PlayerSignal.showPlaybackProgress,
        ]);
      }
    } else if (context.orientation.isPortrait) {
      ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
        PlayerSignal.showPlaybackProgress,
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
    if (_preventGestures) {
      ref.read(playerRepositoryProvider).sendPlayerSignal(
        [PlayerSignal.showUnlock],
      );
      return;
    }

    // If the player is fully expanded, show controls
    if (_screenHeightNotifier.value == 1) {
      _toggleControls();
    }

    // Maximizes player
    if (_playerWidthNotifier.value != 1 && _screenHeightNotifier.value != 1) {
      _isSeeking = false;
      _preventPlayerDragDown = false;
      _preventPlayerDragUp = false;

      // Set height and width to maximum
      Future.wait([
        _animateScreenHeight(1),
        _animatePlayerWidth(1),
        if (context.orientation.isLandscape) _animateScreenWidth(1),
      ]).then((value) {
        _showControls(ref.read(playerNotifierProvider).ended);

        ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
          PlayerSignal.maximize,
          PlayerSignal.showPlaybackProgress,
        ]);
      });
    }

    // Adjust additional height if within limits
    if (_isResizableExpandingMode) {
      // TODO(josh4500): Consider _recomputeDraggableOpacityAndHeight method

      // Set additional height to its maximum value
      _animateAdditionalHeight(minAdditionalHeight);

      // If comments are opened, animate to the appropriate position
      if (_commentIsOpened) {
        _commentDraggableController.animateTo(
          ((playerHeight ?? 0) + additionalHeight) / screenHeight,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeIn,
        );
      }

      // If description is opened, animate to the appropriate position
      if (_descIsOpened) {
        _descDraggableController.animateTo(
          ((playerHeight ?? 0) + additionalHeight) / screenHeight,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeIn,
        );
      }

      if (_chaptersIsOpened) {
        _chaptersDraggableController.animateTo(
          ((playerHeight ?? 0) + additionalHeight) / screenHeight,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeIn,
        );
      }
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
        // Hide controls before showing zoom pan
        _hideControls();
        // Start zoom panning on swipe up
        _swipeZoomPan(
          -(details.delta.dy / (screenHeight * playerHeightToScreenRatio)),
        );
      }
    }

    // Hide controls when the height falls below a certain threshold
    if (_screenHeightNotifier.value < 1) {
      _hideControls();
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
    _infoScrollPhysics.canScroll(true);
  }

  Future<void> _onDragEndNotExpandedPlayer(DragEndDetails details) async {
    // Set to false because the user pointer events will no longer be updated
    _isDismissing = false;

    if (_isPlayerDraggingDown ?? false) {
      final double latestHeightVal = _screenHeightNotifier.value;
      final double velocityY = details.velocity.pixelsPerSecond.dy;

      if (latestHeightVal >= 0.5) {
        await Future.wait([
          _animateScreenHeight(velocityY >= 200 ? minPlayerHeightRatio : 1),
          _animatePlayerWidth(
            velocityY >= 200 ? minVideoViewPortWidthRatio : 1,
          ),
        ]);
      } else {
        await Future.wait([
          _animateScreenHeight(velocityY <= -150 ? 1 : minPlayerHeightRatio),
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

    if (_playerWidthNotifier.value == minVideoViewPortWidthRatio) {
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

    _infoScrollPhysics.canScroll(true);

    if (_activeZoomPanning) {
      final double velocityY = details.velocity.pixelsPerSecond.dy;
      if (velocityY < -200) {
        _enterFullscreenMode();
      }
    }
  }

  void _onDragFullscreenPlayer(DragUpdateDetails details) {
    // Check the direction of the drag
    // If dragging down
    _hideControls();

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

    _showControls();
  }

  /// Handles drag updates for the player, determining the drag behavior based on
  /// it state.
  void _onDragPlayer(DragUpdateDetails details) {
    if (_preventGestures) return;

    // If active zoom panning is in progress, update zoom panning and return
    if (_activeZoomPanning) {
      _swipeZoomPan(
        -(details.delta.dy / (screenHeight * playerHeightToScreenRatio)),
      );
      return;
    }

    // Hide controls
    _hideControls();

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

  Future<void> _onDragPlayerEnd(DragEndDetails details) async {
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

    // For fullscreen player
    _onDragFullscreenPlayerEnd(details);

    // Reversing zoom due to swiping up
    final lastScaleValue = _transformationController.value.getMaxScaleOnAxis();
    if (lastScaleValue <= kMinPlayerScale + 0.5 && lastScaleValue > 1.0) {
      if (lastScaleValue == kMinPlayerScale + 0.5) _enterFullscreenMode();
      await _reverseZoomPan();
    }

    // Shows controls if it was temporary hidden and avoids showing controls
    // when player is minimized
    _showControls();
  }

  void _onDragInfo(PointerMoveEvent event) {
    if (_preventGestures) return;

    if (_infoScrollController.offset == 0 ||
        (_isResizableExpandingMode && event.delta.dy < 0)) {
      if (_allowInfoDrag) {
        _infoScrollPhysics.canScroll(false);
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

    if (event.delta.dy < 0 && _infoScrollController.offset > 0) {
      _allowInfoDrag = false;
    }

    if (_playerAddedHeightNotifier.value == 0) {
      _infoScrollPhysics.canScroll(true);
    }
  }

  Future<void> _enterExpandedMode() async {
    localExpanded = true;
    _hideControls();

    ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
      PlayerSignal.enterExpanded,
    ]);
    await _animateAdditionalHeight(maxAdditionalHeight);

    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
      overlays: <SystemUiOverlay>[],
    );

    // NOTE: Second call here is to ensure it reaches [maxAdditionalHeight]
    // Screen takes time to show effects of [SystemUiMode.immersive]
    await Future.delayed(
      const Duration(milliseconds: 200),
      () => _animateAdditionalHeight(maxAdditionalHeight),
    );
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

  Future<void> _onDragInfoUp(PointerUpEvent event) async {
    if (_preventGestures) return;

    if (_allowInfoDrag) {
      if (additionalHeight > maxAdditionalHeight / 2) {
        _enterExpandedMode();
      } else {
        _exitExpandedMode();
        _infoScrollPhysics.canScroll(true);
      }
    }

    if (_infoScrollController.offset == 0) {
      _allowInfoDrag = true;
    }
  }

  /// Callback to open Comments draggable sheets
  Future<void> _openCommentSheet() async {
    _commentIsOpened = true;
    final bool wait = !_showCommentDraggable.value;
    _showCommentDraggable.value = true;

    if (wait) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }

    if (_isResizableExpandingMode && additionalHeight > 0) {
      _animateAdditionalHeight(minAdditionalHeight);
    }

    _commentDraggableController.animateTo(
      1 - playerHeightToScreenRatio,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInCubic,
    );

    _commentSizeController.forward();
  }

  /// Callback to close Comments draggable sheets
  void _closeCommentSheet() {
    if (_replyIsOpenedNotifier.value) {
      _replyIsOpenedNotifier.value = false;
      return;
    }

    _commentIsOpened = false;
    _commentDraggableController.animateTo(
      0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
    );
    _commentSizeController.reverse();
  }

  Future<void> _openDescSheet() async {
    _descIsOpened = true;
    final bool wait = !_showCommentDraggable.value;
    _showDescDraggable.value = true;

    if (wait) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }
    if (_isResizableExpandingMode && additionalHeight > 0) {
      _animateAdditionalHeight(minAdditionalHeight);
    }
    _descDraggableController.animateTo(
      1 - playerHeightToScreenRatio,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInCubic,
    );

    _descSizeController.forward();
  }

  void _closeDescSheet() {
    if (_transcriptNotifier.value) {
      _transcriptNotifier.value = false;
      return;
    }

    _descIsOpened = false;
    _descDraggableController.animateTo(
      0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
    );

    _descSizeController.reverse();
  }

  Future<void> _openChaptersSheet() async {
    _chaptersIsOpened = true;
    final bool wait = !_showChaptersDraggable.value;
    _showChaptersDraggable.value = true;

    if (wait) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }

    // Changes the additional heights to zero on Expanded mode
    if (_isResizableExpandingMode && additionalHeight > 0) {
      _animateAdditionalHeight(minAdditionalHeight);
    }

    _chaptersDraggableController.animateTo(
      1 - playerHeightToScreenRatio,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInCubic,
    );
  }

  void _closeChaptersSheet() {
    _chaptersIsOpened = false;
    _chaptersDraggableController.animateTo(
      0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
    );
  }

  // TODO(Josh): Will add Membership sheet too

  /// Callback for when scroll notifications are received in info section
  bool _onScrollInfoScrollNotification(ScrollNotification notification) {
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

  void handlePlayerControlNotification(PlayerNotification notification) {
    if (notification is MinimizePlayerNotification) {
      // Note: Do not remove
      // We set to true to emulate player was dragged down to minimize
      _isPlayerDraggingDown = true;
      _preventPlayerDismiss = false;

      if (_isExpanded) {
        // Avoids animation by passing false
        _exitExpandedMode(false);
      }

      _hideControls(true);

      Future.wait([
        _animateScreenHeight(minPlayerHeightRatio),
        _animatePlayerWidth(minVideoViewPortWidthRatio),
        if (context.orientation.isLandscape)
          _animateScreenWidth(minScreenWidthRatio),
      ]).then((value) {
        ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
          PlayerSignal.minimize,
          PlayerSignal.hidePlaybackProgress,
        ]);
      });
    } else if (notification is ExpandPlayerNotification) {
      _enterExpandedMode();
    } else if (notification is DeExpandPlayerNotification) {
      _exitExpandedMode();
    } else if (notification is EnterFullscreenPlayerNotification) {
      _enterFullscreenMode();
    } else if (notification is ExitFullscreenPlayerNotification) {
      _exitFullscreenMode();
    } else if (notification is SettingsPlayerNotification) {
      _openSettings();
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

  Future<void> _openSettings() async {
    // TODO(josh4500): Create Model for settings final option
    final selection = await openSettingsSheet(context);
    if (selection == 'Lock screen' && context.mounted) {
      _preventGestures = true;
      ref.read(playerRepositoryProvider).sendPlayerSignal(
        [PlayerSignal.lockScreen],
      );
      await Future.delayed(const Duration(milliseconds: 250));
      await _enterFullscreenMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = context.orientation;
    final Axis layoutDirection =
        orientation.isPortrait ? Axis.vertical : Axis.horizontal;

    final interactivePlayerView = PlayerComponentsWrapper(
      key: _interactivePlayerKey,
      handleNotification: handlePlayerControlNotification,
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
      position: Animation.fromValueListenable(
        _screenWidthNotifier,
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
      child: ListenableBuilder(
        listenable: Listenable.merge([
          if (orientation.isLandscape)
            _screenWidthNotifier
          else
            _playerWidthNotifier,
        ]),
        builder: (
          BuildContext context,
          Widget? _,
        ) {
          return Align(
            alignment: Alignment.topRight,
            child: Opacity(
              opacity: miniPlayerOpacity,
              child: MiniPlayer(
                space: orientation.isLandscape
                    ? screenWidth * minVideoViewPortWidthRatio
                    : playerWidth,
                height: playerMinHeight,
              ),
            ),
          );
        },
      ),
    );

    final mainPlayer = Builder(
      builder: (context) {
        // Landscape player
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
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: interactivePlayerView,
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
                margin: EdgeInsets.only(
                  top: playerMargin,
                  left: playerMargin.clamp(0, 10),
                  right: playerMargin.clamp(0, 10),
                ),
                width: playerWidth,
                height: playerHeight,
                child: interactivePlayerView,
              ),
            );
          },
        );
      },
    );

    final infoScrollview = PlayerVideoInfo(
      physics: _infoScrollPhysics,
      controller: _infoScrollController,
      onScrollNotification: _onScrollInfoScrollNotification,
    );

    return Material(
      color: orientation.isLandscape ? Colors.transparent : null,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          SlideTransition(
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
                    Flexible(
                      flex: orientation.isPortrait ? 0 : 1,
                      fit: orientation.isPortrait
                          ? FlexFit.tight
                          : FlexFit.loose,
                      child: FadeTransition(
                        opacity: _playerOpacityAnimation,
                        child: PlayerInfographicsWrapper(
                          hideGraphicsNotifier: _hideGraphicsNotifier,
                          child: GestureDetector(
                            onTap: _onTapPlayer,
                            onVerticalDragUpdate: _onDragPlayer,
                            onVerticalDragEnd: _onDragPlayerEnd,
                            behavior: HitTestBehavior.opaque,
                            child: Stack(
                              children: [
                                miniPlayer,
                                mainPlayer,
                                Positioned(
                                    bottom: 0, child: miniPlayerProgress),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (orientation.isPortrait)
                      Flexible(
                        child: Listener(
                          onPointerMove: _onDragInfo,
                          onPointerUp: _onDragInfoUp,
                          child: AnimatedBuilder(
                            animation: _infoOpacityAnimation,
                            builder: (
                              BuildContext context,
                              Widget? childWidget,
                            ) {
                              return Opacity(
                                opacity: _infoOpacityAnimation.value,
                                child: childWidget,
                              );
                            },
                            child: infoScrollview,
                          ),
                        ),
                      ),
                    if (orientation.isLandscape) ...[
                      PlayerSideSheet(
                        constraints: BoxConstraints(
                          maxWidth: screenWidth * .4,
                        ),
                        sizeFactor: _descSizeAnimation,
                        visibleListenable: _showDescDraggable,
                        child: VideoDescriptionSheet(
                          key: _descSheetKey,
                          showDragIndicator: false,
                          closeDescription: _closeDescSheet,
                          transcriptNotifier: _transcriptNotifier,
                          draggableController: _descDraggableController,
                        ),
                      ),
                      PlayerSideSheet(
                        constraints: BoxConstraints(
                          maxWidth: screenWidth * .4,
                        ),
                        sizeFactor: _commentSizeAnimation,
                        visibleListenable: _showCommentDraggable,
                        child: VideoCommentsSheet(
                          key: _commentSheetKey,
                          maxHeight: 0,
                          showDragIndicator: false,
                          closeComment: _closeCommentSheet,
                          replyNotifier: _replyIsOpenedNotifier,
                          draggableController: _commentDraggableController,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (orientation.isPortrait) ...[
            PlayerDraggableSheet(
              builder: (BuildContext context, ScrollController controller) {
                return VideoCommentsSheet(
                  key: _commentSheetKey,
                  controller: controller,
                  maxHeight: kAvgVideoViewPortHeight,
                  closeComment: _closeCommentSheet,
                  replyNotifier: _replyIsOpenedNotifier,
                  draggableController: _commentDraggableController,
                );
              },
              opacity: _draggableOpacityAnimation,
              controller: _commentDraggableController,
              visibleListenable: _showCommentDraggable,
              snapSizes: <double>[
                0.0,
                maxInitialDraggableSnapSize,
              ],
            ),
            PlayerDraggableSheet(
              builder: (BuildContext context, ScrollController controller) {
                return VideoDescriptionSheet(
                  key: _descSheetKey,
                  controller: controller,
                  closeDescription: _closeDescSheet,
                  transcriptNotifier: _transcriptNotifier,
                  draggableController: _descDraggableController,
                );
              },
              opacity: _draggableOpacityAnimation,
              controller: _descDraggableController,
              visibleListenable: _showDescDraggable,
              snapSizes: <double>[
                0.0,
                maxInitialDraggableSnapSize,
              ],
            ),
            PlayerDraggableSheet(
              builder: (BuildContext context, ScrollController controller) {
                return VideoChaptersSheet(
                  key: _chaptersSheetKey,
                  controller: controller,
                  closeChapter: _closeChaptersSheet,
                  draggableController: _chaptersDraggableController,
                );
              },
              opacity: _draggableOpacityAnimation,
              controller: _chaptersDraggableController,
              visibleListenable: _showChaptersDraggable,
              snapSizes: <double>[
                0.0,
                maxInitialDraggableSnapSize,
              ],
            ),
          ],
        ],
      ),
    );
  }
}
