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

/// A generic class representing a pair of values, one for landscape orientation
/// and another for portrait orientation.
class OrientationPair<T> {
  /// The value associated with the landscape orientation.
  final T landscape;

  /// The value associated with the portrait orientation.
  final T portrait;

  /// Creates an [OrientationPair] instance with values for both landscape and portrait orientations.
  ///
  /// The [landscape] and [portrait] parameters must be provided and cannot be null.
  const OrientationPair({
    required this.landscape,
    required this.portrait,
  });

  /// Resolves the appropriate value based on the given [Orientation].
  ///
  /// Returns the value associated with [landscape] if the orientation is landscape,
  /// otherwise returns the value associated with [portrait].
  T resolveWithOrientation(Orientation orientation) {
    return orientation == Orientation.landscape ? landscape : portrait;
  }
}
