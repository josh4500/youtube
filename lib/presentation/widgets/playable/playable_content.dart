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

class PlayableContent extends StatelessWidget {
  const PlayableContent({
    super.key,
    this.width,
    this.height,
    this.isPlaylist = false,
    this.direction = Axis.vertical,
    this.margin,
  });
  final bool isPlaylist;
  final Axis direction;
  final EdgeInsets? margin;

  // TODO(Josh): rename width and height
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Flex(
        direction: direction,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: width,
            height: height,
            child: Column(
              children: <Widget>[
                if (isPlaylist) ...<Widget>[
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
                      image: DecorationImage(
                        image: NetworkImage('https://picsum.photos/300/300'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white60,
                            image: DecorationImage(
                              image: NetworkImage(
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
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  YTIcons.playlists_outlined,
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
                children: <Widget>[
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                  const Icon(YTIcons.more_vert_outlined, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
