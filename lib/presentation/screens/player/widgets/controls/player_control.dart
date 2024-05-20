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

import 'package:flutter/material.dart';

class PlayerControlButton extends StatefulWidget {
  const PlayerControlButton({
    super.key,
    this.enabled = true,
    this.color = Colors.black26,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    required this.onTap,
    required this.builder,
  });

  final VoidCallback onTap;
  final bool enabled;
  final double verticalPadding;
  final double horizontalPadding;
  final Color color;
  final Widget Function(BuildContext context, Animation animation) builder;

  @override
  State<PlayerControlButton> createState() => PlayerControlButtonState();
}

class PlayerControlButtonState extends State<PlayerControlButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _bgController;
  late Animation<double> _animation;
  late Animation<Color?> _bgAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 300),
    );

    _bgController = AnimationController(
      vsync: this,
      value: 0,
      duration: const Duration(milliseconds: 350),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    _bgAnimation = ColorTween(
      begin: widget.color,
      end: Colors.white12,
    ).animate(_bgController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _bgController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: widget.verticalPadding,
        horizontal: widget.horizontalPadding,
      ),
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        onTapDown: (_) => widget.enabled ? _bgController.forward() : null,
        onTapUp: (_) => widget.enabled ? _bgController.reverse() : null,
        onTapCancel: () => widget.enabled ? _bgController.reverse() : null,
        child: AnimatedBuilder(
          animation: _bgAnimation,
          builder: (context, childWidget) {
            return Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: _bgAnimation.value,
                shape: BoxShape.circle,
              ),
              child: childWidget,
            );
          },
          child: widget.builder(context, _animation),
        ),
      ),
    );
  }
}
