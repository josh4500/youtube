import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/comment_tile.dart';
import 'package:youtube_clone/presentation/widgets/page_draggable_sheet.dart';

import '../../../widgets/comment_textfield_placeholder.dart';

class ShortsCommentsBottomSheet extends StatelessWidget {
  final ScrollController controller;
  final ValueNotifier<bool> replyNotifier;
  final VoidCallback closeComment;
  final DraggableScrollableController draggableController;
  const ShortsCommentsBottomSheet({
    super.key,
    required this.controller,
    required this.replyNotifier,
    required this.closeComment,
    required this.draggableController,
  });

  @override
  Widget build(BuildContext context) {
    return PageDraggableSheet(
      title: 'Comment',
      subtitle: '16k',
      scrollTag: 'short_comment',
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      controller: controller,
      onClose: closeComment,
      showDragIndicator: true,
      draggableController: draggableController,
      actions: [
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(32),
          child: const Icon(Icons.tune_outlined, size: 24),
        ),
      ],
      contentBuilder: (context, scrollController, scrollPhysics) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: scrollPhysics,
                controller: scrollController,
                itemBuilder: (context, index) {
                  return CommentTile(
                    openReply: () {},
                  );
                },
                itemCount: 20,
              ),
            ),
            // TODO: Fix CommentTextFieldPlaceholder overflow issues
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
      baseHeight: 0.68,
    );
  }
}

// PageDraggableOverlayChildItem(
//   title: 'Reply',
//   listenable: widget.replyNotifier,
//   builder: (context) {
//     return Material(
//       child: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemBuilder: (context, index) {
//                 if (index == 0) {
//                   return const CommentTile(showReplies: false);
//                 }
//                 return const ReplyTile();
//               },
//               itemCount: 20,
//             ),
//           ),
//           const CommentTextFieldPlaceholder(isReply: true),
//         ],
//       ),
//     );
//   },
// ),
