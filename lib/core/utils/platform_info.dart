import 'package:flutter/foundation.dart';

class PlatformInfo {
  PlatformInfo() : name = _detectPlatform();
  final String name;

  static String _detectPlatform() {
    if (kIsWeb) return 'Web';
    if (defaultTargetPlatform == TargetPlatform.android) return 'Android';
    if (defaultTargetPlatform == TargetPlatform.iOS) return 'iOS';
    return 'Unknown';
  }
}
