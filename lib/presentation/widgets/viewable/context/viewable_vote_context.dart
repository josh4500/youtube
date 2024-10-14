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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../../gestures/tappable_area.dart';
import '../../network_image/custom_network_image.dart';

class ViewableVoteContext extends StatelessWidget {
  const ViewableVoteContext({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final bool voted = random.nextBool();
    final bool hasImage = random.nextBool();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              VoteOption(
                text: 'Yes',
                selected: false,
                voted: voted,
                hasImage: hasImage,
                vote: 23,
              ),
              VoteOption(
                text: 'No',
                selected: true,
                voted: voted,
                hasImage: hasImage,
                vote: 52,
              ),
              VoteOption(
                text: 'Maybe',
                selected: false,
                voted: voted,
                hasImage: hasImage,
                vote: 25,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '47K votes',
              style: TextStyle(color: Color(0xFFAAAAAA)),
            ),
          ),
        ],
      ),
    );
  }
}

class VoteOption extends StatelessWidget {
  const VoteOption({
    super.key,
    required this.selected,
    required this.text,
    required this.voted,
    required this.vote,
    required this.hasImage,
  });

  final int vote;
  final bool voted;
  final String text;
  final bool hasImage;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final double? imageSize = hasImage ? 96 : null;
    final ViewableStyle theme = context.theme.appStyles.viewableVideoStyle;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double votedSize =
            (constraints.maxWidth - 4 - (imageSize ?? 0)) * (vote / 100);

        return Container(
          height: hasImage ? imageSize : null,
          margin: const EdgeInsets.symmetric(vertical: 2.5),
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: selected && voted
                  ? const Color(0xFF3EA6FF)
                  : const Color(0xFF272727),
            ),
          ),
          child: TappableArea(
            onTap: () {},
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Row(
                  children: [
                    if (hasImage)
                      Container(
                        width: imageSize,
                        decoration: BoxDecoration(
                          color: theme.backgroundColor,
                          image: const DecorationImage(
                            image: CustomNetworkImage(
                              'https://picsum.photos/450/900',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                        ),
                      ),
                    Stack(
                      children: [
                        Container(
                          width: votedSize,
                          height: hasImage ? double.infinity : 40,
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.all(.5),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selected && voted
                                ? const Color(0x203EA6FF)
                                : voted
                                    ? Colors.white12
                                    : null,
                            borderRadius: hasImage
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  )
                                : BorderRadius.circular(4),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.all(.5),
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              text,
                              style: TextStyle(
                                color: selected && voted
                                    ? const Color(0xFF3EA6FF)
                                    : Colors.white54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.all(.5),
                  padding: const EdgeInsets.all(12),
                  child: voted
                      ? Text(
                          '$vote%',
                          style: TextStyle(
                            color: selected && voted
                                ? const Color(0xFF3EA6FF)
                                : Colors.white54,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
