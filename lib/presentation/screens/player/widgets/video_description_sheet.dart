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

import '../../../constants.dart';

class VideoDescriptionSheet extends StatelessWidget {
  const VideoDescriptionSheet({
    super.key,
    this.controller,
    this.showDragIndicator = true,
    required this.transcriptController,
    required this.closeDescription,
    this.draggableController,
  });
  final ScrollController? controller;
  final bool showDragIndicator;
  final PageDraggableOverlayChildController transcriptController;
  final VoidCallback closeDescription;
  final DraggableScrollableController? draggableController;

  @override
  Widget build(BuildContext context) {
    return PageDraggableSheet(
      title: 'Description',
      scrollTag: 'player_description',
      controller: controller ?? ScrollController(),
      onClose: closeDescription,
      showDragIndicator: showDragIndicator,
      draggableController: draggableController,
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
              children: [
                Text(
                  '\'Israel will lose to South Africa\' says international law expert | LBC',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '5,126',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Likes',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '500,126',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Views',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '12h',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Ago',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 24,
              child: Row(
                children: [
                  CustomActionChip(
                    title: '#SangitaMyaska',
                    margin: const EdgeInsets.only(right: 8),
                    backgroundColor: Colors.grey.shade900,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomActionChip(
                    title: '#Israel',
                    margin: const EdgeInsets.only(right: 8),
                    backgroundColor: Colors.grey.shade900,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomActionChip(
                    title: '#SouthAfrica',
                    margin: const EdgeInsets.only(right: 8),
                    backgroundColor: Colors.grey.shade900,
                    textStyle: const TextStyle(
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
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '''One Piece Episode 1090 with English subbed has been released at chia anime, make sure to watch other episodes of ONE PIECE anime series. If you enjoyed this episode, help us make this episode popular, share this link now!, note if the video is broken please contact us on facebook and we will do our best to reply from you and fixed the problem. if you like Chia-Anime show us your love by sharing this episode, Thank you.
                            \nPlease be patient with popup ads with us, that supports us to maintain our fully service to you.''',
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
                  border: Border.all(color: Colors.grey, width: 0.7),
                  onTap: transcriptController.open,
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
                      border: Border.all(color: Colors.grey, width: 0.7),
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
                      border: Border.all(color: Colors.grey, width: 0.7),
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
          controller: transcriptController,
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

class TranscriptTile extends StatelessWidget {
  const TranscriptTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '0:00',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 32),
          const Text('You do know that the one piece treasure'),
        ],
      ),
    );
  }
}
