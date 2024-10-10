import 'package:flutter/foundation.dart';

import 'reporter_client.dart';

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
