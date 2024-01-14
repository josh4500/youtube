// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/widgets.dart';

/// A utility class for handling relative sizing in Flutter.
class RelativeSizing {
  /// Width ratio to be used for relative sizing.
  final double? wRatio;

  /// Height ratio to be used for relative sizing.
  final double? hRatio;

  /// Creates a [RelativeSizing] instance with the specified width and height ratios.
  ///
  /// If both [wRatio] and [hRatio] are null, the resulting size will be (0,0).
  /// If [wRatio] or [hRatio] is null, the corresponding dimension will be 0.
  const RelativeSizing({
    this.wRatio,
    this.hRatio,
  });

  /// Computes the size based on the specified [BuildContext].
  ///
  /// Returns a [Size] object representing the computed size based on [wRatio] and [hRatio].
  Size _valueOf(BuildContext context) {
    return Size(
      (wRatio ?? 0) * MediaQuery.of(context).size.width,
      (hRatio ?? 0) * MediaQuery.of(context).size.height,
    );
  }

  /// Computes the size based on the specified [Size].
  ///
  /// Returns a [Size] object representing the computed size based on [wRatio] and [hRatio].
  Size _valueSizeOf(Size size) {
    return Size(
      (wRatio ?? 0) * size.width,
      (hRatio ?? 0) * size.height,
    );
  }

  /// Gets the width value based on the specified [BuildContext].
  ///
  /// Throws [ArgumentError] if [wRatio] is `null`.
  /// Returns the computed width value based on [wRatio].
  double widthValueOf(BuildContext context) {
    ArgumentError.checkNotNull(wRatio, 'wRatio');
    return _valueOf(context).width;
  }

  /// Gets the width value based on the specified [Size].
  ///
  /// Throws [ArgumentError] if [wRatio] is `null`.
  /// Returns the computed width value based on [wRatio].
  double widthSizeOf(Size size) {
    ArgumentError.checkNotNull(wRatio, 'wRatio');
    return _valueSizeOf(size).width;
  }

  /// Gets the height value based on the specified [BuildContext].
  ///
  /// Throws [ArgumentError] if [hRatio] is `null`.
  /// Returns the computed height value based on [hRatio].
  double heightValueOf(BuildContext context) {
    ArgumentError.checkNotNull(hRatio, 'hRatio');
    return _valueOf(context).height;
  }

  /// Computes the width value based on the specified [BuildContext] and width ratio.
  ///
  /// Returns the computed width value based on the given [wRatio].
  static double w(BuildContext context, double wRatio) {
    return wRatio * MediaQuery.of(context).size.height;
  }

  /// Computes the height value based on the specified [BuildContext] and height ratio.
  ///
  /// Returns the computed height value based on the given [hRatio].
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
