class SizerUtils {
  static late double _dpr;
  static double get dpr => _dpr * 1;
  static set dpr(double v) => _dpr = v;
}

extension DensityPixelsExtension on num {
  double get dp => this / SizerUtils.dpr;
  double get pt => this / SizerUtils.dpr;
}
