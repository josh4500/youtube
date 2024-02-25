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

class Slidable extends StatefulWidget {
  final Widget child;
  const Slidable({super.key, required this.child});

  @override
  State<Slidable> createState() => _SlidableState();
}

class _SlidableState extends State<Slidable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      animationBehavior: AnimationBehavior.preserve,
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-100, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Slide to the left when dragging to the left
        if (details.primaryDelta! < 0) {
          _controller.forward();
        }
        // Slide to the right when dragging to the right
        else if (details.primaryDelta! > 0) {
          _controller.reverse();
        }
      },
      onHorizontalDragEnd: (details) {
        // You can add additional logic here if needed
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 100,
              height: 112,
              color: Colors.white,
              child: const Icon(
                Icons.delete,
                color: Colors.black,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, childWidget) {
              return Transform.translate(
                offset: _animation.value,
                child: childWidget,
              );
            },
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
