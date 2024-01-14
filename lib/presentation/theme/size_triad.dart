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
