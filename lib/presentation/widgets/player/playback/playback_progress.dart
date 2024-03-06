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

class PlaybackProgress extends StatefulWidget {
  final Color? color;
  final Animation<double?>? animation;
  final Animation<Color?>? bufferAnimation;
  final Color? backgroundColor;
  final Stream<Progress>? progress;
  final Progress? start;
  final Duration? end;
  final bool showBuffer;

  const PlaybackProgress({
    super.key,
    this.color = Colors.red,
    this.animation,
    this.bufferAnimation,
    this.progress,
    this.start = Progress.zero,
    this.end = Duration.zero,
    this.showBuffer = true,
    this.backgroundColor = Colors.white30,
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
        Tween<double>(begin: 0, end: 8),
      );
      progressAnimation = widget.animation!.drive(
        ColorTween(begin: Colors.white, end: Colors.red),
      );
    }
  }

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
              child: SizedBox(
                height: 7,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  clipBehavior: Clip.none,
                  children: [
                    // Buffering Progress indicator
                    if (widget.showBuffer)
                      LinearProgressIndicator(
                        color: Colors.white24,
                        value: bufferValue.isNaN || bufferValue.isInfinite
                            ? 0
                            : bufferValue,
                        minHeight: 2,
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
                            value:
                                positionValue.isNaN || positionValue.isInfinite
                                    ? 0
                                    : positionValue,
                            minHeight: 2,
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
                        minHeight: 2,
                        backgroundColor:
                            widget.backgroundColor ?? Colors.transparent,
                      ),

                    // Thumb
                    if (thumbAnimation != null)
                      Positioned(
                        bottom: -3,
                        left: (positionValue * constraint.maxWidth) - 4,
                        child: AnimatedBuilder(
                          animation: thumbAnimation!,
                          builder: (context, _) {
                            return Container(
                              width: thumbAnimation?.value,
                              height: thumbAnimation?.value,
                              decoration: const BoxDecoration(
                                color: Colors.red,
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

  void _onTapDown(TapDownDetails details, double width) {}

  void _onHorizontalDragStart(DragStartDetails details, double width) {}

  void _onHorizontalDragUpdate(DragUpdateDetails details, double width) {}

  void _onHorizontalDragEnd(DragEndDetails details, double width) {}
}
