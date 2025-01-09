import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/theme/app_theme.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class Shimmer extends StatelessWidget {
  const Shimmer({
    super.key,
    this.color,
    this.margin,
    this.borderRadius,
    this.shape,
    this.width,
    this.height,
  });

  final Color? color;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final BoxShape? shape;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final Color shimmerColor = context.theme.appColors.shimmer;
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
