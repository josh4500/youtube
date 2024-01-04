import 'package:flutter/material.dart';

class Slidable extends StatefulWidget {
  final Widget child;
  const Slidable({super.key, required this.child});

  @override
  State<Slidable> createState() => _SlidableState();
}

class _SlidableState extends State<Slidable> with TickerProviderStateMixin {
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
