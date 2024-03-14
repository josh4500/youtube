double normalizeDouble(double value, double min, double max) {
  return (value - min) / (max - min);
}

extension NormalizeDoubleExtension on double {
  double normalize(double min, double max) {
    return (this - min) / (max - min);
  }

  double get invertByOne => 1 - this;
}
