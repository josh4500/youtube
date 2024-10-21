import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  const PersistentHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant PersistentHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.child != child;
  }
}

class FixedHeightHeaderDelegate extends SliverPersistentHeaderDelegate {
  const FixedHeightHeaderDelegate({
    required this.height,
    required this.child,
  });

  final double height;
  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant FixedHeightHeaderDelegate oldDelegate) {
    return height != oldDelegate.height;
  }
}

class FadingSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  FadingSliverPersistentHeaderDelegate({
    required this.height,
    required this.child,
  });
  final double height;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double shrinkFactor = shrinkOffset / maxExtent;
    return FractionalTranslation(
      translation: Offset(0, 1 - shrinkFactor),
      child: Opacity(
        opacity: shrinkFactor,
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration =>
      const PersistentHeaderShowOnScreenConfiguration(
        maxShowOnScreenExtent: 0,
        minShowOnScreenExtent: 0,
      );
}

class SlidingHeaderDelegate extends SliverPersistentHeaderDelegate {
  SlidingHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => 0.1;

  @override
  double get maxExtent => 24;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double shrinkFactor = shrinkOffset / (maxExtent - minHeight);
    return OverflowBox(
      maxHeight: maxHeight,
      child: Opacity(
        opacity: shrinkFactor,
        child: FractionalTranslation(
          translation: Offset(0, 1 - shrinkFactor.clamp(0, .5)),
          child: child,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
