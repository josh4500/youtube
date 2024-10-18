import 'dart:io';
import 'dart:ui';

import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

enum DeviceType {
  android,
  ios,
  tablet,
  ipad,
}

class PlatformInfoCollector {
  factory PlatformInfoCollector() {
    return _instance;
  }

  PlatformInfoCollector._();
  static final _instance = PlatformInfoCollector._();
  static PlatformInfoCollector get instance => _instance;

  // Instance variables to store collected data
  late PlatformInfo _platformInfo;
  PlatformInfo get platformInfo => _platformInfo;

  Future<void> initialize() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final Battery battery = Battery();

    // Collect device info based on platform
    String deviceModel;
    String deviceBrand;
    String osVersion;
    OSType osType;

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceModel = androidInfo.model;
      deviceBrand = androidInfo.brand;
      osVersion = androidInfo.version.release;
      osType = OSType.android;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceModel = iosInfo.utsname.machine;
      deviceBrand = 'Apple';
      osVersion = iosInfo.systemVersion;
      osType = OSType.ios;
    } else {
      deviceModel = 'Unknown';
      deviceBrand = 'Unknown';
      osVersion = 'Unknown';
      osType = OSType.unknown;
    }

    // Collect battery info
    final batteryLevel = (await battery.batteryLevel).toDouble();

    // Placeholder for performance info (system_info_plus package can be used for actual values)
    const totalRAM = 4096; // Example value in MB
    const availableRAM = 1024; // Example value in MB
    const cpuCores = 8; // Example value

    // Locale and preferences
    final language = PlatformDispatcher.instance.locale.toLanguageTag();
    final timezone = DateTime.now().timeZoneName;

    // Collect screen resolution and app version (these can be passed via constructors)
    final screenResolution = getScreenResolution();
    const appVersion = '1.0.0'; // Example value
    const buildNumber = '1'; // Example value

    // Store the collected data in the instance variable
    _platformInfo = PlatformInfo(
      deviceModel: deviceModel,
      deviceBrand: deviceBrand,
      osVersion: osVersion,
      osType: osType,
      screenResolution: screenResolution,
      appVersion: appVersion,
      buildNumber: buildNumber,
      totalRAM: totalRAM,
      availableRAM: availableRAM,
      cpuCores: cpuCores,
      batteryLevel: batteryLevel,
      language: language,
      timezone: timezone,
    );
  }

  static Size _getLogicalSize() {
    final physicalSize = PlatformDispatcher.instance.implicitView!.physicalSize;
    final devicePixelRatio =
        PlatformDispatcher.instance.implicitView!.devicePixelRatio;

    return Size(
      physicalSize.width / devicePixelRatio,
      physicalSize.height / devicePixelRatio,
    );
  }

  static ScreenResolution getScreenResolution() {
    final logicalSize = _getLogicalSize();
    final smallerDimension = logicalSize.width < logicalSize.height
        ? logicalSize.width
        : logicalSize.height;

    if (smallerDimension <= 256) {
      return ScreenResolution.p144;
    } else if (smallerDimension <= 426) {
      return ScreenResolution.p240;
    } else if (smallerDimension <= 640) {
      return ScreenResolution.p360;
    } else if (smallerDimension <= 854) {
      return ScreenResolution.p480;
    } else if (smallerDimension <= 1280) {
      return ScreenResolution.p720;
    } else if (smallerDimension <= 1920) {
      return ScreenResolution.p1080;
    } else if (smallerDimension <= 2560) {
      return ScreenResolution.p1440;
    } else if (smallerDimension <= 3840) {
      return ScreenResolution.p2160; // 4K
    } else {
      return ScreenResolution.unknown;
    }
  }

  static DeviceType getDeviceType() {
    final logicalSize = _getLogicalSize();
    final smallerDimension = logicalSize.width < logicalSize.height
        ? logicalSize.width
        : logicalSize.height;

    if (Platform.isAndroid) {
      return smallerDimension >= 600 ? DeviceType.tablet : DeviceType.android;
    } else if (Platform.isIOS) {
      final aspectRatio = logicalSize.width / logicalSize.height;
      return aspectRatio >= 0.74 && aspectRatio <= 0.78
          ? DeviceType.ipad
          : DeviceType.ios;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}

enum ScreenResolution {
  p144,
  p240,
  p360,
  p480,
  p720,
  p1080,
  p1440,
  p2160, // 4K
  unknown
}

enum OSType { android, ios, unknown }

class PlatformInfo {
  PlatformInfo({
    required this.deviceModel,
    required this.deviceBrand,
    required this.osVersion,
    required this.osType,
    required this.screenResolution,
    required this.appVersion,
    required this.buildNumber,
    required this.totalRAM,
    required this.availableRAM,
    required this.cpuCores,
    required this.batteryLevel,
    required this.language,
    required this.timezone,
    this.totalStorage,
    this.availableStorage,
  });

  final String deviceModel;
  final String deviceBrand;
  final String osVersion;
  final OSType osType;
  final ScreenResolution screenResolution;
  final String appVersion;
  final String buildNumber;
  final int totalRAM;
  final int availableRAM;
  final int cpuCores;
  final double batteryLevel;
  final String language;
  final String timezone;
  final int? totalStorage;
  final int? availableStorage;
}
