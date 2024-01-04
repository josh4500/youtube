import 'package:flutter/material.dart';

import '../../custom_action_chip.dart';
import '../../over_scroll_glow_behavior.dart';

class ViewableGroupContent extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Axis direction;
  final ScrollPhysics? physics;
  final VoidCallback? onTap;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int? itemCount;

  const ViewableGroupContent({
    super.key,
    required this.title,
    this.width,
    this.height,
    this.physics,
    this.padding,
    this.direction = Axis.horizontal,
    required this.itemBuilder,
    this.onTap,
    this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            ListTile(
              title: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              onTap: onTap,
            ),
            Positioned(
              top: 10,
              right: 5,
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: CustomActionChip(
                  title: 'View all',
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  border: const Border.fromBorderSide(
                    BorderSide(color: Colors.white12, width: 0.9),
                  ),
                  onTap: onTap,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: width,
          height: height,
          child: ScrollConfiguration(
            behavior: const OverScrollGlowBehavior(enabled: false),
            child: ListView.builder(
              physics: physics,
              padding: padding ??
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
              itemCount: itemCount,
              itemBuilder: itemBuilder,
              scrollDirection: direction,
            ),
          ),
        ),
      ],
    );
  }
}
