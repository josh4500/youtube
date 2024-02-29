import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/core/constants/constants.dart';
import 'package:youtube_clone/presentation/widgets/custom_scroll_physics.dart';

import '../../providers.dart';
import 'widgets/player/player.dart';
import 'widgets/player/player_components_wrapper.dart';
import 'widgets/player/player_notifications.dart';

class PlayerLandscapeScreen extends ConsumerStatefulWidget {
  const PlayerLandscapeScreen({super.key});

  @override
  ConsumerState<PlayerLandscapeScreen> createState() =>
      _PlayerLandscapeScreenState();
}

class _PlayerLandscapeScreenState extends ConsumerState<PlayerLandscapeScreen>
    with TickerProviderStateMixin {
  final GlobalKey _interactivePlayerKey = GlobalKey();

  final _infoScrollController = ScrollController();
  final _infoScrollPhysics = const CustomScrollableScrollPhysics(
    tag: 'info-landscape',
  );

  final _transformationController = TransformationController();

  bool _preventPlayerDragUp = true;
  bool _preventPlayerDragDown = true;
  bool _isSeeking = true;

  double _slideOffsetYValue = 0;
  late final AnimationController _viewController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  double get screenHeight => MediaQuery.sizeOf(context).height;
  double get screenWidth => MediaQuery.sizeOf(context).width;

  @override
  void initState() {
    super.initState();

    _viewController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, .4),
    ).animate(_viewController);

    _scaleAnimation = ReverseAnimation(
      CurvedAnimation(
        parent: _viewController,
        curve: const Interval(0, .4, curve: Curves.easeInCubic),
        reverseCurve: const Interval(.4, 0, curve: Curves.easeOutCubic),
      ),
    );

    Future(() async {
      await setLandscapeMode();
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _viewController.dispose();
    super.dispose();
  }

  /// Handles tap events on the player.
  Future<void> _onTapPlayer() async {
    // Check if player controls are currently visible
    if (ref.read(playerRepositoryProvider).playerViewState.showControls) {
      // If visible, send a signal to hide controls
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal(PlayerSignal.hideControls);
    } else {
      // If not visible, send a signal to show controls
      ref
          .read(playerRepositoryProvider)
          .sendPlayerSignal(PlayerSignal.showControls);
    }
  }

  void _onDragPlayer(DragUpdateDetails details) {
    // Check the direction of the drag
    // If dragging down
    _hideControls();

    _slideOffsetYValue += details.delta.dy;

    _viewController.value = clampDouble(
      _slideOffsetYValue / 100,
      0,
      1,
    );
  }

  void _onDragPlayerEnd(DragEndDetails details) {
    if (_viewController.value >= 1) {
      _closeFullscreenPlayer();
    }
    _slideOffsetYValue = 0;
    _viewController.value = 0;
  }

  Future<void> setLandscapeMode() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  Future<void> resetOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.restoreSystemUIOverlays();
  }

  /// Hides the player controls by sending a player signal.
  void _hideControls() {
    ref
        .read(playerRepositoryProvider)
        .sendPlayerSignal(PlayerSignal.hideControls);
  }

  /// Closes the player in fullscreen mode by sending a player signal
  Future<void> _closeFullscreenPlayer() async {
    _hideControls();
    ref.read(playerRepositoryProvider).sendPlayerSignal(
          PlayerSignal.exitFullscreen,
        );
    await resetOrientation();
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final interactivePlayerView = PlayerComponentsWrapper(
      key: _interactivePlayerKey,
      handleNotification: (notification) {
        if (notification is ExitFullscreenPlayerNotification) {
          _closeFullscreenPlayer();
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
        child: ProviderScope(
          overrides: [
            playerSizingProvider.overrideWithValue(
              PlayerSizing(
                minHeight: 1,
                maxHeight: 1,
              ),
            ),
          ],
          child: const Hero(
            tag: 'player',
            child: KeyedSubtree(
              child: PlayerView(),
            ),
          ),
        ),
      ),
    );

    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: GestureDetector(
              onTap: _onTapPlayer,
              onVerticalDragUpdate: _onDragPlayer,
              onVerticalDragEnd: _onDragPlayerEnd,
              behavior: HitTestBehavior.opaque,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: interactivePlayerView,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
