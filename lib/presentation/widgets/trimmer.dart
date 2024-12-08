import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clone/core.dart';

const double kTrimmerPadding = 12.0;

enum TrimDragPosition {
  left,
  right,
  none;

  bool get isLeft => this == TrimDragPosition.left;
  bool get isRight => this == TrimDragPosition.right;
}

class TrimDragDetails {
  TrimDragDetails({
    required this.width,
    required this.xPosition,
    required this.xDelta,
  });

  final double width;
  final double xPosition;
  final double xDelta;
}

abstract class TrimmerNotification extends Notification {}

class TrimmerLongPressNotification extends TrimmerNotification {
  TrimmerLongPressNotification({required this.position, required this.range});

  final TrimDragPosition position;
  final RangeValue range;
}

class TrimmerDragUpdateNotification extends TrimmerNotification {
  TrimmerDragUpdateNotification({
    required this.position,
    required this.range,
    required this.details,
  });

  final TrimDragPosition position;
  final RangeValue range;
  final TrimDragDetails details;
}

class TrimmerEndNotification extends TrimmerNotification {
  TrimmerEndNotification({required this.position, required this.range});

  final TrimDragPosition position;
  final RangeValue range;
}

class Trimmer extends StatefulWidget {
  const Trimmer({super.key, this.child});

  final Widget? child;

  @override
  State<Trimmer> createState() => _TrimmerState();
}

class _TrimmerState extends State<Trimmer> {
  final ValueNotifier<RangeValue> _rangeNotifier = ValueNotifier(
    const RangeValue(start: 0, end: 1),
  );

  bool _releaseLongPress = true;
  TrimDragPosition _dragPosition = TrimDragPosition.none;
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
    if (_dragPosition == TrimDragPosition.none) {
      return;
    }
    final range = _rangeNotifier.value;
    final add = 24 / maxWidth;

    if (_releaseLongPress &&
        xPosition < _longPressPosition + kTrimmerPadding &&
        xPosition > _longPressPosition - kTrimmerPadding) {
      _longPressPosition = xPosition;
      _longPressTimer?.cancel();
      _longPressTimer = Timer(
        kLongPressTimeout * 2,
        () {
          if (_dragPosition != TrimDragPosition.none) {
            _releaseLongPress = false;

            if (xPosition < _longPressPosition + kTrimmerPadding &&
                xPosition > _longPressPosition - kTrimmerPadding) {
              TrimmerLongPressNotification(
                position: _dragPosition,
                range: range,
              ).dispatch(context);
            }
          }
        },
      );
    } else {
      _longPressPosition = xPosition;
    }

    _rangeNotifier.value = range.copyWith(
      start: _dragPosition.isLeft && range.start + xDelta + add < range.end
          ? (range.start + xDelta).clamp(0, 1)
          : null,
      end: _dragPosition.isRight && range.end + xDelta - add > range.start
          ? (range.end + xDelta).clamp(0, 1)
          : null,
    );
  }

  void _onPressDragEnd() {
    _dragPosition = TrimDragPosition.none;
    _longPressTimer?.cancel();
    _longPressTimer = null;
    _releaseLongPress = true;
    TrimmerEndNotification(
      position: _dragPosition,
      range: _rangeNotifier.value,
    ).dispatch(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          onLongPressStart: (LongPressStartDetails details) {
            final range = _rangeNotifier.value;
            final maxWidth = constraints.maxWidth;
            final xPosition = details.localPosition.dx;
            if (xPosition <= (maxWidth * range.start) + kTrimmerPadding) {
              _dragPosition = TrimDragPosition.left;
              TrimmerLongPressNotification(
                position: _dragPosition,
                range: range,
              ).dispatch(context);
            } else if (xPosition >= (maxWidth * range.end) - kTrimmerPadding) {
              _dragPosition = TrimDragPosition.right;
              TrimmerLongPressNotification(
                position: _dragPosition,
                range: range,
              ).dispatch(context);
            }
          },
          onHorizontalDragStart: (DragStartDetails details) {
            final range = _rangeNotifier.value;
            final maxWidth = constraints.maxWidth;
            final xPosition = details.localPosition.dx;

            // Offset where trim drag is detected
            const d = kTrimmerPadding * 1.5;
            if (xPosition <= (maxWidth * range.start) + d) {
              _dragPosition = TrimDragPosition.left;
            } else if (xPosition >= (maxWidth * range.end) - d) {
              _dragPosition = TrimDragPosition.right;
            } else {
              _dragPosition = TrimDragPosition.none;
            }
          },
          onLongPressEnd: (_) => _onPressDragEnd(),
          onHorizontalDragEnd: (_) => _onPressDragEnd(),
          onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
            _onDragMoveUpdate(
              xDelta: (details.localPosition.dx - _longPressPosition) /
                  constraints.maxWidth,
              xPosition: details.localPosition.dx,
              maxWidth: constraints.maxWidth,
            );
            TrimmerDragUpdateNotification(
              position: _dragPosition,
              range: _rangeNotifier.value,
              details: TrimDragDetails(
                xDelta: (details.localPosition.dx - _longPressPosition) /
                    constraints.maxWidth,
                width: constraints.maxWidth,
                xPosition: details.localPosition.dx.clamp(
                  0,
                  constraints.maxWidth,
                ),
              ),
            ).dispatch(context);
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            _onDragMoveUpdate(
              xDelta: details.delta.dx / constraints.maxWidth,
              xPosition: details.localPosition.dx,
              maxWidth: constraints.maxWidth,
            );
            TrimmerDragUpdateNotification(
              position: _dragPosition,
              range: _rangeNotifier.value,
              details: TrimDragDetails(
                xDelta: details.delta.dx,
                width: constraints.maxWidth,
                xPosition: details.localPosition.dx,
              ),
            ).dispatch(context);
          },
          child: ValueListenableBuilder(
            valueListenable: _rangeNotifier,
            builder: (
              BuildContext context,
              RangeValue range,
              Widget? childWidget,
            ) {
              return SizedBox.fromSize(
                size: Size(constraints.maxWidth, double.infinity),
                child: CustomPaint(
                  foregroundPainter: TrimmerPainter(range: range),
                  child: childWidget,
                ),
              );
            },
            child: widget.child,
          ),
        );
      },
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
      ..strokeWidth = 4;

    canvas.saveLayer(Rect.largest, Paint());

    // Overlay color
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.zero,
      ),
      Paint()..color = Colors.black54,
    );

    // Clear space
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          range.start * size.width + kTrimmerPadding,
          2.5,
          ((range.end - range.start) * size.width) - kTrimmerPadding * 1.5,
          size.height - 2.5,
        ),
        Radius.zero,
      ),
      Paint()
        ..color = Colors.transparent
        ..blendMode = BlendMode.clear,
    );

    // Start range
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          range.start * size.width,
          0,
          kTrimmerPadding,
          size.height,
        ),
        const Radius.circular(4),
      ),
      paint,
    );
    // End range
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          (range.end * size.width) - kTrimmerPadding,
          0,
          kTrimmerPadding,
          size.height,
        ),
        const Radius.circular(4),
      ),
      paint,
    );

    // Top border line
    canvas.drawLine(
      Offset(range.start * size.width + 6, 2),
      Offset(range.end * size.width - 6, 2),
      paint,
    );
    // Bottom border line
    canvas.drawLine(
      Offset(
        range.start * size.width + kTrimmerPadding / 2,
        size.height - 2,
      ),
      Offset(
        range.end * size.width - kTrimmerPadding / 2,
        size.height - 2,
      ),
      paint,
    );

    // Start ranger marker
    canvas.drawLine(
      Offset(
        range.start * size.width + kTrimmerPadding / 2,
        kTrimmerPadding,
      ),
      Offset(
        range.start * size.width + kTrimmerPadding / 2,
        size.height - kTrimmerPadding,
      ),
      Paint()
        ..color = Colors.black
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2,
    );
    // End ranger marker
    canvas.drawLine(
      Offset(
        range.end * size.width - kTrimmerPadding / 2,
        kTrimmerPadding,
      ),
      Offset(
        range.end * size.width - kTrimmerPadding / 2,
        size.height - kTrimmerPadding,
      ),
      Paint()
        ..color = Colors.black
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(TrimmerPainter oldDelegate) => oldDelegate.range != range;
}
