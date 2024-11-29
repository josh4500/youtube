import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:youtube_clone/infrastructure.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../provider/media_album_state.dart';
import '../provider/media_files_state.dart';
import 'create_close_button.dart';

class AlbumSelector extends ConsumerWidget {
  const AlbumSelector({super.key, this.videoOnly = true});
  final bool videoOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albums = ref.watch(mediaAlbumStateProvider).value?.albums;
    if (albums == null) return const SizedBox();
    return DraggableScrollableSheet(
      minChildSize: .6,
      initialChildSize: 1,
      snap: true,
      snapSizes: const [.7, 1],
      builder: (BuildContext context, ScrollController scrollController) {
        return Material(
          child: DecoratedBox(
            decoration: const BoxDecoration(color: Colors.black),
            child: CustomScrollView(
              controller: scrollController,
              scrollBehavior: const OverScrollGlowBehavior(enabled: false),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  floating: true,
                  backgroundColor: Colors.black,
                  title: const Text(
                    'Select album',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  actions: [
                    Transform.scale(
                      scale: .8,
                      child: const CreateCloseButton(),
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final MediaAlbum album = albums[index];
                      if (album.videoCount <= 0 && videoOnly) {
                        return const SizedBox();
                      }
                      return InkWell(
                        onTap: () {
                          ref
                              .read(mediaFilesStateProvider.notifier)
                              .loadAlbumFiles(album);
                          if (context.mounted) context.pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 12,
                          ),
                          child: Row(
                            children: [
                              AssetEntityImage(
                                album.thumbAsset,
                                fit: BoxFit.cover,
                                height: 100.w,
                                width: 100.w,
                                isOriginal: false,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      album.name,
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      videoOnly
                                          ? album.videoCount.toString()
                                          : album.count.toString(),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: albums.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AlbumSelectorButton extends ConsumerWidget {
  const AlbumSelectorButton({super.key, this.videoOnly = true});
  final bool videoOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAlbum = ref.watch(mediaAlbumStateProvider).value?.selected;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showAlbumSelector(
        context,
        videoOnly: videoOnly,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              currentAlbum?.name ?? 'No album',
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          const RotatedBox(
            quarterTurns: 1,
            child: Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}

void showAlbumSelector(BuildContext context, {bool videoOnly = true}) {
  showModalBottomSheet(
    context: context,
    enableDrag: false,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    constraints: const BoxConstraints.expand(),
    sheetAnimationStyle: AnimationStyle(
      curve: Curves.easeInCubic,
      duration: const Duration(milliseconds: 300),
    ),
    builder: (BuildContext context) {
      return AlbumSelector(videoOnly: videoOnly);
    },
  );
}
