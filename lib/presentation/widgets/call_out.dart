import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/models.dart';

class CallOut extends StatelessWidget {
  const CallOut({
    super.key,
    this.alignment = Alignment.topCenter,
    required this.text,
    required this.child,
    required this.controller,
  });

  final Alignment alignment;
  final String text;
  final OverlayPortalController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final CallOutLink callOutLink = ModelBinding.of<CallOutLink>(context);
    return OverlayPortal(
      controller: controller,
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
                alignment: alignment,
                color: Colors.white,
              ),
              child: GestureDetector(
                onTap: controller.hide,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    text,
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
      child: child,
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

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const double triangleHeight = 12;
    const double triangleHalfWidth = 12;

    // Calculate the x-position based on the alignment
    double xOffset = (alignment.x + 1) * 0.5 * size.width;

    // Clamp xOffset to ensure the triangle stays within the bounds
    xOffset = xOffset.clamp(triangleHalfWidth, size.width - triangleHalfWidth);

    // Calculate the yOffset based on the alignment
    final bool isUpsideDown = alignment.y > 0;

    final Path path = Path();

    if (isUpsideDown) {
      // Draw the triangle pointing upwards (upside down)
      path.moveTo(
        xOffset - triangleHalfWidth,
        size.height,
      ); // Bottom left point
      path.lineTo(xOffset, size.height + triangleHeight); // Top point
      path.lineTo(
        xOffset + triangleHalfWidth,
        size.height,
      ); // Bottom right point
    } else {
      // Draw the triangle pointing downwards (normal)
      path.moveTo(xOffset - triangleHalfWidth, 0); // Top left point
      path.lineTo(xOffset, -triangleHeight); // Bottom point
      path.lineTo(xOffset + triangleHalfWidth, 0); // Top right point
    }

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
