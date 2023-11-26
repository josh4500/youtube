import 'package:hive/hive.dart';

typedef HiveBox = Box;

/// Read or Write to a value from a [HiveBox].
class ReadWriteValue<T> {
  final String key;
  final T defaultValue;
  final HiveBox? getBox;
  final String Function(T input)? encoder;
  final T? Function(String input)? decoder;

  ReadWriteValue(
    this.key,
    this.defaultValue, [
    this.getBox,
    this.encoder,
    this.decoder,
  ]);

  Box _getRealBox() => getBox ?? Hive.box();

  /// Get cached value for [key]
  T get value {
    final value = _getRealBox().get(key);
    if (value != null && decoder != null) {
      return decoder!(value as String)!;
    }
    return value ?? defaultValue;
  }

  /// Set cached value of [key]
  set value(T newVal) {
    _getRealBox().put(
      key,
      encoder != null ? encoder!(newVal) : newVal,
    );
  }
}
