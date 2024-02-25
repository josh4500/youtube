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

import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityType {
  wifi,
  mobile,
  other,
  none;

  bool get isWifi => this == wifi;
  bool get isMobile => this == mobile;
  bool get isOther => this == other;
  bool get isNone => this == none;
}

/// Represents the state of internet connectivity.
class ConnectivityState {
  final bool isConnected;
  final bool initializing;
  final ConnectivityType type;

  bool get isNotConnected => !isConnected;

  const ConnectivityState({
    required this.isConnected,
    this.initializing = false,
    this.type = ConnectivityType.none,
  });

  /// Factory method to create a connected state.
  factory ConnectivityState.connected() {
    return const ConnectivityState(isConnected: true);
  }

  /// Factory method to create a disconnected state.
  factory ConnectivityState.disconnected() {
    return const ConnectivityState(isConnected: false);
  }

  factory ConnectivityState.initializing() {
    return const ConnectivityState(isConnected: false, initializing: true);
  }

  @override
  String toString() {
    return 'ConnectivityState: isConnected $isConnected initializing $initializing';
  }

  ConnectivityState copyWith({ConnectivityType? type}) {
    return ConnectivityState(
      isConnected: isConnected,
      initializing: initializing,
      type: type ?? this.type,
    );
  }
}

extension ConnectivityResultToTypeExtension on ConnectivityResult {
  ConnectivityType toConnectivityType() {
    return ConnectivityType.values.firstWhere(
      (element) => element.name == name,
      orElse: () => ConnectivityType.other,
    );
  }
}
