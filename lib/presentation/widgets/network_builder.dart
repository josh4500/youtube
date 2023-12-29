import 'package:flutter/material.dart';

import '../../infrastructure/services/internet_connectivity/connectivity_state.dart';
import '../../infrastructure/services/internet_connectivity/internet_connectivity.dart';

class NetworkBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ConnectivityState state) builder;
  const NetworkBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, InternetConnectivity.instance.state);
  }
}
