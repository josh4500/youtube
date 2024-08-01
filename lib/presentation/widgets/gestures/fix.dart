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
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// TODO: Remove
class StackedPosition {
  StackedPosition({this.top, this.bottom, this.left, this.right});

  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
}

class TappableArea extends StatefulWidget {
  const TappableArea({
    super.key,
    this.padding = const EdgeInsets.symmetric(
      vertical: 4,
      horizontal: 8,
    ),
    this.shape = BoxShape.rectangle,
    this.behavior,
    this.borderRadius = BorderRadius.zero,
    // TODO: Remove
    this.stackedPosition,
    this.stackedAlignment = Alignment.center,
    this.stackedChild,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.splashColor,
    this.onTapDown,
    this.autofocus = false,
    this.focusNode,
    this.enableFeedback = false,
    this.onTapUp,
    this.onTapCancel,
    this.onDoubleTap,
    this.onHover,
    this.hoverColor,
    this.mouseCursor,
    this.focusColor,
    this.highlightColor,
    this.overlayColor,
    this.onSecondaryTap,
    this.onSecondaryTapUp,
    this.onSecondaryTapDown,
    this.onSecondaryTapCancel,
    this.onHighlightChanged,
    this.focusChange,
  });

  final bool autofocus;
  final FocusNode? focusNode;
  final bool enableFeedback;
  final Widget child;
  final BoxShape shape;
  final HitTestBehavior? behavior;
  final EdgeInsets padding;
  final Alignment stackedAlignment;
  final StackedPosition? stackedPosition;
  final Widget? stackedChild;
  final BorderRadius borderRadius;
  final GestureTapCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final GestureDoubleTapCallback? onDoubleTap;

  final GestureTapCallback? onSecondaryTap;
  final GestureTapUpCallback? onSecondaryTapUp;
  final GestureTapDownCallback? onSecondaryTapDown;
  final GestureTapCallback? onSecondaryTapCancel;
  final ValueChanged<bool>? onHighlightChanged;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? focusChange;
  final MouseCursor? mouseCursor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final Color? splashColor;

  final GestureLongPressCallback? onLongPress;

  @override
  State<TappableArea> createState() => _TappableAreaState();
}

class _TappableAreaState extends State<TappableArea>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<Border?> _borderAnimation;
  final WidgetStatesController statesController = WidgetStatesController();
  bool _reversing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 600),
    );

    _borderAnimation = BorderTween(
      begin: const Border.fromBorderSide(
        BorderSide(color: Colors.transparent),
      ),
      end: const Border.fromBorderSide(
        BorderSide(color: Colors.white10),
      ),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0,
          0.5,
          curve: Curves.ease,
        ),
        reverseCurve: const Interval(
          0,
          0.8,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.reverse) {
        _reversing = true;
      } else if (status == AnimationStatus.completed) {
        _reversing = false;
      } else if (status == AnimationStatus.forward) {
        _reversing = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    statesController.dispose();
    super.dispose();
  }

  void handleTapUp(TapUpDetails details) async {
    widget.onTapUp?.call(details);
    if (statesController.value.contains(WidgetState.pressed)) {
      await _controller.reverse(from: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onTap: widget.onTap,
      onTapUp: handleTapUp,
      onTapDown: widget.onTapDown,
      onTapCancel: widget.onTapCancel,
      onLongPress: widget.onLongPress,
      onDoubleTap: widget.onDoubleTap,
      enableFeedback: widget.enableFeedback,
      onSecondaryTap: widget.onSecondaryTap,
      onSecondaryTapUp: widget.onSecondaryTapUp,
      onSecondaryTapDown: widget.onSecondaryTapDown,
      onSecondaryTapCancel: widget.onSecondaryTapCancel,
      onHover: widget.onHover,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      mouseCursor: widget.mouseCursor,
      onFocusChange: widget.focusChange,
      statesController: statesController,
      hoverDuration: const Duration(milliseconds: 300),
      splashColor: Colors.white10,
      overlayColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.white10;
        } else if (states.contains(WidgetState.hovered)) {
          return Colors.white70;
        } else if (states.contains(WidgetState.focused)) {
          return Colors.white10;
        } else if (states.contains(WidgetState.disabled)) {
          return Colors.white10;
        } else {
          return Colors.transparent; // Default color if no state matches
        }
      }),
      customBorder: widget.shape == BoxShape.circle
          ? const RoundedRectangleBorder(
              side: BorderSide(color: Colors.white12),
            )
          : const CircleBorder(
              side: BorderSide(color: Colors.red, width: 4),
            ),
      borderRadius: widget.borderRadius,
      splashFactory: _CustomSplashFactory.splashFactory,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }
}

class _CustomSplashFactory extends InteractiveInkFeatureFactory {
  const _CustomSplashFactory();
  static const _CustomSplashFactory splashFactory = _CustomSplashFactory();
  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return CustomSplash(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: containedInkWell,
      rectCallback: rectCallback,
      customBorder: customBorder,
      radius: radius,
      onRemoved: onRemoved,
    );
  }
}

const Duration _kUnconfirmedSplashDuration = Duration(seconds: 1);
const double _kSplashConfirmedVelocity = 1.0; // logical pixels per millisecond

RectCallback? _getClipCallback(
  RenderBox referenceBox,
  bool containedInkWell,
  RectCallback? rectCallback,
) {
  if (rectCallback != null) {
    assert(containedInkWell);
    return rectCallback;
  }
  if (containedInkWell) {
    return () => Offset.zero & referenceBox.size;
  }
  return null;
}

double _getTargetRadius(
  RenderBox referenceBox,
  bool containedInkWell,
  RectCallback? rectCallback,
  Offset position,
) {
  final Size size =
      rectCallback != null ? rectCallback().size : referenceBox.size;
  return _getSplashRadiusForPositionInSize(size, position);
}

double _getSplashRadiusForPositionInSize(Size bounds, Offset position) {
  final double d1 = (position - bounds.topLeft(Offset.zero)).distance;
  final double d2 = (position - bounds.topRight(Offset.zero)).distance;
  final double d3 = (position - bounds.bottomLeft(Offset.zero)).distance;
  final double d4 = (position - bounds.bottomRight(Offset.zero)).distance;
  return math.max(math.max(d1, d2), math.max(d3, d4)).ceilToDouble();
}

class CustomSplash extends InteractiveInkFeature {
  CustomSplash({
    required MaterialInkController controller,
    required super.referenceBox,
    Offset? position,
    required super.color,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    super.customBorder,
    double? radius,
    super.onRemoved,
  })  : _position = position,
        _targetRadius = radius ??
            _getTargetRadius(
              referenceBox,
              containedInkWell,
              rectCallback,
              position!,
            ),
        _clipCallback =
            _getClipCallback(referenceBox, containedInkWell, rectCallback),
        _repositionToReferenceBox = !containedInkWell,
        super(controller: controller) {
    _animationController = AnimationController(
      duration: _kUnconfirmedSplashDuration,
      vsync: controller.vsync,
    )
      ..addListener(controller.markNeedsPaint)
      ..addStatusListener(_handleStatusChanged)
      ..forward();

    controller.addInkFeature(this);
  }

  final Offset? _position;
  final double _targetRadius;
  final RectCallback? _clipCallback;
  final bool _repositionToReferenceBox;

  late AnimationController _animationController;

  @override
  void confirm() {
    final int duration = (_targetRadius / _kSplashConfirmedVelocity).floor();
    _animationController
      ..duration = Duration(milliseconds: duration)
      ..forward();
  }

  void _handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      dispose();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    final Paint paint = Paint()
      ..color = Colors.white10
      ..strokeWidth = .8
      ..style = PaintingStyle.stroke;
    Offset? center = _position;
    if (_repositionToReferenceBox) {
      center = referenceBox.size.center(Offset.zero);
    }

    final Offset? originOffset = MatrixUtils.getAsTranslation(transform);
    canvas.save();
    if (originOffset == null) {
      canvas.transform(transform.storage);
    } else {
      canvas.translate(originOffset.dx, originOffset.dy);
    }
    canvas.drawCircle(center!, referenceBox.size.width / 2, paint);
    canvas.restore();
  }
}
