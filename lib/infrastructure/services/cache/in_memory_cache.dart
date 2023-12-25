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
