import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';

class PlayerSeekSlideFrame extends ConsumerStatefulWidget {
  final ValueNotifier<bool> valueListenable;
  final VoidCallback onClose;
  final AnimationController animationController;
  final double frameHeight;
  final Widget seekDurationIndicator;

  const PlayerSeekSlideFrame({
    super.key,
    required this.animationController,
    required this.frameHeight,
    required this.valueListenable,
    required this.onClose,
    required this.seekDurationIndicator,
  });

  @override
  ConsumerState<PlayerSeekSlideFrame> createState() =>
      _PlayerSeekSlideFrameState();
}

class _PlayerSeekSlideFrameState extends ConsumerState<PlayerSeekSlideFrame> {
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _opacityAnimation = CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.easeIn,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const framesCount = 10 + 2;

    return ValueListenableBuilder(
      valueListenable: widget.valueListenable,
      builder: (context, show, _) {
        if (!show) return const SizedBox();
        return ColoredBox(
          color: Colors.black26,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    widget.valueListenable.value = false;
                    widget.onClose();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    return GestureDetector(
                      onTap: () async {
                        widget.valueListenable.value = false;
                        await ref.read(playerRepositoryProvider).playVideo();
                        widget.onClose();
                      },
                      child: GestureDetector(
                        onTap: () async {
                          widget.valueListenable.value = false;
                          await ref.read(playerRepositoryProvider).playVideo();
                          widget.onClose();
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: 54,
                                height: 54,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.black26,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ),
                            widget.seekDurationIndicator,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ClipRRect(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: widget.frameHeight,
                          child: LayoutBuilder(
                            builder: (context, constraint) {
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return SizedBox(
                                      width: constraint.maxWidth / 2,
                                    );
                                  } else if (index == framesCount - 1) {
                                    return SizedBox(
                                      width: constraint.maxWidth / 2,
                                    );
                                  } else {
                                    return Container(
                                      color: Colors.blue.shade100,
                                      width: 50,
                                    );
                                  }
                                },
                                itemCount: framesCount,
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 3,
                            height: widget.frameHeight,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
