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

class PlayableVideoContent extends StatelessWidget {
  const PlayableVideoContent({
    super.key,
    this.width,
    this.height,
    this.direction = Axis.horizontal,
    this.margin,
    this.onMore,
  });
  final Axis direction;
  final EdgeInsets? margin;
  final VoidCallback? onMore;

  // TODO(Josh): rename width and height
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final PlayableStyle theme = context.theme.appStyles.playableStyle;

    return Flex(
      direction: direction,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          flex: direction == Axis.vertical ? 1 : 0,
          child: Container(
            margin: direction == Axis.vertical
                ? margin?.subtract(
                    EdgeInsets.only(bottom: margin?.bottom ?? 0),
                  )
                : margin?.subtract(
                    EdgeInsets.only(right: margin?.right ?? 0),
                  ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    borderRadius: theme.borderRadius,
                    image: const DecorationImage(
                      image: CustomNetworkImage(
                        'https://picsum.photos/300/300',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 4,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '6:54',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
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
            width: direction == Axis.vertical ? width : null,
            margin: direction == Axis.vertical
                ? margin?.subtract(
                    EdgeInsets.only(top: margin?.top ?? 0),
                  )
                : margin?.subtract(
                    EdgeInsets.only(left: margin?.left ?? 0),
                  ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'I found the BEST One Piece cast 2 clips from their socials',
                        maxLines: direction == Axis.horizontal ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.titleStyle,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Mobile Academy',
                        style: theme.subtitleStyle,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '11k Views',
                        style: theme.subtitleStyle,
                      ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: const Offset(14, -8),
                  child: TappableArea(
                    onTap: onMore,
                    padding: const EdgeInsets.all(8),
                    canRequestFocus: false,
                    focusColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    splashFactory: NoSplash.splashFactory,
                    child: const Icon(YTIcons.more_vert_outlined, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
