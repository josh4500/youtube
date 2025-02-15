// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../gestures/tappable_area.dart';
import '../network_image/custom_network_image.dart';

class PlayableContent extends StatelessWidget {
  const PlayableContent({
    super.key,
    this.width,
    this.height,
    this.isPlaylist = false,
    this.isPodcasts = false,
    this.direction = Axis.vertical,
    this.useTappable = true,
    this.margin,
    this.onMore,
  });

  final bool isPlaylist;
  final bool isPodcasts;

  final bool useTappable;
  final Axis direction;
  final EdgeInsets? margin;
  final VoidCallback? onMore;

  // TODO(Josh): rename width and height
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final PlayableStyle theme = context.theme.appStyles.playableStyle;
    return Container(
      margin: margin,
      child: Flex(
        direction: direction,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: direction == Axis.vertical ? 1 : 0,
            child: SizedBox(
              width: width,
              height: height,
              child: Column(
                children: <Widget>[
                  // TODO(josh4500): Refactor later
                  if (isPlaylist)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 1,
                        horizontal: 6,
                      ),
                      child: ClipPath(
                        clipper: ClipEdgeClipper(),
                        child: ColoredBox(
                          color: Colors.white60,
                          child: SizedBox(
                            width: double.infinity,
                            height: 4.2.h,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: theme.borderRadius,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: theme.backgroundColor,
                              image: const DecorationImage(
                                image: CustomNetworkImage(
                                  'https://picsum.photos/300/300',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
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
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    isPodcasts
                                        ? YTIcons.podcast_outlined
                                        : YTIcons.playlists_outlined,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 2.w),
                                  const Text(
                                    '2',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
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
          ),
          if (direction == Axis.vertical)
            SizedBox(height: 8.h)
          else
            SizedBox(width: 16.w),
          Flexible(
            flex: direction == Axis.vertical ? 0 : 1,
            child: Container(
              margin: direction == Axis.vertical
                  ? margin?.subtract(
                      EdgeInsets.only(top: margin?.top ?? 0),
                    )
                  : margin?.subtract(
                      EdgeInsets.only(left: margin?.left ?? 0),
                    ),
              width: direction == Axis.vertical ? width : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          isPlaylist
                              ? 'CNC'
                              : 'One Piece: Wano Country Arc Trailer',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.titleStyle,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isPlaylist ? 'Public . Playlist' : 'Zigalot',
                          style: theme.subtitleStyle,
                        ),
                      ],
                    ),
                  ),
                  // TODO(josh4500): Fix left space layout caused by outer paddings
                  Transform.translate(
                    offset: const Offset(12, -6),
                    child: TappableArea(
                      onTap: onMore,
                      canRequestFocus: false,
                      focusColor: Colors.transparent,
                      padding: const EdgeInsets.all(6),
                      releasedColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: const Icon(YTIcons.more_vert_outlined, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClipEdgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(0, size.height);
    path.arcToPoint(
      const Offset(8, 0),
      radius: const Radius.circular(8),
    );
    path.lineTo(size.width - 8, 0);
    path.arcToPoint(
      Offset(size.width, size.height),
      radius: const Radius.circular(8),
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
