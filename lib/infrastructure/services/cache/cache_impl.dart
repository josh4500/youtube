import 'dart:async';

import 'package:hive/hive.dart';

import 'cache.dart';

class CacheImpl<V> extends Cache<V> {
  late final Box<V> _store;
  final String name;

  CacheImpl(this.name) {
    _store = Hive.box(name: name);
  }

  @override
  bool containsKey(String key) => _store.containsKey(key);

  @override
  Stream<V?> watchKey(String key) => _store.watchKey(key);

  @override
  V? read(String key) => _store[key];

  @override
  Iterable<V> get values {
    return _store
        .getAll(_store.keys)
        .where((element) => element != null)
        .cast();
  }

  @override
  void write(String key, V? value) {
    if (value != null) {
      _store[key] = value;
    } else {
      _store.delete(key);
    }
  }

  @override
  void delete(String key) => _store.delete(key);
}
