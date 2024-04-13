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
import 'package:youtube_clone/presentation/constants/assets.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets/account_avatar.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

import '../custom_ink_well.dart';
import '../dynamic_sheet.dart';
import '../network_image/custom_network_image.dart';

class ViewablePostContent extends StatelessWidget {
  const ViewablePostContent({super.key, this.onMore});
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    // TODO(Josh): Be able to hide more button
    return Column(
      children: <Widget>[
        const Divider(thickness: 1.5, height: 0),
        Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
            top: 8.0,
            bottom: 8.0,
          ),
          child: Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(6.0),
                child: AccountAvatar(size: 42),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'ByteByteGo',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '42 minutes ago',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomInkWell(
                onTap: onMore ??
                    () {
                      showDynamicSheet(
                        context,
                        items: [
                          const DynamicSheetItem(
                            leading: Icon(YTIcons.report_outlined),
                            title: 'Report',
                          ),
                          const DynamicSheetItem(
                            leading: Icon(YTIcons.not_interested_outlined),
                            title: 'Not interested',
                          ),
                          const DynamicSheetItem(
                            leading: Icon(YTIcons.not_interested_outlined),
                            title: 'Don\'t recommend posts from channel',
                            dependents: [DynamicSheetItemDependent.auth],
                          ),
                        ],
                      );
                    },
                padding: const EdgeInsets.all(8.0),
                borderRadius: BorderRadius.circular(32),
                child: const Icon(YTIcons.more_vert_outlined),
              ),
            ],
          ),
        ),
        TappableArea(
          onPressed: () {},
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2),
          child: const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'We are often asked to design for high availability, high scalability, and high throughput. What ',
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 320,
          decoration: const BoxDecoration(
            color: Colors.white38,
            image: DecorationImage(
              image: CustomNetworkImage('https://picsum.photos/450/900'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Icon(YTIcons.like_outlined),
              SizedBox(width: 8),
              Text('104'),
              SizedBox(width: 32),
              Icon(YTIcons.dislike_outlined),
              Spacer(),
              Icon(Icons.comment_outlined),
              SizedBox(width: 8),
              Text('2'),
            ],
          ),
        ),
      ],
    );
  }
}
