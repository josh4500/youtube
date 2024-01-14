// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
