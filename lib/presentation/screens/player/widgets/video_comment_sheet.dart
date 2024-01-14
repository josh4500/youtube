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

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/comment_tile.dart';
import 'package:youtube_clone/presentation/widgets/dynamic_tab.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/reply_tile.dart';

import 'video_comment_guidelines.dart';

class VideoCommentsSheet extends StatefulWidget {
  final ScrollController? controller;
  final ValueNotifier<bool> replyNotifier;
  final VoidCallback closeComment;
  final DraggableScrollableController draggableController;

  const VideoCommentsSheet({
    super.key,
    this.controller,
    required this.replyNotifier,
    required this.closeComment,
    required this.draggableController,
  });

  @override
  State<VideoCommentsSheet> createState() => _VideoCommentsSheetState();
}

class _VideoCommentsSheetState extends State<VideoCommentsSheet>
    with TickerProviderStateMixin {
  bool _replyIsOpened = false;
  final ScrollController _commentListController = ScrollController();
  late final AnimationController _repliesAnimationController;
  late final Animation _repliesOpacityAnimation;
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
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
                    return SliverAppBar(
                      automaticallyImplyLeading: false,
                      pinned: true,
                      leadingWidth: 0,
                      title: childWidget,
                      actions: [
                        InkWell(
                          onTap: _closeComment,
                          borderRadius: BorderRadius.circular(32),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.close,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                      flexibleSpace: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 4,
                          width: 45,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: Size(
                          double.infinity,
                          showCommentTags ? 45.5 : 1.5,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                  child: Stack(
                    children: [
                      const Text(
                        'Comments',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _repliesOpacityAnimation,
                        builder: (context, childWidget) {
                          return Opacity(
                            opacity: _repliesOpacityAnimation.value,
                            child: childWidget,
                          );
                        },
                        child: SlideTransition(
                          position: _repliesSlideAnimation,
                          child: Material(
                            child: Row(
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
                SliverFillRemaining(
                  child: Stack(
                    children: [
                      ListView.builder(
                        controller: _commentListController,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return const VideoCommentGuidelines();
                          }
                          return CommentTile(openReply: _openReply);
                        },
                        itemCount: 20,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
