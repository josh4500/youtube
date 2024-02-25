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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
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
