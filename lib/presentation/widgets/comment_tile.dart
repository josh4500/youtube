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
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

class CommentTile extends StatelessWidget {
  final bool showReplies;
  final VoidCallback? openReply;
  const CommentTile({super.key, this.showReplies = true, this.openReply});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TappableArea(
          onPressed: openReply,
          padding: const EdgeInsets.all(16),
          stackedAlignment: Alignment.topRight,
          stackedChild: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(32),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(
                Icons.more_vert_sharp,
                size: 16,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.grey,
                maxRadius: 16,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RichText(
                            text: const TextSpan(
                              text: '@BussyBoyBonanza',
                              children: [
                                TextSpan(text: ' · '),
                                TextSpan(text: '7mo ago'),
                              ],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Cutting fundig on precautions is going to cost more in the long run',
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Icon(
                            Icons.thumb_up_outlined,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          SizedBox(
                            width: 42,
                            child: Text(
                              '69',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Icon(
                            Icons.thumb_down_outlined,
                            size: 14,
                          ),
                          SizedBox(width: 48),
                          Icon(
                            Icons.comment_outlined,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
        if (showReplies) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 52),
              TappableArea(
                onPressed: openReply,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: const Text(
                  '107 Replies',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
