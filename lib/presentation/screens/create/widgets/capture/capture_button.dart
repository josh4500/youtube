import 'package:flutter/material.dart';

class CaptureButton extends StatelessWidget {
  const CaptureButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      margin: const EdgeInsets.all(48),
      decoration: const BoxDecoration(
        color: Color(0xFFFF0000),
        shape: BoxShape.circle,
      ),
    );
  }
}
