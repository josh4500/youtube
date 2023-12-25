abstract class CacheProvider<E> {
  /// Checks whether a store contains the key.
  bool containsKey(String key);
  E? read(String key);

  /// Write
  void write(String key, E? value);

  /// Get all values from a given store
  Iterable<E> get values;

  /// Watch changes for a given [key]
  Stream<E?> watchKey(String key);

  /// Delete key value
  void delete(String key);
}
