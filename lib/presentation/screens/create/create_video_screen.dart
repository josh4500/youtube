import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:youtube_clone/core/utils/duration.dart';
import 'package:youtube_clone/infrastructure.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'provider/media_album_state.dart';
import 'provider/media_files_state.dart';
import 'widgets/album_selector.dart';
import 'widgets/check_permission.dart';
import 'widgets/create_close_button.dart';
import 'widgets/create_media_preview.dart';
import 'widgets/create_permission_reason.dart';

final _checkMediaStoragePerm = FutureProvider.autoDispose<bool>(
  (ref) async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    return ps.isAuth;
  },
);

class CreateVideoScreen extends ConsumerWidget {
  const CreateVideoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Builder(
        builder: (context) {
          final permResult = ref.watch(_checkMediaStoragePerm);
          return permResult.when(
            data: (bool hasPermissions) {
              if (hasPermissions) {
                return const SelectMediaView();
              }
              return const MediaStoragePermissionRequest(checking: false);
            },
            error: (e, _) => const MediaStoragePermissionRequest(),
            loading: MediaStoragePermissionRequest.new,
          );
        },
      ),
    );
  }
}

class SelectMediaView extends StatelessWidget {
  const SelectMediaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: Row(
            children: [
              Expanded(child: AlbumSelectorButton()),
              SizedBox(width: 24),
              CreateCloseButton(),
            ],
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: const OverScrollGlowBehavior(enabled: false),
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? _) {
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
              },
            ),
          ),
        ),
      ],
    );
  }
}

class MediaStoragePermissionRequest extends StatelessWidget {
  const MediaStoragePermissionRequest({
    super.key,
    this.checking = true,
  });

  final bool checking;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        image: checking
            ? null
            : const DecorationImage(
                image: CustomNetworkImage(
                  'https://images.pexels.com/photos/26221937/pexels-photo-26221937/free-photo-of-a-woman-taking-a-photo.jpeg?auto=compress&cs=tinysrgb&w=600',
                ),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CreateCloseButton(),
          Expanded(
            child: Builder(
              builder: (BuildContext context) {
                if (checking) {
                  return const CheckingPermission();
                } else {
                  return SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.photo_outlined, size: 48),
                              SizedBox(height: 48),
                              Text(
                                'Let YouTube access your photos and videos',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 12),
                              CreatePermissionReason(
                                icon: YTIcons.info_outlined,
                                title: 'Why is this needed?',
                                subtitle:
                                    'So you can import photos and videos from your gallary',
                              ),
                              SizedBox(height: 12),
                              CreatePermissionReason(
                                icon: YTIcons.settings_outlined,
                                title: 'How to enable permission?',
                                subtitle:
                                    'Open settings, go to permissions and allow access to photos and videos',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Consumer(
                          builder: (context, ref, child) {
                            return GestureDetector(
                              onTap: () async {
                                await Permission.storage.request();
                                await Permission.mediaLibrary.request();

                                ref.refresh(_checkMediaStoragePerm);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
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
