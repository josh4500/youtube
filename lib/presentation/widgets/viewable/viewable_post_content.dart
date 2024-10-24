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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../account_avatar.dart';
import '../dynamic_sheet.dart';
import '../gestures/custom_ink_well.dart';
import '../gestures/tappable_area.dart';
import 'context/viewable_answer_context.dart';
import 'context/viewable_image_context.dart';
import 'context/viewable_playlist_context.dart';
import 'context/viewable_slides_context.dart';
import 'context/viewable_video_context.dart';
import 'context/viewable_vote_context.dart';

class ViewablePostContent extends StatelessWidget {
  const ViewablePostContent({super.key, this.onMore});
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    // TODO(Josh): Be able to hide more button

    return Column(
      children: <Widget>[
        const Divider(thickness: .92, height: 0),
        Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
            top: 8.0,
            bottom: 8.0,
          ),
          child: Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(6.0),
                child: AccountAvatar(size: 36),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'ByteByteGo',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          text: '42 minutes ago',
                          children: [TextSpan(text: ' (edited)')],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomInkWell(
                onTap: onMore ??
                    () {
                      showDynamicSheet(
                        context,
                        items: [
                          const DynamicSheetOptionItem(
                            leading: Icon(YTIcons.report_outlined),
                            title: 'Report',
                          ),
                          const DynamicSheetOptionItem(
                            leading: Icon(YTIcons.not_interested_outlined),
                            title: 'Not interested',
                          ),
                          const DynamicSheetOptionItem(
                            leading: Icon(YTIcons.not_interested_outlined),
                            title: 'Don\'t recommend posts from channel',
                            dependents: [DynamicSheetItemDependent.auth],
                          ),
                        ],
                      );
                    },
                canRequestFocus: false,
                padding: const EdgeInsets.all(8.0),
                borderRadius: BorderRadius.circular(32),
                child: const Icon(YTIcons.more_vert_outlined),
              ),
            ],
          ),
        ),
        TappableArea(
          onTap: () {},
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2),
          child: const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'We are often asked to design for high availability, high scalability, and high throughput. What ',
            ),
          ),
        ),
        const SizedBox(height: 4),
        const [
          ViewableVoteContext(),
          ViewableImageContext(),
          ViewableVideoContext(),
          ViewableSlidesContext(),
          ViewableAnswerContext(),
          ViewablePlaylistContext(),
        ][Random().nextInt(6)],
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: <Widget>[
              TappableArea(
                onTap: () {},
                padding: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(32),
                child: const Icon(YTIcons.like_outlined),
              ),
              const Text('104', maxLines: 1, overflow: TextOverflow.clip),
              const SizedBox(width: 24),
              CustomInkWell(
                onTap: () {},
                splashFactory: NoSplash.splashFactory,
                padding: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(32),
                child: const Icon(YTIcons.dislike_outlined),
              ),
              const Spacer(),
              TappableArea(
                onTap: () {},
                padding: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(32),
                child: const Icon(YTIcons.share_outlined),
              ),
              const SizedBox(width: 12),
              TappableArea(
                onTap: () {},
                child: const Row(
                  children: [
                    Icon(YTIcons.comments_outlined),
                    SizedBox(width: 8),
                    Text('2'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
