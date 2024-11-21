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
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class VideoMembershipSheet extends StatefulWidget {
  const VideoMembershipSheet({
    super.key,
    this.controller,
    required this.onPressClose,
    this.draggableController,
    required this.initialHeight,
  });

  final ScrollController? controller;
  final VoidCallback onPressClose;
  final double initialHeight;
  final DraggableScrollableController? draggableController;

  @override
  State<VideoMembershipSheet> createState() => _VideoMembershipSheetState();
}

class _VideoMembershipSheetState extends State<VideoMembershipSheet> {
  final showMore = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.draggableController?.animateTo(
        widget.initialHeight,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInCubic,
      );
    });
  }

  @override
  void dispose() {
    showMore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageDraggableSheet(
      title: 'Membership',
      controller: widget.controller ?? ScrollController(),
      onClose: widget.onPressClose,
      draggableController: widget.draggableController,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          padding: EdgeInsets.zero,
          splashRadius: 32,
          splashColor: Colors.transparent,
          constraints: const BoxConstraints.tightFor(height: 28),
          icon: const Icon(YTIcons.info_outlined),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () {
            showDynamicSheet(
              context,
              items: [
                const DynamicSheetOptionItem(
                  leading: SizedBox(),
                  title: 'Learn more about memberships',
                ),
                const DynamicSheetOptionItem(
                  leading: SizedBox(),
                  title: 'Report perks',
                ),
              ],
            );
          },
          splashRadius: 32,
          splashColor: Colors.transparent,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(height: 28),
          icon: const Icon(Icons.more_vert_rounded),
        ),
      ],
      contentBuilder: (context, controller, physics) {
        return ListView(
          controller: controller,
          physics: physics,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.1),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AccountAvatar(),
                  SizedBox(height: 12),
                  Text(
                    'Harris Craycraft',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Join this channel',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text('Get access to membership perks'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  const Text(r'$ 150.00/month'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CustomActionChip(
                        title: 'Join',
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        backgroundColor: context.theme.primaryColor,
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: context.theme.colorScheme.inverseSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Recurring payment. Cancel anytime. Creator may update perks.',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            ...[
              {
                'icon': YTIcons.badge_outlined,
                'text': 'Support the Channel!',
                'subtitle': 'Support the channel beyond watching the videos',
              },
              {
                'icon': YTIcons.badge_outlined,
                'text': 'Behind-the-scenes!',
                'subtitle':
                    'Early access to the experimental and behind-the-scenes content for your direct feedback!',
              },
              {
                'icon': YTIcons.star,
                'text':
                    'Loyalty badges next to your name in comments and live chat',
                'subtitle': 'Support the channel beyond watching the videos',
              },
              {
                'icon': YTIcons.emoji_smile_outlined,
                'text': 'Custom emoji to use in comments and live chat',
                'subtitle': 'Support the channel beyond watching the videos',
              }
            ].map((item) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.theme.highlightColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icon']! as IconData,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: showMore,
                        builder: (
                          BuildContext context,
                          bool show,
                          Widget? _,
                        ) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['text']! as String),
                              if (show) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item['subtitle']! as String,
                                  style: TextStyle(
                                    color: context.theme.hintColor,
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
            Row(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: showMore,
                  builder: (
                    BuildContext context,
                    bool show,
                    Widget? _,
                  ) {
                    return CustomActionButton(
                      onTap: () => showMore.value = !show,
                      title: 'More about perks',
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.theme.primaryColor,
                      ),
                      backgroundColor: Colors.transparent,
                      trailingIcon: Icon(
                        show ? YTIcons.chevron_up : YTIcons.chevron_down,
                        size: 14,
                        color: context.theme.primaryColor,
                      ),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text.rich(
                TextSpan(
                  text:
                      'Your channel name (Josh4500) ad member status may be publicly visible and shared by the channel with 3rd parties (to provide perks). ',
                  children: [
                    TextSpan(
                      text: 'Learn more',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.theme.primaryColor,
                      ),
                    ),
                  ],
                ),
                style: TextStyle(
                  fontSize: 12,
                  color: context.theme.hintColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(thickness: 1, height: 0),
          ],
        );
      },
      baseHeight: 1 - kAvgVideoViewPortHeight,
      showDragIndicator: true,
    );
  }
}
