import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/theme/app_theme.dart';

class Shimmer extends StatelessWidget {
  final Color? color;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final BoxShape? shape;
  final double? width;
  final double? height;

  const Shimmer({
    super.key,
    this.color,
    this.margin,
    this.borderRadius,
    this.shape,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final shimmerColor = context.theme.appColors.shimmer;
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? shimmerColor,
        borderRadius: borderRadius,
        shape: shape ?? BoxShape.rectangle,
      ),
    );
  }
}
