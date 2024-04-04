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
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
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
      itemCount: 20,
    );
  }
}
