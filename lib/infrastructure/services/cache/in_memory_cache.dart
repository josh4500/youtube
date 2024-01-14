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

import 'dart:async';

import 'cache_provider.dart';

class InMemoryCache<E> extends CacheProvider<E> {
  static final Map<String, Map<String, Object>> _generalStore = {};
  Map<String, E> get _store => _generalStore[name]! as Map<String, E>;

  final String name;
  final _controller = StreamController<(String, E)>.broadcast();

  InMemoryCache(this.name) {
    _generalStore[name] ??= {};
  }

  @override
  Stream<E> watchKey(String key) {
    return _controller.stream
        .where((event) => event.$1 == key)
        .map((event) => event.$2);
  }

  @override
  E? read(String key) => _store[key];

  @override
  Iterable<E> get values => _store.values;

  @override
  void write(String key, E? value) {
    if (value != null) {
      _store[key] = value;
      _controller.sink.add((key, value));
    } else {
      _store.remove(key);
    }
  }

  @override
  bool containsKey(String key) => _store.containsKey(key);

  @override
  void delete(String key) => _store.remove(key);
}
