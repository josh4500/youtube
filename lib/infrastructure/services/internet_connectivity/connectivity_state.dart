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
