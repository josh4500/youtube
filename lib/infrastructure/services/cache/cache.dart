abstract class Cache<V> {
  /// Checks whether a store contains the key.
  bool containsKey(String key);
  V? read(String key);

  /// Write
  void write(String key, V? value);

  /// Get all values from a given store
  Iterable<V> get values;

  /// Watch changes for a given [key]
  Stream<V?> watchKey(String key);

  /// Delete key value
  void delete(String key);
}
