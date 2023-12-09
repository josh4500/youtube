import 'package:flutter/material.dart';

class ErrorOverlay extends StatefulWidget {
  const ErrorOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<ErrorOverlay> createState() => _ErrorOverlayState();
}

class _ErrorOverlayState extends State<ErrorOverlay> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
