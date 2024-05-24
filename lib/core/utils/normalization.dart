import 'dart:math';

double normalizeDouble(double value, double min, double max) {
  return (value - min) / (max - min);
}

extension NormalizeDoubleExtension on double {
  double normalize(double min, double max) {
    return (this - min) / (max - min);
  }
}

extension RateOfChangeDoubleExtension on double {
  double roc(double value) {
    return max(0, min(1, this + value));
  }
}

extension InvertByOneDoubleExtension on double {
  double get invertByOne => 1 - this;
}
