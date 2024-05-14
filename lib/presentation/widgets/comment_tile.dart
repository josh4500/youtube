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
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/themes.dart';

import 'account_avatar.dart';
import 'custom_ink_well.dart';
import 'tappable_area.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    this.pinned = false,
    this.byCreator = false,
    this.creatorLikes = false,
    this.creatorReply = false,
    this.showReplies = true,
    this.openReply,
    this.backgroundColor,
  });

  final bool pinned;
  final bool showReplies;
  final bool byCreator;
  final bool creatorLikes;
  final bool creatorReply;
  final VoidCallback? openReply;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    const double avatarSpace = 52;
    final showTranslationOption = Random().nextBool();
    return ColoredBox(
      color: backgroundColor ?? Colors.transparent,
      child: Column(
        children: <Widget>[
          Stack(
            children: [
              TappableArea(
                onTap: openReply,
                padding: const EdgeInsets.all(16),
                stackedAlignment: Alignment.topRight,
                stackedChild: CustomInkWell(
                  onTap: () {},
                  padding: const EdgeInsets.all(16.0),
                  borderRadius: BorderRadius.circular(32),
                  child: const Icon(YTIcons.more_vert_outlined, size: 16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(width: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (pinned) ...[
                              const Row(
                                children: [
                                  Icon(
                                    YTIcons.pinned_outlined,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Pinned by BussyBoyBonanza',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                            Row(
                              children: [
                                Container(
                                  padding: byCreator
                                      ? const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 8,
                                        )
                                      : null,
                                  decoration: byCreator
                                      ? BoxDecoration(
                                          color: Colors.white24,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        )
                                      : null,
                                  child: RichText(
                                    text: TextSpan(
                                      text: '@BussyBoyBonanza',
                                      children: <InlineSpan>[
                                        if (byCreator)
                                          WidgetSpan(
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 4),
                                                Icon(
                                                  YTIcons.verified_filled,
                                                  size: 12,
                                                  color: byCreator
                                                      ? Colors.white
                                                      : Colors.grey,
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: byCreator
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                const Text.rich(
                                  TextSpan(
                                    text: kDotSeparator,
                                    children: <InlineSpan>[
                                      TextSpan(text: '7mo ago'),
                                    ],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Cutting funding on precautions is going to cost more in the long run',
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            if (showTranslationOption)
                              const SizedBox(height: 48),
                            const SizedBox(height: 36),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomInkWell(
                    onTap: () {},
                    padding: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(24),
                    child: const AccountAvatar(size: 32),
                  ),
                ),
              ),
              if (showTranslationOption)
                const Positioned(
                  left: avatarSpace + 12,
                  bottom: 48,
                  child: CommentTranslationButton(),
                ),
              Positioned(
                left: avatarSpace + 6,
                bottom: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TappableArea(
                      onTap: () {},
                      padding: const EdgeInsets.all(8),
                      borderRadius: BorderRadius.circular(24),
                      child: const Icon(
                        YTIcons.like_outlined,
                        size: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 34,
                      child: Text(
                        '69',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    CustomInkWell(
                      onTap: () {},
                      padding: const EdgeInsets.all(8),
                      borderRadius: BorderRadius.circular(24),
                      child: const Icon(
                        YTIcons.dislike_outlined,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 16),
                    CustomInkWell(
                      onTap: () {},
                      padding: const EdgeInsets.all(8),
                      borderRadius: BorderRadius.circular(24),
                      child: const Icon(
                        YTIcons.reply_outlined,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (creatorLikes)
                      CustomInkWell(
                        onTap: () {},
                        padding: const EdgeInsets.all(8),
                        borderRadius: BorderRadius.circular(24),
                        child: const Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AccountAvatar(size: 18),
                            Positioned(
                              top: 9,
                              left: 9,
                              child: Icon(
                                YTIcons.heart_filled,
                                size: 14,
                                color: Color(0xFFFF0000),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (showReplies) ...<Widget>[
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                const SizedBox(width: avatarSpace),
                TappableArea(
                  onTap: openReply,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  child: Row(
                    children: [
                      if (creatorReply) ...[
                        const AccountAvatar(size: 18),
                        const Text(
                          kDotSeparator,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3EA6FF),
                          ),
                        ),
                      ],
                      const Text(
                        '107 Replies',
                        style: TextStyle(color: Color(0xFF3EA6FF)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class CommentTranslationButton extends StatefulWidget {
  const CommentTranslationButton({super.key});

  @override
  State<CommentTranslationButton> createState() =>
      _CommentTranslationButtonState();
}

class _CommentTranslationButtonState extends State<CommentTranslationButton> {
  bool translated = false;
  @override
  Widget build(BuildContext context) {
    return TappableArea(
      onTap: () => setState(() => translated = !translated),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        translated
            ? 'See original (Translated by Google)'
            : 'Translate to English',
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
