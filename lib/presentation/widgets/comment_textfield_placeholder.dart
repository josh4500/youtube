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

class CommentTextFieldPlaceholder extends StatelessWidget {
  const CommentTextFieldPlaceholder({super.key, this.isReply = false});
  final bool isReply;

  @override
  Widget build(BuildContext context) {
    final isPaused = (() => true)();
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Divider(thickness: 1, height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8.0,
            ),
            child: Row(
              children: <Widget>[
                if (!isPaused) ...[
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: AccountAvatar(size: 24),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.highlightColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: isPaused
                        ? RichText(
                            text: TextSpan(
                              text: 'Comments are paused. ',
                              children: [
                                TextSpan(
                                  text: 'Learn More',
                                  style: TextStyle(
                                    color: context.theme.primaryColor,
                                  ),
                                ),
                              ],
                              style: TextStyle(
                                color: context.theme.hintColor,
                              ),
                            ),
                          )
                        : Text(
                            'Add a ${isReply ? 'reply' : 'comment'}...',
                            style: TextStyle(
                              color: context.theme.hintColor,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 4),
                if (!isPaused) ...[
                  if (isReply)
                    const Icon(YTIcons.camera_outlined)
                  else
                    TappableArea(
                      onTap: () {},
                      padding: const EdgeInsets.all(4),
                      borderRadius: BorderRadius.circular(24),
                      child: const Icon(YTIcons.thanks_outlined, size: 24),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
