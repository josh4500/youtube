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
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/controls/player_control.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/player/player_notifications.dart';

class PlayerFullscreen extends ConsumerWidget {
  const PlayerFullscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Check if Expanded or Fullscreen control mode
    const bool expandedMode = false;

    return PlayerControl(
      onTap: () {
        final isExpanded = ref
            .read(
              playerRepositoryProvider,
            )
            .playerViewState
            .isExpanded;
        if (expandedMode || isExpanded) {
          if (!isExpanded) {
            ExpandPlayerNotification().dispatch(context);
          } else {
            DeExpandPlayerNotification().dispatch(context);
          }
          ref.read(playerRepositoryProvider).sendPlayerSignal(
            [PlayerSignal.showControls],
          );
        } else {
          if (!ref
              .read(playerRepositoryProvider)
              .playerViewState
              .isFullscreen) {
            EnterFullscreenPlayerNotification().dispatch(context);
          } else {
            ExitFullscreenPlayerNotification().dispatch(context);
          }
        }
      },
      color: Colors.transparent,
      horizontalPadding: 8,
      builder: (context, _) {
        return const Icon(Icons.fullscreen);
      },
    );
  }
}
