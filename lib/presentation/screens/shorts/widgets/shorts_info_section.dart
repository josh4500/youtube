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
import 'package:youtube_clone/presentation/widgets/channel_avatar.dart';

import 'shorts_audio_button.dart';
import 'shorts_context_info.dart';

class ShortsInfoSection extends StatelessWidget {
  final VoidCallback onTapComment;
  const ShortsInfoSection({super.key, required this.onTapComment});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(
                    16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(32),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              32,
                            ),
                            color: Colors.black45,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text('New york'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const ChannelAvatar(size: 32),
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
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(Icons.arrow_right_sharp),
                          SizedBox(width: 4),
                          Text(
                            'Posted content will be found here if clicked',
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
                        children: [
                          Icon(Icons.music_note_outlined),
                          SizedBox(width: 8),
                          Text('Original Sound'),
                          SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SomeWidget(
                    title: const Icon(
                      Icons.thumb_up_sharp,
                      size: 32,
                    ),
                    summary: '196k',
                    onTap: () {},
                  ),
                  SomeWidget(
                    title: const Icon(
                      Icons.thumb_down_sharp,
                      size: 32,
                    ),
                    summary: 'Dislike',
                    onTap: () {},
                  ),
                  SomeWidget(
                    title: const Icon(
                      Icons.comment,
                      size: 32,
                    ),
                    summary: '1.2k',
                    onTap: onTapComment,
                  ),
                  SomeWidget(
                    title: const Icon(
                      Icons.reply,
                      size: 32,
                    ),
                    summary: 'Share',
                    onTap: () {},
                  ),
                  SomeWidget(
                    title: const Icon(
                      Icons.recycling,
                      size: 32,
                    ),
                    summary: 'Remix',
                    onTap: () {},
                  ),
                  const ShortsAudioButton()
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const ShortsContextInfo()
      ],
    );
  }
}

class SomeWidget extends StatelessWidget {
  final Widget title;
  final String summary;
  final VoidCallback onTap;

  const SomeWidget({
    super.key,
    required this.title,
    required this.summary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(64),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(64),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
            child: Column(
              children: [
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
      ),
    );
  }
}
