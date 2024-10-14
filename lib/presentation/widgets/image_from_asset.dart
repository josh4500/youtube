import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../constants/assets.dart';

class ImageFromAsset {
  static final Widget ytPAccessIcon = ClipRRect(
    borderRadius: BorderRadius.circular(2),
    child: Image.asset(
      AssetsPath.ytPAccessIcon48,
      width: 24,
      height: 24,
    ),
  );

  static final Widget ytPFullLogo = Builder(
    builder: (context) {
      final brightness = context.theme.brightness;
      return Image.asset(
        brightness.isLight
            ? AssetsPath.ytPremiumFullLogoLightBig
            : AssetsPath.ytPremiumFullLogoDarkBig,
        fit: BoxFit.fitHeight,
        height: 40,
      );
    },
  );
}
