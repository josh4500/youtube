import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../constants/assets.dart';

abstract class ImageFromAsset {
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

  static final Widget trendingAnimated = Image.asset(
    AssetsPath.trendingAnimated,
    fit: BoxFit.contain,
    height: 60,
    width: 60,
  );

  static final Widget gameAnimated = Image.asset(
    AssetsPath.gameAnimated,
    fit: BoxFit.contain,
    height: 60,
    width: 60,
  );

  static final Widget fashionAnimated = Image.asset(
    AssetsPath.fashionAnimated,
    fit: BoxFit.contain,
    height: 60,
    width: 60,
  );

  static final Widget liveAnimated = Image.asset(
    AssetsPath.liveAnimated,
    fit: BoxFit.contain,
    height: 60,
    width: 60,
  );

  static final Widget musicAvatar = Image.asset(
    AssetsPath.musicAvatar,
    fit: BoxFit.contain,
    height: 60,
    width: 60,
  );

  static final Widget sportAvatar = Image.asset(
    AssetsPath.sportAvatar,
    fit: BoxFit.contain,
    height: 60,
    width: 60,
  );

  static final Widget textOption = Image.asset(
    AssetsPath.textOption,
    fit: BoxFit.contain,
    height: 24,
    width: 24,
  );

  static final Widget textBackgroundIcon = Image.asset(
    AssetsPath.textBackground,
    fit: BoxFit.contain,
    height: 24,
    width: 24,
  );
  static final Widget textBorderedIcon = Image.asset(
    AssetsPath.textBordered,
    fit: BoxFit.contain,
    height: 24,
    width: 24,
  );
  static final Widget textNormalIcon = Image.asset(
    AssetsPath.textNormal,
    fit: BoxFit.contain,
    height: 24,
    width: 24,
  );
  static final Widget textTransparentIcon = Image.asset(
    AssetsPath.textTransparent,
    fit: BoxFit.contain,
    height: 24,
    width: 24,
  );
}
