// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'package:logging/logging.dart';

typedef LogFilter = bool Function();
typedef LogBuilder = void Function(Object? message);
typedef ExceptionLogFilter = bool Function(Object error);
typedef ExceptionLogBuilder = void Function(
  Object error,
  StackTrace stackTrace, {
  Object extra,
}); // Defines how to build exception logs

class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger.root;

  /// Initializes the logger with the specified filters and log builders.
  static void init({
    required LogFilter shouldLog,
    required ExceptionLogFilter shouldLogException,
    required ExceptionLogBuilder onException,
    required LogBuilder onLog,
  }) {
    _logger.level = Level.ALL;
    _logger.onRecord.listen(
      _logListener(shouldLog, shouldLogException, onException, onLog),
    );
  }

  /// Logs an error message along with the stack trace.
  static void error(Object error, StackTrace stackTrace, {Object? message}) {
    _logger.severe(message, error, stackTrace);
  }

  /// Logs an informational message.
  static void info(Object? message) {
    _logger.info(message);
  }

  /// Creates a listener for the logger to handle logs and exceptions.
  static void Function(LogRecord) _logListener(
    LogFilter shouldLog,
    ExceptionLogFilter shouldLogException,
    ExceptionLogBuilder onException,
    LogBuilder onLog,
  ) {
    return (LogRecord record) {
      // Handle general log messages
      if (record.level != Level.SEVERE) {
        if (shouldLog()) {
          onLog(record.message);
        }
        return;
      }

      // Handle severe (error) log messages and exceptions
      final Object? error = record.error;
      if (error == null) return;

      if (shouldLog()) {
        onLog(record.message);
        onLog(error);
        onLog(record.stackTrace ?? StackTrace.current);
      }

      // Handle exceptions based on the filter
      if (shouldLogException(error)) {
        onException(
          error,
          record.stackTrace ?? StackTrace.current,
          extra: record.object ?? <String, dynamic>{},
        );
      }
    };
  }
}
