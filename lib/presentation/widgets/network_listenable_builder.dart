import 'dart:async';

import 'package:flutter/material.dart';

import '../../infrastructure/services/internet_connectivity/connectivity_state.dart';
import '../../infrastructure/services/internet_connectivity/internet_connectivity.dart';

class NetworkListenableBuilder extends StatelessWidget {
  final bool autoHide;
  final Duration hideDuration;
  final Widget Function(BuildContext context, ConnectivityState state) builder;
  const NetworkListenableBuilder({
    super.key,
    this.autoHide = false,
    this.hideDuration = const Duration(seconds: 3),
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityState>(
      initialData: InternetConnectivity.instance.state,
      stream: InternetConnectivity.instance.onStateChange,
      builder: (context, snapshot) {
        if (autoHide && snapshot.data!.isConnected) {
          return FutureBuilder(
            initialData: true,
            future: Future.delayed(hideDuration, () => false),
            builder: (context, fSnapshot) {
              final show = fSnapshot.data!;
              if (!show) return const SizedBox();
              return builder(context, snapshot.data!);
            },
          );
        }
        return builder(context, snapshot.data!);
      },
    );
  }
}
