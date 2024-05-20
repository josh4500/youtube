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

import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../view_models/progress.dart';

/// Default size of the tappable area for seeking playback.
const double kDefaultPlaybackProgressTapSize = 10.0;

/// Equivalent value between 0 - 1 of Position and Buffer duration to the full
/// length duration of the playback
typedef ProgressValue = (double, double);

/// A widget that displays a visual representation of playback progress,
/// including chapters, key concepts, and buffer indication (optional).
/// Creates a new PlaybackProgress widget.
///
/// Example usage:
/// ```dart
/// PlaybackProgress(
///   chapters: [
///     Chapter(title: "Introduction", startTime: Duration(seconds: 0), endTime: Duration(seconds: 60)),
///     Chapter(title: "Chapter 1", startTime: Duration(seconds: 60), endTime: Duration(seconds: 120)),
///   ],
///   keyConcepts: [
///     KeyConcept(title: "Concept A", time: Duration(seconds: 30)),
///     KeyConcept(title: "Concept B", time: Duration(seconds: 90)),
///   ],
///   onTap: (position) {
///     // Seek to the tapped position.
///   },
/// ),
/// ```
class PlaybackProgress extends StatefulWidget {
  const PlaybackProgress({
    super.key,
    this.tapSize = kDefaultPlaybackProgressTapSize,
    this.color = const Color(0xFFFF0000),
    this.animation,
    this.bufferAnimation,
    this.progress,
    this.start = Progress.zero,
    this.end = Duration.zero,
    this.showBuffer = true,
    this.keyConcepts = const <KeyConcept>[],
    this.chapters = const <Chapter>[],
    this.replayed = const <Replayed>[],
    this.backgroundColor = Colors.white30,
    this.onTap,
    this.onDragStart,
    this.onDragEnd,
    this.onChangePosition,
  });

  /// Size of the tappable area for seeking playback.
  final double tapSize;

  /// Color of the progress indicator.
  final Color? color;

  /// Animation for the progress indicator (optional).
  final Animation<double?>? animation;

  /// Animation for the buffer indicator color (optional).
  final Animation<Color?>? bufferAnimation;

  /// Background color of the widget.
  final Color? backgroundColor;

  /// Stream of progress updates (optional).
  final Stream<Progress>? progress;

  /// Starting position of the playback.
  final Progress start;

  /// Total duration of the playback content.
  final Duration? end;

  /// Whether to show the buffer indicator.
  final bool showBuffer;

  /// List of [KeyConcept] and their positions within the playback duration.
  final List<KeyConcept> keyConcepts;

  /// List of [Chapter] and their positions within the playback duration.
  final List<Chapter> chapters;

  /// List of [Replayed] positions
  final List<Replayed> replayed;

  /// Callback triggered when the user taps on the progress indicator.
  final void Function(Duration position)? onTap;

  /// Callback triggered when the user starts dragging the progress indicator.
  final void Function(Duration position)? onDragStart;

  /// Callback triggered when the user finishes dragging the progress indicator.
  final void Function()? onDragEnd;

  /// Callback triggered when the user changes the playback position (during drag).
  final void Function(Duration position)? onChangePosition;

  @override
  State<PlaybackProgress> createState() => _PlaybackProgressState();
}

class _PlaybackProgressState extends State<PlaybackProgress>
    with SingleTickerProviderStateMixin {
  Stream<Progress>? progressStream;

  Animation<double>? _thumbSizeAnimation;

  /// Animation value for progress track
  Animation<Color?>? _trackColorAnimation;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  /// Y position of user pointer when vertical drag starts
  double _longPressYStartPosition = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: 0.8,
      lowerBound: 0.8,
      duration: const Duration(milliseconds: 175),
      reverseDuration: const Duration(milliseconds: 125),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceIn,
      reverseCurve: Curves.easeOutCubic,
    );

    if (widget.animation != null) {
      _thumbSizeAnimation = widget.animation!.drive(
        Tween<double>(begin: _indicatorHeight, end: 14),
      );
      _trackColorAnimation = widget.animation!.drive(
        ColorTween(begin: Colors.white70, end: const Color(0xFFFF0000)),
      );
    }
  }

  /// Progress Indicators minimum height
  double get _indicatorHeight => widget.keyConcepts.isEmpty ? 1.75 : 4;

  /// Equivalent value between 0 - 1 of the KeyConcepts duration positions
  List<double> get _keyConceptPositions => widget.keyConcepts
      .map(
        (KeyConcept e) =>
            e.position.inMicroseconds / widget.end!.inMicroseconds,
      )
      .toList();

  /// Equivalent value between 0 - 1 of the Chapter duration positions
  List<double> get _chaptersPositions => widget.chapters
      .map(
        (Chapter e) => e.position.inMicroseconds / widget.end!.inMicroseconds,
      )
      .toList();

  /// Computes playback progress values
  ProgressValue _computeProgressValue(Progress data) {
    final double positionValue =
        data.position.inMicroseconds / (widget.end?.inMicroseconds ?? 0);
    final double bufferValue =
        data.buffer.inMicroseconds / (widget.end?.inMicroseconds ?? 0);
    return (positionValue, bufferValue);
  }

  @override
  Widget build(BuildContext context) {
    Widget indicators = StreamBuilder<Progress>(
      stream: widget.progress,
      initialData: widget.start,
      builder: (BuildContext context, AsyncSnapshot<Progress> snapshot) {
        final data = _computeProgressValue(snapshot.data ?? Progress.zero);
        final double positionValue = data.$1;
        final double bufferValue = data.$2;
        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            // Buffering Progress indicator
            if (widget.showBuffer)
              LinearProgressIndicator(
                color: Colors.white12,
                value: bufferValue.isNaN || bufferValue.isInfinite
                    ? 0
                    : bufferValue,
                minHeight: _indicatorHeight,
                valueColor: widget.bufferAnimation,
                backgroundColor: Colors.transparent,
              ),
            // Player position Indicator
            if (_trackColorAnimation != null)
              AnimatedBuilder(
                animation: _trackColorAnimation!,
                builder: (_, __) {
                  return LinearProgressIndicator(
                    color: _trackColorAnimation!.value ?? widget.color,
                    value: positionValue.isNaN || positionValue.isInfinite
                        ? 0
                        : positionValue,
                    minHeight: _indicatorHeight,
                    backgroundColor:
                        widget.backgroundColor ?? Colors.transparent,
                  );
                },
              )
            else
              LinearProgressIndicator(
                color: widget.color,
                value: positionValue.isNaN || positionValue.isInfinite
                    ? 0
                    : positionValue,
                minHeight: _indicatorHeight,
                backgroundColor: widget.backgroundColor ?? Colors.transparent,
              ),
          ],
        );
      },
    );

    // Updates the `indicators` widget based on the presence of chapters.
    if (widget.chapters.isNotEmpty) {
      // Draws progress indicators for chapters based on their positions.
      indicators = ClipPath(
        clipper: ProgressChapterClipper(
          chapters: _chaptersPositions,
        ),
        child: indicators,
      );
    }

    // Updates the `indicators` widget based on the presence of key concepts.
    if (widget.keyConcepts.isNotEmpty) {
      // Paints circles at positions corresponding to key concept progress.
      indicators = CustomPaint(
        foregroundPainter: ProgressKeyConceptPainter(
          keyConcepts: _keyConceptPositions,
        ),
        child: indicators,
      );
    }

    final AnimatedBuilder? thumbIndicator = _thumbSizeAnimation != null
        ? AnimatedBuilder(
            animation: _thumbSizeAnimation!,
            builder: (BuildContext context, _) {
              return AnimatedBuilder(
                animation: _trackColorAnimation!,
                builder: (BuildContext context, _) {
                  return ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: _thumbSizeAnimation?.value,
                      height: _thumbSizeAnimation?.value,
                      decoration: BoxDecoration(
                        color: _trackColorAnimation!.value,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              );
            },
          )
        : null;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraint) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) =>
              _onTapDown(details, constraint.maxWidth),
          onTapCancel: _scaleOut,
          onTapUp: (TapUpDetails details) => _scaleOut(),
          onHorizontalDragStart: (DragStartDetails details) =>
              _onHorizontalDragStart(details, constraint.maxWidth),
          onHorizontalDragUpdate: (DragUpdateDetails details) =>
              _onHorizontalDragUpdate(details, constraint.maxWidth),
          onHorizontalDragEnd: (DragEndDetails details) =>
              _onHorizontalDragEnd(details, constraint.maxWidth),
          child: Container(
            color: Colors.transparent,
            height: widget.tapSize,
            child: Stack(
              alignment: Alignment.bottomLeft,
              clipBehavior: Clip.none,
              children: <Widget>[
                // Stacked Position and Buffer indicators
                indicators,
                // Thumb Indicator
                if (_thumbSizeAnimation != null)
                  StreamBuilder<Progress>(
                    stream: widget.progress,
                    initialData: widget.start,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<Progress> snapshot,
                    ) {
                      final ProgressValue data = _computeProgressValue(
                        snapshot.data ?? Progress.zero,
                      );
                      final double positionValue = data.$1;
                      final animation = widget.animation!.drive(
                        Tween<double>(begin: -0.175, end: -6),
                      );

                      return AnimatedBuilder(
                        animation: animation,
                        builder: (context, _) {
                          return Positioned(
                            bottom: animation.value,
                            left: clampDouble(
                              (positionValue * constraint.maxWidth) +
                                  animation.value -
                                  1,
                              0,
                              constraint.maxWidth - 12,
                            ),
                            child: thumbIndicator!,
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _scaleIn() {
    _controller.forward();
  }

  void _scaleOut() {
    _controller.reverse();
  }

  /// Handles tap down event on the widget and triggers the `onTap` callback
  /// if provided.
  ///
  /// [details]: The details of the tap down event.
  /// [width]: The width of the widget.
  void _onTapDown(TapDownDetails details, double width) {
    // Get the position in milliseconds relative to the widget width.
    final int positionInMilliseconds =
        _getRelativePosition(details.localPosition.dx, width);

    // Call the passed `onTap` callback if available.
    widget.onTap?.call(Duration(milliseconds: positionInMilliseconds));
    _scaleIn();
  }

  /// Handles the start of a horizontal drag event and triggers the `onDragStart`
  /// callback if provided.
  ///
  /// [details]: The details of the drag start event.
  /// [width]: The width of the widget.
  void _onHorizontalDragStart(DragStartDetails details, double width) {
    // Get the position in milliseconds relative to the widget width.
    final int positionInMilliseconds =
        _getRelativePosition(details.localPosition.dx, width);

    // Call the passed `onDragStart` callback if available.
    widget.onDragStart?.call(Duration(milliseconds: positionInMilliseconds));
    _scaleIn();
  }

  /// Handles updates during a horizontal drag event and triggers the
  /// `onChangePosition` callback if provided.
  ///
  /// [details]: The details of the drag update event.
  /// [width]: The width of the widget.
  void _onHorizontalDragUpdate(DragUpdateDetails details, double width) {
    // Get the position in milliseconds relative to the widget width.
    final int positionInMilliseconds =
        _getRelativePosition(details.localPosition.dx, width);

    // Call the passed `onChangePosition` callback if available.
    widget.onChangePosition
        ?.call(Duration(milliseconds: positionInMilliseconds));
  }

  /// Handles the end of a horizontal drag event and triggers the `onDragEnd`
  /// callback if provided.
  ///
  /// [details]: The details of the drag end event.
  void _onHorizontalDragEnd(DragEndDetails details, double width) {
    // Call the passed `onDragEnd` callback if available.
    widget.onDragEnd?.call();
    _scaleOut();
  }

  /// Calculates the position in milliseconds relative to the widget width.
  ///
  /// This function takes the horizontal position (`dx`) of a tap or drag event
  /// and the width of the widget and returns the corresponding position in
  /// milliseconds based on the assumed total duration (accessible through
  /// `widget.end`).
  int _getRelativePosition(double dx, double width) {
    // Use the provided end value (or 0 if not provided) and scale it
    // proportionally based on the tap/drag position and widget width.
    // Then convert the result to milliseconds and return the floor value
    // (rounded down to nearest whole number).
    return ((widget.end?.inMilliseconds ?? 0) * (dx / width)).floor();
  }
}

/// Creates a custom clipper that generates a path representing progress
/// through a series of chapters, with visual separation between chapters.
class ProgressChapterClipper extends CustomClipper<Path> {
  /// Creates a new ProgressChapterClipper.
  ///
  /// [chapters]: A list of chapter progress values.
  ProgressChapterClipper({super.reclip, required this.chapters});

  /// Constant spacing between chapters in the visual representation.
  static const double _space = 2.5;

  /// List of chapter progress values, ranging from 0.0 (no progress) to 1.0
  /// (complete).
  final List<double> chapters;

  /// Generates the clipping path based on the provided size and chapter progress.
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Start path creation at the top-left corner.
    path.moveTo(0, 0);

    // Iterate through each chapter to create path segments.
    for (int i = 0; i < chapters.length; i++) {
      final double chapter = chapters[i];

      // Draw a horizontal line to the progress point of the current chapter.
      path.lineTo(size.width * chapter, 0);

      // Draw a vertical line down to the bottom of the clip area.
      path.lineTo(size.width * chapter, size.height);

      // Handle special cases for the first and last chapters:

      if (i == 0) {
        // Close the path back to the top-left corner for the first chapter.
        path.lineTo(0, size.height);
        path.lineTo(0, 0);
      } else {
        // Add a visual gap between chapters using `_space`.
        final double prevChapter = chapters[i - 1];
        path.lineTo((size.width * prevChapter) + _space, size.height);
        path.lineTo((size.width * prevChapter) + _space, 0);
      }

      if (i != chapters.length - 1) {
        // Move the path to the start of the next chapter, accounting for spacing.
        final double nextChapter = chapters[i + 1];
        path.moveTo((size.width * nextChapter) + _space, 0);
      }
    }

    // Close the path to form a complete shape.
    path.close();

    return path;
  }

  /// Indicates that re-clipping is unnecessary for this clipper.
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// A custom painter that draws circles at positions corresponding to key concept progress.
class ProgressKeyConceptPainter extends CustomPainter {
  /// Creates a new ProgressKeyConceptPainter.
  ///
  /// [keyConcepts]: A list of key concept progress values.
  ProgressKeyConceptPainter({super.repaint, required this.keyConcepts});

  /// List of key concept progress values, ranging from 0.0 (no progress) to 1.0
  /// (complete).
  final List<double> keyConcepts;

  /// Constant radius of the circles representing key concepts.
  static const double _radius = 2;

  /// Paints circles on the canvas based on the provided size and key concept progress.
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 1 // Sets the width of the circle's stroke.
      ..color = Colors.white // Sets the color of the circle to white.
      ..style = PaintingStyle.fill; // Fills the circles with the paint color.

    // Loop through each key concept and draw a circle at its corresponding position.
    for (int i = 0; i < keyConcepts.length; i++) {
      final double conceptProgress = keyConcepts[i];

      // Calculate the center of the circle based on progress and radius.
      final double centerX = (size.width * conceptProgress) + (_radius / 2);
      final double centerY = size.height / 2;

      // Draw the circle on the canvas.
      canvas.drawCircle(
        Offset(centerX, centerY),
        _radius,
        paint,
      );
    }
  }

  /// Indicates that re-painting is unnecessary unless the [keyConcepts] list changes.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ProgressReplayedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO(Josh): implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO(Josh): implement shouldRepaint
    throw UnimplementedError();
  }
}

// TODO(Josh): Move to different file
class KeyConcept {
  KeyConcept({required this.position});
  final Duration position;
}

class Chapter {
  Chapter({required this.position});

  /// Position represent where the chapter begins.
  ///
  /// No need or use of an end duration because the next chapter beginning will be
  /// the end of the current chapter.
  ///
  /// If no next chapter, the end of the video will be the end of the chapter
  final Duration position;
}

class Replayed {
  Replayed({required this.position});

  final Duration position;
}
