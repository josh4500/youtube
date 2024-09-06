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
  /// Constructs a BrightnessPair with values for light and dark modes.
  ///
  /// Parameters:
  /// - [light]: The value for light mode.
  /// - [dark]: The value for dark mode.
  const BrightnessPair({
    required this.light,
    required this.dark,
  });

  /// Value for light mode.
  final T light;

  /// Value for dark mode.
  final T dark;
}
