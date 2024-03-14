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
import 'package:youtube_clone/core/constants/constants.dart';
import 'package:youtube_clone/presentation/widgets.dart';
import 'package:youtube_clone/presentation/widgets/page_draggable_sheet.dart';
import 'package:youtube_clone/presentation/widgets/persistent_header_delegate.dart';

import 'video_comment_guidelines.dart';

class VideoCommentsSheet extends StatelessWidget {
  final ScrollController? controller;
  final ValueNotifier<bool> replyNotifier;
  final VoidCallback closeComment;
  final double maxHeight;
  final bool showDragIndicator;
  final DraggableScrollableController? draggableController;

  const VideoCommentsSheet({
    super.key,
    this.controller,
    required this.replyNotifier,
    required this.closeComment,
    required this.maxHeight,
    this.draggableController,
    this.showDragIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    return PageDraggableSheet(
      title: 'Comments',
      scrollTag: 'player_comments',
      controller: controller ?? ScrollController(),
      onClose: closeComment,
      showDragIndicator: showDragIndicator,
      draggableController: draggableController,
      dynamicTab: const DynamicTab(
        initialIndex: 0,
        options: ['Top', 'Timed', 'Newest'],
      ),
      contentBuilder: (context, controller, physics) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: physics,
                controller: controller,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const VideoCommentGuidelines();
                  }
                  return CommentTile(openReply: () {});
                },
                itemCount: 20,
              ),
            ),
            // ValueListenableBuilder(
            //   valueListenable: widget.replyNotifier,
            //   builder: (context, value, _) {
            //     return Visibility(
            //       visible: !value,
            //       child: const CommentTextFieldPlaceholder(),
            //     );
            //   },
            // ),
          ],
        );
      },
      baseHeight: 1 - avgVideoViewPortHeight,
    );
  }
}
