import 'dart:io';

import 'package:flutter/src/foundation/assertions.dart';

import 'reporter_client.dart';

class LocalFileReporterClient implements ReporterClient {
  LocalFileReporterClient(String path) : _logFile = File(path);
  final File _logFile;
  @override
  void reportError(Object error, StackTrace stackTrace, {Object? extra}) {
    final log = 'Error: $error\nStackTrace: $stackTrace\n';
    _logFile.writeAsStringSync(log, mode: FileMode.append, flush: true);
  }

  @override
  void reportCrash(FlutterErrorDetails details) {
    final log =
        'Error: ${details.exceptionAsString()}\nStackTrace: ${details.stack}\n';
    _logFile.writeAsStringSync(log, mode: FileMode.append, flush: true);
  }

  @override
  void logMessage(String message) {
    _logFile.writeAsStringSync(
      'Log: $message\n',
      mode: FileMode.append,
      flush: true,
    );
  }

  @override
  void setUserId(String userId) {
    _logFile.writeAsStringSync(
      'User ID: $userId\n',
      mode: FileMode.append,
      flush: true,
    );
  }

  @override
  void setCustomKey(String key, String value) {
    _logFile.writeAsStringSync(
      'Key: $key, Value: $value\n',
      mode: FileMode.append,
      flush: true,
    );
  }
}
