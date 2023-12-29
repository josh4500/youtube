import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/network_listenable_builder.dart';

class ConnectionSnackbar extends StatelessWidget {
  const ConnectionSnackbar({super.key});

  @override
  Widget build(BuildContext context) {
    return NetworkListenableBuilder(
      autoHide: true,
      builder: (context, state) {
        if (state.initializing) return const SizedBox();
        return AnimatedContainer(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4.0),
          duration: const Duration(milliseconds: 200),
          color: state.isConnected ? Colors.green : Colors.grey,
          child: Text(state.isConnected ? 'Connected' : 'No connection'),
        );
      },
    );
  }
}
