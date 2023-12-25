import 'package:flutter/material.dart';

class OrientationPair<T> {
  final T landscape;
  final T portrait;

  const OrientationPair({
    required this.landscape,
    required this.portrait,
  });

  T resolveWithOrientation(Orientation orientation) {
    return orientation == Orientation.landscape ? landscape : portrait;
  }
}
