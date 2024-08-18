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
  _Pingable({required this.host, required this.port});
  final String host;
  final int port;
}

/// Singleton class that manages internet connectivity and emits state changes.
final class InternetConnectivity {
  factory InternetConnectivity() {
    return _instance;
  }
  InternetConnectivity._();

  static final InternetConnectivity _instance = InternetConnectivity._();
  static InternetConnectivity get instance => _instance;

  final _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
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
  Future<void> _onConnectivityResultChange(
    List<ConnectivityResult> result,
  ) async {
    // Update the connectivity type
    _connectivityType = result.toConnectivityType();

    if (_connectivityType == ConnectivityType.none) {
      _lastConnectionTest = false;
      _updateConnectivityState(ConnectivityState.disconnected());
    } else if (_lastConnectionTest == false && !state.initializing) {
      await Future.delayed(const Duration(milliseconds: 2000));
      _lastConnectionTest = await _tryConnection(_pingables[_pingableIndex]);
      if (!_lastConnectionTest) {
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
