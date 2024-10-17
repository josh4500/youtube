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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/preferences.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'video_highlighted_comment.dart';

class VideoCommentSection extends ConsumerStatefulWidget {
  const VideoCommentSection({super.key});

  @override
  ConsumerState<VideoCommentSection> createState() =>
      _VideoCommentSectionState();
}

class _VideoCommentSectionState extends ConsumerState<VideoCommentSection> {
  int currentPage = 0;
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openComments() {
    ref.read(playerRepositoryProvider).sendPlayerSignal([
      PlayerSignal.openComments,
    ]);
  }

  void _openLiveChats() {}

  @override
  Widget build(BuildContext context) {
    final isRestrictedMode = ref.watch(
      preferencesProvider.select((value) => value.restrictedMode),
    );
    // TODO(Josh): Check for isLiveVideo
    final random = Random();
    final isLiveVideo = random.nextBool();
    final showHighlighted = random.nextBool();

    final childWidget = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isRestrictedMode)
          const Text(
            'Comments',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          )
        else ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                ListenableBuilder(
                  listenable: _pageController,
                  builder: (context, _) {
                    return Text(
                      currentPage == 0 ? 'Comments' : 'Live chat replay',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
                if (!isRestrictedMode) ...[
                  SizedBox(width: 4.w),
                  ListenableBuilder(
                    listenable: _pageController,
                    builder: (context, _) {
                      if (currentPage != 0) return const SizedBox();
                      return const Text(
                        '16k',
                        style: TextStyle(
                          color: Color(0xFFAAAAAA),
                        ),
                      );
                    },
                  ),
                ],
                const Spacer(),
                if (isLiveVideo && !isRestrictedMode)
                  ListenableBuilder(
                    listenable: _pageController,
                    builder: (BuildContext context, Widget? child) {
                      return SlidesIndicator(
                        pageCount: 2,
                        currentPage: currentPage,
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
        if (isRestrictedMode)
          const SizedBox(height: 8)
        else
          const SizedBox(height: 2),
        if (isRestrictedMode)
          const Text(
            'Restricted Mode has hidden comments for this video.',
            style: TextStyle(fontSize: 14),
          )
        else
          SizedBox(
            child: isLiveVideo
                ? SizedBox(
                    height: 45,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: PageView(
                        controller: _pageController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        onPageChanged: (page) => currentPage = page,
                        children: [
                          if (showHighlighted)
                            TappableArea(
                              onTap: _openComments,
                              padding: EdgeInsets.zero,
                              child: const VideoHighlightedComment(),
                            )
                          else
                            const VideoCommentInput(),
                          TappableArea(
                            onTap: _openLiveChats,
                            padding: EdgeInsets.zero,
                            child: const VideoHighlightedLiveComment(),
                          ),
                        ],
                      ),
                    ),
                  )
                : showHighlighted
                    ? const VideoHighlightedComment()
                    : const VideoCommentInput(),
          ),
        if (!isRestrictedMode) const SizedBox(height: 8),
      ],
    );

    if (!isRestrictedMode) {
      return Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: context.theme.highlightColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: LayoutBuilder(
          builder: (context, c) {
            return TappableArea(
              onTap: _openComments,
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(16),
              child: childWidget,
            );
          },
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: context.theme.highlightColor,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: childWidget,
    );
  }
}

class VideoCommentInput extends StatelessWidget {
  const VideoCommentInput({super.key});

  void _openCommentInput() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8,
      ),
      child: Row(
        children: [
          const AccountAvatar(size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: TappableArea(
              onTap: _openCommentInput,
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: context.theme.highlightColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Add a comment...',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
