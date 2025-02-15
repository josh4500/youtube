import 'package:flutter/material.dart';

const double kFocusSize = 56;

class CaptureFocusIndicator extends StatelessWidget {
  const CaptureFocusIndicator({super.key, required this.animation});

  final AnimationController animation;

  @override
  Widget build(BuildContext context) {
    final sizeAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0, .5, curve: Curves.easeInCubic),
    );

    final opacityAnimation = ReverseAnimation(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(.5, 1, curve: Curves.easeInCubic),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? _) {
        final sizeFactor = sizeAnimation.value;
        final opacity = opacityAnimation.value;
        return CustomPaint(
          size: const Size.square(kFocusSize),
          foregroundPainter: _FocusPainter(
            sizeFactor: sizeFactor,
            opacity: opacity,
          ),
          willChange: true,
        );
      },
    );
  }
}

class _FocusPainter extends CustomPainter {
  _FocusPainter({
    required this.sizeFactor,
    required this.opacity,
  });

  final double sizeFactor;
  final double opacity;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
      Offset(size.width, size.width),
      (size.width / 2) + (12 * (1 - sizeFactor)),
      paint,
    );

    final Paint paint2 = Paint()
      ..strokeWidth = 1
      ..color = Colors.white.withAlpha((77.0 * opacity).round())
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width, size.width),
      ((size.width / 2) - 7) + (5 * sizeFactor),
      paint2,
    );
  }

  @override
  bool shouldRepaint(_FocusPainter oldPainter) {
    return oldPainter.sizeFactor != sizeFactor || oldPainter.opacity != opacity;
  }
}
