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
import 'custom_action_button.dart';
import 'dynamic_sheet.dart';
import 'gestures/custom_ink_well.dart';
import 'gestures/tappable_area.dart';

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
          TappableArea(
            onTap: openReply,
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TappableArea(
                  onTap: () => showCommenterProfile(context),
                  releasedColor: Colors.transparent,
                  padding: const EdgeInsets.all(8),
                  borderRadius: BorderRadius.circular(24),
                  child: const AccountAvatar(size: 32),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
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
                          const SizedBox(height: 4),
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
                                    color:
                                        byCreator ? Colors.white : Colors.grey,
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
                          const CommentTranslationButton(),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TappableArea(
                              onTap: () {},
                              releasedColor: Colors.transparent,
                              padding: const EdgeInsets.all(8),
                              borderRadius: BorderRadius.circular(24),
                              child: const Icon(
                                YTIcons.like_outlined,
                                size: 18,
                              ),
                            ),
                            const Text(
                              '69',
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 16),
                            TappableArea(
                              onTap: () {},
                              releasedColor: Colors.transparent,
                              padding: const EdgeInsets.all(8),
                              borderRadius: BorderRadius.circular(24),
                              child: const Icon(
                                YTIcons.dislike_outlined,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 16),
                            TappableArea(
                              onTap: () {},
                              releasedColor: Colors.transparent,
                              padding: const EdgeInsets.all(8),
                              borderRadius: BorderRadius.circular(24),
                              child: const Icon(
                                YTIcons.reply_outlined,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (creatorLikes)
                              TappableArea(
                                onTap: () {},
                                releasedColor: Colors.transparent,
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
                      ],
                    ),
                  ),
                ),
                TappableArea(
                  onTap: () => showCommentOption(context),
                  releasedColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: const EdgeInsets.all(8.0),
                  borderRadius: BorderRadius.circular(32),
                  splashFactory: InkSplash.splashFactory,
                  containedInkWell: true,
                  child: const Icon(YTIcons.more_vert_outlined, size: 16),
                ),
              ],
            ),
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

  void showCommenterProfile(BuildContext context) {
    showDynamicSheet(
      context,
      items: <DynamicSheetItem>[
        DynamicSheetSection(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AccountAvatar(size: 64),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bussy Boy',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '@BussyBoyBonanza',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Joined 1 year ago $kDotSeparator 11 subscribers',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              CustomActionButton(
                                title: 'Subscribe',
                                onTap: () {},
                                backgroundColor: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 14,
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(8, -8),
                      child: GestureDetector(
                        onTap: () {
                          showDynamicSheet(
                            context,
                            items: [
                              const DynamicSheetOptionItem(
                                leading: Icon(YTIcons.info_outlined),
                                title: 'Learn more about this feature',
                              ),
                              const DynamicSheetOptionItem(
                                leading: Icon(YTIcons.feedbck_outlined),
                                title: 'Send feedback',
                              ),
                            ],
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(YTIcons.more_vert_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'On this channel',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '5 comments',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: AppPalette.red,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Transform.translate(
                            offset: const Offset(0, -1),
                            child: const Icon(
                              YTIcons.subscriptions_filled,
                              size: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Public subscriber',
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Allows everyone to see their subscriptions',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Recent comments on this channel',
                          style: TextStyle(fontSize: 15),
                        ),
                        SubCommentTile(),
                        SubCommentTile(),
                        SubCommentTile(),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12,
                        ),
                        child: Text(
                          'Subscriptions',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 76,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: const Column(
                                children: [
                                  AccountAvatar(size: 52),
                                  SizedBox(height: 8),
                                  Text(
                                    'Bussy Boy',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: 10,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 0),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomInkWell(
                      onTap: () {},
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 12,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      splashFactory: NoSplash.splashFactory,
                      child: const Text(
                        'View Channel',
                        style: TextStyle(color: AppPalette.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showCommentOption(BuildContext context) {
    showDynamicSheet(
      context,
      title: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        child: Text(
          'Comment',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      items: <DynamicSheetItem>[
        const DynamicSheetOptionItem(
          leading: Icon(YTIcons.report_outlined),
          title: 'Report',
        ),
      ],
    );
  }
}

class SubCommentTile extends StatelessWidget {
  const SubCommentTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TappableArea(
                onTap: () {},
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Commented on ',
                        children: [
                          TextSpan(text: '"'),
                          TextSpan(
                            text: 'I was so confused lol',
                            style: TextStyle(
                              color: AppPalette.blue,
                            ),
                          ),
                          TextSpan(text: '"'),
                        ],
                      ),
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Realized this the second time I watched but he sounds mean',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            const Icon(
              YTIcons.chevron_right,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(height: 0),
      ],
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
