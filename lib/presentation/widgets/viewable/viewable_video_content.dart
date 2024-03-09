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
                height: 227,
                child: PlaybackView(
                  placeholder: Container(
                    color: const Color(0xFF656565),
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
                        const SizedBox(width: 44),
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
                                const SizedBox(height: 6),
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
                                const SizedBox(height: 6),
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
          bottom: 32,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 4,
            ),
            child: ChannelAvatar(size: 36),
          ),
        ),
        Positioned(
          right: 9.5,
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
