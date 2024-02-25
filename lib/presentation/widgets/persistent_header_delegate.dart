import 'dart:math';

import 'package:flutter/cupertino.dart';

class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  PersistentHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

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

class FadingSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  FadingSliverPersistentHeaderDelegate({
    required this.height,
    required this.child,
  });

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
    final scrollPercentage = (shrinkOffset / height).clamp(0.0, 1.0);
    final fadeValue = scrollPercentage;

    return Opacity(
      opacity: fadeValue,
      child: child,
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class SlidingHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  SlidingHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

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
    final double shrinkFactor = (shrinkOffset / (maxExtent - minHeight));
    print(Offset(0, 1 - shrinkFactor.clamp(0, .5)));
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
