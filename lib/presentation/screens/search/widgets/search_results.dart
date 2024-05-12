import 'dart:math';

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'search_result_in_chapter.dart';
import 'search_result_in_concepts.dart';
import 'search_result_in_desc.dart';
import 'search_result_in_playlist.dart';

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
                  ViewableVideoContent(
                    onMore: () {
                      showDynamicSheet(
                        context,
                        items: [
                          DynamicSheetOptionItem(
                            leading: const Icon(
                              YTIcons.playlist_play_outlined,
                            ),
                            title: 'Play next in queue',
                            trailing: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Image.asset(
                                AssetsPath.ytPAccessIcon48,
                                width: 18,
                                height: 18,
                              ),
                            ),
                          ),
                          const DynamicSheetOptionItem(
                            leading: Icon(YTIcons.watch_later_outlined),
                            title: 'Save to Watch later',
                          ),
                          const DynamicSheetOptionItem(
                            leading: Icon(YTIcons.save_outlined_1),
                            title: 'Save to playlist',
                          ),
                          const DynamicSheetOptionItem(
                            leading: Icon(YTIcons.share_outlined),
                            title: 'Share',
                          ),
                          const DynamicSheetOptionItem(
                            leading: Icon(YTIcons.reload_outlined),
                            title: 'Remix',
                          ),
                          const DynamicSheetOptionItem(
                            leading: Icon(
                              YTIcons.youtube_music_outlined,
                            ),
                            title: 'Listened with YouTube music',
                            trailing: Icon(
                              YTIcons.external_link_rounded_outlined,
                              size: 20,
                            ),
                          ),
                          const DynamicSheetOptionItem(
                            leading: Icon(YTIcons.report_outlined),
                            title: 'Report',
                            dependents: [DynamicSheetItemDependent.auth],
                          ),
                        ],
                      );
                    },
                  ),
                  if (random.nextBool())
                    const SizedBox()
                  else
                    random.nextBool()
                        ? random.nextBool()
                            ? const SearchResultInPlaylist()
                            : const SearchResultInConcepts()
                        : random.nextBool()
                            ? const SearchResultInDesc()
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
