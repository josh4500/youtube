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

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class VideoCommentGuidelines extends StatelessWidget {
  const VideoCommentGuidelines({super.key});

  @override
  Widget build(BuildContext context) {
    final isCustom = () {
      return true;
    }();
    if (isCustom) {
      return GestureDetector(
        onTap: () {
          showDynamicSheet(
            context,
            items: [
              DynamicSheetSection(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Harris Craycraft',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Guidelines',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: context.theme.colorScheme.surface
                                  .withValues(alpha: .38),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const AccountAvatar(size: 52),
                          const SizedBox(height: 24),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  color: context.theme.highlightColor,
                                  transform: Matrix4.translationValues(0, 0, 0)
                                    ..rotateZ(-45 * math.pi / 180),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: context.theme.highlightColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Welcome to Harris Craycraft YouTube channel. We encourage a respectful discussions',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...List.generate(3, (int index) {
                            final text = [
                              'Respectful and Constructive',
                              'Respect Privacy',
                              'Stay On-Topic',
                            ][index];
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: context.theme.highlightColor,
                                      ),
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(child: Text(text)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                              ],
                            );
                          }),
                          const SizedBox(height: 8),
                          CustomActionChip(
                            title: 'Got it',
                            expanded: true,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(12),
                            backgroundColor: context.theme.primaryColor,
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: context.theme.colorScheme.inverseSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          RichText(
                            text: TextSpan(
                              text:
                                  'Remember, your comments should always be respectful and follow ',
                              children: [
                                TextSpan(
                                  text: 'YouTube Community Guidelines.',
                                  style: TextStyle(
                                    color: context.theme.primaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              style: TextStyle(
                                fontSize: 12,
                                color: context.theme.colorScheme.surface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            showDynamicSheet(
                              context,
                              items: [
                                const DynamicSheetOptionItem(
                                  leading: Icon(YTIcons.report_outlined),
                                  title: 'Report',
                                ),
                              ],
                            );
                          },
                          child: const Icon(YTIcons.more_vert_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          color: context.theme.highlightColor,
          child: Row(
            children: [
              const AccountAvatar(size: 24),
              const SizedBox(width: 12),
              const Text(
                'Guidelines for this channel',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                'View',
                style:
                    TextStyle(color: context.theme.primaryColor, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(12),
      color: context.theme.highlightColor,
      child: RichText(
        text: TextSpan(
          text: 'Remember to keep comments respectful and to follow our ',
          children: [
            TextSpan(
              text: 'Community Guidelines',
              style: TextStyle(color: context.theme.primaryColor, fontSize: 12),
            ),
          ],
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
