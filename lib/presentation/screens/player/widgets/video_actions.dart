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
import 'package:youtube_clone/presentation/theme/icon/y_t_icons_icons.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_button.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_chip.dart';

class VideoActions extends StatelessWidget {
  const VideoActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      child: SizedBox(
        height: 32,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF272727),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Row(
                children: [
                  CustomActionButton(
                    title: '336',
                    leadingWidth: 4,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    icon: Icon(YTIcons.like_outlined, size: 16),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Divider(height: 0, thickness: 1.5),
                    ),
                  ),
                  CustomActionButton(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    icon: Icon(YTIcons.dislike_outlined, size: 16),
                  ),
                ],
              ),
            ),
            const CustomActionChip(
              title: 'Share',
              padding: EdgeInsets.symmetric(horizontal: 12),
              margin: EdgeInsets.symmetric(horizontal: 4),
              backgroundColor: Color(0xFF272727),
              icon: Icon(YTIcons.shared_filled, size: 16),
            ),
            const CustomActionChip(
              title: 'Remix',
              padding: EdgeInsets.symmetric(horizontal: 12),
              margin: EdgeInsets.symmetric(horizontal: 4),
              backgroundColor: Color(0xFF272727),
              icon: Icon(Icons.wifi_channel_outlined, size: 16),
            ),
            const CustomActionChip(
              title: 'Thanks',
              padding: EdgeInsets.symmetric(horizontal: 12),
              margin: EdgeInsets.symmetric(horizontal: 4),
              backgroundColor: Color(0xFF272727),
              icon: Icon(YTIcons.thanks_outlined, size: 16),
            ),
            const CustomActionButton(
              title: 'Download',
              padding: EdgeInsets.symmetric(horizontal: 12),
              margin: EdgeInsets.symmetric(horizontal: 4),
              backgroundColor: Color(0xFF272727),
              icon: Icon(YTIcons.download_outlined, size: 16),
            ),
            const CustomActionChip(
              title: 'Clip',
              padding: EdgeInsets.symmetric(horizontal: 12),
              margin: EdgeInsets.symmetric(horizontal: 4),
              backgroundColor: Color(0xFF272727),
              icon: Icon(YTIcons.clip_outlined, size: 16),
            ),
            const CustomActionChip(
              title: 'Save',
              padding: EdgeInsets.symmetric(horizontal: 12),
              margin: EdgeInsets.symmetric(horizontal: 4),
              backgroundColor: Color(0xFF272727),
              icon: Icon(YTIcons.save_outlined, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
