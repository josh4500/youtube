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

import 'dart:async';

import 'cache_provider.dart';

// Note these are just fake impl
class Box<E> {
  get keys => null;

  containsKey(String key) {}

  watchKey(String key) {}

  getAll(keys) {}

  void delete(String key) {}
  operator [](String keys) {}
  operator []=(String keys, dynamic object) {}
}

class Hive {
  static Box<E> box<E>({required String name}) => Box<E>();
}

class HiveCacheProvider<E> extends CacheProvider<E> {
  HiveCacheProvider(this.name) {
    _store = Hive.box(name: name);
    throw Exception(
      'Cannot create HiveCacheProvider, use SharedPreference instead',
    );
  }
  late final Box<E> _store;
  final String name;

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
        .where((E? element) => element != null)
        .cast<E>();
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

Future<void> hiveInit() async {
  // final Directory dir = await getApplicationDocumentsDirectory();
  // final String appPath = dir.path;

  // Set Hive default directory
  // Hive.defaultDirectory = appPath;
}
