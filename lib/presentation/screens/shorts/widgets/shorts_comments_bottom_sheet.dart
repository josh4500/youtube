import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class ShortsCommentsBottomSheet extends StatefulWidget {
  const ShortsCommentsBottomSheet({
    super.key,
    required this.controller,
    required this.replyNotifier,
    required this.closeComment,
    required this.draggableController,
  });
  final ScrollController controller;
  final ValueNotifier<bool> replyNotifier;
  final VoidCallback closeComment;
  final DraggableScrollableController draggableController;

  @override
  State<ShortsCommentsBottomSheet> createState() =>
      _ShortsCommentsBottomSheetState();
}

class _ShortsCommentsBottomSheetState extends State<ShortsCommentsBottomSheet> {
  final _replyController = PageDraggableOverlayChildController(
    title: 'Replies',
  );

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageDraggableSheet(
      title: 'Comment',
      subtitle: '16k',
      scrollTag: 'short_comment',
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      controller: widget.controller,
      onClose: widget.closeComment,
      showDragIndicator: true,
      draggableController: widget.draggableController,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(maxHeight: 24),
            icon: const Icon(YTIcons.tune_outlined, size: 24),
          ),
        ),
      ],
      contentBuilder: (
        BuildContext context,
        ScrollController scrollController,
        CustomScrollableScrollPhysics scrollPhysics,
      ) {
        return Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                physics: scrollPhysics,
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return CommentTile(
                    openReply: () {},
                  );
                },
                itemCount: 20,
              ),
            ),
            // TODO(Josh): Fix CommentTextFieldPlaceholder overflow issues
            // ValueListenableBuilder(
            //   valueListenable: replyNotifier,
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
      overlayChildren: [
        PageDraggableOverlayChild(
          controller: _replyController,
          builder: (context, controller, physics) {
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
        ),
      ],
      baseHeight: 0.68,
    );
  }
}
