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

import 'package:flutter/material.dart';
import 'package:youtube_clone/infrastructure.dart';

class ConnectionSnackbar extends StatefulWidget {
  const ConnectionSnackbar({
    super.key,
    this.autoHide = false,
    this.labelSwitchDuration = const Duration(milliseconds: 500),
    this.duration = const Duration(milliseconds: 300),
    this.hideDuration = const Duration(seconds: 5),
  });

  /// Whether connection state should auto hide
  final bool autoHide;

  /// Show and hide animation duration
  final Duration duration;

  /// Duration on which to wait before it hides the connection state after
  /// just been connected
  final Duration hideDuration;

  final Duration labelSwitchDuration;

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

    _connectivityState = ValueNotifier<ConnectivityState>(
      InternetConnectivity.instance.state,
    );

    _connectivityStream = InternetConnectivity.instance.onStateChange.listen(
      (ConnectivityState state) async {
        _connectivityState.value = state;

        if (widget.autoHide && state.isConnected && !_wasConnected) {
          _wasConnected = true;

          await Future<void>.delayed(widget.labelSwitchDuration, slideUp);
          await Future<void>.delayed(widget.hideDuration, slideDown);
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
        builder:
            (BuildContext context, ConnectivityState state, Widget? child) {
          return AnimatedContainer(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2.0),
            curve: Curves.easeInCubic,
            duration: widget.labelSwitchDuration,
            color: state.isConnected
                ? const Color(0xFF2BA640)
                : const Color(0xFF212121),
            child: Text(
              state.isConnected ? 'Back online' : 'No connection',
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
