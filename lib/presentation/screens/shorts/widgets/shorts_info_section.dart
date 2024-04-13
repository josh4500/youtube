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
import 'package:youtube_clone/presentation/widgets.dart';
import 'package:youtube_clone/presentation/widgets/account_avatar.dart';

import 'shorts_audio_button.dart';
import 'shorts_context_info.dart';

class ShortsInfoSection extends StatelessWidget {
  const ShortsInfoSection({super.key, required this.onTapComment});
  final VoidCallback onTapComment;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ...<Widget>[
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.black45,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(YTIcons.paid_promotion_outlined),
                                SizedBox(width: 4),
                                Text(
                                  'Includes Paid Promotions',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 4),
                                Icon(YTIcons.chevron_right, size: 14),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      ...<Widget>[
                        CustomInkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(32),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              color: Colors.black45,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(YTIcons.place_outlined, size: 18),
                                SizedBox(width: 4),
                                Text('New york'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        children: <Widget>[
                          const AccountAvatar(size: 32, name: 'John Jackson'),
                          const SizedBox(width: 8),
                          const Text('@maxymilliano'),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: const Text(
                              'Subscribe',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: <Widget>[
                          Icon(Icons.arrow_right_sharp),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Posted content will be found here if clicked',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'These 2 controversial ads use the same psychological trick 🤯 #shorts',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: <Widget>[
                          Icon(YTIcons.music_outlined),
                          SizedBox(width: 8),
                          Text('Original Sound'),
                          SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ShortsActionButton(
                    title: const Icon(YTIcons.shorts_like_filled, size: 32),
                    summary: '196k',
                    onTap: () {},
                  ),
                  ShortsActionButton(
                    title: const Icon(YTIcons.shorts_dislike_filled, size: 32),
                    summary: 'Dislike',
                    onTap: () {},
                  ),
                  ShortsActionButton(
                    title: const Icon(YTIcons.shorts_comment_filled, size: 32),
                    summary: '1.2k',
                    onTap: onTapComment,
                  ),
                  ShortsActionButton(
                    title: const Icon(YTIcons.shorts_share_filled, size: 32),
                    summary: 'Share',
                    onTap: () {},
                  ),
                  ShortsActionButton(
                    title: const Icon(Icons.recycling, size: 32),
                    summary: 'Remix',
                    onTap: () {},
                  ),
                  const ShortsAudioButton(),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const ShortsContextInfo(),
      ],
    );
  }
}

class ShortsActionButton extends StatelessWidget {
  const ShortsActionButton({
    super.key,
    required this.title,
    required this.summary,
    required this.onTap,
  });
  final Widget title;
  final String summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(64),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: CustomInkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(64),
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
          child: Column(
            children: <Widget>[
              title,
              const SizedBox(height: 8),
              Text(
                summary,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
