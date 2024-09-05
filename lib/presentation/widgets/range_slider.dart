import 'package:flutter/material.dart';

class OneWayRangeSlider extends StatefulWidget {
  const OneWayRangeSlider({
    super.key,
    required this.value,
    this.trackHeight = 16,
    this.activeColor = Colors.white24,
    this.trackColor = Colors.black87,
    this.markerColor = Colors.blue,
    this.onChanged,
  });
  final RangeValue value;
  final double trackHeight;
  final Color trackColor;
  final Color activeColor;
  final Color markerColor;
  final ValueChanged<double>? onChanged;

  @override
  State<OneWayRangeSlider> createState() => _OneWayRangeSliderState();
}

class _OneWayRangeSliderState extends State<OneWayRangeSlider> {
  late final ValueNotifier<RangeValue> rangeValueNotifier;

  @override
  void initState() {
    super.initState();
    rangeValueNotifier = ValueNotifier<RangeValue>(
      widget.value,
    );
  }

  @override
  void dispose() {
    rangeValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            final currentValue = rangeValueNotifier.value;
            final maxWidth = constraints.maxWidth;
            final positionX = details.localPosition.dx;
            rangeValueNotifier.value = currentValue.copyWith(
              end: (positionX / maxWidth).clamp(
                rangeValueNotifier.value.start,
                1,
              ),
            );
            widget.onChanged?.call(rangeValueNotifier.value.end);
          },
          onHorizontalDragUpdate: (details) {
            final currentValue = rangeValueNotifier.value;
            final maxWidth = constraints.maxWidth;
            final positionX = details.localPosition.dx;
            rangeValueNotifier.value = currentValue.copyWith(
              end: (positionX / maxWidth).clamp(
                rangeValueNotifier.value.start,
                1,
              ),
            );
            widget.onChanged?.call(rangeValueNotifier.value.end);
          },
          child: Column(
            children: [
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                height: widget.trackHeight,
                child: ListenableBuilder(
                  listenable: rangeValueNotifier,
                  builder: (BuildContext context, Widget? _) {
                    return CustomPaint(
                      foregroundPainter: RangeSliderPainter(
                        value: rangeValueNotifier.value,
                        trackColor: widget.trackColor,
                        activeColor: widget.activeColor,
                        markerColor: widget.markerColor,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}

class RangeValue {
  const RangeValue({required this.start, required this.end});

  final double start;
  final double end;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RangeValue &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;

  RangeValue copyWith({
    double? start,
    double? end,
  }) {
    return RangeValue(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }
}

class RangeSliderPainter extends CustomPainter {
  RangeSliderPainter({
    super.repaint,
    required this.value,
    required this.trackColor,
    required this.activeColor,
    required this.markerColor,
    this.paddleRadius = 10,
  });

  final RangeValue value;
  final Color activeColor;
  final Color trackColor;
  final Color markerColor;
  final double paddleRadius;

  static const double strokeWidth = 2.5;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint markerPaint = Paint()
      ..color = markerColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final Paint markerPaddlePaint = Paint()
      ..color = markerColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    final Paint activePaint = Paint()
      ..color = activeColor
      ..strokeWidth = size.height - 4;

    final Paint backgroundPaint = Paint()
      ..color = trackColor
      ..strokeWidth = size.height
      ..strokeCap = StrokeCap.round;

    // Draws background
    canvas.drawRRect(
      RRect.fromLTRBR(0, 0, size.width, size.height, const Radius.circular(10)),
      backgroundPaint,
    );

    final RRect startBeginRRect = RRect.fromLTRBR(
      value.start > 0 ? 2.5 : 0,
      2.5,
      size.width * value.start,
      size.height - 2.5,
      const Radius.circular(12),
    );

    // Draws start range
    canvas.drawRRect(startBeginRRect, activePaint);

    if (value.start > 0) {
      final double markerX1 =
          (size.width * value.start) + (strokeWidth / 2) - 2.5;

      // Draws start maker
      canvas.drawLine(
        Offset(markerX1, 2),
        Offset(markerX1, size.height - 2),
        markerPaint,
      );
    }

    final RRect endBeginRRect = RRect.fromLTRBR(
      size.width * value.end,
      2.5,
      value.start < 1 ? size.width - 2.5 : size.width,
      size.height - 2.5,
      const Radius.circular(12),
    );

    // Draws end range
    canvas.drawRRect(endBeginRRect, activePaint);

    // Draws end marker
    final double markerX2 = (size.width * value.end) - (strokeWidth / 2) + 2.5;
    canvas.drawLine(
      Offset(markerX2, -(paddleRadius - 2)),
      Offset(markerX2, size.height + paddleRadius - 2),
      markerPaint,
    );
    // Draws paddle
    canvas.drawCircle(
      Offset(markerX2, size.height + paddleRadius + 2),
      paddleRadius,
      markerPaddlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
