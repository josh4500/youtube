import 'package:flutter/material.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:youtube_clone/core/utils/duration.dart';
import 'package:youtube_clone/infrastructure.dart';
import 'package:youtube_clone/presentation/models.dart';

import 'media_preview.dart';

class MediaThumbnail extends StatefulWidget {
  const MediaThumbnail({
    super.key,
    required this.media,
    this.index,
    this.onSelect,
    this.selectable = false,
  });

  final MediaFile media;
  final int? index;
  final ValueChanged<MediaFile>? onSelect;
  final bool selectable;

  @override
  State<MediaThumbnail> createState() => _MediaThumbnailState();
}

class _MediaThumbnailState extends State<MediaThumbnail> {
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
            child: const MediaPreview(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.selectable) {
          widget.onSelect?.call(widget.media);
        }
      },
      onLongPress: handleLongPress,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: widget.selectable ? BorderRadius.circular(8) : null,
          border: Border.all(
            color: widget.selectable && widget.index != null
                ? Colors.white
                : Colors.transparent,
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: widget.selectable
                  ? BorderRadius.circular(6)
                  : BorderRadius.zero,
              child: AssetEntityImage(
                widget.media,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                isOriginal: false, // Defaults to `true`.
              ),
            ),
            if (widget.media.duration > 0)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    widget.media.videoDuration.hoursMinutesSeconds,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            if (widget.selectable)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 16,
                    height: 16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.index != null ? Colors.white : null,
                    ),
                    child: widget.index != null
                        ? Text(
                            widget.index.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
