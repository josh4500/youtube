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

import '../gestures/custom_ink_well.dart';
import '../network_image/custom_network_image.dart';

class ViewableShortsContent extends StatelessWidget {
  const ViewableShortsContent({
    super.key,
    this.width,
    this.margin,
    this.borderRadius,
    this.showTitle = true,
    this.onMore,
  });
  final double? width;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final bool showTitle;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final shorts = context.provide<ShortsViewModel>();
    final ViewableStyle theme = context.theme.appStyles.viewableVideoStyle;
    return Container(
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: borderRadius,
        image: const DecorationImage(
          image: CustomNetworkImage('https://picsum.photos/400/900'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: CustomInkWell(
              onTap: onMore,
              canRequestFocus: false,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
              child: const Icon(
                YTIcons.more_vert_outlined,
                size: 20,
                color: Colors.white,
                shadows: [
                  BoxShadow(
                    offset: Offset(2, 2),
                    color: Colors.black12,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (showTitle)
                  Text(
                    shorts.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        BoxShadow(
                          offset: Offset(2, 2),
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                // TODO(josh4500): Needs counter extension;
                Text(
                  '${shorts.views} views',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    shadows: [
                      BoxShadow(
                        offset: Offset(2, 2),
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
