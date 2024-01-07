import 'dart:js_interop';

import 'package:flutter/foundation.dart';
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
