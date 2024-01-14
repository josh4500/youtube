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

import '../channel_avatar.dart';
import '../player/playback/playback_view.dart';

class ViewableVideoContent extends StatelessWidget {
  final VoidCallback? onTap;

  const ViewableVideoContent({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TappableArea(
          onPressed: onTap,
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              SizedBox(
                height: 208,
                child: PlaybackView(
                  placeholder: Container(
                    color: Colors.blue,
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 4,
                          ),
                          child: Visibility(
                            visible: false,
                            maintainSize: true,
                            maintainState: true,
                            maintainAnimation: true,
                            child: ChannelAvatar(),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 4,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Japan stocks: a minute\'s silence, then a slide | REUTERS',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    RichText(
                                      text: const TextSpan(
                                        text: 'REUTERS',
                                        children: [
                                          TextSpan(text: ' · '),
                                          TextSpan(text: '309 views'),
                                          TextSpan(text: ' · '),
                                          TextSpan(text: '1 hour ago'),
                                        ],
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 2,
                          ),
                          child: SizedBox(
                            width: 32,
                            height: 24,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Positioned(
          left: 8,
          bottom: 16,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 4,
            ),
            child: ChannelAvatar(),
          ),
        ),
        Positioned(
          right: 12,
          bottom: 48,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.more_vert_sharp,
                  size: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
