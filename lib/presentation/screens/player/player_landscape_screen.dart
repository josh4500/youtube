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
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../constants.dart';
import '../../providers.dart';
import 'widgets/controls/player_notifications.dart';
import 'widgets/player/player_components_wrapper.dart';
import 'widgets/player/player_infographics_wrapper.dart';
import 'widgets/player/player_view.dart';

class PlayerLandscapeScreen extends ConsumerStatefulWidget {
  const PlayerLandscapeScreen({super.key});

  @override
  ConsumerState<PlayerLandscapeScreen> createState() =>
      _PlayerLandscapeScreenState();
}

class _PlayerLandscapeScreenState extends ConsumerState<PlayerLandscapeScreen>
    with TickerProviderStateMixin {
  final GlobalKey _interactivePlayerKey = GlobalKey();

  final ScrollController _infoScrollController = ScrollController();
  final CustomScrollableScrollPhysics _infoScrollPhysics =
      const CustomScrollableScrollPhysics(
    tag: 'info-landscape',
  );

  final TransformationController _transformationController =
      TransformationController();

  bool _preventPlayerDragUp = true;
  bool _preventPlayerDragDown = true;
  bool _isSeeking = true;

  double _slideOffsetYValue = 0;
  late final AnimationController _viewController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  double get screenHeight => MediaQuery.sizeOf(context).height;
  double get screenWidth => MediaQuery.sizeOf(context).width;

  /// PlayerSignal StreamSubscription
  StreamSubscription<PlayerSignal>? _subscription;

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

    Future<void>(() async {
      await setLandscapeMode();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _transformationController.dispose();
    _viewController.dispose();
    super.dispose();
  }

  /// Handles tap events on the player.
  Future<void> _onTapPlayer() async {
    // Check if player controls are currently visible
    if (ref.read(playerViewStateProvider).showControls) {
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

  void _onDragFullscreenPlayer(DragUpdateDetails details) {
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

  void _onDragFullscreenPlayerEnd(DragEndDetails details) {
    if (_viewController.value >= 1) {
      _closeFullscreenPlayer();
    }
    _slideOffsetYValue = 0;
    _viewController.value = 0;
  }

  Future<void> setLandscapeMode() async {
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: <SystemUiOverlay>[],
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
        .sendPlayerSignal(<PlayerSignal>[PlayerSignal.hideControls]);
  }

  /// Closes the player in fullscreen mode by sending a player signal
  Future<void> _closeFullscreenPlayer() async {
    await resetOrientation();
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlayerComponentsWrapper interactivePlayerView =
        PlayerComponentsWrapper(
      key: _interactivePlayerKey,
      handleNotification: (PlayerNotification notification) {
        if (notification is ExitFullscreenPlayerNotification) {
          _closeFullscreenPlayer();
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

    return Material(
      child: PlayerInfographicsWrapper(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: GestureDetector(
                    onTap: _onTapPlayer,
                    onVerticalDragUpdate: _onDragFullscreenPlayer,
                    onVerticalDragEnd: _onDragFullscreenPlayerEnd,
                    behavior: HitTestBehavior.opaque,
                    child: interactivePlayerView,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
