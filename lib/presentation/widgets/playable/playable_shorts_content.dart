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
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../gestures/tappable_area.dart';
import '../network_image/custom_network_image.dart';

class PlayableShortsContent extends StatelessWidget {
  const PlayableShortsContent({
    super.key,
    this.width,
    this.height,
    this.margin,
    this.onTap,
    this.onMore,
  });

  final double? width, height;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final shorts = context.provide<ShortsViewModel>();
    final PlayableStyle theme = context.theme.appStyles.playableStyle;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 4,
        ),
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: theme.borderRadius,
          image: const DecorationImage(
            image: CustomNetworkImage('https://picsum.photos/250/300'),
            fit: BoxFit.cover,
          ),
          color: theme.backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Transform.translate(
                offset: const Offset(8, -8),
                child: TappableArea(
                  onTap: onMore,
                  canRequestFocus: false,
                  focusColor: Colors.transparent,
                  padding: const EdgeInsets.all(8),
                  releasedColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: const Icon(
                    YTIcons.more_vert_outlined,
                    size: 18,
                    color: Colors.white,
                    shadows: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(4),
              child: Text(
                shorts.title,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  shadows: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
