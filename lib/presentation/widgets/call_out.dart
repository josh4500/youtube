import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/models.dart';

class CallOut extends StatefulWidget {
  const CallOut({
    super.key,
    required this.text,
    required this.child,
    required this.controller,
  });
  final String text;
  final OverlayPortalController controller;
  final Widget child;

  @override
  State<CallOut> createState() => _CallOutState();
}

class _CallOutState extends State<CallOut> {
  @override
  Widget build(BuildContext context) {
    final CallOutLink callOutLink = ModelBinding.of<CallOutLink>(context);
    return OverlayPortal(
      controller: widget.controller,
      overlayChildBuilder: (BuildContext context) {
        return CompositedTransformFollower(
          link: callOutLink.link,
          // TODO(josh4500): Fix Offset fall possible use case
          offset: callOutLink.offset + const Offset(0, 14),
          targetAnchor: Alignment.bottomLeft,
          child: Align(
            alignment: AlignmentDirectional.topCenter,
            child: CustomPaint(
              painter: TrianglePainter(
                alignment: Alignment.topCenter,
                color: Colors.white,
              ),
              child: GestureDetector(
                onTap: widget.controller.hide,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

class CallOutLink {
  CallOutLink({this.offset = Offset.zero});

  final Offset offset;
  final LayerLink link = LayerLink();
}

class TrianglePainter extends CustomPainter {
  TrianglePainter({
    required this.alignment,
    required this.color,
  });
  final Alignment alignment;
  final Color color;

  // TODO(josh4500): Paint triangle for possible alignment position
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final Path path = Path();
    path.moveTo((size.width / 2) - 12, 0);
    path.lineTo(size.width / 2, -12);
    path.lineTo((size.width / 2) + 12, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
