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

import 'package:flutter/material.dart';

class TappableArea extends StatefulWidget {
  final Widget child;
  final HitTestBehavior? behavior;
  final EdgeInsets padding;
  final Alignment stackedAlignment;
  final Widget? stackedChild;
  final BorderRadius? borderRadius;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  const TappableArea({
    super.key,
    this.padding = const EdgeInsets.symmetric(
      vertical: 4,
      horizontal: 8,
    ),
    this.behavior,
    this.borderRadius,
    this.stackedAlignment = Alignment.center,
    this.stackedChild,
    required this.child,
    this.onPressed,
    this.onLongPress,
  });

  @override
  State<TappableArea> createState() => _TappableAreaState();
}

class _TappableAreaState extends State<TappableArea>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _backgroundAnimation;
  late final Animation<Border?> _borderAnimation;

  bool _reversing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 600),
    );

    _backgroundAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.white10,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );

    _borderAnimation = BorderTween(
      begin: const Border.fromBorderSide(
        BorderSide(color: Colors.transparent),
      ),
      end: const Border.fromBorderSide(
        BorderSide(color: Colors.white10),
      ),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0,
          0.5,
          curve: Curves.ease,
        ),
        reverseCurve: const Interval(
          0,
          0.8,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.reverse) {
        _reversing = true;
      } else if (status == AnimationStatus.completed) {
        _reversing = false;
      } else if (status == AnimationStatus.forward) {
        _reversing = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          behavior: widget.behavior,
          onTap: widget.onPressed,
          onLongPress: widget.onLongPress,
          onTapDown: (_) async => await _controller.forward(),
          onTapUp: (_) async => await _controller.reverse(),
          onTapCancel: () async => await _controller.reverse(),
          child: AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, backgroundChild) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  // Border animation will show only when reversing
                  border: _reversing ? _borderAnimation.value : null,
                  color: _backgroundAnimation.value,
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(2),
                ),
                child: backgroundChild!,
              );
            },
            child: Padding(
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        ),
        if (widget.stackedChild != null)
          Align(
            alignment: widget.stackedAlignment,
            child: widget.stackedChild,
          ),
      ],
    );
  }
}
