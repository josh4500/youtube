import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../../../constants.dart';

class VideoChaptersSheet extends StatefulWidget {
  const VideoChaptersSheet({
    super.key,
    this.controller,
    this.draggableController,
  });
  final ScrollController? controller;
  final DraggableScrollableController? draggableController;

  @override
  State<VideoChaptersSheet> createState() => _VideoChaptersSheetState();
}

class _VideoChaptersSheetState extends State<VideoChaptersSheet> {
  @override
  Widget build(BuildContext context) {
    return PageDraggableSheet(
      title: 'Chapters',
      controller: widget.controller ?? ScrollController(),
      showDragIndicator: true,
      draggableController: widget.draggableController,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
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
      baseHeight: 1 - kAvgVideoViewPortHeight,
    );
  }
}

class ChapterTile extends StatelessWidget {
  const ChapterTile({super.key, this.selected = false});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: selected ? Colors.white10 : Colors.transparent,
      child: TappableArea(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 12,
        ),
        child: Row(
          children: [
            Container(
              width: 160,
              height: 88,
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
                              Icon(YTIcons.reply_outlined, size: 32),
                              SizedBox(width: 18),
                              Icon(YTIcons.loop_outlined, size: 32),
                            ],
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.theme.primaryColor.withValues(
                            alpha: 0.2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '1:04',
                          style: TextStyle(
                            color: context.theme.primaryColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
