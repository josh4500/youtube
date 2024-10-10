import 'package:flutter/src/foundation/assertions.dart';

abstract class ReporterClient {
  void reportError(Object error, StackTrace stackTrace, {Object? extra});
  void logMessage(String message);
  void setUserId(String userId);
  void setCustomKey(String key, String value);
  void reportCrash(FlutterErrorDetails details);
}
