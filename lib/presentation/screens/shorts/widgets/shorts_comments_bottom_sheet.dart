import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class ShortsCommentsBottomSheet extends StatefulWidget {
  const ShortsCommentsBottomSheet({
    super.key,
    required this.controller,
    required this.closeComment,
    required this.replyController,
    required this.draggableController,
  });
  final ScrollController controller;
  final VoidCallback closeComment;
  final PageDraggableOverlayChildController replyController;
  final DraggableScrollableController draggableController;

  @override
  State<ShortsCommentsBottomSheet> createState() =>
      _ShortsCommentsBottomSheetState();
}

class _ShortsCommentsBottomSheetState extends State<ShortsCommentsBottomSheet> {
  Completer<bool> replyCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    return PageDraggableSheet(
      title: 'Comments',
      trailingTitle: '7.1k',
      scrollTag: 'short_comments',
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      controller: widget.controller,
      onClose: widget.closeComment,
      showDragIndicator: true,
      draggableController: widget.draggableController,
      actions: <Widget>[
        TappableArea(
          onTapDown: (TapDownDetails details) {
            showMenu(
              context: context,
              menuPadding: EdgeInsets.zero,
              position: RelativeRect.fromLTRB(
                details.globalPosition.dx,
                // Size of icon plus top and half padding
                details.globalPosition.dy - (46),
                52, // Size of icon plus horizontal padding
                0,
              ),
              initialValue: 'Top comments',
              items: <PopupMenuEntry>[
                const PopupMenuItem(
                  value: 'Top comments',
                  padding: EdgeInsets.only(left: 12, right: 64),
                  child: Text('Top comments'),
                ),
                const PopupMenuItem(
                  value: 'Newest first',
                  padding: EdgeInsets.only(left: 12, right: 64),
                  child: Text('Newest first'),
                ),
              ],
            );
          },
          padding: const EdgeInsets.symmetric(horizontal: 8),
          releasedColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashFactory: InkSplash.splashFactory,
          child: const Icon(YTIcons.tune_outlined),
        ),
      ],
      contentBuilder: (
        BuildContext context,
        ScrollController scrollController,
        CustomScrollableScrollPhysics scrollPhysics,
      ) {
        return ListView.builder(
          physics: scrollPhysics,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) {
            return CommentTile(
              pinned: index == 0,
              creatorLikes: index == 0,
              openReply: widget.replyController.open,
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
      onOpenOverlayChild: (int index) {
        replyCompleter = Completer();
        replyCompleter.complete(
          Future.delayed(const Duration(seconds: 5), () => true),
        );
      },
      overlayChildren: [
        PageDraggableOverlayChild(
          controller: widget.replyController,
          builder: (context, controller, physics) {
            return FutureBuilder<bool>(
              future: replyCompleter.future,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.data == false) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
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
                      ),
                    ),
                    // const SingleChildScrollView(
                    //   reverse: true,
                    //   child: IntrinsicHeight(
                    //     child: CommentTextFieldPlaceholder(isReply: true),
                    //   ),
                    // ),
                  ],
                );
              },
            );
          },
        ),
      ],
      baseHeight: 0.68,
    );
  }
}
