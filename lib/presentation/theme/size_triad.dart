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

import 'enum.dart';

/// A generic class representing a triad of sizes for different platforms.
///
/// This class is designed to hold size values for Android phones, iOS phones,
/// Android tablets, and iPads. The sizes are represented by a generic type 'T',
/// making the class flexible to accommodate various numeric types (e.g., int, double).
///
/// Example Usage:
/// ```dart
/// // Creating a SizeTriad with the same size for all platforms.
/// var equalSizes = SizeTriad.single(10.0);
///
/// // Creating a SizeTriad with different sizes for phones and tablets.
/// var differentSizes = SizeTriad.double(5.0, 8.0);
/// ```
class SizeTriad<T> {
  /// Size for Android phones.
  final T android;

  /// Size for iOS phones.
  final T ios;

  /// Size for Android tablets.
  final T androidTablet;

  /// Size for iPads.
  final T ipad;

  /// Constructs a SizeTriad with sizes for each platform.
  ///
  /// All parameters are required, and they represent the sizes for Android
  /// phones, iOS phones, Android tablets, and iPads, respectively.
  const SizeTriad({
    required this.android,
    required this.ios,
    required this.androidTablet,
    required this.ipad,
  });

  /// Factory constructor to create a SizeTriad with the same size for all platforms.
  ///
  /// Parameters:
  /// - [value]: The size value to be used for all platforms.
  factory SizeTriad.single(T value) {
    return SizeTriad(
      android: value,
      ios: value,
      androidTablet: value,
      ipad: value,
    );
  }

  /// Factory constructor to create a SizeTriad with different sizes for phones and tablets.
  ///
  /// Parameters:
  /// - [phone]: The size value for phones (Android and iOS).
  /// - [tablet]: The size value for tablets (Android and iPad).
  factory SizeTriad.double(T phone, T tablet) {
    return SizeTriad(
      android: phone,
      ios: phone,
      androidTablet: tablet,
      ipad: tablet,
    );
  }

  T resolveWithDeviceType(DeviceType type) {
    switch (type) {
      case DeviceType.android:
        return android;
      case DeviceType.ios:
        return ios;
      case DeviceType.tablet:
        return androidTablet;
      case DeviceType.ipad:
        return ipad;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SizeTriad &&
          runtimeType == other.runtimeType &&
          android == other.android &&
          ios == other.ios &&
          androidTablet == other.androidTablet &&
          ipad == other.ipad;

  @override
  int get hashCode =>
      android.hashCode ^ ios.hashCode ^ androidTablet.hashCode ^ ipad.hashCode;
}
