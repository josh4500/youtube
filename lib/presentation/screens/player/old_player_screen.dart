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
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core/utils/normalization.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/view_models/progress.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../constants.dart';
import '../../providers.dart';
import 'providers/player_view_state_provider.dart';
import 'widgets/controls/player_ambient.dart';
import 'widgets/controls/player_notifications.dart';
import 'widgets/player/mini_player.dart';
import 'widgets/player/player_components_wrapper.dart';
import 'widgets/player/player_view.dart';
import 'widgets/video_actions.dart';
import 'widgets/video_channel_section.dart';
import 'widgets/video_chapters_sheet.dart';
import 'widgets/video_comment_section.dart';
import 'widgets/video_comment_sheet.dart';
import 'widgets/video_context.dart';
import 'widgets/video_description_section.dart';
import 'widgets/video_description_sheet.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key, required this.height});
  final double height;

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen>
    with TickerProviderStateMixin {
  final GlobalKey _interactivePlayerKey = GlobalKey();
  final GlobalKey _portraitPlayerKey = GlobalKey();

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

  late final AnimationController _infoOpacityController;
  late final Animation<double> _infoOpacityAnimation;

  late final AnimationController _draggableOpacityController;
  late final Animation<double> _draggableOpacityAnimation;

  late final AnimationController _additionalHeightController;
  late final ValueNotifier<double> _additionalHeightNotifier;

  late final ValueNotifier<double> _marginNotifier;

  late final AnimationController _heightController;
  late final ValueNotifier<double> _heightNotifier;

  late final AnimationController _widthController;
  late final ValueNotifier<double> _widthNotifier;

  late final Animation<double> sizeAnimation;

  bool _controlWasTempHidden = false;

  double get screenWidth => MediaQuery.sizeOf(context).width;
  double get screenHeight => widget.height;

  double get heightRatio {
    return kAvgVideoViewPortHeight;
  }

  double get videoViewHeight {
    // TODO(Josh): Determine value from Video Size either avg or max height
    return kAvgVideoViewPortHeight;
  }

  // TODO(Josh): Compute bool value
  bool get _isResizableExpandingMode => false;

  double get maxVerticalMargin {
    return screenHeight * (1 - heightRatio);
  }

  double get maxAdditionalHeight {
    return screenHeight * (1 - heightRatio);
  }

  double get midAdditionalHeight {
    return screenHeight * (1 - heightRatio) / 2;
  }

  double get additionalHeight => _additionalHeightNotifier.value;

  /// PlayerSignal StreamSubscription
  StreamSubscription<PlayerSignal>? _subscription;

  /// Whether video was temporary paused
  bool _wasTempPaused = false;

  /// [MiniPlayer] PlaybackProgress indicator opacity value
  double get miniPlayerOpacity => const Interval(
        kMinVideoViewPortWidth,
        1,
        curve: Curves.easeInCubic,
      ).transform(_widthNotifier.value).invertByOne;

  // Video Comment Sheet
  bool _commentIsOpened = false;
  final _showCommentDraggable = ValueNotifier<bool>(false);
  final _replyIsOpenedNotifier = ValueNotifier<bool>(false);
  final _commentDraggableController = DraggableScrollableController();

  // Video Description Sheet
  bool _descIsOpened = false;
  final _showDescDraggable = ValueNotifier<bool>(false);
  final _transcriptNotifier = ValueNotifier<bool>(false);
  final _descDraggableController = DraggableScrollableController();

  // Video Chapter Sheet
  bool _chaptersIsOpened = false;
  final _showChaptersDraggable = ValueNotifier<bool>(false);
  final _chaptersDraggableController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();

    _widthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
    );
    _heightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
    );

    _additionalHeightController = AnimationController(
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

    _draggableOpacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _draggableOpacityAnimation = CurvedAnimation(
      parent: ReverseAnimation(_draggableOpacityController),
      curve: Curves.easeIn,
    );

    _additionalHeightNotifier = ValueNotifier<double>(
      clampDouble(
        (screenHeight * (1 - kAvgVideoViewPortHeight)) -
            (screenHeight * (1 - videoViewHeight)),
        0,
        maxAdditionalHeight,
      ),
    );

    // Added a callback to animate info opacity when additional heights changes
    // (i.e when player going in or out of expanded mode)
    // Opacity of info does not need to be updated when either bottom sheets are open
    // (i.e Comment or Description Sheet)
    _additionalHeightNotifier.addListener(() {
      double opacityValue;
      if (_isResizableExpandingMode) {
        opacityValue =
            additionalHeight / (screenHeight - (heightRatio * screenHeight));
        _draggableOpacityController.value = opacityValue;
      } else {
        opacityValue = additionalHeight / maxAdditionalHeight;
        _draggableOpacityController.value = opacityValue;
      }
      if (!_commentIsOpened && !_descIsOpened && !_chaptersIsOpened) {
        _infoOpacityController.value = opacityValue;
      }
    });

    _marginNotifier = ValueNotifier<double>(0);
    _widthNotifier = ValueNotifier<double>(kMinVideoViewPortWidth);
    _heightNotifier = ValueNotifier<double>(kMinPlayerHeight);

    _animateWidth(1);
    _animateHeight(1);

    sizeAnimation = CurvedAnimation(
      parent: Animation<double>.fromValueListenable(
        _heightNotifier,
        transformer: (v) => v.clamp(0.5, 1),
      ),
      curve: const Interval(kMinPlayerHeight, 1),
    );

    if (additionalHeight > 0) {
      _infoScrollPhysics.canScroll(false);
    }

    _heightNotifier.addListener(() {
      _showHideNavigationBar(_heightNotifier.value);
      _recomputeDraggableOpacityAndHeight(_heightNotifier.value);
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
      if (size == 0 && _heightNotifier.value != kMinPlayerHeight) {
        _descIsOpened = false;
      }
      _changeInfoOpacityOnDraggable(size);
      _checkDraggableSizeToPause(size);
    });

    _commentDraggableController.addListener(() {
      final double size = _commentDraggableController.size;
      if (size == 0 && _heightNotifier.value != kMinPlayerHeight) {
        _commentIsOpened = false;
      }
      _changeInfoOpacityOnDraggable(size);
      _checkDraggableSizeToPause(size);
    });

    _chaptersDraggableController.addListener(() {
      final double size = _chaptersDraggableController.size;
      if (size == 0 && _heightNotifier.value != kMinPlayerHeight) {
        _chaptersIsOpened = false;
      }
      _changeInfoOpacityOnDraggable(size);
      _checkDraggableSizeToPause(size);
    });

    Future<void>(() async {
      // Initial changes
      _showHideNavigationBar(_heightNotifier.value);

      final PlayerRepository playerRepo = ref.read(playerRepositoryProvider);

      playerRepo.openVideo(); // Opens and play video

      // Listens to PlayerSignal events related to description and comments
      // Events are usually sent from PlayerLandscapeScreen
      _subscription =
          playerRepo.playerSignalStream.listen((PlayerSignal signal) {
        if (signal == PlayerSignal.openDescription) {
          _openDescSheet(); // Opens description sheet in this screen
        } else if (signal == PlayerSignal.closeDescription) {
          _closeDescSheet(); // Closes description sheet in this screen
        } else if (signal == PlayerSignal.openComments) {
          _openCommentSheet(); // Opens comment sheet in this screen
        } else if (signal == PlayerSignal.closeComments) {
          _closeCommentSheet(); // Closes comment sheet in this screen
        } else if (signal == PlayerSignal.openChapters) {
          _openChaptersSheet(); // Opens chapters sheet in this screen
        } else if (signal == PlayerSignal.closeChapters) {
          _closeChaptersSheet(); // Closes chapters sheet in this screen
        } else if (signal == PlayerSignal.enterExpanded) {
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.immersive,
            overlays: <SystemUiOverlay>[],
          );
        } else if (signal == PlayerSignal.exitExpanded) {
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: SystemUiOverlay.values,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _draggableOpacityController.dispose();
    _zoomPanAnimationController.dispose();
    _transformationController.dispose();
    _commentDraggableController.dispose();
    _descDraggableController.dispose();
    _showCommentDraggable.dispose();
    _showDescDraggable.dispose();
    _replyIsOpenedNotifier.dispose();
    _transcriptNotifier.dispose();
    _infoScrollController.dispose();
    _infoOpacityController.dispose();
    super.dispose();
  }

  /// Indicates whether the player is expanded or not.
  bool get _expanded {
    return ref.read(playerRepositoryProvider).playerViewState.isExpanded;
  }

  /// Indicates whether the player is minimized or not.
  bool get _isMinimized {
    return ref.read(playerRepositoryProvider).playerViewState.isMinimized;
  }

  /// Indicates whether active zoom panning is in progress.
  bool _activeZoomPanning = false;

  /// Indicates whether player can be dismissed/closed by swiping down
  bool _preventPlayerDismiss = true;

  /// Indicates whether player dismissing
  bool _isDismissing = false;

  /// Indicates whether pointer has been released since resizing player screen
  bool _releasedPlayerPointer = true;

  /// Indicates the direction of player dragging. True if dragging down, otherwise null.
  bool? _isPlayerDraggingDown;

  /// Prevents player from being dragged up when set to true.
  bool _preventPlayerDragUp = false;

  /// Prevents player from being dragged down when set to true.
  bool _preventPlayerDragDown = false;

  /// Prevents player margin changes
  bool _preventPlayerMarginUpdate = false;

  bool _isSeeking = false;

  /// Allows or disallows dragging for info. Set to true by default.
  bool _allowInfoDrag = true;

  Future<void> _animateHeight(double to) async {
    await _tweenAnimateNotifier(
      notifier: _heightNotifier,
      controller: _heightController,
      value: to,
    );
  }

  Future<void> _animateWidth(double to) async {
    await _tweenAnimateNotifier(
      notifier: _widthNotifier,
      controller: _widthController,
      value: to,
    );
  }

  Future<void> _animateAdditionalHeight(double to) async {
    await _tweenAnimateNotifier(
      notifier: _additionalHeightNotifier,
      controller: _additionalHeightController,
      value: to,
    );
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
  void _changeInfoOpacityOnDraggable(double size) {
    if (_heightNotifier.value == 1) {
      _infoOpacityController.value =
          clampDouble(size / (1 - heightRatio), 0, 1);
    }
  }

  /// Callback to show or hide home screen navigation bar
  void _showHideNavigationBar(double value) {
    ref.read(homeRepositoryProvider).updateNavBarPosition(
          value.normalize(kMinPlayerHeight, 1).invertByOne,
        );
  }

  /// Callback to change Draggable heights when the Player height changes (via [_heightNotifier])
  void _recomputeDraggableOpacityAndHeight(double value) {
    final double newSizeValue = clampDouble(
      (value - kMinPlayerHeight) - (value * 0.135),
      0,
      1 - heightRatio,
    );

    /***************************** Opacity Changes *****************************/
    final double opacityValue = 1 - (_heightNotifier.value - 0.45) / (1 - 0.45);
    // Changes info opacity when neither of the draggable sheet are opened
    if (!_commentIsOpened && !_descIsOpened && !_chaptersIsOpened) {
      _infoOpacityController.value = (opacityValue - .225).clamp(0, 1);
    } else {
      // Changes the opacity level of all draggable sheets
      _draggableOpacityController.value = opacityValue;
    }

    /***************************** Height Changes *****************************/
    // Changes Comment Draggable height
    if (_commentIsOpened) {
      if (_heightNotifier.value == kMinPlayerHeight) {
        _commentDraggableController.jumpTo(0);
      } else {
        _commentDraggableController.jumpTo(newSizeValue);
      }
    }

    // Changes Description Draggable height
    if (_descIsOpened) {
      if (_heightNotifier.value == kMinPlayerHeight) {
        _descDraggableController.jumpTo(0);
      } else {
        _descDraggableController.jumpTo(newSizeValue);
      }
    }

    // Changes Chapters Draggable height
    if (_chaptersIsOpened) {
      if (_heightNotifier.value == kMinPlayerHeight) {
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
      scaleFactor = clampDouble(
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

  /// Opens the player in fullscreen mode by sending a player signal to the repository.
  Future<void> _openFullscreenPlayer() async {
    _hideControls();
    await context.goto(AppRoutes.playerLandscapeScreen);
    if (!ref.read(playerViewStateProvider).isMinimized) {
      _showControls(true);
    }
  }

  /// Hides the player controls and save state whether control will be temporary
  /// hidden.
  void _hideControls([bool force = false]) {
    final bool hide =
        ref.read(playerRepositoryProvider).playerViewState.showControls;
    if (hide || force) {
      _controlWasTempHidden = true && !force;
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal(<PlayerSignal>[PlayerSignal.hideControls]);
    }
  }

  void _showControls([bool force = false]) {
    if (_controlWasTempHidden || force) {
      _controlWasTempHidden = false;
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal(<PlayerSignal>[PlayerSignal.showControls]);
    }
  }

  /// Toggles the visibility of player controls based on the current state.
  void _toggleControls() {
    // Check if player controls are currently visible
    if (ref.read(playerRepositoryProvider).playerViewState.showControls) {
      // If visible, send a signal to hide controls
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal(<PlayerSignal>[PlayerSignal.hideControls]);
    } else {
      // If not visible, send a signal to show controls
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal(<PlayerSignal>[PlayerSignal.showControls]);
    }
  }

  /// Handles tap events on the player.
  Future<void> _onTapPlayer() async {
    // If the player is fully expanded, show controls
    if (_heightNotifier.value == 1) {
      _toggleControls();
    }

    // Maximizes player
    if (_widthNotifier.value != 1 && _heightNotifier.value != 1) {
      _isSeeking = false;
      _preventPlayerDragDown = false;
      _preventPlayerDragUp = false;

      // Set height and width to maximum
      Future.wait([
        _animateHeight(1),
        _animateWidth(1),
      ]).then((value) {
        _showControls(ref.read(playerNotifierProvider).ended);

        ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
          PlayerSignal.maximize,
          PlayerSignal.showPlaybackProgress,
        ]);
      });
    }

    // Adjust additional height if within limits
    if (additionalHeight < midAdditionalHeight) {
      // Check if video view height is not equal to height ratio
      if (videoViewHeight != heightRatio) {
        // If comments are opened, animate to the appropriate position
        if (_commentIsOpened) {
          _commentDraggableController.animateTo(
            ((screenHeight * heightRatio) + additionalHeight) / screenHeight,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeIn,
          );
        }

        // If description is opened, animate to the appropriate position
        if (_descIsOpened) {
          _descDraggableController.animateTo(
            ((screenHeight * heightRatio) + additionalHeight) / screenHeight,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeIn,
          );
        }

        if (_chaptersIsOpened) {
          _chaptersDraggableController.animateTo(
            ((screenHeight * heightRatio) + additionalHeight) / screenHeight,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeIn,
          );
        }

        // Set additional height to its maximum value
        _animateAdditionalHeight(maxAdditionalHeight);
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
      if (_marginNotifier.value > 0) {
        // Prevent player from being dragged up beyond the top
        _preventPlayerDragUp = true;

        // Adjust player view margin within valid limits
        _marginNotifier.value = clampDouble(
          _marginNotifier.value + details.delta.dy,
          0,
          maxVerticalMargin,
        );
      } else if (!_preventPlayerDragUp) {
        // If not preventing drag up, adjust _additionalHeightNotifier
        _additionalHeightNotifier.value = clampDouble(
          _additionalHeightNotifier.value + details.delta.dy,
          0,
          maxVerticalMargin,
        );
      }
    } else {
      // If dragging down
      if (!_preventPlayerDragDown) {
        if (additionalHeight >= screenHeight * (1 - heightRatio)) {
          if (!_preventPlayerMarginUpdate) {
            // Adjust player view margin within valid limits
            _marginNotifier.value = clampDouble(
              _marginNotifier.value + details.delta.dy,
              0,
              maxVerticalMargin,
            );
          }
        } else {
          _preventPlayerMarginUpdate = true;
          _additionalHeightNotifier.value = clampDouble(
            _additionalHeightNotifier.value + details.delta.dy,
            0,
            screenHeight * (1 - heightRatio),
          );
        }
      } else {
        // If preventing drag down, adjust _additionalHeightNotifier
        _additionalHeightNotifier.value = clampDouble(
          _additionalHeightNotifier.value + details.delta.dy,
          0,
          screenHeight * (1 - heightRatio),
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
      if (details.delta.dy > 0 && _heightNotifier.value == kMinPlayerHeight) {
        // Ensures that the first drag down by the from [minVideoViewPortHeight]
        // will be dismissing player if user pointer was recently released
        _isDismissing = true && _releasedPlayerPointer;
      }

      if (_isDismissing) {
        final val = details.delta.dy * 1.3 / (kMinPlayerHeight * screenHeight);
        _playerDismissController.value += val;
        return;
      }
    }
    // Player has not released pointer
    _releasedPlayerPointer = false;

    // If dragging down
    if (_isPlayerDraggingDown ?? false) {
      // Adjust height and width based on the drag delta
      _heightNotifier.value = clampDouble(
        _heightNotifier.value - (details.delta.dy / screenHeight),
        kMinPlayerHeight,
        1,
      );

      _widthNotifier.value = clampDouble(
        _heightNotifier.value / heightRatio,
        kMinVideoViewPortWidth,
        1,
      );
    } else {
      // Hide controls before showing zoom pan
      _hideControls();
      // Start zoom panning on swipe up
      _swipeZoomPan(-(details.delta.dy / (screenHeight * heightRatio)));
    }

    // Hide controls when the height falls below a certain threshold
    if (_heightNotifier.value < 1) {
      _hideControls();

      ref.read(playerRepositoryProvider).sendPlayerSignal(
        <PlayerSignal>[PlayerSignal.hidePlaybackProgress],
      );
    }
  }

  void _onDragEndExpandedPlayer(DragEndDetails details) {
    if (additionalHeight > midAdditionalHeight) {
      ref.read(playerRepositoryProvider).sendPlayerSignal(
        <PlayerSignal>[PlayerSignal.enterExpanded],
      );
      _animateAdditionalHeight(maxAdditionalHeight);
    } else {
      ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
        PlayerSignal.exitExpanded,
        PlayerSignal.showPlaybackProgress,
      ]);

      if (_isResizableExpandingMode) {
        _animateAdditionalHeight(midAdditionalHeight);
      } else {
        _animateAdditionalHeight(0);
      }
    }

    if (_marginNotifier.value > maxAdditionalHeight / 4) {
      ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
        PlayerSignal.exitExpanded,
        PlayerSignal.showPlaybackProgress,
      ]);

      if (_isResizableExpandingMode) {
        _animateAdditionalHeight(midAdditionalHeight);
      } else {
        _animateAdditionalHeight(0);
      }
    }

    _marginNotifier.value = 0;
    _infoScrollPhysics.canScroll(true);
  }

  Future<void> _onDragEndNotExpandedPlayer(DragEndDetails details) async {
    // Set to false because the user pointer events will no longer be updated
    _isDismissing = false;

    if (_isPlayerDraggingDown ?? false) {
      final double latestHeightVal = _heightNotifier.value;
      final double velocityY = details.velocity.pixelsPerSecond.dy;

      if (latestHeightVal >= 0.5) {
        await Future.wait([
          _animateHeight(velocityY >= 200 ? kMinPlayerHeight : 1),
          _animateWidth(velocityY >= 200 ? kMinVideoViewPortWidth : 1),
        ]);
      } else {
        await Future.wait([
          _animateHeight(velocityY <= -150 ? 1 : kMinPlayerHeight),
          _animateWidth(velocityY <= -150 ? 1 : kMinVideoViewPortWidth),
        ]);
      }
    }

    if (_heightNotifier.value > kMinPlayerHeight) {
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

    if (_widthNotifier.value == kMinVideoViewPortWidth) {
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
        _openFullscreenPlayer();
      }
    }
  }

  /// Handles drag updates for the player, determining the drag behavior based on its state.
  void _onDragPlayer(DragUpdateDetails details) {
    // If active zoom panning is in progress, update zoom panning and return
    if (_activeZoomPanning) {
      // Update zoom panning on swipe up or swipe down
      _swipeZoomPan(-(details.delta.dy / (screenHeight * heightRatio)));
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

    // Determine the drag behavior based on the player's state
    if (_expanded) {
      // If player is expanded, handle drag as per expanded player behavior
      _onDragExpandedPlayer(details);
    } else {
      // If player is not expanded, handle drag as per not expanded player behavior
      _onDragNotExpandedPlayer(details);
    }
  }

  Future<void> _onDragPlayerEnd(DragEndDetails details) async {
    _releasedPlayerPointer = true;
    if (!_isSeeking) {
      _preventPlayerDragUp = false;
      _preventPlayerDragDown = false;
      _preventPlayerMarginUpdate = false;
    }

    if (_expanded) {
      _onDragEndExpandedPlayer(details);
    } else {
      await _onDragEndNotExpandedPlayer(details);
    }

    // Reversing zoom due to swiping up
    final lastScaleValue = _transformationController.value.getMaxScaleOnAxis();
    if (lastScaleValue <= kMinPlayerScale + 0.5 && lastScaleValue > 1.0) {
      if (lastScaleValue == kMinPlayerScale + 0.5) _openFullscreenPlayer();
      await _reverseZoomPan();
    }

    // Shows controls if it was temporary hidden and avoids showing controls
    // when player is minimized
    if (!_isMinimized) {
      _showControls();
    }
  }

  void _onDragInfo(PointerMoveEvent event) {
    if (_infoScrollController.offset == 0 ||
        (videoViewHeight > heightRatio && event.delta.dy < 0)) {
      if (_allowInfoDrag) {
        _infoScrollPhysics.canScroll(false);
        _additionalHeightNotifier.value = clampDouble(
          _additionalHeightNotifier.value + event.delta.dy,
          0,
          screenHeight * (1 - heightRatio),
        );
        if (additionalHeight > 0) {
          // Hides the playback progress while animating "to" expanded view
          ref.read(playerRepositoryProvider).sendPlayerSignal(
            <PlayerSignal>[PlayerSignal.hidePlaybackProgress],
          );

          _hideControls();
        }
      }
    }

    if (event.delta.dy < 0 && _infoScrollController.offset > 0) {
      _allowInfoDrag = false;
    }

    if (_additionalHeightNotifier.value == 0) {
      _infoScrollPhysics.canScroll(true);
    }
  }

  Future<void> _onDragInfoUp(PointerUpEvent event) async {
    if (_allowInfoDrag && additionalHeight > 0) {
      if (additionalHeight > midAdditionalHeight) {
        await _animateAdditionalHeight(maxAdditionalHeight);
        ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
          PlayerSignal.enterExpanded,
        ]);
      } else {
        if (_isResizableExpandingMode &&
            additionalHeight > midAdditionalHeight / 2) {
          await _animateAdditionalHeight(midAdditionalHeight);
        } else {
          await _animateAdditionalHeight(0);
        }

        ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
          PlayerSignal.exitExpanded,
          PlayerSignal.showPlaybackProgress,
        ]);

        _infoScrollPhysics.canScroll(true);
      }
    } else if (_allowInfoDrag && additionalHeight == 0) {
      ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
        PlayerSignal.exitExpanded,
        PlayerSignal.showPlaybackProgress,
      ]);
    }

    if (_infoScrollController.offset == 0) {
      _allowInfoDrag = true;
    }

    _showControls();
  }

  /// Callback to open Comments draggable sheets
  Future<void> _openCommentSheet() async {
    _commentIsOpened = true;
    final bool wait = !_showCommentDraggable.value;
    _showCommentDraggable.value = true;

    if (wait) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }
    if (videoViewHeight != heightRatio && additionalHeight > 0) {
      _animateAdditionalHeight(0);
    }

    _commentDraggableController.animateTo(
      1 - heightRatio,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInCubic,
    );
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
  }

  void _sendCloseCommentSheetSignal() {
    ref.read(playerRepositoryProvider).sendPlayerSignal(
      <PlayerSignal>[PlayerSignal.closeComments],
    );
  }

  Future<void> _openDescSheet() async {
    _descIsOpened = true;
    final bool wait = !_showCommentDraggable.value;
    _showDescDraggable.value = true;

    if (wait) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }
    if (videoViewHeight != heightRatio && additionalHeight > 0) {
      _animateAdditionalHeight(0);
    }
    _descDraggableController.animateTo(
      1 - heightRatio,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInCubic,
    );
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
  }

  void _sendCloseDescSheetSignal() {
    ref.read(playerRepositoryProvider).sendPlayerSignal(
      <PlayerSignal>[PlayerSignal.closeDescription],
    );
  }

  Future<void> _openChaptersSheet() async {
    _chaptersIsOpened = true;
    final bool wait = !_showChaptersDraggable.value;
    _showChaptersDraggable.value = true;

    if (wait) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }

    // Changes the additional heights to zero on Expanded mode
    if (videoViewHeight != heightRatio && additionalHeight > 0) {
      _animateAdditionalHeight(0);
    }

    _chaptersDraggableController.animateTo(
      1 - heightRatio,
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

  void _sendCloseChapterSheetSignal() {
    ref.read(playerRepositoryProvider).sendPlayerSignal(
      <PlayerSignal>[PlayerSignal.closeChapters],
    );
  }

  // TODO(Josh): Will add Membership sheet too

  /// Callback for when scroll notifications are received in info section
  bool _onScrollInfoScrollNotification(ScrollNotification notification) {
    // Prevents info to be dragged down while scrolling in DynamicTab
    if (notification.depth >= 1) {
      if (notification is ScrollStartNotification) {
        _allowInfoDrag = false;

        if (_additionalHeightNotifier.value > 0) {
          _additionalHeightNotifier.value = 0;
          ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
            PlayerSignal.exitExpanded,
            PlayerSignal.showPlaybackProgress,
          ]);
        }
      } else if (notification is ScrollEndNotification) {
        _allowInfoDrag = true;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final interactivePlayerView = PlayerComponentsWrapper(
      key: _interactivePlayerKey,
      handleNotification: (PlayerNotification notification) {
        if (notification is MinimizePlayerNotification) {
          // Note: Do not remove
          // We set to true to emulate player was dragged down to minimize
          _isPlayerDraggingDown = true;
          _preventPlayerDismiss = false;

          _animateHeight(kMinPlayerHeight);
          _animateWidth(kMinVideoViewPortWidth);

          ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
            PlayerSignal.minimize,
            PlayerSignal.hideControls,
            PlayerSignal.hidePlaybackProgress,
          ]);
        } else if (notification is ExpandPlayerNotification) {
          _hideControls();
          _animateAdditionalHeight(screenHeight * (1 - heightRatio));

          ref.read(playerRepositoryProvider).sendPlayerSignal(
            <PlayerSignal>[PlayerSignal.enterExpanded],
          );
        } else if (notification is DeExpandPlayerNotification) {
          _hideControls();

          if (_isResizableExpandingMode) {
            _animateAdditionalHeight(midAdditionalHeight);
          } else {
            _animateAdditionalHeight(0);
          }

          ref.read(playerRepositoryProvider).sendPlayerSignal(<PlayerSignal>[
            PlayerSignal.exitExpanded,
            PlayerSignal.showPlaybackProgress,
          ]);
        } else if (notification is EnterFullscreenPlayerNotification) {
          _openFullscreenPlayer();
        } else if (notification is SettingsPlayerNotification) {
          // TODO(Josh): Open settings
        } else if (notification is SeekStartPlayerNotification) {
          _preventPlayerDragUp = true;
          _preventPlayerDragDown = true;
          _isSeeking = true;
        } else if (notification is SeekEndPlayerNotification) {
          _isSeeking = false;
          _preventPlayerDragUp = false;
          _preventPlayerDragDown = false;
        }
      },
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

    final PlayerRepository playerRepo = ref.read(playerRepositoryProvider);
    final PlaybackProgress miniPlayerProgress = PlaybackProgress(
      progress: playerRepo.videoProgressStream,
      // TODO(Josh): Revisit this code
      start: playerRepo.currentVideoProgress ?? Progress.zero,
      // TODO(Josh): Get ready value
      end: const Duration(minutes: 1),
      showBuffer: false,
      backgroundColor: Colors.transparent,
    );

    final ScrollConfiguration infoScrollview = ScrollConfiguration(
      behavior: const NoOverScrollGlowBehavior(),
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScrollInfoScrollNotification,
        child: CustomScrollView(
          physics: _infoScrollPhysics,
          controller: _infoScrollController,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  const PlayerAmbient(),
                  Column(
                    children: <Widget>[
                      VideoDescriptionSection(onTap: _openDescSheet),
                      const VideoChannelSection(),
                      const VideoContext(),
                      const VideoActions(),
                      VideoCommentSection(onTap: _openCommentSheet),
                      const SizedBox(height: 12),
                    ],
                  ),
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: FadingSliverPersistentHeaderDelegate(
                height: 48,
                child: const Material(
                  child: Column(
                    children: [
                      Spacer(),
                      SizedBox(
                        height: 40,
                        child: DynamicTab(
                          initialIndex: 0,
                          leadingWidth: 8,
                          options: <String>[
                            'All',
                            'Something',
                            'Related',
                            'Recently uploaded',
                            'Watched',
                          ],
                        ),
                      ),
                      Spacer(),
                      Divider(height: 0, thickness: 1),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: ViewableVideoContent()),
            const SliverToBoxAdapter(child: ViewableVideoContent()),
            const SliverToBoxAdapter(child: ViewableVideoContent()),
            const SliverToBoxAdapter(child: ViewableVideoContent()),
            const SliverToBoxAdapter(child: ViewableVideoContent()),
            const SliverToBoxAdapter(child: ViewableVideoContent()),
          ],
        ),
      ),
    );

    return ValueListenableBuilder<double>(
      valueListenable: _heightNotifier,
      builder: (
        BuildContext context,
        double heightValue,
        Widget? childWidget,
      ) {
        return SlideTransition(
          position: _playerSlideAnimation,
          child: FadeTransition(
            opacity: _playerFadeAnimation,
            child: SizedBox(
              key: _portraitPlayerKey,
              height: screenHeight * heightValue,
              width: double.infinity,
              child: childWidget,
            ),
          ),
        );
      },
      child: Material(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ValueListenableBuilder<double>(
                  valueListenable: _heightNotifier,
                  builder: (
                    BuildContext context,
                    double heightValue,
                    Widget? miniPlayer,
                  ) {
                    return ValueListenableBuilder<double>(
                      valueListenable: _additionalHeightNotifier,
                      builder: (
                        BuildContext context,
                        double addHeightValue,
                        Widget? childWidget,
                      ) {
                        return SizedBox(
                          height: heightValue < 1
                              ? null
                              : (screenHeight * heightRatio) + addHeightValue,
                          child: GestureDetector(
                            onTap: _onTapPlayer,
                            onVerticalDragUpdate: _onDragPlayer,
                            onVerticalDragEnd: _onDragPlayerEnd,
                            behavior: HitTestBehavior.opaque,
                            child: ValueListenableBuilder<double>(
                              valueListenable: _widthNotifier,
                              builder: (
                                BuildContext context,
                                double widthValue,
                                _,
                              ) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Opacity(
                                        opacity: miniPlayerOpacity,
                                        child: MiniPlayer(
                                          space: screenWidth * widthValue,
                                          height:
                                              screenHeight * kMinPlayerHeight,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: ValueListenableBuilder<double>(
                                        valueListenable: _marginNotifier,
                                        builder: (
                                          BuildContext context,
                                          double marginValue,
                                          _,
                                        ) {
                                          print(heightValue);
                                          return Container(
                                            margin: EdgeInsets.only(
                                              top: marginValue,
                                              left: marginValue.clamp(0, 10),
                                              right: marginValue.clamp(0, 10),
                                            ),
                                            constraints: addHeightValue > 0
                                                ? null
                                                : BoxConstraints(
                                                    maxHeight: screenHeight *
                                                        heightRatio,
                                                    minHeight: screenHeight *
                                                        kMinPlayerHeight,
                                                  ),
                                            height: screenHeight * heightValue,
                                            width: screenWidth * widthValue,
                                            child: interactivePlayerView,
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      width: screenWidth,
                                      child: Visibility(
                                        visible: miniPlayerOpacity > 0,
                                        child: Opacity(
                                          opacity: miniPlayerOpacity,
                                          child: miniPlayerProgress,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                Flexible(
                  child: Listener(
                    onPointerMove: _onDragInfo,
                    onPointerUp: _onDragInfoUp,
                    child: AnimatedBuilder(
                      animation: _infoOpacityAnimation,
                      builder: (BuildContext context, Widget? childWidget) {
                        return Opacity(
                          opacity: _infoOpacityAnimation.value,
                          child: childWidget,
                        );
                      },
                      child: infoScrollview,
                    ),
                  ),
                ),
              ],
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _showCommentDraggable,
              builder: (BuildContext context, bool show, Widget? childWidget) {
                if (!show) {
                  return const SizedBox();
                }
                return DraggableScrollableSheet(
                  snap: true,
                  minChildSize: 0,
                  initialChildSize: 0,
                  snapSizes: const <double>[0.0, (1 - kAvgVideoViewPortHeight)],
                  shouldCloseOnMinExtent: false,
                  controller: _commentDraggableController,
                  snapAnimationDuration: const Duration(milliseconds: 300),
                  builder: (BuildContext context, ScrollController controller) {
                    return AnimatedBuilder(
                      animation: _draggableOpacityAnimation,
                      builder: (_, Widget? childWidget) {
                        return Opacity(
                          opacity: _draggableOpacityAnimation.value,
                          child: childWidget,
                        );
                      },
                      child: VideoCommentsSheet(
                        controller: controller,
                        maxHeight: kAvgVideoViewPortHeight,
                        closeComment: _sendCloseCommentSheetSignal,
                        replyNotifier: _replyIsOpenedNotifier,
                        draggableController: _commentDraggableController,
                      ),
                    );
                  },
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _showDescDraggable,
              builder: (BuildContext context, bool show, Widget? childWidget) {
                if (!show) {
                  return const SizedBox();
                }
                return AnimatedBuilder(
                  animation: _draggableOpacityAnimation,
                  builder: (_, Widget? childWidget) {
                    return Opacity(
                      opacity: _draggableOpacityAnimation.value,
                      child: childWidget,
                    );
                  },
                  child: DraggableScrollableSheet(
                    snap: true,
                    minChildSize: 0,
                    initialChildSize: 0,
                    snapSizes: const <double>[
                      0.0,
                      (1 - kAvgVideoViewPortHeight),
                    ],
                    shouldCloseOnMinExtent: false,
                    controller: _descDraggableController,
                    snapAnimationDuration: const Duration(milliseconds: 300),
                    builder:
                        (BuildContext context, ScrollController controller) {
                      return VideoDescriptionSheet(
                        controller: controller,
                        closeDescription: _sendCloseDescSheetSignal,
                        transcriptNotifier: _transcriptNotifier,
                        draggableController: _descDraggableController,
                      );
                    },
                  ),
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _showChaptersDraggable,
              builder: (BuildContext context, bool show, Widget? childWidget) {
                if (!show) {
                  return const SizedBox();
                }
                return AnimatedBuilder(
                  animation: _draggableOpacityAnimation,
                  builder: (_, Widget? childWidget) {
                    return Opacity(
                      opacity: _draggableOpacityAnimation.value,
                      child: childWidget,
                    );
                  },
                  child: DraggableScrollableSheet(
                    snap: true,
                    minChildSize: 0,
                    initialChildSize: 0,
                    snapSizes: const <double>[
                      0.0,
                      (1 - kAvgVideoViewPortHeight),
                    ],
                    shouldCloseOnMinExtent: false,
                    controller: _chaptersDraggableController,
                    snapAnimationDuration: const Duration(milliseconds: 300),
                    builder: (
                      BuildContext context,
                      ScrollController controller,
                    ) {
                      return VideoChaptersSheet(
                        controller: controller,
                        closeChapter: _sendCloseChapterSheetSignal,
                        draggableController: _chaptersDraggableController,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}