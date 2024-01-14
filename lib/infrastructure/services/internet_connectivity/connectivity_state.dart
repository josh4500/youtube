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
