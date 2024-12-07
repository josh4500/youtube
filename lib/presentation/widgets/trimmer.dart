import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'range_slider.dart';

enum TrimDragPosition {
  left,
  right;

  bool get isLeft => this == TrimDragPosition.left;
  bool get isRight => this == TrimDragPosition.right;
}

abstract class TrimmerNotification extends Notification {}

class TrimmerRangeUpdateNotification extends TrimmerNotification {
  TrimmerRangeUpdateNotification({required this.range});

  final RangeValue range;
}

class TrimmerLongPressNotification extends TrimmerNotification {
  TrimmerLongPressNotification({required this.position, required this.range});

  final TrimDragPosition position;
  final RangeValue range;
}

class Trimmer extends StatefulWidget {
  const Trimmer({super.key});

  @override
  State<Trimmer> createState() => _TrimmerState();
}

class _TrimmerState extends State<Trimmer> {
  final ValueNotifier<RangeValue> rangeNotifier = ValueNotifier(
    const RangeValue(start: 0, end: 1),
  );

  bool _releaseLongPress = true;
  TrimDragPosition? _dragPosition;
  double _longPressPosition = 0;
  Timer? _longPressTimer;

  @override
  void dispose() {
    _longPressTimer?.cancel();
    _longPressTimer = null;
    super.dispose();
  }

  void _onDragMoveUpdate({
    double xDelta = 0,
    double maxWidth = 0,
    double xPosition = 0,
  }) {
    if (_dragPosition == null) {
      return;
    }
    final range = rangeNotifier.value;
    final add = 24 / maxWidth;

    if (_releaseLongPress &&
        xPosition < _longPressPosition + 12 &&
        xPosition > _longPressPosition - 12) {
      _longPressPosition = xPosition;
      _longPressTimer?.cancel();
      _longPressTimer = Timer(
        kLongPressTimeout,
        () {
          if (_dragPosition != null) {
            _releaseLongPress = false;

            TrimmerLongPressNotification(
              position: _dragPosition!,
              range: range,
            ).dispatch(context);
          }
        },
      );
    } else {
      _longPressPosition = xPosition;
    }

    rangeNotifier.value = range.copyWith(
      start: _dragPosition!.isLeft && range.start + xDelta + add < range.end
          ? (range.start + xDelta).clamp(0, 1)
          : null,
      end: _dragPosition!.isRight && range.end + xDelta - add > range.start
          ? (range.end + xDelta).clamp(0, 1)
          : null,
    );
    TrimmerRangeUpdateNotification(
      range: rangeNotifier.value,
    ).dispatch(context);
  }

  void _onPressDragEnd() {
    _dragPosition = null;
    _longPressTimer?.cancel();
    _longPressTimer = null;
    _releaseLongPress = true;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return GestureDetector(
            onLongPressDown: (LongPressDownDetails details) {
              final range = rangeNotifier.value;
              final maxWidth = constraints.maxWidth;
              final xPosition = details.localPosition.dx;
              if (xPosition <= (maxWidth * range.start) + 12) {
                _dragPosition = TrimDragPosition.left;
                TrimmerLongPressNotification(
                  position: _dragPosition!,
                  range: range,
                ).dispatch(context);
              } else if (xPosition >= (maxWidth * range.end) - 12) {
                _dragPosition = TrimDragPosition.right;
                TrimmerLongPressNotification(
                  position: _dragPosition!,
                  range: range,
                ).dispatch(context);
              }
            },
            onHorizontalDragStart: (DragStartDetails details) {
              final range = rangeNotifier.value;
              final maxWidth = constraints.maxWidth;
              final xPosition = details.localPosition.dx;
              if (xPosition <= (maxWidth * range.start) + 12) {
                _dragPosition = TrimDragPosition.left;
              } else if (xPosition >= (maxWidth * range.end) - 12) {
                _dragPosition = TrimDragPosition.right;
              }
            },
            onLongPressEnd: (_) => _onPressDragEnd(),
            onHorizontalDragEnd: (_) => _onPressDragEnd(),
            onLongPressMoveUpdate: (details) {
              _onDragMoveUpdate(
                xDelta: (details.localPosition.dx - _longPressPosition) /
                    constraints.maxWidth,
                xPosition: details.localPosition.dx,
                maxWidth: constraints.maxWidth,
              );
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              _onDragMoveUpdate(
                xDelta: details.delta.dx / constraints.maxWidth,
                xPosition: details.localPosition.dx,
                maxWidth: constraints.maxWidth,
              );
            },
            child: ValueListenableBuilder(
              valueListenable: rangeNotifier,
              builder: (BuildContext context, RangeValue range, Widget? _) {
                return SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: TrimmerPainter(range: range),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class TrimmerPainter extends CustomPainter {
  const TrimmerPainter({this.range = RangeValue.zero});
  final RangeValue range;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(range.start * size.width, 0, 12, size.height),
        const Radius.circular(4),
      ),
      paint,
    );
    canvas.drawLine(
      Offset(range.start * size.width + 6, 0),
      Offset(range.end * size.width - 6, 0),
      paint,
    );
    canvas.drawLine(
      Offset(range.start * size.width + 6, size.height),
      Offset(range.end * size.width - 6, size.height),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH((range.end * size.width) - 12, 0, 12, size.height),
        const Radius.circular(4),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
