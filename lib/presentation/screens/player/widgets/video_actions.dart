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
