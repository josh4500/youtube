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

import '../../../../constants.dart';

class VideoDescriptionSheet extends StatefulWidget {
  const VideoDescriptionSheet({
    super.key,
    this.controller,
    this.dragDismissible = true,
    required this.transcriptController,
    required this.onPressClose,
    this.draggableController,
    required this.initialHeight,
  });

  final ScrollController? controller;
  final bool dragDismissible;
  final PageDraggableOverlayChildController transcriptController;
  final VoidCallback onPressClose;
  final double initialHeight;
  final DraggableScrollableController? draggableController;

  @override
  State<VideoDescriptionSheet> createState() => _VideoDescriptionSheetState();
}

class _VideoDescriptionSheetState extends State<VideoDescriptionSheet> {
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
  Widget build(BuildContext context) {
    return PageDraggableSheet(
      title: 'Description',
      controller: widget.controller ?? ScrollController(),
      onClose: widget.onPressClose,
      dragDismissible: widget.dragDismissible,
      showDragIndicator: widget.dragDismissible,
      draggableController: widget.draggableController,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      contentBuilder: (context, controller, physics) {
        return ListView(
          physics: physics,
          controller: controller,
          padding: const EdgeInsets.all(16.0),
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Google Pixel 9 Pro Fold Is so Good! But...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: VideoCounterInfo(
                        title: '5,126',
                        subtitle: 'Likes',
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: VideoCounterInfo(
                        title: '500,126',
                        subtitle: 'Views',
                      ),
                    ),
                    Expanded(
                      child: VideoCounterInfo(
                        title: '12h',
                        subtitle: 'Ago',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(
              height: 24,
              child: Row(
                children: [
                  CustomActionChip(
                    title: '#SangitaMyaska',
                    margin: EdgeInsets.only(right: 8),
                    textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomActionChip(
                    title: '#Israel',
                    margin: EdgeInsets.only(right: 8),
                    textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomActionChip(
                    title: '#SouthAfrica',
                    margin: EdgeInsets.only(right: 8),
                    textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '''Pixel 9 Pro Fold is my favorite foldable I've ever used and you should totally get one, except ... \n\n'''
                '''Be the first to get the MKBHD x Ridge Biflex wallet at https://ridge.com/mkbhd''',
              ),
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transcript',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Follow along using the transcript',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                CustomActionChip(
                  title: 'Show transcript',
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(12),
                  border: Border.all(color: Colors.white12),
                  onTap: widget.transcriptController.open,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                const Row(
                  children: [
                    AccountAvatar(size: 48, name: 'John Jackson'),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LBC',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '691k subscribers',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CustomActionChip(
                      title: 'Videos',
                      icon: const Icon(YTIcons.your_videos_outlined),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      border: Border.all(color: Colors.white12),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    CustomActionChip(
                      title: 'About',
                      icon: const Icon(
                        Icons.account_box_outlined,
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      border: Border.all(color: Colors.white12),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ],
            ),
          ],
        );
      },
      baseHeight: 1 - kAvgVideoViewPortHeight,
      overlayChildren: [
        PageDraggableOverlayChild(
          controller: widget.transcriptController,
          builder: (context, controller, physics) {
            return ListView.builder(
              physics: physics,
              controller: controller,
              itemBuilder: (context, index) {
                return const TranscriptTile();
              },
              itemCount: 20,
            );
          },
        ),
      ],
    );
  }
}

class VideoCounterInfo extends StatelessWidget {
  const VideoCounterInfo({
    super.key,
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            fontFamily: AppFont.youTubeSans,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class TranscriptTile extends StatelessWidget {
  const TranscriptTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            decoration: BoxDecoration(
              color: context.theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '0:00',
              style: TextStyle(
                color: context.theme.primaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Flexible(
            child: Text('You do know that the one piece treasure'),
          ),
        ],
      ),
    );
  }
}
