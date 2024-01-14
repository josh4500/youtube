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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/preferences.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

import 'video_highlighted_comment.dart';

class VideoCommentSection extends ConsumerWidget {
  final VoidCallback? onTap;
  const VideoCommentSection({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restrictedMode = ref.watch(
      preferencesProvider.select((value) => value.restrictedMode),
    );
    final childWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Comments',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (!restrictedMode) ...[
              const SizedBox(width: 8),
              const Text('16k'),
            ],
          ],
        ),
        if (restrictedMode)
          const SizedBox(height: 8)
        else
          const SizedBox(height: 12),
        if (restrictedMode)
          const Text(
            'Restricted Mode has hidden comments for this video.',
            style: TextStyle(
              fontSize: 14,
            ),
          )
        else
          const VideoHighlightedComment(),
      ],
    );

    if (!restrictedMode) {
      return Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TappableArea(
          onPressed: onTap,
          padding: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(16),
          child: childWidget,
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
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: childWidget,
    );
  }
}
