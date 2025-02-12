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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/screens/video/player_view_controller.dart';
import 'package:youtube_clone/presentation/themes.dart';

import 'player_control.dart';
import 'player_notifications.dart';

class PlayerFullscreen extends ConsumerWidget {
  const PlayerFullscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = context.provide<PlayerViewController>();
    return NotifierSelector(
      notifier: controller,
      selector: (controller) => controller.boxProp,
      builder: (BuildContext context, PlayerBoxProp boxProp, Widget? child) {
        final bool isExpanded = boxProp.isExpanded;
        final bool isResizableExpandMode = boxProp.isResizableExpandMode;
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return PlayerControlButton(
              onTap: () {
                if (isResizableExpandMode || isExpanded) {
                  if (isExpanded) {
                    ExitExpandPlayerNotification().dispatch(context);
                  } else {
                    EnterExpandPlayerNotification().dispatch(context);
                  }
                } else {
                  if (context.orientation.isPortrait) {
                    EnterFullscreenPlayerNotification().dispatch(context);
                  } else {
                    ExitFullscreenPlayerNotification().dispatch(context);
                  }
                }
              },
              backgroundColor: Colors.transparent,
              horizontalPadding: 8,
              builder: (context, _) {
                return isExpanded || context.orientation.isLandscape
                    ? const Icon(YTIcons.exit_fullscreen_outlined)
                    : isResizableExpandMode
                        ? const Icon(Icons.expand)
                        : const Icon(YTIcons.fullscreen);
              },
            );
          },
        );
      },
    );
  }
}
