import 'dart:io' as io;

import 'package:flutter/foundation.dart';

abstract class ReporterClient {
  void reportError(Object error, StackTrace stackTrace, {Object? extra});
  void logMessage(String message);
  void setUserId(String userId);
  void setCustomKey(String key, String value);
  void reportCrash(FlutterErrorDetails details);
}

class LocalFileReporterClient implements ReporterClient {
  LocalFileReporterClient(String path) : _logFile = io.File(path);
  final io.File _logFile;
  @override
  void reportError(Object error, StackTrace stackTrace, {Object? extra}) {
    final log = 'Error: $error\nStackTrace: $stackTrace\n';
    _logFile.writeAsStringSync(log, mode: io.FileMode.append, flush: true);
  }

  @override
  void reportCrash(FlutterErrorDetails details) {
    final log =
        'Error: ${details.exceptionAsString()}\nStackTrace: ${details.stack}\n';
    _logFile.writeAsStringSync(log, mode: io.FileMode.append, flush: true);
  }

  @override
  void logMessage(String message) {
    _logFile.writeAsStringSync(
      'Log: $message\n',
      mode: io.FileMode.append,
      flush: true,
    );
  }

  @override
  void setUserId(String userId) {
    _logFile.writeAsStringSync(
      'User ID: $userId\n',
      mode: io.FileMode.append,
      flush: true,
    );
  }

  @override
  void setCustomKey(String key, String value) {
    _logFile.writeAsStringSync(
      'Key: $key, Value: $value\n',
      mode: io.FileMode.append,
      flush: true,
    );
  }
}

class ConsoleReporterClient implements ReporterClient {
  @override
  void reportError(Object error, StackTrace stackTrace, {Object? extra}) {
    debugPrint('Console Reporter - Error: $error');
    debugPrint('Console Reporter - StackTrace: $stackTrace');
    if (extra != null) {
      debugPrint('Console Reporter - Extra: $extra');
    }
  }

  @override
  void reportCrash(FlutterErrorDetails details) {
    debugPrint('Console Reporter - Error: ${details.exception}');
    debugPrint('Console Reporter - StackTrace: ${details.stack}');
  }

  @override
  void logMessage(String message) {
    debugPrint('Console Reporter - Message: $message');
  }

  @override
  void setUserId(String userId) {
    debugPrint('Console Reporter - User ID: $userId');
  }

  @override
  void setCustomKey(String key, String value) {
    debugPrint('Console Reporter - Key: $key, Value: $value');
  }
}
