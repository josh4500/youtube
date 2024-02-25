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
import 'package:youtube_clone/presentation/widgets/channel_avatar.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_chip.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/persistent_header_delegate.dart';

class VideoDescriptionSheet extends StatefulWidget {
  final ScrollController? controller;
  final ValueNotifier<bool> transcriptNotifier;
  final VoidCallback closeDescription;
  final DraggableScrollableController draggableController;

  const VideoDescriptionSheet({
    super.key,
    this.controller,
    required this.transcriptNotifier,
    required this.closeDescription,
    required this.draggableController,
  });

  @override
  State<VideoDescriptionSheet> createState() => _VideoDescriptionSheetState();
}

class _VideoDescriptionSheetState extends State<VideoDescriptionSheet>
    with TickerProviderStateMixin {
  bool _replyIsOpened = false;
  final ScrollController _descListController = ScrollController();
  late final AnimationController _transcriptAnimationController;
  late final Animation _transcriptOpacityAnimation;
  late final Animation<Offset> _transcriptSlideAnimation;

  @override
  void initState() {
    super.initState();

    _transcriptAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 250),
    );

    _transcriptOpacityAnimation = CurvedAnimation(
      parent: _transcriptAnimationController,
      curve: const Interval(
        0,
        1,
        curve: Curves.easeInOutCubic,
      ),
    );

    _transcriptSlideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: const Offset(0, 0),
    ).animate(_transcriptAnimationController);

    widget.transcriptNotifier.addListener(_hideTranscriptListCallback);
  }

  void _hideTranscriptListCallback() {
    if (!widget.transcriptNotifier.value) {
      _transcriptAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    // Note: "widget.transcriptNotifier: should not be disposed
    widget.transcriptNotifier.removeListener(_hideTranscriptListCallback);

    _descListController.dispose();
    _transcriptAnimationController.dispose();
    super.dispose();
  }

  void _openTranscript() {
    widget.transcriptNotifier.value = _replyIsOpened = true;
    _transcriptAnimationController.forward();
  }

  void _closeTranscript() {
    widget.transcriptNotifier.value = _replyIsOpened = false;
  }

  void _closeDescription() {
    if (_replyIsOpened) {
      _closeTranscript();
    }
    widget.closeDescription();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Material(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: ScrollConfiguration(
          behavior: const NoOverScrollGlowBehavior(),
          child: CustomScrollView(
            controller: widget.controller,
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: PersistentHeaderDelegate(
                  minHeight: 68,
                  maxHeight: 68,
                  child: Column(
                    children: [
                      Container(
                        height: 4,
                        width: 45,
                        margin: const EdgeInsets.only(top: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16.0,
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                AnimatedBuilder(
                                  animation: _transcriptOpacityAnimation,
                                  builder: (context, childWidget) {
                                    final visible =
                                        _transcriptOpacityAnimation.value == 1;
                                    return Visibility(
                                      visible: visible,
                                      child: Opacity(
                                        opacity:
                                            _transcriptOpacityAnimation.value,
                                        child: childWidget,
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.more_vert_outlined,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                InkWell(
                                  borderRadius: BorderRadius.circular(32),
                                  onTap: _closeDescription,
                                  child: const Icon(Icons.close),
                                ),
                              ],
                            ),
                            AnimatedBuilder(
                              animation: _transcriptOpacityAnimation,
                              builder: (context, childWidget) {
                                return Opacity(
                                  opacity: _transcriptOpacityAnimation.value,
                                  child: childWidget,
                                );
                              },
                              child: SlideTransition(
                                position: _transcriptSlideAnimation,
                                child: Material(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(32),
                                        onTap: _closeTranscript,
                                        child: const Icon(Icons.arrow_back),
                                      ),
                                      const SizedBox(width: 32),
                                      const Text(
                                        'Transcript',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(thickness: 1.5, height: 0),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                child: Stack(
                  children: [
                    ListView(
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
                              padding: const EdgeInsets.all(8),
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.7,
                              ),
                              onTap: _openTranscript,
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
                                ChannelAvatar(size: 48),
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
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomActionChip(
                                    title: 'Videos',
                                    icon: const Icon(Icons.video_settings),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(8),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.7,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomActionChip(
                                    title: 'About',
                                    icon: const Icon(
                                      Icons.account_box_outlined,
                                    ),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(8),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.7,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    SlideTransition(
                      position: _transcriptSlideAnimation,
                      child: Material(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return const TranscriptTile();
                          },
                          itemCount: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TranscriptTile extends StatelessWidget {
  const TranscriptTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
