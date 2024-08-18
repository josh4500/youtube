import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

class Worker {
  Worker._(this._commands, this._responses) {
    _responses.listen(_handleResponsesFromIsolate);
  }

  final SendPort _commands;
  final ReceivePort _responses;
  final Map<int, Completer<Object?>> _activeRequests = {};

  bool _closed = false;
  int _idCounter = 0;

  Future<Object?> parseJson(String message) async {
    if (_closed) throw StateError('Closed'); // New
    final completer = Completer<Object?>.sync();
    final id = _idCounter++;
    _activeRequests[id] = completer;
    _commands.send((id, message));
    return completer.future;
  }

  static Future<Worker> spawn() async {
    // Create a receive port and add its initial message handler.
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();

    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete(
        (
          ReceivePort.fromRawReceivePort(initPort),
          commandPort,
        ),
      );
    };

    // Spawn the isolate.
    try {
      await Isolate.spawn(_startRemoteIsolate, initPort.sendPort);
    } on Object {
      initPort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
        await connection.future;

    return Worker._(sendPort, receivePort);
  }

  void _handleResponsesFromIsolate(dynamic message) {
    final (int id, Object? response) = message as (int, Object?); // New
    final completer = _activeRequests.remove(id)!; // New

    if (response is RemoteError) {
      completer.completeError(response); // Updated
    } else {
      completer.complete(response); // Updated
    }
  }

  static void _startRemoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    _handleCommandsToIsolate(receivePort, sendPort);
  }

  static void _handleCommandsToIsolate(
    ReceivePort receivePort,
    SendPort sendPort,
  ) async {
    receivePort.listen((message) {
      if (message == 'shutdown') {
        receivePort.close();
        return;
      }

      final (int id, String jsonText) = message as (int, String); // New
      try {
        final jsonData = jsonDecode(jsonText);
        sendPort.send((id, jsonData)); // Updated
      } catch (e) {
        sendPort.send((id, RemoteError(e.toString(), '')));
      }
    });
  }

  void close() {
    if (!_closed) {
      _closed = true;
      _commands.send('shutdown');
      if (_activeRequests.isEmpty) _responses.close();
      debugPrint('--- port closed --- ');
    }
  }
}
