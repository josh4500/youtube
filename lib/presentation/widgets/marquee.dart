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

class Marquee extends StatefulWidget {
  final String text;
  final Duration duration;
  final AxisDirection direction;

  const Marquee({
    super.key,
    required this.text,
    this.duration = const Duration(seconds: 5),
    this.direction = AxisDirection.left,
  });

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  // Called when this object is removed from the tree.
  @override
  void deactivate() {
    super.deactivate();
  }

  // Called when this object is reinserted into the tree after having been
  // removed via deactivate.
  @override
  void activate() {
    super.activate();
  }

  // Called when a dependency of this State object changes.
  // For example, if the previous call to build referenced an InheritedWidget
  // that later changed, the framework would call this method to notify this object
  // about the change. This method is also called immediately after initState.
  // It is safe to call BuildContext.dependOnInheritedWidgetOfExactType from this method.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant Marquee oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView();
  }
}
