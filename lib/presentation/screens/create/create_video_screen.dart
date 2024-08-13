import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:youtube_clone/core/utils/duration.dart';
import 'package:youtube_clone/infrastructure.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';

import 'provider/media_album_state.dart';
import 'provider/media_files_state.dart';
import 'widgets/album_selector.dart';
import 'widgets/create_close_button.dart';
import 'widgets/create_media_preview.dart';

class CreateVideoScreen extends StatelessWidget {
  const CreateVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black38,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Row(
              children: [
                AlbumSelectorButton(),
                Spacer(),
                CreateCloseButton(),
              ],
            ),
          ),
          Expanded(child: FileSelector()),
        ],
      ),
    );
  }
}

class FileSelector extends ConsumerWidget {
  const FileSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(mediaFilesStateProvider).value;
    if (files == null) return const SizedBox();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return AssetThumbnail(media: files[index]);
      },
      itemCount: files.length,
    );
  }
}

class AssetThumbnail extends StatefulWidget {
  const AssetThumbnail({super.key, required this.media});

  final MediaFile media;

  @override
  State<AssetThumbnail> createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<AssetThumbnail> {
  Future<void> handleLongPress() async {
    await showGeneralDialog(
      context: context,
      barrierLabel: '${widget.media.title ?? 'File'} preview',
      barrierDismissible: true,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> _,
      ) {
        final forwardPosition = Tween<Offset>(
          begin: const Offset(0, .2),
          end: Offset.zero,
        ).animate(animation);
        final reversePosition = Tween<Offset>(
          begin: const Offset(0, .5),
          end: Offset.zero,
        ).animate(animation);
        return SlideTransition(
          position: animation.status == AnimationStatus.forward
              ? forwardPosition
              : reversePosition,
          child: ModelBinding<MediaFile>(
            model: widget.media,
            child: const CreateMediaPreview(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: handleLongPress,
      child: Stack(
        children: [
          AssetEntityImage(
            widget.media,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            isOriginal: false, // Defaults to `true`.
          ),
          if (widget.media.duration > 0)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.media.videoDuration.hoursMinutesSeconds,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AlbumSelectorButton extends ConsumerWidget {
  const AlbumSelectorButton({super.key});

  void showDraggableBottomSheet(BuildContext context) {
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
        return const AlbumSelector();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAlbum = ref.watch(mediaAlbumStateProvider).value?.selected;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showDraggableBottomSheet(context);
      },
      child: Row(
        children: [
          Text(
            currentAlbum?.name ?? 'Videos',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          const RotatedBox(
            quarterTurns: 1,
            child: Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}
