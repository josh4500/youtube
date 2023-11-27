import 'dart:async';

import 'cache.dart';

class CacheMock<V> extends Cache<V> {
  static final Map<String, Map<String, Object>> _generalStore = {};
  Map<String, V> get _store => _generalStore[name]! as Map<String, V>;

  final String name;
  final _controller = StreamController<(String, V)>.broadcast();

  CacheMock(this.name) {
    _generalStore[name] ??= {};
  }

  @override
  Stream<V> watchKey(String key) {
    return _controller.stream
        .where((event) => event.$1 == key)
        .map((event) => event.$2);
  }

  @override
  V? read(String key) => _store[key];

  @override
  Iterable<V> get values => _store.values;

  @override
  void write(String key, V? value) {
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
