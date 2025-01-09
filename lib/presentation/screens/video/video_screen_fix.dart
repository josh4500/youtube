import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core.dart';
import 'package:youtube_clone/core/utils/normalization.dart';
import 'package:youtube_clone/presentation/constants/values.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/screens/homepage.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';
import 'package:youtube_clone/presentation/widgets/home/home_navigation_bar.dart';

import 'player_view_controller.dart';
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
import 'widgets/video_notification.dart';
import 'widgets/video_playlist_section.dart';

const double kOrientationLockBreakpoint = 600;
const double kMaxMargin = 20.0;

enum ExpandedSide { translate, height, extraHeight }

class VideoScreenFix extends ConsumerStatefulWidget {
  const VideoScreenFix({
    super.key,
    required this.width,
    required this.height,
  });

  final double height;
  final double width;

  @override
  ConsumerState<VideoScreenFix> createState() => _VideoScreenFixState();
}

class _VideoScreenFixState extends ConsumerState<VideoScreenFix>
    with
        WidgetsBindingObserver,
        TickerProviderStateMixin,
        TabIndexListenerMixin,
        PageDraggableSizeListenerMixin {
  double get screenWidth => widget.width;
  double get screenHeight => widget.height;

  late final PlayerViewController _viewC = PlayerViewController(
    vsync: this,
    boxProp: PlayerBoxProp.fromScreenSize(
      Size(
        math.min(screenWidth, screenHeight),
        math.max(screenWidth, screenHeight),
      ),
    ),
  );

  late final _playlistOffsetController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  late final _playlistOffsetAnimation = Tween<ui.Offset>(
    begin: const ui.Offset(0, 1),
    end: ui.Offset.zero,
  ).animate(_playlistOffsetController);

  // **************************************************************************
  // ********************** Player Animation Values ***************************
  // **************************************************************************
  final TransformationController _transC = TransformationController();
  late final _playerDismissController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 125),
  );
  late final AnimationNotifier<Matrix4> _zoomNotifier = AnimationNotifier(
    vsync: this,
    duration: Durations.long1,
    value: Matrix4.identity(),
  );

  // **************************************************************************
  // ******************* Player Gesture Related Values ************************
  // **************************************************************************
  bool _activeZoomPanning = false;
  bool _isDismissing = false;
  bool _releasedPointer = true;
  bool _preventDragUp = false;
  bool _preventDragDown = false;
  bool _preventDismiss = true;
  ExpandedSide? _expandedSideFlag;
  bool? _isPlayerDraggingDown;

  // **************************************************************************
  // ******************* Details Gesture Related Values ***********************
  // **************************************************************************
  bool _allowDetailsDrag = true;
  VelocityTracker? _detailsVelocityTracker;
  final ScrollController _detailsScrollController = ScrollController();
  final CustomScrollPhysics _detailsScrollPhysics = CustomScrollPhysics(
    parent: const AlwaysScrollableScrollPhysics(),
  );
  late final AnimationController _detailsOpacityController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  ui.FlutterView? _view;
  final Set<ui.AppLifecycleState> _lastLifecycleStates = {};
  static bool _localIsExpanded = false;
  static bool _localIsFullscreen = false;

  @override
  void initState() {
    super.initState();
    // NOTE: Do not remove
    WidgetsBinding.instance.addObserver(this);

    _transC.addListener(_interactiveZoomListenerCallback);
    _viewC.addListener(_playerViewControllerListenerCallback);
    // TODO: Might want to avoid postframe callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewC.exitMinimizedMode();
    });
  }

  @override
  void dispose() {
    // NOTE: Do not remove
    WidgetsBinding.instance.removeObserver(this);

    _transC.removeListener(_interactiveZoomListenerCallback);
    _viewC.removeListener(_playerViewControllerListenerCallback);

    _viewC.dispose();
    _transC.dispose();
    _detailsScrollController.dispose();
    _playlistOffsetController.dispose();
    _detailsOpacityController.dispose();
    super.dispose();
  }

  @override
  void didChangePageDraggableSize(double size) {
    _detailsOpacityController.value = size.normalize(0, .75);
  }

  @override
  void didTabIndexChanged(int index) {
    if (index == HomeTab.short.index) {
      _viewC.minimizeAndPauseVideo();
      _playerDismissController.forward();
    } else {
      _playerDismissController.reverse();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _view = View.maybeOf(context);
  }

  @override
  void didChangeMetrics() {
    final ui.Display? display = _view?.display;

    if (display == null) {
      return;
    }
    _localIsFullscreen = !(display.size.width / display.devicePixelRatio <
        kOrientationLockBreakpoint);

    if ((display.size.width / display.devicePixelRatio <
            kOrientationLockBreakpoint) &&
        !_localIsExpanded) {
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
      if (_localIsFullscreen) {
        _viewC.exitFullscreenMode();
      }

      _lastLifecycleStates.clear();

      if (_localIsExpanded) {
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.immersiveSticky,
          overlays: <SystemUiOverlay>[],
        );
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  // **************************************************************************
  // ************************ Listener Callbacks ******************************
  // **************************************************************************
  void _interactiveZoomListenerCallback() {
    final double scale = _transC.value.getMaxScaleOnAxis();

    if (scale != kMinPlayerScale) {
      _activeZoomPanning = true;
    } else {
      _activeZoomPanning = false;
    }
  }

  void _playerViewControllerListenerCallback() {
    final boxProp = _viewC.boxProp;
    _detailsOpacityController.value = boxProp.expandRatio > 0
        ? boxProp.expandRatio.normalize(0, .75)
        : 1 - boxProp.heightRatio;

    HomeMessenger.updateNavBarPosition(
      context,
      boxProp.heightRatio.invertByOne,
    );

    _localIsExpanded = boxProp.isExpanded;
  }

  Future<void> _openSettings() async {
    // TODO(josh4500): Create Model for settings final option
    final selection = await openSettingsSheet(context);
    if (selection == 'Lock screen' && context.mounted) {
      _viewC.lockControls();
    } else if (selection is PlayerSpeed) {
      _viewC.setPlayerSpeed(selection);
    } else if (selection == 'Ambient mode') {
      final hasAmbientMode = ref.read(preferencesProvider).ambientMode;
      ref.read(preferencesProvider.notifier).ambientMode = !hasAmbientMode;
    }
  }

  Future<void> _openBottomSheet(VideoBottomSheet sheet) async {
    StackedPageDraggable.open(
      context,
      key: sheet,
      builder: (
        BuildContext context,
        ScrollController? controller,
        DraggableScrollableController? draggableController,
      ) {
        final isPortrait = context.orientation.isPortrait;
        Widget childWidget;
        // Use key to preserve widget state across depth in widget tree
        if (sheet == VideoBottomSheet.comment) {
          childWidget = VideoCommentsSheet(
            key: GlobalObjectKey(sheet),
            controller: controller,
            dragDismissible: context.orientation.isPortrait,
            draggableController: draggableController,
          );
        } else if (sheet == VideoBottomSheet.chapter) {
          childWidget = VideoChaptersSheet(
            key: GlobalObjectKey(sheet),
            controller: controller,
            draggableController: draggableController,
          );
        } else if (sheet == VideoBottomSheet.description) {
          childWidget = VideoDescriptionSheet(
            key: GlobalObjectKey(sheet),
            controller: controller,
            dragDismissible: isPortrait,
            draggableController: draggableController,
          );
        } else if (sheet == VideoBottomSheet.playlist) {
          childWidget = VideoPlaylistSheet(
            key: GlobalObjectKey(sheet),
            controller: controller,
            draggableController: draggableController,
          );
        } else if (sheet == VideoBottomSheet.thanks) {
          return VideoThanksSheet(
            key: GlobalObjectKey(sheet),
            controller: controller,
            draggableController: draggableController,
          );
        } else if (sheet == VideoBottomSheet.membership) {
          return VideoMembershipSheet(
            key: GlobalObjectKey(sheet),
            controller: controller,
            draggableController: draggableController,
          );
        } else if (sheet == VideoBottomSheet.clip) {
          return VideoClipSheet(
            key: GlobalObjectKey(sheet),
            controller: controller,
            draggableController: draggableController,
          );
        } else {
          childWidget = const SizedBox();
        }

        return childWidget;
      },
    );
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

  bool _onScrollDetailsScrollNotification(ScrollNotification notification) {
    // Prevents info to be dragged down while scrolling in DynamicTab
    if (notification.depth >= 1) {
      if (notification is ScrollUpdateNotification) {
        _allowDetailsDrag = false;

        if (_viewC.boxProp.expandRatio > 0) {
          // No need for animation
          _viewC.updateBoxProp((current) => current.copyWith(expandRatio: 0));
        }
      } else if (notification is ScrollEndNotification) {
        _allowDetailsDrag = _detailsScrollController.offset == 0;
      }
    }
    return true;
  }

  /// Handles when back navigation system tries to pop route
  Future<void> _handleBackButtonPressed<T>(bool didPop, T? result) async {
    final didPop = context.stackPagePop();
    if (didPop) {}
  }

  bool _handleScreenNotification(VideoScreenNotification notification) {
    if (notification is OpenBottomSheetNotification) {
      _openBottomSheet(notification.sheet);
    } else if (notification is OpenCommentNotification) {
      _openCommentTextfield();
    }
    return true;
  }

  void _handlePlayerNotification(PlayerNotification notification) {
    // TODO(josh4500): Unimplemented
    if (notification is ForwardSeekPlayerNotification) {
      _viewC.forwardOrRewindSeek();
    } else if (notification is RewindSeekPlayerNotification) {
      _viewC.forwardOrRewindSeek(rewind: true);
    } else if (notification is Forward2xSpeedStartPlayerNotification) {
      _viewC.forward2xSpeed();
    } else if (notification is Forward2xSpeedEndPlayerNotification) {
      _viewC.forward2xSpeed(true);
    } else if (notification is SlideSeekStartPlayerNotification) {
      _preventDragUp = true;
      _preventDragDown = true;
      _viewC.slideSeek(lockProgress: notification.lockProgress);
    } else if (notification is SlideSeekEndPlayerNotification) {
      _preventDragUp = false;
      _preventDragDown = false;
      _viewC.slideSeek(end: true);
    } else if (notification is SlideSeekUpdatePlayerNotification) {
      _viewC.slideSeekUpdate(
        notification.duration,
        showRelease: notification.showRelease,
      );
    } else if (notification is MinimizePlayerNotification) {
      _viewC.enterMinimizedMode();
    } else if (notification is RotatePlayerNotification) {
      _viewC.enterFullscreenMode();
    } else if (notification is EnterFullscreenPlayerNotification) {
      _viewC.enterFullscreenMode();
    } else if (notification is ExitFullscreenPlayerNotification) {
      _viewC.exitFullscreenMode();
    } else if (notification is EnterExpandPlayerNotification) {
      _viewC.enterExpandedMode();
    } else if (notification is ExitExpandPlayerNotification) {
      _viewC.exitExpandedMode();
    } else if (notification is UnlockPlayerNotification) {
      _viewC.unlockControls();
    } else if (notification is SettingsPlayerNotification) {
      _openSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = context.orientation;
    final Axis axis = orientation.isPortrait ? Axis.vertical : Axis.horizontal;

    return ModelBinding(
      model: _viewC,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: _handleBackButtonPressed,
        child: NotificationListener<VideoScreenNotification>(
          onNotification: _handleScreenNotification,
          child: SlideTransition(
            position: Tween(
              begin: Offset.zero,
              end: const Offset(0, 1),
            ).animate(_playerDismissController),
            child: FadeTransition(
              opacity: ReverseAnimation(
                CurvedAnimation(
                  parent: _playerDismissController,
                  curve: Curves.easeInCubic,
                ),
              ),
              child: NotifierSelector(
                notifier: _viewC,
                selector: (state) => Offset(
                  state.boxProp.widthRatio,
                  state.boxProp.heightRatio,
                ),
                builder: (
                  BuildContext context,
                  Offset offset,
                  Widget? childWidget,
                ) {
                  return SizedBox(
                    width: offset.dx.normalizeRange(
                      orientation.isPortrait ? screenWidth : screenWidth * .75,
                      screenWidth,
                    ),
                    height: offset.dy.normalizeRange(
                      _viewC.boxProp.minHeight,
                      screenHeight,
                    ),
                    child: childWidget,
                  );
                },
                child: Material(
                  color: AppPalette.backgroundColor.dark,
                  child: Flex(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    direction: axis,
                    children: [
                      Expanded(
                        flex: orientation.isPortrait ? 0 : 1,
                        child: Theme(
                          data: AppTheme.dark,
                          child: PlayerAnnotationsWrapper(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _onTapPlayer,
                              onVerticalDragEnd: _onDragPlayerEnd,
                              onVerticalDragStart: _onDragStartPlayer,
                              onVerticalDragUpdate: _onDragUpdatePlayer,
                              child: PlayerComponentsWrapper(
                                handleNotification: _handlePlayerNotification,
                                child: NotifierSelector(
                                  notifier: _viewC,
                                  selector: (state) => state.boxProp,
                                  builder: (
                                    BuildContext context,
                                    PlayerBoxProp boxProp,
                                    Widget? childWidget,
                                  ) {
                                    if (orientation.isLandscape) {
                                      boxProp = boxProp.copyWith(
                                        extraHeight: 0,
                                        maxWidth: screenWidth,
                                        maxHeight: screenHeight,
                                      );
                                    }
                                    return _PlayerBox(
                                      boxProp: boxProp,
                                      screenSize:
                                          Size(screenWidth, screenHeight),
                                      view: childWidget,
                                    );
                                  },
                                  child: InteractiveViewer(
                                    minScale: kMinPlayerScale,
                                    maxScale: kMaxPlayerScale,
                                    alignment: Alignment.center,
                                    transformationController: _transC,
                                    child: const PlayerView(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (orientation.isPortrait)
                        Flexible(
                          child: Stack(
                            children: [
                              Listener(
                                onPointerUp: _onPointerUpOnDetails,
                                onPointerDown: _onPointerDownOnDetails,
                                onPointerMove: _onPointerMoveOnDetails,
                                child: NotificationListener<ScrollNotification>(
                                  onNotification:
                                      _onScrollDetailsScrollNotification,
                                  child: FadeTransition(
                                    opacity: ReverseAnimation(
                                      _detailsOpacityController,
                                    ),
                                    child: VideoDetailsSection(
                                      physics: _detailsScrollPhysics,
                                      controller: _detailsScrollController,
                                    ),
                                  ),
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
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Handles zooming and panning based on a swipe gesture.
  ///
  /// Parameters:
  ///   - scaleFactor: The scaling factor to be applied based on the swipe gesture.
  void _swipeZoomPan(double scaleFactor) {
    // Retrieve the last scale value from the transformation controller
    final double lastScaleValue = _transC.value.getMaxScaleOnAxis();

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
      _transC.value = updatedMatrix;
    }
  }

  /// Reverses the zoom and pan effect using an animation.
  Future<void> _reverseZoomPan() async {
    await _zoomNotifier.animate(
      begin: _transC.value,
      end: Matrix4.identity(),
      updateWhen: (current) {
        _transC.value = current;
        return true;
      },
    );
  }

  /// Handles drag updates for an expanded player.
  ///
  /// Parameters:
  ///   - details: The drag update details containing information about the drag.
  void _onDragExpandedPlayer(DragUpdateDetails details) {
    final yDelta = details.primaryDelta!;
    _viewC.updateBoxProp((PlayerBoxProp current) {
      _expandedSideFlag ??= current.expandRatio == 1.0 && yDelta > 0
          ? ExpandedSide.translate
          : ExpandedSide.height;

      final newTranslate = _expandedSideFlag == ExpandedSide.translate
          ? ui.clampDouble(
              current.translate + yDelta / PlayerBoxProp.maxTranslate,
              0,
              1,
            )
          : null;
      final newAddedHeightRatio = _expandedSideFlag == ExpandedSide.height
          ? current.expandRatio +
              yDelta / (screenHeight - current.maxHeight - current.extraHeight)
          : null;

      return current.copyWith(
        translate: newTranslate,
        expandRatio: newAddedHeightRatio,
      );
    });
  }

  /// Handles drag updates for a not expanded player.
  ///
  /// Parameters:
  ///   - details: The drag update details containing information about the drag.
  void _onDragNotExpandedPlayer(DragUpdateDetails details) {
    final yDelta = details.primaryDelta!;

    // Determine the drag direction (down or up or not)
    _isPlayerDraggingDown ??= yDelta > 0;

    if (!_preventDismiss) {
      if (yDelta > 0 && _viewC.boxProp.isMinimized) {
        // Ensures that the first drag down by the from [PlayerBoxProp.minHeight]
        // will be dismissing player if user pointer was recently released
        _isDismissing = true && _releasedPointer;
      }

      if (_isDismissing) {
        final val = yDelta * kPlayerDismissRate / _viewC.boxProp.minHeight;
        _playerDismissController.value += val;
        return;
      }
    }
    // Gesture has not released pointer
    _releasedPointer = false;

    if (!_preventDragUp || !_preventDragDown) {
      _viewC.updateBoxProp(
        (PlayerBoxProp current) {
          final newHeightRatio = current.heightRatio - (yDelta / screenHeight);
          final newExtraHeightRatio = yDelta > 0
              ? current.extraHeightRatio - (yDelta / screenHeight)
              : 0.0;
          final newWidthRatio =
              newHeightRatio * screenHeight <= current.maxHeight
                  ? current.widthRatio - (yDelta / current.maxHeight)
                  : 1.0;
          return current.copyWith(
            widthRatio: newWidthRatio.clamp(0, 1),
            heightRatio: newHeightRatio.clamp(0, 1),
            extraHeightRatio: newExtraHeightRatio.clamp(0, 1),
          );
        },
      );
    } else {
      // Start zoom panning on swipe up
      _swipeZoomPan(
        -(details.delta.dy / (screenHeight * _viewC.boxProp.minHeight)),
      );
    }
  }

  Future<void> _onDragEndExpandedPlayer(DragEndDetails details) async {
    final boxProp = _viewC.boxProp;
    if (boxProp.expandRatio > 0.5 && boxProp.translate < 0.5) {
      _viewC.enterExpandedMode();
    } else {
      _viewC.exitExpandedMode();
    }
    _detailsScrollPhysics.canScroll = true;
  }

  Future<void> _onDragEndNotExpandedPlayer(DragEndDetails details) async {
    // Set to false because the user pointer events will no longer be updated
    _isDismissing = false;

    if (_viewC.boxProp.heightRatio > 0.5) {
      _viewC.exitMinimizedMode();
      _isPlayerDraggingDown = null;
      _preventDismiss = true;
    } else {
      _viewC.enterMinimizedMode();
      _preventDismiss = false;
    }

    if (_playerDismissController.value >= 0.7) {
      _playerDismissController.value = 1;
      HomeMessenger.closePlayer(context);
    } else {
      _playerDismissController.value = 0;
    }

    _detailsScrollPhysics.canScroll = true;

    if (_activeZoomPanning) {
      final double velocityY = details.velocity.pixelsPerSecond.dy;
      if (velocityY < -kMaxDragVelocity) {
        _viewC.enterFullscreenMode();
      }
    }
  }

  void _onDragFullscreenPlayer(DragUpdateDetails details) {
    _viewC.updateBoxProp(
      (current) => current.copyWith(
        translate: current.translate +
            (details.primaryDelta! / PlayerBoxProp.maxTranslate),
      ),
    );
  }

  Future<void> _onDragFullscreenPlayerEnd(DragEndDetails details) async {
    if (_viewC.boxProp.translate >= 1) {
      _viewC.exitFullscreenMode();
    } else {
      _viewC.updateBoxProp(
        (current) => current.copyWith(translate: 0),
        animate: true,
      );
    }
  }

  void _onTapPlayer() {
    // If the player screen is maximized toggle controls
    if (_viewC.boxProp.isMinimized) {
      _viewC.exitMinimizedMode();
    } else {
      _viewC.toggleControls();
    }
  }

  void _onDragUpdatePlayer(DragUpdateDetails details) {
    if (_viewC.isControlsLocked || _viewC.isSeeking) return;

    // If active zoom panning is in progress, update zoom panning and return
    if (_activeZoomPanning) {
      _swipeZoomPan(
        -(details.delta.dy / (screenHeight * _viewC.boxProp.minHeight)),
      );
      return;
    }

    // If preventing player drag up or down, return without further processing
    if (details.delta.dy > 0 && _preventDragUp) {
      return;
    }
    if (details.delta.dy < 0 && _preventDragDown) {
      return;
    }

    if (context.orientation.isLandscape) {
      _viewC.boxProp.isMinimized
          ? _onDragNotExpandedPlayer(details)
          : _onDragFullscreenPlayer(details);
    } else {
      _viewC.boxProp.isExpanded
          ? _onDragExpandedPlayer(details)
          : _onDragNotExpandedPlayer(details);
    }
  }

  void _onDragStartPlayer(DragStartDetails details) {
    if (_viewC.isControlsLocked || _viewC.isSeeking) return;
  }

  void _onDragPlayerEnd(DragEndDetails details) {
    if (_viewC.isControlsLocked) return;

    _releasedPointer = true;

    _preventDragUp = false;
    _preventDragDown = false;
    _isPlayerDraggingDown = null;
    _expandedSideFlag = null;

    if (_viewC.boxProp.isExpanded) {
      _onDragEndExpandedPlayer(details);
    } else {
      _onDragEndNotExpandedPlayer(details);
    }

    if (_localIsFullscreen) {
      // For fullscreen video
      _onDragFullscreenPlayerEnd(details);
    }

    // Reversing zoom due to swiping up
    final lastScaleValue = _transC.value.getMaxScaleOnAxis();

    if (lastScaleValue <= kMinPlayerScale + 0.5 && lastScaleValue > 1.0) {
      if (lastScaleValue == kMinPlayerScale + 0.5) _viewC.enterFullscreenMode();
      _reverseZoomPan();
    }
  }

  void _onPointerUpOnDetails(PointerUpEvent event) {
    if (_viewC.isControlsLocked) return;

    final yDelta = event.delta.dy;
    final boxProp = _viewC.boxProp;
    final scrollAtTop = _detailsScrollController.offset == 0;

    if (_allowDetailsDrag) {
      final velocity = _detailsVelocityTracker?.getVelocity();
      final aboveMaxVelocity =
          velocity != null && velocity.pixelsPerSecond.dy > kMaxDragVelocity;

      if (boxProp.expandRatio > .5 || aboveMaxVelocity && yDelta < 1) {
        _viewC.enterExpandedMode();
      } else {
        _viewC.exitExpandedMode();

        _detailsScrollPhysics.canScroll = true;
      }
    }

    _allowDetailsDrag = scrollAtTop;
    _detailsVelocityTracker = null;
  }

  void _onPointerMoveOnDetails(PointerMoveEvent event) {
    if (_viewC.isControlsLocked) return;

    final yDelta = event.delta.dy;
    final boxProp = _viewC.boxProp;
    final scrollAtTop = _detailsScrollController.offset == 0;

    // Ensures to disable _allowDetailsDrag when scrollAtTop is false
    if (_allowDetailsDrag && !scrollAtTop) _allowDetailsDrag = false;

    if ((scrollAtTop && _allowDetailsDrag) ||
        (boxProp.isResizableExpandMode && yDelta < 0)) {
      _detailsVelocityTracker?.addPosition(
        event.timeStamp,
        event.localPosition,
      );

      _detailsScrollPhysics.canScroll = false;
      _viewC.updateBoxProp(
        (current) {
          return current.copyWith(
            expandRatio: current.extraHeightRatio >= 1
                ? (current.expandRatio +
                        yDelta /
                            (screenHeight -
                                current.maxHeight -
                                current.extraHeight))
                    .clamp(0, 1)
                : null,
            extraHeightRatio: current.expandRatio == 0
                ? (current.extraHeightRatio + yDelta / current.extraHeight)
                    .clamp(0, 1)
                : null,
          );
        },
      );
    }

    if (boxProp.expandRatio == 0) {
      _detailsScrollPhysics.canScroll = true;
    }
  }

  void _onPointerDownOnDetails(PointerDownEvent event) {
    if (_viewC.isControlsLocked) return;

    _allowDetailsDrag = _detailsScrollController.offset == 0;
    _detailsVelocityTracker = VelocityTracker.withKind(event.kind);
  }
}

class _PlayerBox extends StatelessWidget {
  const _PlayerBox({
    required this.screenSize,
    required this.boxProp,
    this.view,
  });

  final Size screenSize;
  final PlayerBoxProp boxProp;
  final Widget? view;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: boxProp.expandRatio > 0
          ? boxProp.expandRatio < 1
              ? boxProp.getFullHeight(screenSize.height)
              : screenSize.height
          : null,
      child: Row(
        children: [
          Container(
            width: boxProp.getFullWidth(screenSize.width),
            height: boxProp.height,
            constraints: BoxConstraints(
              minHeight: boxProp.minHeight,
              maxHeight: boxProp.maxHeight + boxProp.maxExtraHeight,
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: screenSize.width >= screenSize.height
                    ? const Offset(0, .1)
                    : const Offset(0, 1),
              ).animate(AlwaysStoppedAnimation(boxProp.translate)),
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 1,
                  end: 0.95,
                ).animate(AlwaysStoppedAnimation(boxProp.translate)),
                child: view,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: FadeTransition(
                opacity: AlwaysStoppedAnimation(
                  boxProp.heightRatio.invertByOne,
                ),
                child: SizedBox(
                  height: boxProp.minHeight,
                  child: const MiniPlayer(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
