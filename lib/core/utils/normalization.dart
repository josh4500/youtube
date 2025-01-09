import 'dart:math' as math;

double normalizeDouble(double value, double min, double max) {
  return (value - min) / (max - min);
}

extension NormalizeDoubleExtension on num {
  /// Normalizes value to 0 - 1
  double normalize(double min, double max) {
    return ((this - min) / (max - min)).clamp(0, 1);
  }

  /// Normalizes between  0 - 1  to [min] - [max]
  double normalizeRange(double min, double max) {
    assert(this >= 0 || this <= 1, 'Value must be in range 0 ... 1');
    return (this * (max - min)) + min;
  }
}

extension RateOfChangeDoubleExtension on double {
  /// Exponential Rate of change
  double eRoc(double min, double max) {
    return max * (math.exp(2.303 * math.log(min) * this));
  }

  /// Quadratic Rate of change
  double qRoc(double min, double max) {
    return max - ((max - min) * math.pow(this, 2));
  }

  /// Cubic Rate of change
  double cRoc(double min, double max) {
    return ((max - min) * ((3 * math.pow(this, 2)) - (2 * math.pow(this, 3)))) +
        min;
  }
}

extension InvertByOneDoubleExtension on double {
  double get invertByOne => 1 - this;
}
