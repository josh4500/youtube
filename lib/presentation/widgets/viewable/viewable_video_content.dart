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

import '../account_avatar.dart';
import '../gestures/tappable_area.dart';
import '../network_image/custom_network_image.dart';
import '../player/playback/playback_view.dart';
import '../shimmer.dart';

class ViewableVideoContent extends StatelessWidget {
  const ViewableVideoContent({super.key, this.onTap, this.onMore});
  final VoidCallback? onTap;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final ViewableStyle theme = context.theme.appStyles.viewableVideoStyle;
    return TappableArea(
      onTap: onTap,
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints.expand(
              height: 252.h,
            ),
            child: PlaybackView(
              placeholder: Container(
                decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  image: const DecorationImage(
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
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TappableArea(
                      onTap: () {},
                      containedInkWell: true,
                      highlightColor: Colors.transparent,
                      padding: const EdgeInsets.all(4),
                      borderRadius: BorderRadius.circular(36),
                      releasedColor: Colors.transparent,
                      child: const AccountAvatar(
                        size: 36,
                        name: 'John Jackson',
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Future, Metro BoomIn - Like That (Official Audio)',
                              style: theme.titleStyle,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    text: 'Future',
                                    children: const <InlineSpan>[
                                      TextSpan(
                                        text: kDotSeparator,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(text: '1.8M views'),
                                      TextSpan(
                                        text: kDotSeparator,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(text: '1 day ago'),
                                    ],
                                    style: theme.subtitleStyle,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -6),
                      child: TappableArea(
                        onTap: onMore,
                        padding: const EdgeInsets.all(8.0),
                        borderRadius: BorderRadius.circular(32),
                        canRequestFocus: false,
                        focusColor: Colors.transparent,
                        releasedColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        containedInkWell: true,
                        splashFactory: InkSplash.splashFactory,
                        child: const Icon(
                          YTIcons.more_vert_outlined,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget shimmer() {
    return Column(
      children: <Widget>[
        Shimmer(
          height: 252.h,
          width: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Shimmer(width: 36.w, height: 36.w, shape: BoxShape.circle),
              SizedBox(width: 12.w),
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
                      width: 120.w,
                      height: 16.h,
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
