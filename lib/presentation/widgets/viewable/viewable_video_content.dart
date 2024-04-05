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
import 'package:youtube_clone/presentation/widgets/shimmer.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

import '../account_avatar.dart';
import '../network_image/custom_network_image.dart';
import '../player/playback/playback_view.dart';

class ViewableVideoContent extends StatelessWidget {
  const ViewableVideoContent({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        TappableArea(
          onPressed: onTap,
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 227,
                width: double.infinity,
                child: PlaybackView(
                  placeholder: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF656565),
                      image: DecorationImage(
                        image: CustomNetworkImage(
                          'https://picsum.photos/900/500',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(width: 44),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 4,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  'Future, Metro BoomIn - Like That (Official Audio)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFF1F1F1),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: <Widget>[
                                    RichText(
                                      text: const TextSpan(
                                        text: 'Future',
                                        children: <InlineSpan>[
                                          TextSpan(text: ' · '),
                                          TextSpan(text: '1.8M views'),
                                          TextSpan(text: ' · '),
                                          TextSpan(text: '1 day ago'),
                                        ],
                                        style: TextStyle(
                                          color: Color(0xFFAAAAAA),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
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
                        ),
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
          top: 227,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 4,
            ),
            child: AccountAvatar(
              size: 36,
              name: 'John Jackson',
            ),
          ),
        ),
        Positioned(
          right: 9.5,
          top: 227,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  YTIcons.more_vert_outlined,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget shimmer() {
    return Column(
      children: <Widget>[
        const Shimmer(
          height: 227,
          width: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Shimmer(width: 36, height: 36, shape: BoxShape.circle),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Shimmer(
                      width: double.infinity,
                      height: 16,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                    const SizedBox(height: 15),
                    Shimmer(
                      width: double.infinity,
                      height: 16,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                    const SizedBox(height: 15),
                    Shimmer(
                      width: 120,
                      height: 16,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                    const SizedBox(height: 12),
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
