import 'package:flutter/material.dart';

class ChannelAvatar extends StatelessWidget {
  const ChannelAvatar({super.key});

  bool get hasLive => false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
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
    );
  }
}
