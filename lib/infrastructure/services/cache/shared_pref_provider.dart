import 'package:shared_preferences/shared_preferences.dart';

import 'cache_provider.dart';

// Implement storing many into one
class SharedPrefProvider<E extends Object> extends CacheProvider<E> {
  SharedPrefProvider(this.name);
  // : assert(
  //     E == int || E == bool || E == String,
  //     'Generic type E must be either int, bool, or String',
  //   );

  final String name;

  String _keyed(String key) => '$name::$key';

  @override
  bool containsKey(String key) {
    return SharedPref.instance.containsKey(_keyed(key));
  }

  @override
  void delete(String key) {
    SharedPref.instance.remove(_keyed(key));
  }

  @override
  E? read(String key) {
    return SharedPref.instance.get(_keyed(key)) as E?;
  }

  @override
  Iterable<E> get values {
    throw UnimplementedError();
  }

  @override
  Stream<E?> watchKey(String key) {
    throw UnimplementedError();
  }

  @override
  void write(String key, E? value) {
    if (value == null) {
      SharedPref.instance.remove(_keyed(key));
    } else if (value is int) {
      SharedPref.instance.setInt(_keyed(key), value);
    } else if (value is bool) {
      SharedPref.instance.setBool(_keyed(key), value);
    } else if (value is String) {
      SharedPref.instance.setString(_keyed(key), value);
    } else {
      throw ArgumentError('Unsupported value type: $E');
    }
  }
}

class SharedPref {
  static late SharedPreferences _prefs;
  static SharedPreferences get instance => _prefs;
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
