import 'package:flutter/material.dart';

const Duration _kDefaultHighlightFadeDuration = Duration(milliseconds: 2000);

class TapReleaseHighlight extends InkHighlight {
  TapReleaseHighlight({
    required super.controller,
    required super.referenceBox,
    required super.color,
    required super.textDirection,
    super.shape,
    super.radius,
    super.borderRadius,
    super.customBorder,
    super.rectCallback,
    super.onRemoved,
    Duration fadeDuration = _kDefaultHighlightFadeDuration,
  })  : _shape = shape,
        _radius = radius,
        _borderRadius = borderRadius ?? BorderRadius.zero,
        _textDirection = textDirection,
        _rectCallback = rectCallback {
    _setupAnimation(fadeDuration);
  }

  late AnimationController _animationController;
  late Animation<int> _alphaAnimation;

  void _setupAnimation(Duration duration) {
    _animationController = AnimationController(
      vsync: controller.vsync,
      duration: duration,
    );

    _alphaAnimation =
        IntTween(begin: color.a.toInt(), end: 0).animate(_animationController)
          ..addListener(() {
            controller.markNeedsPaint();
          })
          ..addStatusListener(
            (status) {
              if (status == AnimationStatus.completed) {
                dispose();
              }
            },
          );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void activate() {
    super.activate();
    _animationController.forward(from: 0.0);
  }

  final BoxShape _shape;
  final double? _radius;
  final BorderRadius _borderRadius;
  final RectCallback? _rectCallback;
  final TextDirection _textDirection;

  void _paintHighlight(Canvas canvas, Rect rect, Paint paint) {
    canvas.save();
    if (customBorder != null) {
      canvas.clipPath(
        customBorder!.getOuterPath(rect, textDirection: _textDirection),
      );
    }
    switch (_shape) {
      case BoxShape.circle:
        canvas.drawCircle(
          rect.center,
          _radius ?? Material.defaultSplashRadius,
          paint,
        );
      case BoxShape.rectangle:
        if (_borderRadius != BorderRadius.zero) {
          final RRect clipRRect = RRect.fromRectAndCorners(
            rect,
            topLeft: _borderRadius.topLeft,
            topRight: _borderRadius.topRight,
            bottomLeft: _borderRadius.bottomLeft,
            bottomRight: _borderRadius.bottomRight,
          );
          canvas.drawRRect(clipRRect, paint);
        } else {
          canvas.drawRect(rect, paint);
        }
    }
    canvas.restore();
  }

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    // TODO(josh4500): Paint properties should be set from constructor
    final Paint paint = Paint()
      ..color = color.withAlpha(_alphaAnimation.value)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final Offset? originOffset = MatrixUtils.getAsTranslation(transform);
    final Rect rect = _rectCallback != null
        ? _rectCallback()
        : Offset.zero & referenceBox.size;
    if (originOffset == null) {
      canvas.save();
      canvas.transform(transform.storage);
      _paintHighlight(canvas, rect, paint);
      canvas.restore();
    } else {
      _paintHighlight(canvas, rect.shift(originOffset), paint);
    }
  }
}
