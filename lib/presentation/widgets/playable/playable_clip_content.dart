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
import 'package:youtube_clone/presentation/widgets/clip_thumb_clipper.dart';

class PlayableClipContent extends StatelessWidget {
  const PlayableClipContent({
    super.key,
    this.width,
    this.height,
  });
  // TODO(Josh): rename width and height
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            ClipPath(
              clipper: ClipThumbClipper(),
              child: Container(
                width: width,
                height: height,
                color: Colors.white,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 6,
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
                    Icons.content_cut_outlined,
                    size: 13,
                  ),
                  SizedBox(width: 2),
                  Text(
                    '1:04',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        const Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Lazy loading',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      'from Flutter',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Clipped 3 months ago',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Icon(YTIcons.more_vert_outlined),
            ],
          ),
        ),
      ],
    );
  }
}
