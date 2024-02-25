// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:youtube_clone/core/constants/constants.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/provider/state/player_state_provider.dart';

import 'player_overlay_controls.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({super.key});

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> with TickerProviderStateMixin {
  late final AnimationController _controlsOpacityController;
  late final Animation<double> _controlsAnimation;

  @override
  void initState() {
    super.initState();
    _controlsOpacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 175),
      reverseDuration: const Duration(seconds: 1),
    );

    _controlsAnimation = CurvedAnimation(
      parent: _controlsOpacityController,
      curve: Curves.easeIn,
    );
  }

  // Timer instance
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          child: Container(
            color: Colors.white,
            constraints: BoxConstraints(
              minWidth: 135,
              maxWidth: screenWidth,
              maxHeight: screenHeight * avgVideoViewPortHeight,
              minHeight: screenHeight * minVideoViewPortHeight,
            ),
            // child: Video(
            //   controller: controller,
            //   fit: BoxFit.fitWidth,
            //   controls: null,
            // ),
          ),
        ),
        Consumer(
          builder: (context, ref, childWidget) {
            ref.listen(
              playerNotifierProvider.select((value) => value.controlsHidden),
              (previous, next) async {
                if (!next) {
                  _controlsOpacityController.forward();

                  // Cancel any existing timer
                  if (_timer != null && (_timer?.isActive ?? false)) {
                    _timer?.cancel();
                  }

                  _timer = Timer(const Duration(seconds: 3), () async {
                    await _controlsOpacityController.reverse();
                    ref.read(playerRepositoryProvider).hideControls();
                  });
                }
              },
            );

            return AnimatedBuilder(
              animation: _controlsAnimation,
              builder: (context, innerChildWidget) {
                return Visibility(
                  visible: _controlsAnimation.value > 0,
                  child: Opacity(
                    opacity: _controlsAnimation.value,
                    child: innerChildWidget,
                  ),
                );
              },
              child: childWidget,
            );
          },
          child: const PlayerOverlayControls(),
        ),
      ],
    );
  }
}
