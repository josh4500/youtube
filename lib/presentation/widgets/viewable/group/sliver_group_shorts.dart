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
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../../playable/playable_shorts_content.dart';
import '../viewable_shorts_content.dart';

enum ShortsGroupLayout {
  list,
  grid,
}

enum ShortsGroupView {
  playable,
  viewable,
}

class SliverGroupShorts extends StatelessWidget {
  const SliverGroupShorts({
    super.key,
    this.layout = ShortsGroupLayout.list,
    this.view = ShortsGroupView.viewable,
    this.crossAxisCount = 2,
    this.itemMargin = const EdgeInsets.all(4),
    this.width,
    this.height,
    this.onMore,
    this.showDivider = true,
  });

  final double? width, height;
  final bool showDivider;
  final EdgeInsets itemMargin;
  final ShortsGroupLayout layout;
  final int crossAxisCount;
  final ShortsGroupView view;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final shorts = context.provide<List<ShortsViewModel>>();

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              if (showDivider) const Divider(thickness: 1, height: 0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AssetsPath.logoShorts32,
                      filterQuality: FilterQuality.high,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Shorts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (layout == ShortsGroupLayout.grid)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (view == ShortsGroupView.viewable) {
                    ViewableShortsContent(
                      onMore: onMore,
                      margin: itemMargin,
                      borderRadius: BorderRadius.circular(8),
                    );
                  }
                  return PlayableShortsContent(
                    onMore: onMore,
                    margin: itemMargin,
                  );
                },
                childCount: shorts.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 9 / 14,
              ),
            ),
          )
        else
          SliverToBoxAdapter(
            child: SizedBox(
              height: height ?? 330.h,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if (view == ShortsGroupView.viewable) {
                    return ViewableShortsContent(
                      width: width ?? 196.h,
                      onMore: onMore,
                      margin: itemMargin,
                      borderRadius: BorderRadius.circular(8),
                    );
                  }
                  return PlayableShortsContent(
                    width: width ?? 196.h,
                    onMore: onMore,
                    margin: itemMargin,
                  );
                },
                itemCount: shorts.length,
              ),
            ),
          ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 12),
        ),
      ],
    );
  }
}
