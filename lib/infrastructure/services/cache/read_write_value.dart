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

import 'cache_provider.dart';

/// Read or Write to a value from a [HiveBox].
class ReadWriteValue<T> {
  ReadWriteValue(
    this.key,
    this.defaultValue,
    this.provider, {
    this.encoder,
    this.decoder,
  });
  final String key;
  final T defaultValue;
  final CacheProvider<dynamic>? provider;
  final String Function(T input)? encoder;
  final T? Function(String input)? decoder;

  CacheProvider<dynamic> get _provider =>
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
  ReadWriteEnum(super.key, super.defaultValue, super.provider, this.enumValues)
      : super(
          encoder: (T enumValue) => enumValue.name,
          decoder: (String name) => enumValues.firstWhere(
            (T element) => element.name == name,
            orElse: () => defaultValue,
          ),
        );
  final List<T> enumValues;
}
