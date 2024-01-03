import 'package:flutter/material.dart';

class PlayableContent extends StatelessWidget {
  final bool isPlaylist;
  final Axis direction;

  // TODO: rename width and height
  final double? width;
  final double? height;

  const PlayableContent({
    super.key,
    this.width,
    this.height,
    this.isPlaylist = false,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          height: height,
          child: Column(
            children: [
              if (isPlaylist) ...[
                Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(
                    vertical: 1,
                    horizontal: 6,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(16, 8),
                      topRight: Radius.elliptical(16, 8),
                    ),
                  ),
                ),
              ],
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        color: Colors.white38,
                      ),
                      if (isPlaylist)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 4,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.playlist_play,
                                size: 18,
                              ),
                              SizedBox(width: 2),
                              Text(
                                '2',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (direction == Axis.vertical)
          const SizedBox(height: 8)
        else
          const SizedBox(width: 16),
        Flexible(
          child: SizedBox(
            width: width,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CNC',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Public . Playlist',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                if (direction == Axis.vertical)
                  const SizedBox(height: 8)
                else
                  const SizedBox(width: 8),
                const Icon(Icons.more_vert_outlined),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
