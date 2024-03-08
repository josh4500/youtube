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
import 'package:youtube_clone/core/constants/constants.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/provider/state/player_state_provider.dart';
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/player/player_components_wrapper.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/player/player_notifications.dart';
import 'package:youtube_clone/presentation/widgets.dart';
import 'package:youtube_clone/presentation/widgets/persistent_header_delegate.dart';

import '../../view_models/playback/player_sizing.dart';
import 'widgets/player/mini_player.dart';
import 'widgets/player/player.dart';
import 'widgets/video_actions.dart';
import 'widgets/video_comment_section.dart';
import 'widgets/video_comment_sheet.dart';
import 'widgets/video_context.dart';
import 'widgets/video_description_section.dart';
import 'widgets/video_description_sheet.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final double height;
  const PlayerScreen({super.key, required this.height});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen>
    with TickerProviderStateMixin {
  final GlobalKey _interactivePlayerKey = GlobalKey();
  final GlobalKey _portraitPlayerKey = GlobalKey();

  final _infoScrollController = ScrollController();
  final _infoScrollPhysics = const CustomScrollableScrollPhysics(tag: 'info');

  final _transformationController = TransformationController();
  late final AnimationController _zoomPanAnimationController;

  late final AnimationController _infoOpacityController;
  late final Animation _infoOpacityAnimation;

  late final AnimationController _draggableOpacityController;
  late final Animation _draggableOpacityAnimation;

  late final ValueNotifier<double> additionalHeightNotifier;

  late final ValueNotifier<double> marginNotifier;
  late final ValueNotifier<double> heightNotifier;
  late final ValueNotifier<double> widthNotifier;

  bool _controlWasTempHidden = false;

  double get screenWidth => MediaQuery.sizeOf(context).width;
  double get screenHeight => widget.height;

  double get heightRatio {
    return avgVideoViewPortHeight;
  }

  double get videoViewHeight {
    // TODO: Determine value from Video Size either avg or max height
    return avgVideoViewPortHeight;
  }

  bool get expandedMode => heightRatio != videoViewHeight;

  double get maxAdditionalHeight {
    return (screenHeight * (1 - avgVideoViewPortHeight) / 1.5);
  }

  double get additionalHeight => additionalHeightNotifier.value;

  /// PlayerSignal StreamSubscription
  StreamSubscription<PlayerSignal>? _subscription;

  @override
  void initState() {
    super.initState();
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

    additionalHeightNotifier = ValueNotifier<double>(clampDouble(
      ((screenHeight * (1 - avgVideoViewPortHeight)) -
          (screenHeight * (1 - videoViewHeight))),
      0,
      maxAdditionalHeight,
    ));

    // Added a callback to animate info opacity when additional heights changes
    // (i.e when player going in or out of expanded mode)
    // Opacity of info does not need to be updated when either bottom sheets are open
    // (i.e Comment or Description Sheet)
    additionalHeightNotifier.addListener(() {
      double opacityValue;
      if (expandedMode) {
        opacityValue =
            (additionalHeight / (screenHeight - (heightRatio * screenHeight)));
        _draggableOpacityController.value = opacityValue;
      } else {
        opacityValue = additionalHeight / maxAdditionalHeight;
        _draggableOpacityController.value = opacityValue;
      }
      if (!_commentIsOpened && !_descIsOpened) {
        _infoOpacityController.value = opacityValue;
      }
    });

    marginNotifier = ValueNotifier<double>(0);
    heightNotifier = ValueNotifier<double>(1);
    widthNotifier = ValueNotifier<double>(1);

    if (additionalHeight > 0) {
      _infoScrollPhysics.canScroll(false);
    }

    heightNotifier.addListener(() {
      _recomputeDraggableHeight(heightNotifier.value);
      final opacityValue = (1 - (heightNotifier.value - 0.45) / (1 - 0.45));

      _draggableOpacityController.value = opacityValue;
      if (!_commentIsOpened && !_descIsOpened) {
        _infoOpacityController.value = opacityValue;
      }
    });

    _transformationController.addListener(() {
      final scale = _transformationController.value.getMaxScaleOnAxis();

      if (scale != minPlayerScale) {
        _activeZoomPanning = true;
      } else {
        _activeZoomPanning = false;
      }
    });

    _descDraggableController.addListener(() {
      final size = _descDraggableController.size;
      if (size == 0) _descIsOpened = false;
      _infoOpacityController.value =
          clampDouble(size / (1 - heightRatio), 0, 1);
    });

    _commentDraggableController.addListener(() {
      final size = _commentDraggableController.size;
      if (size == 0) _commentIsOpened = false;
      _infoOpacityController.value =
          clampDouble(size / (1 - heightRatio), 0, 1);
    });

    Future(() async {
      final playerRepo = ref.read(playerRepositoryProvider);

      playerRepo.openVideo(); // Opens and play video

      // Listens to PlayerSignal events related to description and comments
      // Events are usually sent from PlayerLandscapeScreen
      _subscription = playerRepo.playerSignalStream.listen((signal) {
        if (signal == PlayerSignal.openDescription) {
          _openDescSheet(); // Opens description sheet in this screen
        } else if (signal == PlayerSignal.closeDescription) {
          _closeDescSheet(); // Closes description sheet in this screen
        } else if (signal == PlayerSignal.openComments) {
          _openCommentSheet(); // Opens comment sheet in this screen
        } else if (signal == PlayerSignal.closeComments) {
          _closeCommentSheet(); // Closes comment sheet in this screen
        } else if (signal == PlayerSignal.enterExpanded) {
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.immersive,
            overlays: [],
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

  /// Handles zooming and panning based on a swipe gesture.
  ///
  /// Parameters:
  ///   - scaleFactor: The scaling factor to be applied based on the swipe gesture.
  void _swipeZoomPan(double scaleFactor) {
    // Retrieve the last scale value from the transformation controller
    final lastScaleValue = _transformationController.value.getMaxScaleOnAxis();

    // Check if the last scale value is below a certain threshold
    if (lastScaleValue <= minPlayerScale + 0.5) {
      // Ensure a minimum scale to avoid zooming in too much
      scaleFactor = clampDouble(
        lastScaleValue + scaleFactor,
        minPlayerScale,
        minPlayerScale + 0.5,
      );

      // Create a new identity matrix and apply scaling
      final updatedMatrix = Matrix4.identity();
      updatedMatrix.scale(minPlayerScale * scaleFactor);

      // Update the transformation controller with the new matrix
      _transformationController.value = updatedMatrix;
    }
  }

  /// Reverses the zoom and pan effect using an animation.
  Future<void> _reverseZoomPan() async {
    // Create a Matrix4Tween for the animation
    final tween = Matrix4Tween(
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

  // Opens the player in fullscreen mode by sending a player signal to the repository.
  Future<void> _openFullscreenPlayer() async {
    _hideControls();
    await context.goto(AppRoutes.playerLandscapeScreen);
    _showControls(true);
  }

  /// Hides the player controls and save state whether control will be temporary
  /// hidden.
  void _hideControls([bool force = false]) {
    var hide = ref.read(playerRepositoryProvider).playerViewState.showControls;
    if (hide || force) {
      _controlWasTempHidden = true && !force;
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal([PlayerSignal.hideControls]);
    }
  }

  void _showControls([bool force = false]) {
    if (_controlWasTempHidden || force) {
      _controlWasTempHidden = false;
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal([PlayerSignal.showControls]);
    }
  }

  /// Toggles the visibility of player controls based on the current state.
  void _toggleControls() {
    // Check if player controls are currently visible
    if (ref.read(playerRepositoryProvider).playerViewState.showControls) {
      // If visible, send a signal to hide controls
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal([PlayerSignal.hideControls]);
    } else {
      // If not visible, send a signal to show controls
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal([PlayerSignal.showControls]);
    }
  }

  /// Handles tap events on the player.
  Future<void> _onTapPlayer() async {
    // If the player is fully expanded, show controls
    if (heightNotifier.value == 1) {
      _toggleControls();
    }

    // Maximizes player
    if (widthNotifier.value != 1 && heightNotifier.value != 1) {
      ref.read(playerRepositoryProvider).sendPlayerSignal([
        PlayerSignal.maximize,
        PlayerSignal.showPlaybackProgress,
      ]);

      // Set height and width to maximum
      heightNotifier.value = 1;
      widthNotifier.value = 1;

      if (ref.read(playerNotifierProvider).ended) {
        ref.read(playerRepositoryProvider).sendPlayerSignal([
          PlayerSignal.showControls,
          PlayerSignal.hidePlaybackProgress,
        ]);
      }
    }

    // Adjust additional height if within limits
    if (additionalHeight < maxAdditionalHeight) {
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

        // Set additional height to its maximum value
        additionalHeightNotifier.value = maxAdditionalHeight;
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
      if (marginNotifier.value > 0) {
        // Prevent player from being dragged up beyond the top
        _preventPlayerDragUp = true;

        // Adjust player view margin within valid limits
        marginNotifier.value = clampDouble(
          marginNotifier.value + details.delta.dy,
          0,
          (screenHeight - (screenHeight * heightRatio)),
        );
      } else if (!_preventPlayerDragUp) {
        // If not preventing drag up, adjust additionalHeightNotifier
        additionalHeightNotifier.value = clampDouble(
          additionalHeightNotifier.value + details.delta.dy,
          0,
          (screenHeight - (screenHeight * heightRatio)),
        );
      }
    } else {
      // If dragging down
      if (!_preventPlayerDragDown) {
        if (additionalHeight >= screenHeight * (1 - heightRatio)) {
          if (!_preventPlayerMarginUpdate) {
            // Adjust player view margin within valid limits
            marginNotifier.value = clampDouble(
              marginNotifier.value + details.delta.dy,
              0,
              (screenHeight - (screenHeight * heightRatio)),
            );
          }
        } else {
          _preventPlayerMarginUpdate = true;
          additionalHeightNotifier.value = clampDouble(
            additionalHeightNotifier.value + details.delta.dy,
            0,
            screenHeight * (1 - heightRatio),
          );
        }
      } else {
        // If preventing drag down, adjust additionalHeightNotifier
        additionalHeightNotifier.value = clampDouble(
          additionalHeightNotifier.value + details.delta.dy,
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

    // If dragging down
    if (_isPlayerDraggingDown ?? false) {
      // Adjust height and width based on the drag delta
      heightNotifier.value = clampDouble(
        heightNotifier.value - (details.delta.dy / screenHeight),
        minVideoViewPortHeight,
        1,
      );

      widthNotifier.value = clampDouble(
        heightNotifier.value / heightRatio,
        minVideoViewPortWidth,
        1,
      );
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal([PlayerSignal.hidePlaybackProgress]);
    } else {
      // Hide controls before showing zoom pan
      _hideControls();
      // Start zoom panning on swipe up
      _swipeZoomPan(-(details.delta.dy / (screenHeight * heightRatio)));
    }

    // Hide controls when the height falls below a certain threshold
    if (heightNotifier.value < 1) {
      _hideControls();
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
    if (details.delta.dy > 0 && _preventPlayerDragUp) return;
    if (details.delta.dy < 0 && _preventPlayerDragDown) return;

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
    if (!_isSeeking) {
      _preventPlayerDragUp = false;
      _preventPlayerDragDown = false;
      _preventPlayerMarginUpdate = false;
    }

    if (_expanded) {
      if (additionalHeight > maxAdditionalHeight) {
        ref
            .read(playerRepositoryProvider)
            .sendPlayerSignal([PlayerSignal.enterExpanded]);
        additionalHeightNotifier.value =
            screenHeight - (screenHeight * heightRatio);
      } else {
        ref.read(playerRepositoryProvider).sendPlayerSignal([
          PlayerSignal.exitExpanded,
          PlayerSignal.showPlaybackProgress,
        ]);
        if (expandedMode) {
          additionalHeightNotifier.value = maxAdditionalHeight;
        } else {
          additionalHeightNotifier.value = 0;
        }
      }

      if (marginNotifier.value >
          (screenHeight - (screenHeight * heightRatio)) / 4) {
        ref.read(playerRepositoryProvider).sendPlayerSignal([
          PlayerSignal.exitExpanded,
          PlayerSignal.showPlaybackProgress,
        ]);

        if (expandedMode) {
          additionalHeightNotifier.value = maxAdditionalHeight;
        } else {
          additionalHeightNotifier.value = 0;
        }
      }

      marginNotifier.value = 0;
      _infoScrollPhysics.canScroll(true);
    } else {
      if (_isPlayerDraggingDown ?? false) {
        final latestHeightVal = heightNotifier.value;
        final velocityY = details.velocity.pixelsPerSecond.dy;

        if (latestHeightVal >= 0.5) {
          heightNotifier.value = velocityY >= 200 ? minVideoViewPortHeight : 1;
          widthNotifier.value = velocityY >= 200 ? minVideoViewPortWidth : 1;
        } else {
          heightNotifier.value = velocityY <= -150 ? 1 : minVideoViewPortHeight;
          widthNotifier.value = velocityY <= -150 ? 1 : minVideoViewPortWidth;
        }
      }

      if (heightNotifier.value == 1) {
        _isPlayerDraggingDown = null;
      }

      if (widthNotifier.value == minVideoViewPortWidth) {
        ref.read(playerRepositoryProvider).sendPlayerSignal([
          PlayerSignal.minimize,
          PlayerSignal.hidePlaybackProgress,
        ]);
      } else {
        ref.read(playerRepositoryProvider).sendPlayerSignal([
          PlayerSignal.maximize,
          PlayerSignal.showPlaybackProgress,
        ]);
      }

      _infoScrollPhysics.canScroll(true);

      if (_activeZoomPanning) {
        final velocityY = details.velocity.pixelsPerSecond.dy;
        if (velocityY < -200) _openFullscreenPlayer();
      }
    }

    // Reversing zoom due to swiping up
    final lastScaleValue = _transformationController.value.getMaxScaleOnAxis();
    if (lastScaleValue <= minPlayerScale + 0.5 && lastScaleValue > 1.0) {
      if (lastScaleValue == minPlayerScale + 0.5) {
        _openFullscreenPlayer();
      }
      await _reverseZoomPan();
    }

    // Shows controls if it was temporary hidden and avoids showing controls
    // when player is minimized
    if (!_isMinimized) _showControls();
  }

  void _onDragInfo(PointerMoveEvent event) {
    if (_infoScrollController.offset == 0 ||
        (videoViewHeight > heightRatio && event.delta.dy < 0)) {
      if (_allowInfoDrag) {
        _infoScrollPhysics.canScroll(false);
        additionalHeightNotifier.value = clampDouble(
          additionalHeightNotifier.value + event.delta.dy,
          0,
          screenHeight * (1 - heightRatio),
        );
        if (additionalHeight > 0) {
          ref
              .read(playerRepositoryProvider)
              .sendPlayerSignal([PlayerSignal.hidePlaybackProgress]);
        }
      }
    }

    if (_allowInfoDrag && additionalHeight > 0 && !_controlWasTempHidden) {
      _hideControls();
    }

    if (event.delta.dy < 0 && _infoScrollController.offset > 0) {
      _allowInfoDrag = false;
    }

    if (additionalHeightNotifier.value == 0) {
      _infoScrollPhysics.canScroll(true);
    }
  }

  // TODO: Fix issue where just a tap triggers _onDragInfoUp
  void _onDragInfoUp(PointerUpEvent event) {
    if (additionalHeight > 0 && _allowInfoDrag) {
      if (additionalHeight > maxAdditionalHeight) {
        ref.read(playerRepositoryProvider).sendPlayerSignal([
          PlayerSignal.enterExpanded,
        ]);
        additionalHeightNotifier.value =
            screenHeight - (screenHeight * heightRatio);
      } else {
        if (!expandedMode) {
          additionalHeightNotifier.value = 0;

          ref.read(playerRepositoryProvider).sendPlayerSignal([
            PlayerSignal.exitExpanded,
            PlayerSignal.showPlaybackProgress,
          ]);
          _infoScrollPhysics.canScroll(true);
        }
      }
    }

    if (_infoScrollController.offset == 0) {
      _allowInfoDrag = true;
    }

    _showControls();
  }

  // Video Comment Sheet
  bool _commentIsOpened = false;
  final _showCommentDraggable = ValueNotifier(false);
  final _commentDraggableController = DraggableScrollableController();
  final _replyIsOpenedNotifier = ValueNotifier<bool>(false);

  void _recomputeDraggableHeight(double value) {
    if (_commentIsOpened) {
      if (heightNotifier.value == minVideoViewPortHeight) {
        _commentDraggableController.jumpTo(0);
      } else {
        _commentDraggableController.jumpTo(
          clampDouble(value - minVideoViewPortHeight, 0, (1 - heightRatio)),
        );
      }
    }
    if (_descIsOpened) {
      if (heightNotifier.value == minVideoViewPortHeight) {
        _descDraggableController.jumpTo(0);
      } else {
        _descDraggableController.jumpTo(
          clampDouble(value - minVideoViewPortHeight, 0, (1 - heightRatio)),
        );
      }
    }
  }

  void _openCommentSheet() async {
    _commentIsOpened = true;
    final wait = !_showCommentDraggable.value;
    _showCommentDraggable.value = true;

    if (wait) await Future.delayed(const Duration(milliseconds: 150));
    if (videoViewHeight != heightRatio && additionalHeight > 0) {
      additionalHeightNotifier.value = 0;
    }

    _commentDraggableController.animateTo(
      (1 - heightRatio),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInCubic,
    );
  }

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

  // Video Description Sheet
  bool _descIsOpened = false;
  final _showDescDraggable = ValueNotifier(false);
  final _descDraggableController = DraggableScrollableController();
  final _transcriptNotifier = ValueNotifier<bool>(false);

  void _openDescSheet() async {
    _descIsOpened = true;
    final wait = !_showCommentDraggable.value;
    _showDescDraggable.value = true;

    if (wait) await Future.delayed(const Duration(milliseconds: 150));
    if (videoViewHeight != heightRatio && additionalHeight > 0) {
      additionalHeightNotifier.value = 0;
    }
    _descDraggableController.animateTo(
      (1 - heightRatio),
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

  // TODO: Rename
  bool _onScrollDynamicTab(ScrollNotification notification) {
    // Prevents info to be dragged down while scrolling in DynamicTab
    if (notification.depth >= 1) {
      if (notification is ScrollStartNotification) {
        _allowInfoDrag = false;
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
      handleNotification: (notification) {
        if (notification is MinimizePlayerNotification) {
          ref.read(playerRepositoryProvider).sendPlayerSignal([
            PlayerSignal.minimize,
            PlayerSignal.hideControls,
            PlayerSignal.hidePlaybackProgress,
          ]);
          heightNotifier.value = minVideoViewPortHeight;
          widthNotifier.value = minVideoViewPortWidth;
        } else if (notification is ExpandPlayerNotification) {
          _hideControls();
          additionalHeightNotifier.value = screenHeight * (1 - heightRatio);
          ref
              .read(playerRepositoryProvider)
              .sendPlayerSignal([PlayerSignal.enterExpanded]);
        } else if (notification is DeExpandPlayerNotification) {
          if (expandedMode) {
            additionalHeightNotifier.value = maxAdditionalHeight;
          } else {
            additionalHeightNotifier.value = 0;
          }
          _hideControls();
          ref
              .read(playerRepositoryProvider)
              .sendPlayerSignal([PlayerSignal.exitExpanded]);
        } else if (notification is EnterFullscreenPlayerNotification) {
          _openFullscreenPlayer();
        } else if (notification is SettingsPlayerNotification) {
          // TODO: Open settings
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
        builder: (context, childWidget) {
          return InteractiveViewer(
            constrained: true,
            minScale: minPlayerScale,
            maxScale: maxPlayerScale,
            alignment: Alignment.center,
            transformationController: _transformationController,
            child: childWidget!,
          );
        },
        child: Hero(
          tag: 'player',
          child: ProviderScope(
            overrides: [
              playerSizingProvider.overrideWithValue(
                PlayerSizing(
                  minHeight: minVideoViewPortHeight,
                  maxHeight: heightRatio,
                ),
              ),
            ],
            child: const KeyedSubtree(
              child: PlayerView(),
            ),
          ),
        ),
      ),
    );

    return ValueListenableBuilder(
      valueListenable: heightNotifier,
      builder: (context, value, childWidget) {
        return SizedBox(
          key: _portraitPlayerKey,
          height: screenHeight * heightNotifier.value,
          width: double.infinity,
          child: childWidget,
        );
      },
      child: Material(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: heightNotifier,
                  builder: (context, heightValue, miniPlayer) {
                    return ValueListenableBuilder(
                      valueListenable: additionalHeightNotifier,
                      builder: (context, addHeightValue, childWidget) {
                        return SizedBox(
                          height: heightNotifier.value < 1
                              ? null
                              : screenHeight * heightRatio + addHeightValue,
                          child: GestureDetector(
                            onTap: _onTapPlayer,
                            onVerticalDragUpdate: _onDragPlayer,
                            onVerticalDragEnd: _onDragPlayerEnd,
                            behavior: HitTestBehavior.opaque,
                            child: ValueListenableBuilder(
                              valueListenable: widthNotifier,
                              builder: (context, widthValue, _) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: MiniPlayer(
                                        opacity: 1,
                                        space: screenWidth * widthValue,
                                        height: screenHeight *
                                            minVideoViewPortHeight,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: ValueListenableBuilder(
                                        valueListenable: marginNotifier,
                                        builder: (context, marginValue, _) {
                                          return Container(
                                            margin: EdgeInsets.only(
                                              top: marginValue,
                                              left: marginValue > 0 ? 10 : 0,
                                              right: marginValue > 0 ? 10 : 0,
                                            ),
                                            constraints: addHeightValue > 0
                                                ? null
                                                : BoxConstraints(
                                                    maxHeight: screenHeight *
                                                        heightRatio,
                                                    minHeight: screenHeight *
                                                        minVideoViewPortHeight,
                                                  ),
                                            height: screenHeight * heightValue,
                                            width: screenWidth * widthValue,
                                            child: interactivePlayerView,
                                          );
                                        },
                                      ),
                                    ),
                                    if (heightValue == minVideoViewPortHeight)
                                      Positioned(
                                        left: 0,
                                        bottom: 0,
                                        width: screenWidth,
                                        child: const PlaybackProgress(
                                          showBuffer: false,
                                          backgroundColor: Colors.transparent,
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
                    child: ScrollConfiguration(
                      behavior: const NoOverScrollGlowBehavior(),
                      child: AnimatedBuilder(
                        animation: _infoOpacityAnimation,
                        builder: (context, childWidget) {
                          return Opacity(
                            opacity: _infoOpacityAnimation.value,
                            child: Material(
                              child: childWidget,
                            ),
                          );
                        },
                        child: NotificationListener<ScrollNotification>(
                          onNotification: _onScrollDynamicTab,
                          child: CustomScrollView(
                            physics: _infoScrollPhysics,
                            controller: _infoScrollController,
                            slivers: [
                              SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    VideoDescriptionSection(
                                      onTap: _openDescSheet,
                                    ),
                                    const VideoContext(),
                                    const VideoActions(),
                                    VideoCommentSection(
                                      onTap: _openCommentSheet,
                                    ),
                                  ],
                                ),
                              ),
                              SliverPersistentHeader(
                                pinned: true,
                                floating: false,
                                delegate: FadingSliverPersistentHeaderDelegate(
                                  height: 40,
                                  child: const Material(
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
                                ),
                              ),
                              const SliverToBoxAdapter(
                                child: ViewableVideoContent(),
                              ),
                              const SliverToBoxAdapter(
                                child: ViewableVideoContent(),
                              ),
                              const SliverToBoxAdapter(
                                child: ViewableVideoContent(),
                              ),
                              const SliverToBoxAdapter(
                                child: ViewableVideoContent(),
                              ),
                              const SliverToBoxAdapter(
                                child: ViewableVideoContent(),
                              ),
                              const SliverToBoxAdapter(
                                child: ViewableVideoContent(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ValueListenableBuilder(
              valueListenable: _showCommentDraggable,
              builder: (context, show, childWidget) {
                if (!show) return const SizedBox();
                return DraggableScrollableSheet(
                  snap: true,
                  minChildSize: 0,
                  maxChildSize: 1,
                  initialChildSize: 0,
                  snapSizes: const [0.0, (1 - avgVideoViewPortHeight)],
                  shouldCloseOnMinExtent: false,
                  controller: _commentDraggableController,
                  snapAnimationDuration: const Duration(milliseconds: 300),
                  builder: (context, controller) {
                    return AnimatedBuilder(
                      animation: _draggableOpacityAnimation,
                      builder: (_, childWidget) {
                        return Opacity(
                          opacity: _draggableOpacityAnimation.value,
                          child: childWidget,
                        );
                      },
                      child: VideoCommentsSheet(
                        controller: controller,
                        maxHeight: avgVideoViewPortHeight,
                        closeComment: _closeCommentSheet,
                        replyNotifier: _replyIsOpenedNotifier,
                        draggableController: _commentDraggableController,
                      ),
                    );
                  },
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: _showDescDraggable,
              builder: (context, show, childWidget) {
                if (!show) return const SizedBox();
                return AnimatedBuilder(
                  animation: _draggableOpacityAnimation,
                  builder: (_, childWidget) {
                    return Opacity(
                      opacity: _draggableOpacityAnimation.value,
                      child: childWidget,
                    );
                  },
                  child: DraggableScrollableSheet(
                    snap: true,
                    minChildSize: 0,
                    maxChildSize: 1,
                    initialChildSize: 0,
                    snapSizes: const [0.0, (1 - avgVideoViewPortHeight)],
                    shouldCloseOnMinExtent: false,
                    controller: _descDraggableController,
                    snapAnimationDuration: const Duration(milliseconds: 300),
                    builder: (context, controller) {
                      return VideoDescriptionSheet(
                        controller: controller,
                        closeDescription: _closeDescSheet,
                        transcriptNotifier: _transcriptNotifier,
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
