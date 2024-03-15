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

/// Default size of the tappable area for seeking playback.
const defaultPlaybackProgressTapSize = 10.0;

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

  /// List of key concepts and their positions within the playback duration.
  final List<KeyConcept> keyConcepts;

  /// List of chapters and their positions within the playback duration.
  final List<Chapter> chapters;

  /// Callback triggered when the user taps on the progress indicator.
  final void Function(Duration position)? onTap;

  /// Callback triggered when the user starts dragging the progress indicator.
  final void Function(Duration position)? onDragStart;

  /// Callback triggered when the user finishes dragging the progress indicator.
  final void Function()? onDragEnd;

  /// Callback triggered when the user changes the playback position (during drag).
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
    this.keyConcepts = const <KeyConcept>[],
    this.chapters = const <Chapter>[],
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
        Tween<double>(begin: _indicatorHeight, end: 12),
      );
      progressAnimation = widget.animation!.drive(
        ColorTween(begin: Colors.white70, end: const Color(0xFFFF0000)),
      );
    }
  }

  /// Progress Indicators minimum height
  double get _indicatorHeight => widget.keyConcepts.isEmpty ? 2 : 4;

  /// Equivalent value between 0 - 1 of the KeyConcepts duration positions
  List<double> get _keyConceptPositions => widget.keyConcepts
      .map((e) => e.position.inMicroseconds / widget.end!.inMicroseconds)
      .toList();

  /// Equivalent value between 0 - 1 of the Chapter duration positions
  List<double> get _chaptersPositions => widget.chapters
      .map((e) => e.position.inMicroseconds / widget.end!.inMicroseconds)
      .toList();

  /// Computes playback progress values
  ProgressValue _computeProgressValue(Progress data) {
    final positionValue =
        data.position.inSeconds / (widget.end?.inSeconds ?? 0);
    final bufferValue = data.buffer.inSeconds / (widget.end?.inSeconds ?? 0);
    return (positionValue, bufferValue);
  }

  @override
  Widget build(BuildContext context) {
    Widget indicators = StreamBuilder<Progress>(
      stream: widget.progress,
      initialData: widget.start,
      builder: (context, snapshot) {
        final data = _computeProgressValue(snapshot.data ?? Progress.zero);
        final positionValue = data.$1;
        final bufferValue = data.$2;
        return Stack(
          clipBehavior: Clip.none,
          children: [
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
            if (progressAnimation != null)
              AnimatedBuilder(
                animation: progressAnimation!,
                builder: (_, __) {
                  return LinearProgressIndicator(
                    color: progressAnimation!.value ?? widget.color,
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

    final thumbIndicator = thumbAnimation != null
        ? AnimatedBuilder(
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
          )
        : null;

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
                // Stacked Position and Buffer indicators
                indicators,
                // Thumb Indicator
                if (thumbAnimation != null)
                  StreamBuilder<Progress>(
                    stream: widget.progress,
                    initialData: widget.start,
                    builder: (context, snapshot) {
                      final data = _computeProgressValue(
                        snapshot.data ?? Progress.zero,
                      );
                      final positionValue = data.$1;

                      return Positioned(
                        bottom: -4.75,
                        left: (positionValue * constraint.maxWidth) - 1.5,
                        child: thumbIndicator!,
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

  /// Handles tap down event on the widget and triggers the `onTap` callback
  /// if provided.
  ///
  /// [details]: The details of the tap down event.
  /// [width]: The width of the widget.
  void _onTapDown(TapDownDetails details, double width) {
    // Get the position in milliseconds relative to the widget width.
    final positionInMilliseconds =
        _getRelativePosition(details.localPosition.dx, width);

    // Call the passed `onTap` callback if available.
    if (widget.onTap != null) {
      widget.onTap!(Duration(milliseconds: positionInMilliseconds));
    }
  }

  /// Handles the start of a horizontal drag event and triggers the `onDragStart`
  /// callback if provided.
  ///
  /// [details]: The details of the drag start event.
  /// [width]: The width of the widget.
  void _onHorizontalDragStart(DragStartDetails details, double width) {
    // Get the position in milliseconds relative to the widget width.
    final positionInMilliseconds =
        _getRelativePosition(details.localPosition.dx, width);

    // Call the passed `onDragStart` callback if available.
    if (widget.onDragStart != null) {
      widget.onDragStart!(Duration(milliseconds: positionInMilliseconds));
    }
  }

  /// Handles updates during a horizontal drag event and triggers the
  /// `onChangePosition` callback if provided.
  ///
  /// [details]: The details of the drag update event.
  /// [width]: The width of the widget.
  void _onHorizontalDragUpdate(DragUpdateDetails details, double width) {
    // Get the position in milliseconds relative to the widget width.
    final positionInMilliseconds =
        _getRelativePosition(details.localPosition.dx, width);

    // Call the passed `onChangePosition` callback if available.
    if (widget.onChangePosition != null) {
      widget.onChangePosition!(Duration(milliseconds: positionInMilliseconds));
    }
  }

  /// Handles the end of a horizontal drag event and triggers the `onDragEnd`
  /// callback if provided.
  ///
  /// [details]: The details of the drag end event.
  void _onHorizontalDragEnd(DragEndDetails details, double width) {
    // Call the passed `onDragEnd` callback if available.
    if (widget.onDragEnd != null) {
      widget.onDragEnd!();
    }
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
  /// Constant spacing between chapters in the visual representation.
  static const double _space = 2.5;

  /// List of chapter progress values, ranging from 0.0 (no progress) to 1.0
  /// (complete).
  final List<double> chapters;

  /// Creates a new ProgressChapterClipper.
  ///
  /// [chapters]: A list of chapter progress values.
  ProgressChapterClipper({super.reclip, required this.chapters});

  /// Generates the clipping path based on the provided size and chapter progress.
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start path creation at the top-left corner.
    path.moveTo(0, 0);

    // Iterate through each chapter to create path segments.
    for (int i = 0; i < chapters.length; i++) {
      final chapter = chapters[i];

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
        final prevChapter = chapters[i - 1];
        path.lineTo((size.width * prevChapter) + _space, size.height);
        path.lineTo((size.width * prevChapter) + _space, 0);
      }

      if (i != chapters.length - 1) {
        // Move the path to the start of the next chapter, accounting for spacing.
        final nextChapter = chapters[i + 1];
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
  /// List of key concept progress values, ranging from 0.0 (no progress) to 1.0
  /// (complete).
  final List<double> keyConcepts;

  /// Constant radius of the circles representing key concepts.
  static const double _radius = 2;

  /// Creates a new ProgressKeyConceptPainter.
  ///
  /// [keyConcepts]: A list of key concept progress values.
  ProgressKeyConceptPainter({super.repaint, required this.keyConcepts});

  /// Paints circles on the canvas based on the provided size and key concept progress.
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1 // Sets the width of the circle's stroke.
      ..color = Colors.white // Sets the color of the circle to white.
      ..style = PaintingStyle.fill; // Fills the circles with the paint color.

    // Loop through each key concept and draw a circle at its corresponding position.
    for (int i = 0; i < keyConcepts.length; i++) {
      final conceptProgress = keyConcepts[i];

      // Calculate the center of the circle based on progress and radius.
      final centerX = (size.width * conceptProgress) + (_radius / 2);
      final centerY = size.height / 2;

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

// TODO: Move to different file

class KeyConcept {
  final Duration position;

  KeyConcept({required this.position});
}

class Chapter {
  /// Position represent where the chapter begins.
  ///
  /// No need or use of an end duration because the next chapter beginning will be
  /// the end of the current chapter.
  ///
  /// If no next chapter, the end of the video will be the end of the chapter
  final Duration position;

  Chapter({required this.position});
}
