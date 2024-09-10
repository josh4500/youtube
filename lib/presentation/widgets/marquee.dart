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

const Gradient startGradient = LinearGradient(
  stops: [.8, 1],
  colors: <Color>[
    Color(0xFFFFFFFF),
    Color(0x00FFFFFF),
  ],
);

const Gradient endGradient = LinearGradient(
  stops: [0, .2, .8, 1],
  colors: <Color>[
    Color(0x00FFFFFF),
    Color(0xFFFFFFFF),
    Color(0xFFFFFFFF),
    Color(0x00FFFFFF),
  ],
);

enum MarqueeState {
  animating,
  notAnimating,
}

class Marquee extends StatefulWidget {
  const Marquee({
    super.key,
    required this.text,
    this.style,
    this.spacing = 32,
    this.enabled = true,
    this.padding = EdgeInsets.zero,
    this.duration = const Duration(seconds: 15),
    this.intervalDelayDuration = const Duration(seconds: 5),
  });

  final String text;
  final TextStyle? style;
  final EdgeInsets padding;
  final double spacing;
  final Duration duration;
  final Duration intervalDelayDuration;
  final bool enabled;

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> {
  final ScrollController _controller = ScrollController();
  late Size textLayoutSize;
  late bool _enabled = widget.enabled;
  MarqueeState state = MarqueeState.notAnimating;
  final ValueNotifier<Gradient> _gradient = ValueNotifier<Gradient>(
    startGradient,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(_gradientChangeCallback);
  }

  @override
  void dispose() {
    state = MarqueeState.notAnimating;

    _controller.removeListener(_gradientChangeCallback);
    _controller.dispose();
    _gradient.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _calculateTextSize();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Marquee oldWidget) {
    _enabled = widget.enabled;
    if (!oldWidget.enabled && state == MarqueeState.animating) {
      state = MarqueeState.notAnimating;
    }

    if (oldWidget.text != widget.text || oldWidget.style != widget.style) {
      _calculateTextSize();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _gradientChangeCallback() {
    if (_controller.offset == 0 || _controller.offset > textLayoutSize.width) {
      _gradient.value = startGradient;
    } else {
      _gradient.value = endGradient;
    }
  }

  void _calculateTextSize() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    );
    textPainter.layout();
    textLayoutSize = textPainter.size;
  }

  Future<void> _animate(double maxWidth) async {
    final shouldAnimate = textLayoutSize.width > maxWidth;
    if (!shouldAnimate || !_enabled) {
      // TODO(josh4500): Cancel async _controller.animateTo before calling
      // if (_controller.offset != 0) _controller.jumpTo(0);
      state = MarqueeState.notAnimating;
      return;
    }

    if (state == MarqueeState.animating || !_controller.hasClients) {
      return;
    }

    state = MarqueeState.animating;
    await Future.delayed(widget.intervalDelayDuration);
    while (mounted && state == MarqueeState.animating && _enabled) {
      if (_controller.hasClients) {
        await _controller.animateTo(
          textLayoutSize.width + widget.spacing,
          duration: widget.duration,
          curve: Curves.linear,
        );
        if (mounted && _controller.hasClients) {
          _controller.jumpTo(0);
          await Future.delayed(widget.intervalDelayDuration);
        }
      }
    }
    state = MarqueeState.notAnimating;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style = widget.style ?? DefaultTextStyle.of(context).style;
    final textSpan = TextSpan(
      text: widget.text,
      children: <InlineSpan>[
        WidgetSpan(child: SizedBox(width: widget.spacing)),
        TextSpan(text: widget.text),
      ],
      style: style,
    );
    final double height =
        (style.fontSize ?? kDefaultFontSize) + widget.padding.vertical;
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final child = _MarqueeBuilder(
            text: textSpan,
            animate: _animate,
            controller: _controller,
            constraints: constraints,
            padding: widget.padding,
          );
          if (textLayoutSize.width > constraints.maxWidth) {
            return ListenableBuilder(
              listenable: _gradient,
              builder: (BuildContext context, Widget? childWidget) {
                return ShaderMask(
                  shaderCallback: _gradient.value.createShader,
                  child: childWidget,
                );
              },
              child: child,
            );
          }

          return child;
        },
      ),
    );
  }
}

class _MarqueeBuilder extends StatefulWidget {
  const _MarqueeBuilder({
    required this.controller,
    required this.constraints,
    required this.text,
    required this.padding,
    required this.animate,
  });

  final TextSpan text;
  final ScrollController controller;
  final BoxConstraints constraints;
  final EdgeInsets padding;
  final void Function(double maxWidth) animate;

  @override
  State<_MarqueeBuilder> createState() => _MarqueeBuilderState();
}

class _MarqueeBuilderState extends State<_MarqueeBuilder> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.animate(widget.constraints.maxWidth);
    });
  }

  @override
  void didUpdateWidget(_MarqueeBuilder oldWidget) {
    widget.animate(widget.constraints.maxWidth);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: widget.padding,
      controller: widget.controller,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      children: [Text.rich(widget.text)],
    );
  }
}
