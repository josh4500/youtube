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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StackedPosition {
  StackedPosition({this.top, this.bottom, this.left, this.right});

  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
}

class TappableArea extends StatefulWidget {
  const TappableArea({
    super.key,
    this.padding = const EdgeInsets.symmetric(
      vertical: 4,
      horizontal: 8,
    ),
    this.behavior,
    this.borderRadius = BorderRadius.zero,
    this.stackedPosition,
    this.stackedAlignment = Alignment.center,
    this.stackedChild,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.splashColor,
    this.onTapDown,
  });

  final Widget child;
  final HitTestBehavior? behavior;
  final EdgeInsets padding;
  final Alignment stackedAlignment;
  final StackedPosition? stackedPosition;
  final Widget? stackedChild;
  final BorderRadius borderRadius;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Color? splashColor;
  final void Function(TapDownDetails details)? onTapDown;

  @override
  State<TappableArea> createState() => _TappableAreaState();
}

class _TappableAreaState extends State<TappableArea>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<Color?> _backgroundAnimation;
  late Animation<Border?> _borderAnimation;

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

    _controller.addStatusListener((AnimationStatus status) {
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
  void didUpdateWidget(covariant TappableArea oldWidget) {
    if (oldWidget.splashColor != widget.splashColor) {
      _backgroundAnimation = ColorTween(
        begin: Colors.transparent,
        end: widget.splashColor ?? Colors.white10,
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
        end: Border.fromBorderSide(
          BorderSide(color: widget.splashColor ?? Colors.white10),
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
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          behavior: widget.behavior,
          onTap: widget.onPressed,
          onLongPress: widget.onLongPress,
          onTapDown: (details) async {
            widget.onTapDown?.call(details);
            await _controller.forward();
          },
          onTapUp: (_) async => await _controller.reverse(),
          onTapCancel: () async => await _controller.reverse(),
          child: AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (BuildContext context, Widget? backgroundChild) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  // Border animation will show only when reversing
                  border: _reversing ? _borderAnimation.value : null,
                  color: _backgroundAnimation.value,
                  borderRadius: widget.borderRadius,
                ),
                child: backgroundChild,
              );
            },
            child: Padding(
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        ),
        if (widget.stackedChild != null && widget.stackedPosition != null)
          Positioned.fill(
            top: widget.stackedPosition?.top,
            bottom: widget.stackedPosition?.bottom,
            left: widget.stackedPosition?.left,
            right: widget.stackedPosition?.right,
            child: Align(
              alignment: widget.stackedAlignment,
              child: widget.stackedChild,
            ),
          ),
        if (widget.stackedChild != null && widget.stackedPosition == null)
          Align(
            alignment: widget.stackedAlignment,
            child: widget.stackedChild,
          ),
      ],
    );
  }
}
