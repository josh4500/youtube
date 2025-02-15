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

class VideoChannelContext extends StatelessWidget {
  const VideoChannelContext({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(josh4500): This space should between videoChannelSection and VideoActions if no context
    // return const SizedBox(height: 8);
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 12),
      decoration: BoxDecoration(
        color: context.theme.highlightColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: 'TRT is a Turkish public broadcast service. ',
                children: [
                  TextSpan(
                    text: 'Wikipedia ',
                    children: const [
                      IconSpan(YTIcons.external_link_outlined),
                    ],
                    style: TextStyle(
                      fontSize: 12,
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                ],
                style: TextStyle(
                  fontSize: 12,
                  color: context.theme.colorScheme.surface,
                ),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(width: 24),
          CustomInkWell(
            onTap: () {
              showDynamicSheet(
                context,
                items: [
                  const DynamicSheetOptionItem(
                    leading: Icon(YTIcons.info_outlined),
                    title: 'Why am I seeing thhis?',
                  ),
                  const DynamicSheetOptionItem(
                    leading: Icon(YTIcons.feedbck_outlined),
                    title: 'Send feedback',
                  ),
                ],
              );
            },
            splashFactory: NoSplash.splashFactory,
            padding: const EdgeInsets.all(4),
            child: const Icon(YTIcons.more_vert_outlined, size: 16),
          ),
        ],
      ),
    );
  }
}
