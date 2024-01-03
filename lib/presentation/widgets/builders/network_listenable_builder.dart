import 'dart:async';

import 'package:flutter/material.dart';

import '../../../infrastructure/services/internet_connectivity/connectivity_state.dart';
import '../../../infrastructure/services/internet_connectivity/internet_connectivity.dart';

class NetworkListenableBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ConnectivityState state) builder;
  const NetworkListenableBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityState>(
      initialData: InternetConnectivity.instance.state,
      stream: InternetConnectivity.instance.onStateChange,
      builder: (context, snapshot) {
        return builder(context, snapshot.data!);
      },
    );
  }
}
