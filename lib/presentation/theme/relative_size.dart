// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'package:flutter/widgets.dart';

/// A utility class for handling relative sizing in Flutter.
class RelativeSizing {
  /// Creates a [RelativeSizing] instance with the specified width and height ratios.
  ///
  /// If both [wRatio] and [hRatio] are null, the resulting size will be (0,0).
  /// If [wRatio] or [hRatio] is null, the corresponding dimension will be 0.
  const RelativeSizing({
    this.wRatio,
    this.hRatio,
  });

  /// Width ratio to be used for relative sizing.
  final double? wRatio;

  /// Height ratio to be used for relative sizing.
  final double? hRatio;

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
