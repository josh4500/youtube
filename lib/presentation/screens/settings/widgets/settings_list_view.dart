import 'package:flutter/material.dart';

class SettingsListView extends StatelessWidget {
  final List<Widget> children;

  const SettingsListView({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return GlowingOverscrollIndicator(
      showLeading: false,
      showTrailing: false,
      axisDirection: AxisDirection.up,
      color: Colors.grey,
      child: Scrollbar(
        child: ListView(
          children: children,
        ),
      ),
    );
  }
}
