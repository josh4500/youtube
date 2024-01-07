import 'package:flutter/material.dart';

class ChannelAvatar extends StatelessWidget {
  final double? size;
  final VoidCallback? onTap;
  const ChannelAvatar({super.key, this.size, this.onTap});

  bool get hasLive => false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size ?? 50,
        height: size ?? 50,
        decoration: BoxDecoration(
          color: Colors.white12,
          border: hasLive
              ? Border.all(
                  width: 2,
                  color: Colors.red,
                )
              : null,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
