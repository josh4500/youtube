import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class ShortsCommentsBottomSheet extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return PageDraggableSheet(
      title: 'Comments',
      subtitle: '7.1k',
      scrollTag: 'short_comments',
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      controller: controller,
      onClose: closeComment,
      showDragIndicator: true,
      draggableController: draggableController,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(maxHeight: 28),
            icon: const Icon(YTIcons.tune_outlined),
          ),
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
              openReply: replyController.open,
            );
          },
          itemCount: 20,
        );
      },
      bottom: ListenableBuilder(
        listenable: replyController,
        builder: (context, _) {
          return Visibility(
            visible: !replyController.isOpened,
            child: const CommentTextFieldPlaceholder(),
          );
        },
      ),
      overlayChildren: [
        PageDraggableOverlayChild(
          controller: replyController,
          builder: (context, controller, physics) {
            return FutureBuilder<bool>(
              initialData: false,
              future: Future.delayed(const Duration(seconds: 2), () => true),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == false) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  controller: controller,
                  physics: physics,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const CommentTile(
                        showReplies: false,
                        backgroundColor: Color(0xFF272727),
                      );
                    }
                    return const ReplyTile();
                  },
                  itemCount: 20,
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
