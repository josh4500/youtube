import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';

class CallOut extends StatefulWidget {
  const CallOut({
    super.key,
    this.alignment = Alignment.bottomCenter,
    this.link,
    this.controller,
    this.buildContent,
    this.useChildAsTarget = true,
    this.text,
    this.padding = const EdgeInsets.all(12),
    required this.child,
  });

  final EdgeInsets padding;
  final bool useChildAsTarget;
  final Alignment alignment;
  final String? text;
  final Widget Function(BuildContext context)? buildContent;
  final CallOutLink? link;
  final OverlayPortalController? controller;
  final Widget child;

  @override
  State<CallOut> createState() => _CallOutState();
}

class _CallOutState extends State<CallOut> {
  final key = GlobalKey();
  Size? childSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateChildSize();
    });
  }

  void _updateChildSize() {
    final context = key.currentContext;
    if (context != null) {
      childSize = context.size;
    }
  }

  @override
  Widget build(BuildContext context) {
    final callOutLink = widget.link ?? context.provide<CallOutLink>();
    final effectiveController = widget.controller ?? callOutLink.controller;

    return OverlayPortal(
      controller: effectiveController,
      overlayChildBuilder: (BuildContext context) {
        // Default offset in case child size is unavailable
        Offset calculatedOffset = Offset.zero;

        if (childSize != null) {
          // Calculate offset based on alignment
          switch (widget.alignment) {
            case Alignment.topCenter:
              calculatedOffset = Offset(0, -childSize!.height + 24);
              break;
            case Alignment.bottomCenter:
              calculatedOffset = Offset(0, childSize!.height + 24);
              break;
            case Alignment.centerLeft:
              calculatedOffset = Offset(-childSize!.width, 0);
              break;
            case Alignment.centerRight:
              calculatedOffset = Offset(childSize!.width, 0);
              break;
            default:
              calculatedOffset = Offset.zero;
          }
        }

        return CompositedTransformFollower(
          link: callOutLink.link,
          offset: calculatedOffset,
          targetAnchor: Alignment.center,
          followerAnchor: Alignment.center,
          child: Material(
            type: MaterialType.transparency,
            child: TapRegion(
              groupId: CallOut,
              onTapOutside: (_) => effectiveController.hide(),
              child: Align(
                alignment: AlignmentDirectional.center,
                child: CustomPaint(
                  painter: TrianglePainter(
                    alignment: widget.alignment,
                    color: context.theme.colorScheme.surface,
                  ),
                  child: Container(
                    padding: widget.padding,
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: widget.buildContent?.call(context) ??
                        Text(
                          widget.text ?? '',
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
        key: key,
        builder: (context) {
          if (widget.useChildAsTarget) {
            return CompositedTransformTarget(
              link: callOutLink.link,
              child: widget.child,
            );
          }
          return widget.child;
        },
      ),
    );
  }
}

class CallOutLink {
  final controller = OverlayPortalController();
  void show() => controller.show();
  void hide() => controller.hide();
  bool get isShowing => controller.isShowing;
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

    final Path path = Path();

    if (alignment == Alignment.topCenter) {
      // Arrow at the bottom center of the child
      path.moveTo(
        size.width / 2 - triangleHalfWidth,
        size.height,
      ); // Bottom left
      path.lineTo(size.width / 2, size.height + triangleHeight); // Tip
      path.lineTo(
        size.width / 2 + triangleHalfWidth,
        size.height,
      ); // Bottom right
    } else if (alignment == Alignment.bottomCenter) {
      // Arrow at the top center of the child
      path.moveTo(size.width / 2 - triangleHalfWidth, 0); // Top left
      path.lineTo(size.width / 2, -triangleHeight); // Tip
      path.lineTo(size.width / 2 + triangleHalfWidth, 0); // Top right
    } else if (alignment == Alignment.centerLeft) {
      // Arrow at the center right of the child
      path.moveTo(size.width, size.height / 2 - triangleHalfWidth); // Right top
      path.lineTo(size.width + triangleHeight, size.height / 2); // Tip
      path.lineTo(
        size.width,
        size.height / 2 + triangleHalfWidth,
      ); // Right bottom
    } else if (alignment == Alignment.centerRight) {
      // Arrow at the center left of the child
      path.moveTo(0, size.height / 2 - triangleHalfWidth); // Left top
      path.lineTo(-triangleHeight, size.height / 2); // Tip
      path.lineTo(0, size.height / 2 + triangleHalfWidth); // Left bottom
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
