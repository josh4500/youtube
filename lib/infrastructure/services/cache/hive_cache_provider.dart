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

import 'package:hive/hive.dart';

import 'cache_provider.dart';

class HiveCacheProvider<E> extends CacheProvider<E> {
  late final Box<E> _store;
  final String name;

  HiveCacheProvider(this.name) {
    _store = Hive.box(name: name);
  }

  @override
  bool containsKey(String key) => _store.containsKey(key);

  @override
  Stream<E?> watchKey(String key) => _store.watchKey(key);

  @override
  E? read(String key) => _store[key];

  @override
  Iterable<E> get values {
    return _store
        .getAll(_store.keys)
        .where((element) => element != null)
        .cast();
  }

  @override
  void write(String key, E? value) {
    if (value != null) {
      _store[key] = value;
    } else {
      _store.delete(key);
    }
  }

  @override
  void delete(String key) => _store.delete(key);
}
