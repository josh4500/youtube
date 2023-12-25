extension FirstWhereOrNullExtension<T> on Iterable<T> {
  /// The first element that satisfies the given predicate [test].
  ///
  /// Iterates through elements and returns the first to satisfy [test].
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// var result = numbers.firstWhereOrNull((element) => element < 5); // 1
  /// result = numbers.firstWhereOrNull((element) => element > 5); // 6
  /// result = numbers.firstWhereOrNull((element) => element > 10); // null
  /// ```
  ///
  /// If no element satisfies [test], `null` is returned;
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}

extension RemoveFirstExtension<T> on List<T> {
  T removeFirst() {
    return removeAt(0);
  }
}
