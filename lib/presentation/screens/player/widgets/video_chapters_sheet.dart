import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets.dart';
import 'package:youtube_clone/presentation/widgets/page_draggable_sheet.dart';

import '../../../constants.dart';

class VideoChaptersSheet extends StatefulWidget {
  final ScrollController controller;
  final VoidCallback closeChapter;
  final DraggableScrollableController draggableController;

  const VideoChaptersSheet({
    super.key,
    required this.controller,
    required this.closeChapter,
    required this.draggableController,
  });

  @override
  State<VideoChaptersSheet> createState() => _VideoChaptersSheetState();
}

class _VideoChaptersSheetState extends State<VideoChaptersSheet> {
  @override
  Widget build(BuildContext context) {
    return PageDraggableSheet(
      title: 'Chapters',
      scrollTag: 'player_chapters',
      controller: widget.controller,
      onClose: widget.closeChapter,
      showDragIndicator: true,
      draggableController: widget.draggableController,
      contentBuilder: (context, controller, physics) {
        return ListView.builder(
          physics: physics,
          controller: controller,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const ChapterTile(
                selected: true,
              );
            }
            return const ChapterTile();
          },
          itemCount: 6,
        );
      },
      baseHeight: 1 - avgVideoViewPortHeight,
    );
  }
}

class ChapterTile extends StatelessWidget {
  final bool selected;

  const ChapterTile({super.key, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: selected ? Colors.white10 : Colors.transparent,
      child: TappableArea(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        borderRadius: BorderRadius.zero,
        child: Row(
          children: [
            Container(
              width: 160,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: CustomNetworkImage('https://picsum.photos/900/500'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Intro',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (selected)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(Icons.reply_outlined, size: 32),
                              SizedBox(width: 18),
                              Icon(Icons.repeat, size: 32),
                            ],
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '1:04',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
