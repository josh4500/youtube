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
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../video_comment_guidelines.dart';

class VideoCommentsSheet extends StatefulWidget {
  const VideoCommentsSheet({
    super.key,
    this.controller,
    required this.replyController,
    required this.onPressClose,
    required this.initialHeight,
    this.draggableController,
    this.dragDismissible = true,
  });
  final ScrollController? controller;
  final PageDraggableOverlayChildController replyController;
  final VoidCallback onPressClose;
  final double initialHeight;
  final bool dragDismissible;
  final DraggableScrollableController? draggableController;

  @override
  State<VideoCommentsSheet> createState() => _VideoCommentsSheetState();
}

class _VideoCommentsSheetState extends State<VideoCommentsSheet> {
  final indexNotifier = ValueNotifier(0);
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
      controller: widget.controller ?? ScrollController(),
      onClose: widget.onPressClose,
      dragDismissible: widget.dragDismissible,
      showDragIndicator: widget.dragDismissible,
      draggableController: widget.draggableController,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      dynamicTab: ValueListenableBuilder(
        valueListenable: indexNotifier,
        builder: (context, page, __) {
          return DynamicTab(
            initialIndex: page,
            options: const ['Top', 'Timed', 'Members', 'Newest'],
            onChanged: (int index) => indexNotifier.value = index,
          );
        },
      ),
      contentBuilder: (context, controller, physics) {
        return ListView.builder(
          physics: physics,
          controller: controller,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ValueListenableBuilder(
                valueListenable: indexNotifier,
                builder: (context, page, __) {
                  if (page == 2) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: .1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: .5),
                                  ),
                                ),
                                child: const AccountAvatar(size: 36),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      r'Support this channel and get access to perks, from $1/month',
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Become a member',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: context.theme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 0, thickness: 1),
                      ],
                    );
                  }
                  return const VideoCommentGuidelines();
                },
              );
            }
            if (index == 4) {
              return Column(
                children: [
                  const Divider(thickness: 6, height: 0),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Comments by members',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppFont.youTubeSans,
                                ),
                              ),
                              Text(
                                'Fans who have membership to this channel',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.theme.hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => indexNotifier.value = 2,
                          child: Text(
                            'View all',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: context.theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CommentTile(
                    openReply: widget.replyController.open,
                  ),
                  const Divider(thickness: 6, height: 0),
                ],
              );
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
