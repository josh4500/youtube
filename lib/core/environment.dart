import 'dart:io' as io;

enum Environment {
  dev,
  prod,
  testing;

  bool get isDev => this == dev;
  bool get isProd => this == prod;
  bool get isTesting => this == testing;

  static const String _envMode =
      String.fromEnvironment('env.mode', defaultValue: 'dev');

  static Environment _derive() {
    if (io.Platform.environment.containsKey('FLUTTER_TEST')) {
      return testing;
    }

    try {
      return Environment.values.byName(_envMode);
    } on ArgumentError {
      throw Exception(
          "Invalid runtime environment: '$_envMode'. Available environments: ${values.join(', ')}");
    }
  }
}

Environment? _environment;
Environment get environment => _environment ??= Environment._derive();
