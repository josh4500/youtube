import 'package:flutter/material.dart';

class AppbarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final void Function(TapDownDetails details)? onTapDown;

  const AppbarAction({
    super.key,
    required this.icon,
    this.onTap,
    this.onTapDown,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0, top: 2, bottom: 2),
      child: InkWell(
        onTap: onTap,
        onTapDown: onTapDown,
        borderRadius: BorderRadius.circular(32),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Icon(icon),
        ),
      ),
    );
  }
}
