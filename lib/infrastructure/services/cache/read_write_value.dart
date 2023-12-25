import 'cache_provider.dart';

/// Read or Write to a value from a [HiveBox].
class ReadWriteValue<T> {
  final String key;
  final T defaultValue;
  final CacheProvider? provider;
  final String Function(T input)? encoder;
  final T? Function(String input)? decoder;

  ReadWriteValue(
    this.key,
    this.defaultValue,
    this.provider, {
    this.encoder,
    this.decoder,
  });

  CacheProvider get _provider =>
      provider ?? (throw ArgumentError.notNull('provider'));

  /// Get cached value for [key]
  T get value {
    final value = _provider.read(key);
    if (value != null && decoder != null) {
      return decoder!(value as String)!;
    }
    return value ?? defaultValue;
  }

  /// Set cached value of [key]
  set value(T newVal) {
    _provider.write(
      key,
      encoder != null ? encoder!(newVal) : newVal,
    );
  }
}

class ReadWriteEnum<T extends Enum> extends ReadWriteValue<T> {
  final List<T> enumValues;

  ReadWriteEnum(super.key, super.defaultValue, super.provider, this.enumValues)
      : super(
          encoder: (enumValue) => enumValue.name,
          decoder: (name) => enumValues.firstWhere(
            (element) => element.name == name,
            orElse: () => defaultValue,
          ),
        );
}
