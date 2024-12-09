class RangeValue {
  const RangeValue({required this.start, required this.end});

  final double start;
  final double end;

  static const RangeValue zero = RangeValue(start: 0, end: 0);
  double get distance => end - start;
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

  @override
  String toString() {
    return 'RangeValue{start: $start, end: $end}';
  }
}

extension InBetweenExt on num {
  bool isBetween(RangeValue range) {
    return range.start <= this && this <= range.end;
  }
}

class DurationRange {
  const DurationRange({required this.start, required this.end});
  static const DurationRange zero = DurationRange(
    start: Duration.zero,
    end: Duration.zero,
  );

  final Duration start;
  final Duration end;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DurationRange &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

extension DurationExt on Duration {
  bool isBetween(DurationRange range) {
    return range.start <= this && this <= range.end;
  }
}
