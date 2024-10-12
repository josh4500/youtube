import 'package:flutter/material.dart';

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
}
