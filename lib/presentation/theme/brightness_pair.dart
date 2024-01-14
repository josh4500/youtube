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

/// A generic class representing a pair of values for different brightness modes.
///
/// This class is designed to hold two values, one for light mode and one for dark mode.
/// The values are represented by a generic type 'T', making the class flexible to
/// accommodate various numeric types (e.g., int, double) or any other custom type.
///
/// Example Usage:
/// ```dart
/// // Creating a BrightnessPair with color values for light and dark modes.
/// var colorPair = BrightnessPair<Color>(
///   light: Colors.white,
///   dark: Colors.black,
/// );
///
/// // Creating a BrightnessPair with font sizes for light and dark modes.
/// var fontSizePair = BrightnessPair<double>(
///   light: 16.0,
///   dark: 18.0,
/// );
/// ```
class BrightnessPair<T> {
  /// Value for light mode.
  final T light;

  /// Value for dark mode.
  final T dark;

  /// Constructs a BrightnessPair with values for light and dark modes.
  ///
  /// Parameters:
  /// - [light]: The value for light mode.
  /// - [dark]: The value for dark mode.
  const BrightnessPair({
    required this.light,
    required this.dark,
  });
}
