import 'package:flutter/cupertino.dart';

class RelativeSizing {
  final double? wRatio;
  final double? hRatio;

  const RelativeSizing({
    this.wRatio,
    this.hRatio,
  });

  Size _valueOf(BuildContext context) {
    return Size(
      (wRatio ?? 0) * MediaQuery.of(context).size.width,
      (hRatio ?? 0) * MediaQuery.of(context).size.height,
    );
  }

  Size _valueSizeOf(Size size) {
    return Size(
      (wRatio ?? 0) * size.width,
      (hRatio ?? 0) * size.height,
    );
  }

  double widthValueOf(BuildContext context) {
    ArgumentError.checkNotNull(wRatio, 'wRatio');
    return _valueOf(context).width;
  }

  double widthSizeOf(Size size) {
    ArgumentError.checkNotNull(wRatio, 'wRatio');
    return _valueSizeOf(size).width;
  }

  double heightValueOf(BuildContext context) {
    ArgumentError.checkNotNull(hRatio, 'hRatio');
    return _valueOf(context).height;
  }

  static double w(BuildContext context, double wRatio) {
    return wRatio * MediaQuery.of(context).size.height;
  }

  static double h(BuildContext context, double hRatio) {
    return hRatio * MediaQuery.of(context).size.height;
  }
}

// TODO: Finish implementation
// class RelativeConstraintSizing {
//   final double wMinRatio;
//   final double wMaxSize;
//   final double hMinRatio;
//   final double hMaxSize;
//
//   RelativeConstraintSizing({
//     this.wMinRatio = 0,
//     this.wMaxSize = 0,
//     this.hMinRatio = 0,
//     this.hMaxSize = 0,
//   });
//
//   Size _valueOf(BuildContext context) {
//     return Size(
//       wMinRatio * MediaQuery.of(context).size.width,
//       hMinRatio * MediaQuery.of(context).size.height,
//     );
//   }
//
//   double heightValueOf(BuildContext context) {
//     return _valueOf(context).height;
//   }
//
//   double widthValueOf(BuildContext context) {
//     return _valueOf(context).width;
//   }
// }
//
