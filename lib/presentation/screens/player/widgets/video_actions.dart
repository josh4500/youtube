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
import 'package:youtube_clone/presentation/widgets/custom_action_button.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_chip.dart';

class VideoActions extends StatelessWidget {
  const VideoActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 34,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Row(
                children: [
                  CustomActionButton(
                    title: '1.7k',
                    leadingWidth: 8,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    icon: Icon(Icons.thumb_up_outlined, size: 14),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Divider(
                        height: 0,
                        thickness: 1.5,
                      ),
                    ),
                  ),
                  CustomActionButton(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    icon: Icon(Icons.thumb_down_outlined, size: 14),
                  ),
                ],
              ),
            ),
            CustomActionChip(
              title: 'Share',
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              backgroundColor: Colors.grey.shade900,
              icon: const Icon(Icons.reply_outlined, size: 14),
            ),
            CustomActionChip(
              title: 'Remix',
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              backgroundColor: Colors.grey.shade900,
              icon: const Icon(Icons.wifi_channel_outlined, size: 14),
            ),
            CustomActionChip(
              title: 'Thanks',
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              backgroundColor: Colors.grey.shade900,
              icon: const Icon(Icons.attach_money, size: 14),
            ),
            CustomActionButton(
              title: 'Download',
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              backgroundColor: Colors.grey.shade900,
              icon: const Icon(Icons.download, size: 14),
            ),
            CustomActionChip(
              title: 'Clip',
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              backgroundColor: Colors.grey.shade900,
              icon: const Icon(Icons.cut_outlined, size: 14),
            ),
            CustomActionChip(
              title: 'Save',
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              backgroundColor: Colors.grey.shade900,
              icon: const Icon(Icons.add_box_outlined, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}
