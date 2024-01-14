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

import 'cache_provider.dart';

/// Read or Write to a value from a [HiveBox].
class ReadWriteValue<T> {
  final String key;
  final T defaultValue;
  final CacheProvider? provider;
  final String Function(T input)? encoder;
  final T? Function(String input)? decoder;

  ReadWriteValue(
    this.key,
    this.defaultValue,
    this.provider, {
    this.encoder,
    this.decoder,
  });

  CacheProvider get _provider =>
      provider ?? (throw ArgumentError.notNull('provider'));

  /// Get cached value for [key]
  T get value {
    final value = _provider.read(key);
    if (value != null && decoder != null) {
      return decoder!(value as String)!;
    }
    return value ?? defaultValue;
  }

  /// Set cached value of [key]
  set value(T newVal) {
    _provider.write(
      key,
      encoder != null ? encoder!(newVal) : newVal,
    );
  }
}

class ReadWriteEnum<T extends Enum> extends ReadWriteValue<T> {
  final List<T> enumValues;

  ReadWriteEnum(super.key, super.defaultValue, super.provider, this.enumValues)
      : super(
          encoder: (enumValue) => enumValue.name,
          decoder: (name) => enumValues.firstWhere(
            (element) => element.name == name,
            orElse: () => defaultValue,
          ),
        );
}
