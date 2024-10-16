import 'package:flutter/material.dart';
import 'package:youtube_clone/main.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';

class CallOut extends StatelessWidget {
  const CallOut({
    super.key,
    this.alignment = Alignment.topCenter,
    this.link,
    this.controller,
    this.buildContent,
    this.useChildAsTarget = true,
    this.text,
    required this.child,
  });

  final bool useChildAsTarget;
  final Alignment alignment;
  final String? text;
  final Widget Function(BuildContext context)? buildContent;
  final CallOutLink? link;
  final OverlayPortalController? controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final callOutLink = link ?? context.provide<CallOutLink>();
    final effectiveController = controller ?? callOutLink.controller;
    return OverlayPortal(
      controller: effectiveController,
      overlayChildBuilder: (BuildContext context) {
        return CompositedTransformFollower(
          link: callOutLink.link,
          // TODO(josh4500): Calculate offset base on triangle position
          offset: callOutLink.offset + const Offset(0, 12),
          targetAnchor: Alignment.center,
          followerAnchor: Alignment.center,
          child: Material(
            type: MaterialType.transparency,
            child: TapRegion(
              groupId: CallOut,
              onTapInside: (_) => effectiveController.hide(),
              onTapOutside: (_) => effectiveController.hide(),
              child: Align(
                alignment: AlignmentDirectional.center,
                child: CustomPaint(
                  painter: TrianglePainter(
                    alignment: alignment,
                    color: context.theme.colorScheme.surface,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: buildContent?.call(context) ??
                        Text(
                          text ?? '',
                          style: TextStyle(
                            color: context.theme.colorScheme.inverseSurface,
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Builder(
        builder: (context) {
          if (useChildAsTarget) {
            return CompositedTransformTarget(
              link: callOutLink.link,
              child: child,
            );
          }
          return child;
        },
      ),
    );
  }
}

class CallOutLink {
  CallOutLink({this.offset = Offset.zero});
  final controller = OverlayPortalController();
  void show() => controller.show();
  void hide() => controller.hide();
  bool get isShowing => controller.isShowing;
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
