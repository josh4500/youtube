import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/comment_tile.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/reply_tile.dart';

class ShortsCommentsBottomSheet extends StatefulWidget {
  final ScrollController? controller;
  final ValueNotifier<bool> replyNotifier;
  final VoidCallback closeComment;
  const ShortsCommentsBottomSheet({
    super.key,
    this.controller,
    required this.replyNotifier,
    required this.closeComment,
  });

  @override
  State<ShortsCommentsBottomSheet> createState() =>
      _ShortsCommentsBottomSheetState();
}

class _ShortsCommentsBottomSheetState extends State<ShortsCommentsBottomSheet>
    with TickerProviderStateMixin {
  late final AnimationController _repliesAnimationController;
  late final Animation _repliesOpacityAnimation;
  late final Animation<Offset> _repliesSlideAnimation;
  bool _replyIsOpened = false;

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

    widget.replyNotifier.addListener(() {
      if (!widget.replyNotifier.value) {
        _repliesAnimationController.reverse();
      }
    });
  }

  @override
  void dispose() {
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
            behavior: const OverScrollGlowBehavior(enabled: false),
            child: CustomScrollView(
              controller: widget.controller,
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  leadingWidth: 0,
                  toolbarHeight: kToolbarHeight + 12,
                  flexibleSpace: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 4,
                        width: 50,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Stack(
                                  children: [
                                    const Row(
                                      children: [
                                        SizedBox(width: 16),
                                        Text(
                                          'Comments',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Text(
                                          '1k',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    AnimatedBuilder(
                                      animation: _repliesOpacityAnimation,
                                      builder: (context, childWidget) {
                                        return Opacity(
                                          opacity:
                                              _repliesOpacityAnimation.value,
                                          child: childWidget,
                                        );
                                      },
                                      child: SlideTransition(
                                        position: _repliesSlideAnimation,
                                        child: Material(
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 16),
                                              InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  32,
                                                ),
                                                onTap: _closeReply,
                                                child: const Icon(
                                                    Icons.arrow_back),
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
                              const Spacer(),
                              const InkWell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.tune_outlined,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
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
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(thickness: 1.5, height: 0),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: true,
                  fillOverscroll: true,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return CommentTile(
                                  openReply: _openReply,
                                );
                              },
                              itemCount: 20,
                            ),
                          ),
                          ValueListenableBuilder(
                              valueListenable: widget.replyNotifier,
                              builder: (context, value, _) {
                                return Visibility(
                                  visible: !value,
                                  child: Column(
                                    children: [
                                      const Divider(thickness: 1.5, height: 0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 8.0,
                                        ),
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: CircleAvatar(
                                                backgroundColor: Colors.grey,
                                                maxRadius: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 16,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white12,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: const Text(
                                                  'Add a comment...',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                      SlideTransition(
                        position: _repliesSlideAnimation,
                        child: Material(
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return const CommentTile(
                                          showReplies: false);
                                    }
                                    return const ReplyTile();
                                  },
                                  itemCount: 20,
                                ),
                              ),
                              const Divider(thickness: 1.5, height: 0),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        maxRadius: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'Add a reply...',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                ),
                              )
                            ],
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
