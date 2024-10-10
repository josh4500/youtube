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
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../gestures/tappable_area.dart';
import '../network_image/custom_network_image.dart';

class PlayableLiveContent extends StatelessWidget {
  const PlayableLiveContent({
    super.key,
    this.width,
    this.height,
    this.direction = Axis.horizontal,
    this.margin,
    this.completed = false,
    this.onMore,
  });
  final Axis direction;
  final EdgeInsets? margin;
  final bool completed;

  // TODO(Josh): rename width and height
  final double? width;
  final double? height;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    // TODO(josh4500): Add bool to hide live/duration indicator
    // TODO(josh4500): Can be completed or upcoming or currently live
    final PlayableStyle theme = context.theme.appStyles.playableStyle;
    return Container(
      margin: margin,
      child: Flex(
        direction: direction,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: direction == Axis.vertical ? 1 : 0,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
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
                    color: completed ? Colors.black54 : AppPalette.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: completed
                      ? const Text(
                          '2:06:14',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const Row(
                          children: [
                            Icon(
                              YTIcons.live_outlined,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'LIVE',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
          if (direction == Axis.vertical)
            SizedBox(height: 8.h)
          else
            SizedBox(width: 16.w),
          Flexible(
            flex: direction == Axis.vertical ? 0 : 1,
            child: SizedBox(
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
                          'LIVE: NBC News NOW',
                          maxLines: direction == Axis.horizontal ? 3 : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'NBC News',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Text.rich(
                          TextSpan(
                            text: '',
                            children: [
                              if (completed)
                                const TextSpan(text: '7.6K views')
                              else
                                const TextSpan(text: '11k watching'),
                              if (completed) ...[
                                const TextSpan(text: kDotSeparator),
                                const TextSpan(text: 'Streamed 2 days ago'),
                                const TextSpan(text: kDotSeparator),
                                // const TextSpan(text: ' 7.6K views '),
                              ],
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Transform.translate(
                    offset: const Offset(8, -8),
                    child: TappableArea(
                      onTap: onMore,
                      canRequestFocus: false,
                      focusColor: Colors.transparent,
                      padding: const EdgeInsets.all(8),
                      borderRadius: BorderRadius.circular(16),
                      child: const Icon(YTIcons.more_vert_outlined, size: 16),
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
