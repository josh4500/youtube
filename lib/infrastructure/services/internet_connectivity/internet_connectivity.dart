// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

import 'connectivity_state.dart';

/// The duration (in milliseconds) for the timeout when attempting to ping a server.
const int kPingTimeoutDuration = 5000;

/// The interval (in milliseconds) between consecutive attempts to ping a server.
const int kPingableInterval = 7000;

/// Represents a server that can be pinged to check internet connectivity.
class _Pingable {
  final String host;
  final int port;

  _Pingable({required this.host, required this.port});
}

/// Singleton class that manages internet connectivity and emits state changes.
final class InternetConnectivity {
  InternetConnectivity._();

  static final InternetConnectivity _instance = InternetConnectivity._();
  static InternetConnectivity get instance => _instance;

  factory InternetConnectivity() {
    return _instance;
  }

  final _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription;
  ConnectivityState _state = ConnectivityState.initializing();
  ConnectivityState get state => _state;
  ConnectivityType _connectivityType = ConnectivityType.none;

  late Timer _connectionTimer;
  final _stateController = StreamController<ConnectivityState>.broadcast();
  Stream<ConnectivityState> get onStateChange => _stateController.stream;

  bool _lastConnectionTest = true;
  int _pingableIndex = 0;

  /// Initializes the InternetConnectivity by setting up connectivity change
  /// listeners and periodic ping attempts.
  Future<void> initialize() async {
    final cResult = await _connectivity.checkConnectivity();

    // Set the connectivity type
    _connectivityType = cResult.toConnectivityType();

    // Set subscription to change in connectivity result
    _subscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityResultChange,
    );

    _connectionTimer = Timer.periodic(
      const Duration(milliseconds: kPingableInterval),
      _onTryConnection,
    );
  }

  /// Updates connectivity state
  void _updateConnectivityState(ConnectivityState newState) {
    _stateController.sink.add(
      _state = newState.copyWith(
        type: _connectivityType,
      ),
    );
  }

  /// Handles the change in connectivity status and updates the state accordingly.
  Future<void> _onConnectivityResultChange(ConnectivityResult result) async {
    // Update the connectivity type
    _connectivityType = result.toConnectivityType();

    if (result == ConnectivityResult.none) {
      _lastConnectionTest = false;
      _updateConnectivityState(ConnectivityState.disconnected());
    } else if (_lastConnectionTest == false && !state.initializing) {
      await Future.delayed(const Duration(milliseconds: 2000));
      _lastConnectionTest = await _tryConnection(_pingables[_pingableIndex]);
      if (_lastConnectionTest) {
        _updateConnectivityState(ConnectivityState.disconnected());
      }
    }
  }

  /// Attempts to ping a server and updates the state based on the result.
  Future<void> _onTryConnection(Timer timer) async {
    _lastConnectionTest = await _tryConnection(_pingables[_pingableIndex]);
    if (_lastConnectionTest) {
      _updateConnectivityState(ConnectivityState.connected());
    } else {
      _updateConnectivityState(ConnectivityState.disconnected());
      _switchPingableIndex();
    }
  }

  /// Switches to the next pingable server in the list.
  void _switchPingableIndex() {
    debugPrint('Attempting to switch to another pingable');
    final nextIndex = _pingableIndex + 1;
    _pingableIndex = nextIndex == _pingables.length ? 0 : nextIndex;
  }

  static final List<_Pingable> _pingables = [
    _Pingable(
      host: '8.8.4.4',
      port: 53,
    ),
  ];

  /// Attempts to establish a socket connection to the provided pingable server.
  Future<bool> _tryConnection(_Pingable pingable) async {
    return (await _tryInternetAddress()) || (await _trySock(pingable));
  }

  Future<bool> _tryInternetAddress() async {
    // Find why Device caches DNS lookup and if there's a low bandwidth method
    // than Socket
    // try {
    //   final list = await InternetAddress.lookup('localhost');
    //   if (list.isNotEmpty) return true;
    // } catch (e) {
    //   return false;
    // }
    return false;
  }

  Future<bool> _trySock(_Pingable pingable) async {
    Socket? sock;
    try {
      sock = await Socket.connect(
        pingable.host,
        pingable.port,
        timeout: const Duration(milliseconds: kPingTimeoutDuration),
      );
      sock.destroy();
      return true;
    } on SocketException catch (_) {
      sock?.destroy();
    } catch (e) {
      sock?.destroy();
    }
    return false;
  }

  /// Cancels listeners and subscription
  void destroy() {
    _connectionTimer.cancel();
    _subscription.cancel();
  }
}
