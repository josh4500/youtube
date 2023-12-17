import 'dart:io';

import 'package:flutter/cupertino.dart';

enum DeviceType { android, ios, tablet, ipad }

enum _DeviceThemeAspects {
  deviceType,
}

class DeviceThemeData {
  final DeviceType deviceType;

  const DeviceThemeData({required this.deviceType});

  factory DeviceThemeData.fromDeviceType(DeviceType deviceType) {
    return DeviceThemeData(deviceType: deviceType);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceThemeData &&
          runtimeType == other.runtimeType &&
          deviceType == other.deviceType;

  @override
  int get hashCode => deviceType.hashCode;
}

class DeviceTheme extends InheritedModel<_DeviceThemeAspects> {
  final DeviceThemeData data;

  const DeviceTheme({
    super.key,
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(DeviceTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  bool updateShouldNotifyDependent(
    DeviceTheme oldWidget,
    Set<_DeviceThemeAspects> dependencies,
  ) {
    if (data.deviceType != oldWidget.data.deviceType &&
        dependencies.contains(_DeviceThemeAspects.deviceType)) {
      return true;
    }

    return false;
  }
}
