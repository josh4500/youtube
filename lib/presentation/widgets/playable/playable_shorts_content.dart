import 'package:flutter/material.dart';

class PlayableShortsContent extends StatelessWidget {
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const PlayableShortsContent({
    super.key,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: width,
              height: height,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white12,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 4,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.more_vert_sharp,
                        size: 14,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: const Text(
                        'mappa animators making',
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
