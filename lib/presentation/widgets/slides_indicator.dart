import 'package:flutter/material.dart';

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
          margin:
              index != pageCount - 1 ? const EdgeInsets.only(right: 4) : null,
          decoration: BoxDecoration(
            color: currentPage == index ? Colors.white : Colors.white12,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
