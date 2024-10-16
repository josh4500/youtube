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
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../../constants.dart';

class VideoPlaylistSheet extends StatefulWidget {
  const VideoPlaylistSheet({
    super.key,
    this.controller,
    required this.onPressClose,
    required this.initialHeight,
    this.draggableController,
    this.showDragIndicator = true,
  });
  final ScrollController? controller;
  final VoidCallback onPressClose;
  final double initialHeight;
  final bool showDragIndicator;
  final DraggableScrollableController? draggableController;

  @override
  State<VideoPlaylistSheet> createState() => _VideoPlaylistSheetState();
}

class _VideoPlaylistSheetState extends State<VideoPlaylistSheet> {
  final SharedSlidableState _slidableState = SharedSlidableState(null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.draggableController?.animateTo(
        widget.initialHeight,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInCubic,
      );
    });
  }

  @override
  void dispose() {
    _slidableState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageDraggableSheet(
      title: 'Distributed Systems lecture',
      scrollTag: 'playlist_comments',
      trailingTitle: '$kDotSeparator 1/23',
      subtitle: PreferredSize(
        preferredSize: const Size(double.infinity, 44),
        child: Row(
          children: [
            const SizedBox(width: 4),
            TappableArea(
              onTap: () {},
              padding: const EdgeInsets.all(8),
              child: const Icon(YTIcons.loop_outlined),
            ),
            TappableArea(
              onTap: () {},
              padding: const EdgeInsets.all(8),
              child: const Icon(YTIcons.shuffle_outlined),
            ),
            const Spacer(),
            TappableArea(
              onTap: () {},
              padding: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(24),
              child: const Icon(YTIcons.more_vert_outlined),
            ),
          ],
        ),
      ),
      controller: widget.controller ?? ScrollController(),
      onClose: widget.onPressClose,
      showDragIndicator: widget.showDragIndicator,
      showDivider: false,
      draggableController: widget.draggableController,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      contentBuilder: (context, controller, physics) {
        return ListView.builder(
          physics: physics,
          controller: controller,
          itemBuilder: (context, index) {
            return Slidable(
              key: ValueKey(index),
              sharedSlidableState: _slidableState,
              maxOffset: .3,
              items: const [
                SlidableItem(
                  icon: Icon(YTIcons.hide_outlined),
                ),
              ],
              child: Material(
                child: GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(YTIcons.move_outlined),
                        Expanded(
                          // TODO(josh4500): PlayablePlaylistContent
                          child: PlayableVideoContent(
                            width: 142,
                            height: 88,
                            onMore: () {},
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: 20,
        );
      },
      baseHeight: 1 - kAvgVideoViewPortHeight,
    );
  }
}
