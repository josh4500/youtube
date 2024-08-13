import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit/generated/libmpv/bindings.dart';
import 'package:media_kit/media_kit.dart' as mkit;
import 'package:media_kit_video/media_kit_video.dart' as mkit_video;
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:youtube_clone/core/utils/duration.dart';

import 'package:youtube_clone/infrastructure.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'create_close_button.dart';

class CreateMediaPreview extends StatelessWidget {
  const CreateMediaPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final media = ModelBinding.of<MediaFile>(context);
    final size = MediaQuery.sizeOf(context);
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: size.width * .6,
              maxWidth: size.width * .8,
              minHeight: size.height * .4,
              maxHeight: size.height * .8,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  color: AppPalette.black,
                  child: media.type == AssetType.image
                      ? const _ImageMediaPreview()
                      : _VideoMediaPreview(media),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CreateCloseButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageMediaPreview extends StatelessWidget {
  const _ImageMediaPreview();

  @override
  Widget build(BuildContext context) {
    final media = ModelBinding.of<MediaFile>(context);
    return AssetEntityImage(media, fit: BoxFit.cover);
  }
}

class _VideoMediaPreview extends StatefulWidget {
  const _VideoMediaPreview(this.mediaFile);
  final MediaFile mediaFile;

  @override
  State<_VideoMediaPreview> createState() => _VideoMediaPreviewState();
}

class _VideoMediaPreviewState extends State<_VideoMediaPreview>
    with SingleTickerProviderStateMixin {
  late final animationController = AnimationController(
    vsync: this,
    value: 1,
    duration: const Duration(milliseconds: 300),
  );

  late final player = mkit.Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = mkit_video.VideoController(player);
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.mediaFile.file.then((File? file) {
      if (file != null) player.open(mkit.Media(file.path));
    });
  }

  @override
  void dispose() {
    player.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = ModelBinding.of<MediaFile>(context);
    print(player.state.height?.toDouble());
    final animation = CurvedAnimation(
      parent: ReverseAnimation(animationController),
      curve: Curves.easeInCubic,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (animationController.value < 1) {
          animationController.forward();
          player.play();
        } else {
          animationController.reverse();
          player.pause();
        }
      },
      child: SliderTheme(
        data: const SliderThemeData(
          trackHeight: 2,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
        ),
        child: AspectRatio(
          aspectRatio: media.width / media.height,
          child: Stack(
            children: [
              mkit_video.Video(
                controls: null,
                fit: BoxFit.cover,
                aspectRatio: media.size.width / media.size.height,
                height: player.state.height?.toDouble(),
                wakelock: false,
                controller: controller,
              ),
              Positioned.fill(
                child: AnimatedVisibility(
                  animation: animation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 48),
                        Expanded(
                          child: Center(
                            child: AnimatedIcon(
                              icon: AnimatedIcons.pause_play,
                              size: 48,
                              progress: animation,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            children: [
                              StreamBuilder<Duration>(
                                stream: player.stream.position,
                                builder: (context, snapshot) {
                                  final position =
                                      snapshot.data ?? Duration.zero;
                                  return Text(position.hoursMinutesSeconds);
                                },
                              ),
                              Expanded(
                                child: StreamBuilder<Duration>(
                                  initialData: player.state.position,
                                  stream: player.stream.position,
                                  builder: (context, snapshot) {
                                    final position = snapshot.data!;
                                    return Slider(
                                      value: position.inMilliseconds /
                                          media.videoDuration.inMilliseconds,
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.white12,
                                      onChanged: (double value) {
                                        // player.seek(
                                        //   Duration(
                                        //     milliseconds: (media.videoDuration
                                        //                 .inMilliseconds *
                                        //             value)
                                        //         .toInt(),
                                        //   ),
                                        // );
                                      },
                                    );
                                  },
                                ),
                              ),
                              Text(media.videoDuration.hoursMinutesSeconds),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
