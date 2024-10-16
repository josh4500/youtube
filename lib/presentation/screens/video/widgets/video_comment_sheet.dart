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
import 'package:youtube_clone/main.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../../constants.dart';
import 'video_comment_guidelines.dart';

class VideoCommentsSheet extends StatefulWidget {
  const VideoCommentsSheet({
    super.key,
    this.controller,
    required this.replyController,
    required this.onPressClose,
    required this.initialHeight,
    this.draggableController,
    this.showDragIndicator = true,
  });
  final ScrollController? controller;
  final PageDraggableOverlayChildController replyController;
  final VoidCallback onPressClose;
  final double initialHeight;
  final bool showDragIndicator;
  final DraggableScrollableController? draggableController;

  @override
  State<VideoCommentsSheet> createState() => _VideoCommentsSheetState();
}

class _VideoCommentsSheetState extends State<VideoCommentsSheet> {
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
  Widget build(BuildContext context) {
    return PageDraggableSheet(
      title: 'Comments',
      scrollTag: 'player_comments',
      controller: widget.controller ?? ScrollController(),
      onClose: widget.onPressClose,
      showDragIndicator: widget.showDragIndicator,
      draggableController: widget.draggableController,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      dynamicTab: const DynamicTab(
        initialIndex: 0,
        options: ['Top', 'Timed', 'Newest'],
      ),
      contentBuilder: (context, controller, physics) {
        return ListView.builder(
          physics: physics,
          controller: controller,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const VideoCommentGuidelines();
            }
            return CommentTile(
              openReply: widget.replyController.open,
              pinned: index == 1,
              byCreator: index == 1,
              creatorLikes: index == 1,
              creatorReply: index == 1,
              showReplies: index == 1,
            );
          },
          itemCount: 20,
        );
      },
      bottom: ListenableBuilder(
        listenable: widget.replyController,
        builder: (context, _) {
          return Visibility(
            visible: !widget.replyController.isOpened,
            child: const CommentTextFieldPlaceholder(),
          );
        },
      ),
      baseHeight: 1 - kAvgVideoViewPortHeight,
      overlayChildren: [
        PageDraggableOverlayChild(
          controller: widget.replyController,
          builder: (context, controller, physics) {
            return ListView.builder(
              controller: controller,
              physics: physics,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CommentTile(
                    showReplies: false,
                    backgroundColor: context.theme.highlightColor,
                  );
                }
                return const ReplyTile();
              },
              itemCount: 20,
            );
          },
        ),
      ],
    );
  }
}
