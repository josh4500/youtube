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
