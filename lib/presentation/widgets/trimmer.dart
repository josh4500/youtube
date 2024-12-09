import 'dart:async';

import 'package:flutter/foundation.dart';
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

class TrimController extends ChangeNotifier {
  RangeValue _current = const RangeValue(start: 0, end: 1);
  RangeValue get current => _current;

  List<RangeValue> _changes = [const RangeValue(start: 0, end: 1)];
  List<RangeValue> _undoHistory = [];

  bool get canUndo => _changes.length > 1;
  bool get canRedo => _undoHistory.isNotEmpty;

  void updateCurrentRange(RangeValue range) {
    if (range != _current) {
      _current = range;
      notifyListeners();
    }
  }

  void updateChanges(RangeValue range) {
    if (_changes.isNotEmpty && _changes.last == range) {
      return;
    }
    _current = range;
    _changes.add(range);
    _undoHistory.clear();

    notifyListeners();
  }

  void undo() {
    if (_changes.length > 1) {
      final lastChanges = _changes.removeLast();
      _undoHistory = [..._undoHistory, lastChanges];
      if (_changes.isNotEmpty) {
        updateCurrentRange(_changes.last);
      } else {
        updateCurrentRange(const RangeValue(start: 0, end: 1));
      }
    }
  }

  void redo() {
    if (_undoHistory.isNotEmpty) {
      final lastRemoved = _undoHistory.removeLast();
      _changes = [..._changes, lastRemoved];
      updateCurrentRange(lastRemoved);
    }
  }

  void clear() {
    _changes = [const RangeValue(start: 0, end: 1)];
    _undoHistory.clear();
    _current = const RangeValue(start: 0, end: 1);
    notifyListeners();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrimController &&
          runtimeType == other.runtimeType &&
          _current == other._current &&
          listEquals(_changes, other._changes) &&
          listEquals(_undoHistory, other._undoHistory);

  @override
  int get hashCode =>
      _current.hashCode ^ _changes.hashCode ^ _undoHistory.hashCode;
}

class Trimmer extends StatefulWidget {
  const Trimmer({
    super.key,
    this.child,
    this.controller,
    this.borderLines = true,
  });

  final TrimController? controller;
  final bool borderLines;
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
  void initState() {
    super.initState();
    widget.controller?.addListener(_historyListener);
  }

  @override
  void dispose() {
    widget.controller?.addListener(_historyListener);
    _longPressTimer?.cancel();
    _longPressTimer = null;
    super.dispose();
  }

  void _historyListener() {
    if (widget.controller != null) {
      _rangeNotifier.value = widget.controller!.current;
    }
  }

  @override
  void didUpdateWidget(covariant Trimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == null) {
      widget.controller?.updateChanges(_rangeNotifier.value);
      widget.controller?.addListener(_historyListener);
    }
    if (widget.controller == null) {
      oldWidget.controller?.removeListener(_historyListener);
    }
  }

  void _onDragMoveUpdate({
    double xDelta = 0,
    double maxWidth = 0,
    double xPosition = 0,
  }) {
    if (_dragPosition == TrimDragPosition.none) {
      return;
    }
    RangeValue range = _rangeNotifier.value;
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

    range = range.copyWith(
      start: _dragPosition.isLeft && range.start + xDelta + add < range.end
          ? (range.start + xDelta).clamp(0, 1)
          : null,
      end: _dragPosition.isRight && range.end + xDelta - add > range.start
          ? (range.end + xDelta).clamp(0, 1)
          : null,
    );
    _rangeNotifier.value = range;
    widget.controller?.updateCurrentRange(range);
  }

  void _onPressDragEnd() {
    _dragPosition = TrimDragPosition.none;
    _longPressTimer?.cancel();
    _longPressTimer = null;
    _releaseLongPress = true;

    widget.controller?.updateChanges(_rangeNotifier.value);

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
          child: ListenableBuilder(
            listenable: _rangeNotifier,
            builder: (
              BuildContext context,
              Widget? childWidget,
            ) {
              return SizedBox.fromSize(
                size: Size(constraints.maxWidth, double.infinity),
                child: CustomPaint(
                  foregroundPainter: TrimmerPainter(
                    range: _rangeNotifier.value,
                    borderLines: widget.borderLines,
                  ),
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
  const TrimmerPainter({
    this.range = RangeValue.zero,
    required this.borderLines,
  });
  final RangeValue range;
  final bool borderLines;

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
          0,
          ((range.end - range.start) * size.width) - kTrimmerPadding * 1.5,
          size.height,
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

    if (borderLines) {
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
    }

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
  bool shouldRepaint(TrimmerPainter oldDelegate) =>
      oldDelegate.range != range || oldDelegate.borderLines != borderLines;
}
