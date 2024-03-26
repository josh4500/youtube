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
import 'custom_action_chip.dart';

/// A widget that allows a child to slide horizontally or vertically with a draggable area.
///
/// This widget provides a way to create a dismissible or sliding drawer
/// effect on a child widget. The child can be dragged in the specified direction
/// (`direction`) up to a certain percentage of the parent's size (`maxOffset`). When
/// released, the child will animate back to its original position or completely
/// slide away depending on the drag distance.
///
/// A trailing `icon` can be provided to be displayed behind the child widget
/// when it's slid away.
class Slidable extends StatefulWidget {
  const Slidable({
    super.key,
    this.sharedSlidableState,
    this.backgroundColor = Colors.white,
    this.maxOffset = 0.5,
    this.extraOffset = 0.1,
    this.duration = const Duration(milliseconds: 900),
    this.reverseDuration = const Duration(milliseconds: 250),
    this.direction = AxisDirection.left,
    this.icon,
    required this.child,
  });

  final SharedSlidableState? sharedSlidableState;

  /// Animation duration
  final Duration duration;

  /// Animation reverse duration
  final Duration reverseDuration;

  /// The background color of the sliding area. Defaults to white.
  final Color backgroundColor;

  /// The maximum offset the child can be slid in the specified direction as a percentage
  /// of the parent's size. Defaults to 0.5 (50%).
  final double maxOffset;

  final double extraOffset;

  /// The direction in which the child can be slid. Defaults to AxisDirection.left.
  final AxisDirection direction;

  /// An optional icon to be displayed behind the child widget when slid away.
  final Widget? icon;

  /// The child widget to be wrapped in the Slidable.
  final Widget child;

  @override
  State<Slidable> createState() => _SlidableState();
}

class _SlidableState extends State<Slidable> with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final AnimationController _extraSlideController;
  late Animation<Offset> _animation;
  late Animation<Offset> _extraSlideAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      animationBehavior: AnimationBehavior.preserve,
    );
    _extraSlideController = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      animationBehavior: AnimationBehavior.preserve,
    );
    _animation = _createAnimationValue();

    _extraSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: _getEndOffset(widget.extraOffset),
    ).animate(
      CurvedAnimation(
        parent: _extraSlideController,
        curve: Curves.linear,
        reverseCurve: Curves.easeInToLinear,
      ),
    );

    widget.sharedSlidableState?.addListener(_sharedStateListener);
  }

  void _sharedStateListener() {
    final key = widget.key;
    if (key != null && key is ValueKey) {
      if (widget.sharedSlidableState?.value != key.value) {
        _extraSlideController.reverse();
        _slideController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _extraSlideController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Slidable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.maxOffset != widget.maxOffset ||
        oldWidget.direction != widget.direction) {
      _animation = _createAnimationValue();
    }

    if (oldWidget.extraOffset != widget.extraOffset) {
      _extraSlideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: _getEndOffset(widget.extraOffset),
      ).animate(
        CurvedAnimation(
          parent: _extraSlideController,
          curve: Curves.linear,
          reverseCurve: Curves.easeInToLinear,
        ),
      );
    }

    if (oldWidget.sharedSlidableState == null) {
      widget.sharedSlidableState?.addListener(_sharedStateListener);
    }
    if (widget.sharedSlidableState == null) {
      oldWidget.sharedSlidableState?.removeListener(_sharedStateListener);
    }
  }

  /// Creates an animation for sliding the child widget with linear curves.
  Animation<Offset> _createAnimationValue() {
    return Tween<Offset>(
      begin: Offset.zero,
      end: _getEndOffset(widget.maxOffset),
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.linear,
        reverseCurve: Curves.linear,
      ),
    );
  }

  /// Calculates the end offset for the animation based on the direction and max
  /// offset.
  Offset _getEndOffset(double maxDirectionOffset) {
    return Offset(
      widget.direction.isLeft
          ? -maxDirectionOffset
          : widget.direction.isRight
              ? maxDirectionOffset
              : 0,
      widget.direction.isUp
          ? -maxDirectionOffset
          : widget.direction.isDown
              ? maxDirectionOffset
              : 0,
    );
  }

  /// Gets the offset value relevant to the sliding direction.
  double _getDirectionOffset(Offset offset) {
    if (widget.direction.isHorizontal) {
      return widget.direction.isLeft ? -offset.dx : offset.dx;
    } else {
      return offset.dy;
    }
  }

  /// Gets the size relevant to the sliding direction based on the constraints.
  double _getDirectionSie(BoxConstraints constraint) {
    if (widget.direction.isHorizontal) {
      return constraint.maxWidth;
    } else {
      return constraint.maxHeight;
    }
  }

  /// Handles the end of the drag gesture, deciding whether to complete or cancel
  /// the slide.
  void _onEndDrag(DragEndDetails details) {
    if (_slideController.value >= 0.5) {
      _slideController.forward();
    } else {
      _slideController.reverse();
    }
    _extraSlideController.reverse();
  }

  /// Updates the animation value during dragging, adjusting it based on the
  /// direction and constraints.
  void _onDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    final key = widget.key;
    if (key != null && key is ValueKey) {
      widget.sharedSlidableState?.value = key.value;
    }

    _slideController.value = clampDouble(
      _slideController.value +
          (_getDirectionOffset(details.delta) /
              (_getDirectionSie(constraints) * widget.maxOffset)),
      0,
      1,
    );

    if (_slideController.value == 1) {
      _extraSlideController.value = clampDouble(
        _extraSlideController.value +
            (_getDirectionOffset(details.delta) /
                (_getDirectionSie(constraints) * widget.maxOffset)),
        0,
        1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ColoredBox(
          color: Colors.white10,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Align(
                  alignment: axisDirectionToCenterAlignment(
                    flipAxisDirection(widget.direction),
                  ),
                  child: SizedBox(
                    width: constraints.maxWidth * widget.maxOffset,
                    child: CustomActionChip(
                      onTapCancel: _slideController.reverse,
                      alignment: Alignment.center,
                      backgroundColor: widget.backgroundColor,
                      borderRadius: BorderRadius.zero,
                      icon: widget.icon,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onVerticalDragEnd:
                    widget.direction.isVertical ? _onEndDrag : null,
                onVerticalDragUpdate: widget.direction.isVertical
                    ? (DragUpdateDetails details) {
                        _onDragUpdate(details, constraints);
                      }
                    : null,
                onHorizontalDragUpdate: widget.direction.isHorizontal
                    ? (DragUpdateDetails details) {
                        _onDragUpdate(details, constraints);
                      }
                    : null,
                onHorizontalDragEnd:
                    widget.direction.isHorizontal ? _onEndDrag : null,
                child: widget.extraOffset == 0
                    ? SlideTransition(
                        position: _animation,
                        child: widget.child,
                      )
                    : SlideTransition(
                        position: _extraSlideAnimation,
                        child: SlideTransition(
                          position: _animation,
                          child: widget.child,
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

/// Extension methods for the AxisDirection enum to provide convenient
/// ways to check its direction and alignment properties.
extension on AxisDirection {
  /// Returns true if this direction is [AxisDirection.left].
  bool get isLeft => this == AxisDirection.left;

  /// Returns true if this direction is [AxisDirection.right].
  bool get isRight => this == AxisDirection.right;

  /// Returns true if this direction is [AxisDirection.up].
  bool get isUp => this == AxisDirection.up;

  /// Returns true if this direction is [AxisDirection.down].
  bool get isDown => this == AxisDirection.down;

  /// Returns true if this direction is horizontal (left or right).
  bool get isHorizontal =>
      this == AxisDirection.left || this == AxisDirection.right;

  /// Returns true if this direction is vertical (up or down).
  bool get isVertical => this == AxisDirection.up || this == AxisDirection.down;
}

/// Returns the corresponding [Alignment] for the given [direction]
/// that positions a child widget at the center of the sliding area.
Alignment axisDirectionToCenterAlignment(AxisDirection direction) {
  switch (direction) {
    case AxisDirection.left:
      return Alignment.centerLeft;
    case AxisDirection.up:
      return Alignment.topCenter;
    case AxisDirection.right:
      return Alignment.centerRight;
    case AxisDirection.down:
      return Alignment.bottomCenter;
  }
}

class SharedSlidableState<T> extends ValueNotifier<T> {
  SharedSlidableState(super.value);
}
