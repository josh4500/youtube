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

import 'account_avatar.dart';
import 'comment_tile.dart';
import 'dynamic_sheet.dart';
import 'gestures/tappable_area.dart';

class ReplyTile extends StatelessWidget {
  const ReplyTile({super.key, this.creatorLikes = false});

  final bool creatorLikes;
  @override
  Widget build(BuildContext context) {
    return TappableArea(
      onTap: () {},
      highlightColor: Colors.white10,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(width: 44),
          TappableArea(
            onTap: () => showCommenterProfile(context),
            releasedColor: Colors.transparent,
            padding: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(24),
            child: const AccountAvatar(size: 24),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: const TextSpan(
                      text: '@BussyBoyBonanza',
                      children: <InlineSpan>[
                        TextSpan(text: kDotSeparator),
                        TextSpan(text: '7mo ago'),
                      ],
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Text('OMG This is so fun 😂'),
                  const SizedBox(height: 16),
                  Transform.translate(
                    offset: const Offset(-8, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TappableArea(
                          onTap: () {},
                          releasedColor: Colors.transparent,
                          padding: const EdgeInsets.all(8),
                          borderRadius: BorderRadius.circular(24),
                          child: const Icon(YTIcons.like_outlined, size: 18),
                        ),
                        const SizedBox(
                          width: 24,
                          child: Text(
                            '7',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        TappableArea(
                          onTap: () {},
                          releasedColor: Colors.transparent,
                          padding: const EdgeInsets.all(8),
                          borderRadius: BorderRadius.circular(24),
                          child: const Icon(YTIcons.dislike_outlined, size: 18),
                        ),
                        const SizedBox(width: 16),
                        if (creatorLikes)
                          TappableArea(
                            onTap: () {},
                            releasedColor: Colors.transparent,
                            padding: const EdgeInsets.all(8),
                            borderRadius: BorderRadius.circular(24),
                            child: const Stack(
                              clipBehavior: Clip.none,
                              children: [
                                AccountAvatar(size: 18),
                                Positioned(
                                  top: 9,
                                  left: 9,
                                  child: Icon(
                                    YTIcons.heart_filled,
                                    size: 14,
                                    color: Color(0xFFFF0000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          TappableArea(
            onTap: () => showReplyOption(context),
            releasedColor: Colors.transparent,
            highlightColor: Colors.transparent,
            padding: const EdgeInsets.all(16.0),
            borderRadius: BorderRadius.circular(32),
            child: const Icon(YTIcons.more_vert_outlined, size: 16),
          ),
        ],
      ),
    );
  }

  void showReplyOption(BuildContext context) {
    showDynamicSheet(
      context,
      title: const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12.0,
        ),
        child: Text(
          'Comment',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      items: <DynamicSheetItem>[
        const DynamicSheetOptionItem(
          leading: Icon(YTIcons.reply_outlined),
          title: 'Reply',
        ),
        const DynamicSheetOptionItem(
          leading: Icon(YTIcons.report_outlined),
          title: 'Report',
        ),
      ],
    );
  }
}
