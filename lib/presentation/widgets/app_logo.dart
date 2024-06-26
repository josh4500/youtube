import 'package:flutter/material.dart';

import '../constants.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(Josh): Show Youtube or Premium logo
    final Brightness brightness = Theme.of(context).brightness;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Image.asset(
        brightness == Brightness.dark
            ? AssetsPath.ytFullLogoMediumDark
            : AssetsPath.ytFullLogoMediumLight,
        fit: BoxFit.fitWidth,
        width: 120,
      ),
    );
  }
}
