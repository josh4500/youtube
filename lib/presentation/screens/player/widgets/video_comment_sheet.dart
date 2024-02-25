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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:youtube_clone/core/constants/constants.dart';
import 'package:youtube_clone/presentation/widgets.dart';
import 'package:youtube_clone/presentation/widgets/comment_tile.dart';
import 'package:youtube_clone/presentation/widgets/dynamic_tab.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/persistent_header_delegate.dart';
import 'package:youtube_clone/presentation/widgets/reply_tile.dart';

import 'video_comment_guidelines.dart';

class VideoCommentsSheet extends StatefulWidget {
  final ScrollController? controller;
  final ValueNotifier<bool> replyNotifier;
  final VoidCallback closeComment;
  final double maxHeight;
  final DraggableScrollableController draggableController;

  const VideoCommentsSheet({
    super.key,
    this.controller,
    required this.replyNotifier,
    required this.closeComment,
    required this.maxHeight,
    required this.draggableController,
  });

  @override
  State<VideoCommentsSheet> createState() => _VideoCommentsSheetState();
}

class _VideoCommentsSheetState extends State<VideoCommentsSheet>
    with TickerProviderStateMixin {
  bool _replyIsOpened = false;
  final ScrollController _commentListController = ScrollController();
  final _commentListPhysics = const CustomScrollableScrollPhysics(
    tag: 'comment',
  );
  late final AnimationController _repliesAnimationController;
  late final Animation<double> _repliesOpacityAnimation;
  late final Animation<Offset> _repliesSlideAnimation;

  final _commentTagsNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();

    _repliesAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 250),
    );

    _repliesOpacityAnimation = CurvedAnimation(
      parent: _repliesAnimationController,
      curve: const Interval(
        0,
        1,
        curve: Curves.easeInOutCubic,
      ),
    );

    _repliesSlideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: const Offset(0, 0),
    ).animate(_repliesAnimationController);

    widget.replyNotifier.addListener(_hideReplyListCallback);

    _commentListController.addListener(_hideCommentTagsCallback);
  }

  void _hideCommentTagsCallback() {
    if (_commentListController.offset >= 100) {
      _commentTagsNotifier.value = false;
    } else {
      _commentTagsNotifier.value = true;
    }
  }

  void _hideReplyListCallback() {
    if (widget.replyNotifier.value) {
      _commentTagsNotifier.value = false;
    } else {
      if (_commentListController.offset < 100) {
        _commentTagsNotifier.value = true;
      }
    }

    if (!widget.replyNotifier.value) {
      _repliesAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    // Note: "widget.replyNotifier: should not be disposed
    widget.replyNotifier.removeListener(_hideReplyListCallback);

    _commentListController.removeListener(_hideCommentTagsCallback);
    _commentListController.dispose();
    _repliesAnimationController.dispose();
    super.dispose();
  }

  void _openReply() {
    widget.replyNotifier.value = _replyIsOpened = true;
    _repliesAnimationController.forward();
  }

  void _closeReply() {
    widget.replyNotifier.value = _replyIsOpened = false;
  }

  void _closeComment() {
    if (_replyIsOpened) {
      _closeReply();
    }
    widget.closeComment();
  }

  void _onDragInfo(PointerMoveEvent event) {
    if (_commentListController.offset == 0) {
      final yDist = event.delta.dy;
      final height = MediaQuery.sizeOf(context).height;
      final size = widget.draggableController.size;

      final newSize = clampDouble(
        size - (yDist / height),
        0,
        1 - widget.maxHeight,
      );

      if (newSize >= 1 - widget.maxHeight) {
        _commentListPhysics.canScroll(true);
      } else {
        _commentListPhysics.canScroll(false);
      }

      widget.draggableController.jumpTo(newSize);
    }
  }

  void _onDragInfoUp(PointerUpEvent event) {
    _commentListPhysics.canScroll(true);
    final size = widget.draggableController.size;
    if (size != 0.0 || size != 1 - widget.maxHeight) {
      widget.draggableController.animateTo(
        size < (1 - widget.maxHeight) / 2 ? 0.0 : 1 - widget.maxHeight,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Material(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: ScrollConfiguration(
          behavior: const NoOverScrollGlowBehavior(),
          child: CustomScrollView(
            controller: widget.controller,
            slivers: [
              ValueListenableBuilder(
                valueListenable: _commentTagsNotifier,
                builder: (context, showCommentTags, childWidget) {
                  return SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: PersistentHeaderDelegate(
                      minHeight: 46,
                      maxHeight: showCommentTags ? 100 : 56,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 4,
                            width: 45,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          childWidget!,
                          const SizedBox(height: 12),
                          if (showCommentTags) ...[
                            const Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: DynamicTab(
                                    initialIndex: 0,
                                    options: ['Top', 'Timed', 'Newest'],
                                  ),
                                ),
                                SizedBox(height: 4),
                              ],
                            ),
                          ],
                          const Divider(thickness: 1.5, height: 0),
                        ],
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Comments',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 16),
                          InkWell(
                            borderRadius: BorderRadius.circular(32),
                            onTap: _closeComment,
                            child: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      FadeTransition(
                        opacity: _repliesOpacityAnimation,
                        child: SlideTransition(
                          position: _repliesSlideAnimation,
                          child: Material(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(32),
                                  onTap: _closeReply,
                                  child: const Icon(Icons.arrow_back),
                                ),
                                const SizedBox(width: 32),
                                const Text(
                                  'Replies',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                child: Listener(
                  onPointerMove: _onDragInfo,
                  onPointerUp: _onDragInfoUp,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              physics: _commentListPhysics,
                              controller: _commentListController,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return const VideoCommentGuidelines();
                                }
                                return CommentTile(openReply: _openReply);
                              },
                              itemCount: 20,
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: widget.replyNotifier,
                            builder: (context, value, _) {
                              return Visibility(
                                visible: !value,
                                child: const CommentTextFieldPlaceholder(),
                              );
                            },
                          ),
                        ],
                      ),
                      SlideTransition(
                        position: _repliesSlideAnimation,
                        child: Material(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return const CommentTile(showReplies: false);
                              }
                              return const ReplyTile();
                            },
                            itemCount: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
