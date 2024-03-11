// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'package:flutter/material.dart';

import '../../../../core/progress.dart';

const defaultPlaybackProgressTapSize = 10.0;

class PlaybackProgress extends StatefulWidget {
  final double tapSize;
  final Color? color;
  final Animation<double?>? animation;
  final Animation<Color?>? bufferAnimation;
  final Color? backgroundColor;
  final Stream<Progress>? progress;
  final Progress? start;
  final Duration? end;
  final bool showBuffer;
  final void Function(Duration position)? onTap;
  final void Function(Duration position)? onDragStart;
  final void Function()? onDragEnd;
  final void Function(Duration position)? onChangePosition;

  const PlaybackProgress({
    super.key,
    this.tapSize = defaultPlaybackProgressTapSize,
    this.color = const Color(0xFFFF0000),
    this.animation,
    this.bufferAnimation,
    this.progress,
    this.start = Progress.zero,
    this.end = Duration.zero,
    this.showBuffer = true,
    this.backgroundColor = Colors.white30,
    this.onTap,
    this.onDragStart,
    this.onDragEnd,
    this.onChangePosition,
  });

  @override
  State<PlaybackProgress> createState() => _PlaybackProgressState();
}

class _PlaybackProgressState extends State<PlaybackProgress> {
  Stream<Progress>? progressStream;
  Animation<double>? thumbAnimation;
  Animation<Color?>? progressAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.animation != null) {
      thumbAnimation = widget.animation!.drive(
        Tween<double>(begin: 0, end: 12),
      );
      progressAnimation = widget.animation!.drive(
        ColorTween(begin: Colors.white, end: const Color(0xFFFF0000)),
      );
    }
  }

  // TODO: Compute based on video data
  double get barHeight => 2;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Progress>(
      stream: widget.progress,
      initialData: widget.start,
      builder: (context, snapshot) {
        final data = snapshot.data ?? Progress.zero;
        final positionValue =
            data.position.inSeconds / (widget.end?.inSeconds ?? 0);
        final bufferValue =
            data.buffer.inSeconds / (widget.end?.inSeconds ?? 0);

        return LayoutBuilder(
          builder: (context, constraint) {
            return GestureDetector(
              onTapDown: (details) => _onTapDown(details, constraint.maxWidth),
              onHorizontalDragStart: (details) =>
                  _onHorizontalDragStart(details, constraint.maxWidth),
              onHorizontalDragUpdate: (details) =>
                  _onHorizontalDragUpdate(details, constraint.maxWidth),
              onHorizontalDragEnd: (details) =>
                  _onHorizontalDragEnd(details, constraint.maxWidth),
              child: Container(
                color: Colors.transparent,
                height: widget.tapSize,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  clipBehavior: Clip.none,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Buffering Progress indicator
                        if (widget.showBuffer)
                          LinearProgressIndicator(
                            color: Colors.white12,
                            value: bufferValue.isNaN || bufferValue.isInfinite
                                ? 0
                                : bufferValue,
                            minHeight: barHeight,
                            valueColor: widget.bufferAnimation,
                            backgroundColor: Colors.transparent,
                          ),
                        // TODO: Remove temporary fix for color animation
                        // Player position Indicator
                        if (progressAnimation != null)
                          AnimatedBuilder(
                            animation: progressAnimation!,
                            builder: (_, __) {
                              return LinearProgressIndicator(
                                color: progressAnimation!.value ?? widget.color,
                                value: positionValue.isNaN ||
                                        positionValue.isInfinite
                                    ? 0
                                    : positionValue,
                                minHeight: barHeight,
                                backgroundColor: widget.backgroundColor ??
                                    Colors.transparent,
                              );
                            },
                          )
                        else
                          LinearProgressIndicator(
                            color: widget.color,
                            value:
                                positionValue.isNaN || positionValue.isInfinite
                                    ? 0
                                    : positionValue,
                            minHeight: barHeight,
                            backgroundColor:
                                widget.backgroundColor ?? Colors.transparent,
                          ),
                      ],
                    ),

                    // Thumb
                    if (thumbAnimation != null)
                      Positioned(
                        bottom: -4.75,
                        left: (positionValue * constraint.maxWidth) - 1.5,
                        child: AnimatedBuilder(
                          animation: thumbAnimation!,
                          builder: (context, _) {
                            return Container(
                              width: thumbAnimation?.value,
                              height: thumbAnimation?.value,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF0000),
                                shape: BoxShape.circle,
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _onTapDown(TapDownDetails details, double width) {
    final positionInMilliseconds = _getRelativePosition(
      details.localPosition.dx,
      width,
    );
    if (widget.onTap != null) {
      widget.onTap!(Duration(milliseconds: positionInMilliseconds));
    }
  }

  void _onHorizontalDragStart(DragStartDetails details, double width) {
    final positionInMilliseconds = _getRelativePosition(
      details.localPosition.dx,
      width,
    );
    if (widget.onDragStart != null) {
      widget.onDragStart!(Duration(milliseconds: positionInMilliseconds));
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, double width) {
    final positionInMilliseconds = _getRelativePosition(
      details.localPosition.dx,
      width,
    );
    if (widget.onDragStart != null) {
      widget.onChangePosition!(Duration(milliseconds: positionInMilliseconds));
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details, double width) {
    if (widget.onDragEnd != null) {
      widget.onDragEnd!();
    }
  }

  int _getRelativePosition(double dx, double width) {
    return ((widget.end?.inMilliseconds ?? 0) * (dx / width)).floor();
  }
}

class ProgressChaptersClipper extends CustomClipper<Path> {
  static const double _space = 3;

  static const List<double> chapters = [0.167, .3334, .5001, 0.6668, 0.8335, 1];

  @override
  Path getClip(Size size) {
    final path = Path();
    // Begin
    path.moveTo(0, 0);

    for (int i = 0; i < chapters.length; i++) {
      final chapter = chapters[i];
      path.lineTo(size.width * chapter, 0);
      path.lineTo(size.width * chapter, size.height);

      if (i == 0) {
        path.lineTo(0, size.height);
        path.lineTo(0, 0);

        if (chapters.length > 1) {
          final nextChapter = chapters[i + 1];
          path.moveTo((size.width * nextChapter) + _space, 0);
        }
      } else {
        final prevChapter = chapters[i - 1];
        path.lineTo((size.width * prevChapter) + _space, size.height);
        path.lineTo((size.width * prevChapter) + _space, 0);

        if (i != chapters.length - 1) {
          final nextChapter = chapters[i + 1];
          path.moveTo((size.width * nextChapter) + _space, 0);
        }
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ProgressChapterPainter extends CustomPainter {
  static const double _radius = 2.5;

  static const List<double> chapters = [
    0.125,
    0.25,
    0.375,
    0.5,
    0.625,
    0.75,
    0.875
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < chapters.length; i++) {
      canvas.drawCircle(
        Offset((size.width * chapters[i]) + (_radius / 2), size.height / 2),
        _radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
