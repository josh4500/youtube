// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:youtube_clone/presentation/theme/app_sizing.dart';
import 'package:youtube_clone/presentation/theme/relative_size.dart';

import 'enum.dart';

typedef LandscapeBuilder = Widget Function(BuildContext context, Widget? child);
typedef PortraitBuilder = Widget Function(BuildContext context, Widget? child);

enum _DeviceThemeAspects {
  deviceType,
  screenSize,
  orientation,
}

class DeviceThemeData {
  final DeviceType deviceType;
  final Size screenSize;

  /// The orientation of the media (e.g., whether the device is in landscape or
  /// portrait mode).
  Orientation get orientation {
    return screenSize.width > screenSize.height
        ? Orientation.landscape
        : Orientation.portrait;
  }

  RelativeSizing get settingsTileSize => AppSizing.settingsTileSize
      .resolveWithDeviceType(deviceType)
      .resolveWithOrientation(orientation);

  const DeviceThemeData({
    required this.deviceType,
    required this.screenSize,
  });

  factory DeviceThemeData.fromView(
    ui.FlutterView view, {
    DeviceThemeData? platformData,
  }) {
    return DeviceThemeData(
      deviceType: DeviceType.byPlatform,
      screenSize: view.physicalSize / view.devicePixelRatio,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceThemeData &&
          runtimeType == other.runtimeType &&
          deviceType == other.deviceType &&
          screenSize == other.screenSize;

  @override
  int get hashCode => deviceType.hashCode ^ screenSize.hashCode;
}

class DeviceTheme extends InheritedModel<_DeviceThemeAspects> {
  final DeviceThemeData data;

  const DeviceTheme({
    super.key,
    required this.data,
    required super.child,
  });

  static DeviceThemeData of(BuildContext context) {
    return _of(context);
  }

  static Orientation orientationOf(BuildContext context) {
    return _of(context).orientation;
  }

  static DeviceThemeData _of(
    BuildContext context, [
    _DeviceThemeAspects? aspect,
  ]) {
    assert(debugCheckHasMediaQuery(context));
    return InheritedModel.inheritFrom<DeviceTheme>(
      context,
      aspect: aspect,
    )!
        .data;
  }

  static DeviceThemeData? maybeOf(BuildContext context) {
    return _maybeOf(context);
  }

  static DeviceThemeData? _maybeOf(
    BuildContext context, [
    _DeviceThemeAspects? aspect,
  ]) {
    return InheritedModel.inheritFrom<DeviceTheme>(
      context,
      aspect: aspect,
    )?.data;
  }

  @override
  bool updateShouldNotify(DeviceTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  bool updateShouldNotifyDependent(
    DeviceTheme oldWidget,
    Set<Object> dependencies,
  ) {
    for (final dependency in dependencies) {
      if (dependency is _DeviceThemeAspects) {
        switch (dependency) {
          case _DeviceThemeAspects.deviceType:
            if (data.deviceType != oldWidget.data.deviceType) {
              return true;
            }
          case _DeviceThemeAspects.orientation:
            if (data.orientation != oldWidget.data.orientation) {
              return true;
            }
          case _DeviceThemeAspects.screenSize:
            if (data.screenSize != oldWidget.data.screenSize) {
              return true;
            }
        }
      }
    }

    return false;
  }

  static Widget fromView({
    Key? key,
    required ui.FlutterView view,
    required Widget child,
  }) {
    return _DeviceThemeFromView(
      key: key,
      view: view,
      child: child,
    );
  }
}

class _DeviceThemeFromView extends StatefulWidget {
  final Widget child;
  final ui.FlutterView view;
  const _DeviceThemeFromView({
    super.key,
    required this.view,
    required this.child,
  });

  @override
  State<_DeviceThemeFromView> createState() => _DeviceThemeFromViewState();
}

class _DeviceThemeFromViewState extends State<_DeviceThemeFromView>
    with WidgetsBindingObserver {
  DeviceThemeData? _parentData;
  DeviceThemeData? _data;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // For now we only need to listen to changes from metrics, to know the orientation
  // of the device
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _updateData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateData();
    assert(_data != null);
  }

  void _updateData() {
    final DeviceThemeData newData = DeviceThemeData.fromView(
      widget.view,
      platformData: _parentData,
    );

    if (newData != _data) {
      setState(() => _data = newData);
    }
  }

  @override
  Widget build(BuildContext context) {
    DeviceThemeData effectiveData = _data!;

    return DeviceTheme(
      data: effectiveData,
      child: widget.child,
    );
  }
}

extension DeviceThemeGetter on BuildContext {
  // Usage example: `context.deviceTheme`
  DeviceThemeData get deviceTheme => DeviceTheme.of(this);
  Orientation get orientation => DeviceTheme.orientationOf(this);
}

extension OrientationExtension on Orientation {
  bool get isLandscape => this == Orientation.landscape;
  bool get isPortrait => this == Orientation.portrait;
}
