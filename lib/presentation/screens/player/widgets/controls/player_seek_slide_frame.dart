import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class PlayerSeekSlideFrame extends StatefulWidget {
  const PlayerSeekSlideFrame({
    super.key,
    required this.frameHeight,
    required this.sizeAnimation,
  });
  final double frameHeight;
  final Animation<double> sizeAnimation;

  @override
  State<PlayerSeekSlideFrame> createState() => _PlayerSeekSlideFrameState();
}

class _PlayerSeekSlideFrameState extends State<PlayerSeekSlideFrame> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      Duration(seconds: (_scrollController.offset / 50).ceil());
    });
  }

  int get framesCount {
    // TODO: Get real value
    const duration = Duration(minutes: 1);
    int value;
    if (duration < const Duration(minutes: 3)) {
      value = duration.inSeconds;
    } else if (duration < const Duration(minutes: 5)) {
      value = (duration.inSeconds / 3).floor();
    } else if (duration < const Duration(minutes: 10)) {
      value = (duration.inSeconds / 5).floor();
    } else if (duration < const Duration(seconds: 60)) {
      value = (duration.inSeconds / 10).floor();
    } else {
      value = duration.inSeconds;
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedVisibility(
      animation: widget.sizeAnimation,
      child: SizeTransition(
        sizeFactor: widget.sizeAnimation,
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
                          color: Colors.blueGrey,
                          width: 50,
                        );
                      }
                    },
                    itemCount: framesCount,
                  );
                },
              ),
            ),
            Center(
              child: Container(
                width: 3,
                height: widget.frameHeight,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
