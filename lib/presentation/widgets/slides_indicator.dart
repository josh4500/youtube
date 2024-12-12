import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

class SlidesIndicator extends StatelessWidget {
  const SlidesIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
  });

  final int currentPage;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(pageCount, (index) {
        return Container(
          width: 6,
          height: 6,
          margin: index != pageCount - 1
              ? const EdgeInsets.only(right: 4)
              : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: currentPage == index
                ? context.theme.colorScheme.surface
                : context.theme.colorScheme.surface.withValues(alpha: .1),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
