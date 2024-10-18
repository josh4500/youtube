import 'package:clock/clock.dart' show Clock;
import 'package:flutter/foundation.dart';

import '../platform_info.dart';
import 'reporter_client.dart';

class ErrorReporter {
  ErrorReporter({
    required List<ReporterClient> clients,
    Clock? clock,
    required PlatformInfo platform,
  })  : _clients = clients,
        _clock = clock ?? const Clock(),
        _platform = platform;

  final List<ReporterClient> _clients;
  final Clock _clock;
  final PlatformInfo _platform;

  void reportError(Object error, StackTrace stackTrace, {Object? extra}) {
    final timestamp = _clock.now();
    debugPrint('Error reported at $timestamp on ${_platform.osType}');
    for (final client in _clients) {
      client.reportError(error, stackTrace, extra: extra);
    }
  }

  void logMessage(String message) {
    final timestamp = _clock.now();
    logMessage('Log: [$timestamp] $message');
    for (final client in _clients) {
      client.logMessage(message);
    }
  }

  void setUserId(String userId) {
    for (final client in _clients) {
      client.setUserId(userId);
    }
  }

  void setCustomKey(String key, String value) {
    for (final client in _clients) {
      client.setCustomKey(key, value);
    }
  }

  void reportCrash(FlutterErrorDetails details) {
    final timestamp = _clock.now();
    debugPrint('Error reported at $timestamp on ${_platform.osType}');
    for (final client in _clients) {
      client.reportCrash(details);
    }
  }
}
