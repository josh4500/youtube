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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core/constants/constants.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/provider/state/player_state_provider.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/player_components_wrapper.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/player_notifications.dart';
import 'package:youtube_clone/presentation/widgets.dart';
import 'package:youtube_clone/presentation/widgets/persistent_header_delegate.dart';

import 'widgets/mini_player.dart';
import 'widgets/player.dart';
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
      final opacityValue =
          1 - heightNotifier.value / (1 - minVideoViewPortHeight);

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

    Future(() {
      ref.read(playerRepositoryProvider).openVideo();
    });
  }

  @override
  void dispose() {
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
  bool get _expanded => ref.read(playerNotifierProvider).expanded;

  /// Indicates whether the player is in fullscreen mode or not.
  bool _fullscreen = false;

  /// Indicates whether active zoom panning is in progress.
  bool _activeZoomPanning = false;

  /// Indicates the direction of player dragging. True if dragging down, otherwise null.
  bool? _isPlayerDraggingDown;

  /// Prevents player from being dragged up when set to true.
  bool _preventPlayerDragUp = false;

  /// Prevents player from being dragged down when set to true.
  bool _preventPlayerDragDown = false;

  /// Allows or disallows dragging for info. Set to true by default.
  bool _allowInfoDrag = true;

  void _onTapFullScreen() {
    _fullscreen = !_fullscreen;
    // TODO: Do fullscreen stuff
    // TODO: Also use notifications to listen to controls
  }

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

  void _hideControls() {
    ref.read(playerRepositoryProvider).tapPlayer(PlayerTapActor.none);
  }

  void _toggleControls() {
    ref.read(playerRepositoryProvider).tapPlayer(PlayerTapActor.user);
  }

  /// Handles tap events on the player.
  Future<void> _onTapPlayer() async {
    // If the player is fully expanded, show controls
    if (heightNotifier.value == 1) {
      _toggleControls();
    }

    // Set height and width to maximum
    heightNotifier.value = 1;
    widthNotifier.value = 1;

    if (widthNotifier.value == 1 && heightNotifier.value == 1) {
      ref.read(playerRepositoryProvider).maximize();
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

  void _onDragExpandedPlayer(DragUpdateDetails details) {
    _hideControls();
    if (details.delta.dy < -1) {
      if (marginNotifier.value > 0) {
        _preventPlayerDragUp = true;
        marginNotifier.value = clampDouble(
          marginNotifier.value + details.delta.dy,
          0,
          (screenHeight - (screenHeight * heightRatio)),
        );
      } else if (!_preventPlayerDragUp) {
        _preventPlayerDragDown = true;
        additionalHeightNotifier.value = clampDouble(
          additionalHeightNotifier.value + details.delta.dy,
          maxAdditionalHeight,
          screenHeight * (1 - heightRatio),
        );
      }
    } else {
      if (!_preventPlayerDragDown) {
        marginNotifier.value = clampDouble(
          marginNotifier.value + details.delta.dy,
          0,
          (screenHeight - (screenHeight * heightRatio)),
        );
      } else {
        additionalHeightNotifier.value = clampDouble(
          additionalHeightNotifier.value + details.delta.dy,
          maxAdditionalHeight,
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

  void _onDragPlayer(DragUpdateDetails details) {
    if (!_activeZoomPanning) {
      if (_expanded) {
        _onDragExpandedPlayer(details);
      } else {
        _onDragNotExpandedPlayer(details);
      }
    } else {
      // Update zoom panning on swipe up or swipe down
      _swipeZoomPan(-(details.delta.dy / (screenHeight * heightRatio)));
    }
  }

  Future<void> _onDragPlayerEnd(DragEndDetails details) async {
    _preventPlayerDragUp = false;
    _preventPlayerDragDown = false;

    if (_expanded) {
      if (additionalHeight > maxAdditionalHeight) {
        ref.read(playerRepositoryProvider).expand();
        additionalHeightNotifier.value =
            screenHeight - (screenHeight * heightRatio);
      } else {
        ref.read(playerRepositoryProvider).deExpand();
        if (expandedMode) {
          additionalHeightNotifier.value = maxAdditionalHeight;
        } else {
          additionalHeightNotifier.value = 0;
        }
      }

      if (marginNotifier.value >
          (screenHeight - (screenHeight * heightRatio)) / 4) {
        ref.read(playerRepositoryProvider).deExpand();

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
        ref.read(playerRepositoryProvider).minimize();
      } else {
        ref.read(playerRepositoryProvider).maximize();
      }

      _infoScrollPhysics.canScroll(true);

      final ended = ref.read(playerNotifierProvider).ended;
      if (ended) {
        _toggleControls();
      }
    }

    final hasEnded = ref.read(playerNotifierProvider).ended;
    final isMinimized = ref.read(playerNotifierProvider).minimized;

    // Reversing zoom due to swiping up
    final lastScaleValue = _transformationController.value.getMaxScaleOnAxis();
    if (lastScaleValue <= minPlayerScale + 0.5 && lastScaleValue > 1.0) {
      if (lastScaleValue == minPlayerScale + 0.5) {
        _onTapFullScreen();
        // TODO: Return on fullscreen
        // return;
      }
      await _reverseZoomPan();

      if (hasEnded && !isMinimized) _toggleControls();
    } else {
      _onTapFullScreen();
    }
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
      }
    }

    if (_allowInfoDrag) {
      _hideControls();
    }

    if (event.delta.dy < 0 && _infoScrollController.offset > 0) {
      _allowInfoDrag = false;
    }

    if (additionalHeightNotifier.value == 0) {
      _infoScrollPhysics.canScroll(true);
    }
  }

  void _onDragInfoUp(PointerUpEvent event) {
    if (additionalHeight > 0 && _allowInfoDrag) {
      if (additionalHeight > maxAdditionalHeight) {
        ref.read(playerRepositoryProvider).expand();
        additionalHeightNotifier.value =
            screenHeight - (screenHeight * heightRatio);
      } else {
        if (!expandedMode) {
          additionalHeightNotifier.value = 0;
        }
      }
    }

    if (additionalHeightNotifier.value == 0) {
      ref.read(playerRepositoryProvider).deExpand();
      _infoScrollPhysics.canScroll(true);
    }

    if (_infoScrollController.offset == 0) {
      _allowInfoDrag = true;
    }
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

  @override
  Widget build(BuildContext context) {
    final interactivePlayerView = PlayerComponentsWrapper(
      handleNotification: (notification) {
        if (notification is MinimizePlayerNotification) {
          _hideControls();
          heightNotifier.value = minVideoViewPortHeight;
          widthNotifier.value = minVideoViewPortWidth;
          ref.read(playerRepositoryProvider).minimize();
        } else if (notification is ExpandPlayerNotification) {
          additionalHeightNotifier.value = screenHeight * (1 - heightRatio);
          ref.read(playerRepositoryProvider).tapPlayer(PlayerTapActor.none);
          ref.read(playerRepositoryProvider).expand();
        } else if (notification is DeExpandPlayerNotification) {
          if (expandedMode) {
            additionalHeightNotifier.value = maxAdditionalHeight;
          } else {
            additionalHeightNotifier.value = 0;
          }
          ref.read(playerRepositoryProvider).tapPlayer(PlayerTapActor.none);
          ref.read(playerRepositoryProvider).deExpand();
        } else if (notification is FullscreenPlayerNotification) {
          ref.read(playerRepositoryProvider).toggleFullscreen();
        } else if (notification is SettingsPlayerNotification) {
          // TODO: Open settings
        } else if (notification is SeekStartPlayerNotification) {
          _preventPlayerDragUp = true;
          _preventPlayerDragDown = true;
        } else if (notification is SeekEndPlayerNotification) {
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
        child: const KeyedSubtree(
          child: PlayerView(),
        ),
      ),
    );

    return ValueListenableBuilder(
      valueListenable: heightNotifier,
      builder: (context, value, childWidget) {
        return SizedBox(
          height: screenHeight * heightNotifier.value,
          width: double.infinity,
          child: childWidget,
        );
      },
      child: Material(
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
                            child: childWidget,
                          );
                        },
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
                                  // const VideoContext(),
                                  const VideoActions(),
                                  VideoCommentSection(
                                    onTap: _openCommentSheet,
                                  ),
                                ],
                              ),
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              floating: true,
                              delegate: SlidingHeaderDelegate(
                                minHeight: 0,
                                maxHeight: 40,
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
                        draggableController: _descDraggableController,
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
