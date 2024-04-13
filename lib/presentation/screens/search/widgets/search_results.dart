import 'dart:math';

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/search/widgets/search_result_in_chapter.dart';
import 'package:youtube_clone/presentation/screens/search/widgets/search_result_in_concepts.dart';
import 'package:youtube_clone/presentation/screens/search/widgets/search_result_in_playlist.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    return CustomScrollView(
      slivers: [
        const SliverPersistentHeader(
          pinned: true,
          delegate: PersistentHeaderDelegate(
            minHeight: 48,
            maxHeight: 48,
            child: Material(
              child: Column(
                children: [
                  Spacer(),
                  SizedBox(
                    height: 40,
                    child: DynamicTab(
                      initialIndex: 0,
                      leadingWidth: 8,
                      options: <String>[
                        'All',
                        'Shorts',
                        'Related',
                        'Recently uploaded',
                        'Watched',
                      ],
                    ),
                  ),
                  Spacer(),
                  Divider(height: 0, thickness: 1),
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Column(
                children: [
                  const ViewableVideoContent(),
                  if (random.nextBool())
                    const SizedBox()
                  else
                    random.nextBool()
                        ? random.nextBool()
                            ? const SearchResultInPlaylist()
                            : const SearchResultInConcepts()
                        : const SearchResultInChapters(),
                ],
              );
            },
            childCount: 20,
          ),
        ),
      ],
    );
  }
}
