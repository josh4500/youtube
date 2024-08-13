import 'package:flutter/material.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import 'package:youtube_clone/infrastructure.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'create_close_button.dart';

class CreateMediaPreview extends StatelessWidget {
  const CreateMediaPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: <Widget>[
              Container(
                color: AppPalette.black,
                child: const _VideoMediaPreview(),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CreateCloseButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoMediaPreview extends StatefulWidget {
  const _VideoMediaPreview();

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

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = ModelBinding.of<MediaFile>(context);
    final size = MediaQuery.sizeOf(context);
    final animation = CurvedAnimation(
      parent: ReverseAnimation(animationController),
      curve: Curves.easeInCubic,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (animationController.value < 1) {
          animationController.forward();
        } else {
          animationController.reverse();
        }
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size.width * .8,
          maxHeight: size.height * .8,
        ),
        child: Stack(
          children: [
            AssetEntityImage(media, fit: BoxFit.cover),
            Positioned.fill(
              child: AnimatedVisibility(
                animation: animation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
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
                            const Text('00:00'),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Slider(
                                  value: 0,
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.white12,
                                  onChanged: (double value) {},
                                ),
                              ),
                            ),
                            const Text('00:30'),
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
    );
  }
}
