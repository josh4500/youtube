import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_clone/infrastructure/services/internet_connectivity/internet_connectivity.dart';

import '../../infrastructure/services/internet_connectivity/connectivity_state.dart';

class ConnectionSnackbar extends StatefulWidget {
  /// Whether connection state should auto hide
  final bool autoHide;

  /// Show and hide animation duration
  final Duration duration;

  /// Duration on which to wait before it hides the connection state after
  /// just been connected
  final Duration hideDuration;

  final Duration labelSwitchDuration;

  const ConnectionSnackbar({
    super.key,
    this.autoHide = false,
    this.labelSwitchDuration = const Duration(milliseconds: 500),
    this.duration = const Duration(milliseconds: 300),
    this.hideDuration = const Duration(seconds: 5),
  });

  @override
  State<ConnectionSnackbar> createState() => _ConnectionSnackbarState();
}

class _ConnectionSnackbarState extends State<ConnectionSnackbar>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late StreamSubscription<ConnectivityState> _connectivityStream;
  late ValueNotifier<ConnectivityState> _connectivityState;

  bool _wasConnected = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      animationBehavior: AnimationBehavior.preserve,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    _connectivityState = ValueNotifier(InternetConnectivity.instance.state);

    _connectivityStream = InternetConnectivity.instance.onStateChange.listen(
      (state) async {
        _connectivityState.value = state;

        if (widget.autoHide && state.isConnected && !_wasConnected) {
          _wasConnected = true;

          await Future.delayed(widget.labelSwitchDuration, slideUp);
          await Future.delayed(widget.hideDuration, slideDown);
        } else if (state.isNotConnected) {
          _wasConnected = false;
          await slideUp();
        }
      },
    );
  }

  Future<void> slideUp() async {
    try {
      await _controller.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  Future<void> slideDown() async {
    try {
      if (_connectivityState.value.isConnected) {
        await _controller.reverse().orCancel;
      }
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  void didUpdateWidget(covariant ConnectionSnackbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
  }

  @override
  void dispose() {
    _connectivityStream.cancel();
    _connectivityState.dispose();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      child: ValueListenableBuilder<ConnectivityState>(
        valueListenable: _connectivityState,
        builder: (context, state, child) {
          return AnimatedContainer(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(2.0),
            curve: Curves.easeInCubic,
            duration: widget.labelSwitchDuration,
            color: state.isConnected ? Colors.green : Colors.grey,
            child: Text(state.isConnected ? 'Back online' : 'No connection'),
          );
        },
      ),
    );
  }
}
