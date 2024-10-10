// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_clone/presentation/theme/app_sizing.dart';
import 'package:youtube_clone/presentation/theme/relative_size.dart';

import 'device_type.dart';

typedef LandscapeBuilder = Widget Function(BuildContext context, Widget? child);
typedef PortraitBuilder = Widget Function(BuildContext context, Widget? child);

enum _DeviceThemeAspects {
  deviceType,
  screenSize,
  orientation,
}

class DeviceThemeData {
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

  double get draggableInitialSize =>
      AppSizing.draggableInitialSize.resolveWithDeviceType(deviceType);
  double get draggablePostInitialSize =>
      AppSizing.draggablePostInitialSize.resolveWithDeviceType(deviceType);

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

class SizerUtils {
  static const ui.Size designSize = ui.Size(448, 973.3);
  static late ui.Size deviceSize;
  static late double _dpr;
  static double get dpr => _dpr * 1;
  static set dpr(double v) => _dpr = v;
}

extension DensityPixelsExtension on num {
  double get dp => this / SizerUtils.dpr;
  double get pt => this / SizerUtils.dpr;

  double get h {
    final screenHeight = SizerUtils.deviceSize.height;
    return (this / SizerUtils.designSize.height) * screenHeight;
  }

  double get w {
    final screenWidth = SizerUtils.deviceSize.width;

    return (this / SizerUtils.designSize.width) * screenWidth;
  }
}

class DeviceTheme extends InheritedModel<_DeviceThemeAspects> {
  const DeviceTheme({
    super.key,
    required this.data,
    required super.child,
  });
  final DeviceThemeData data;

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
    for (final Object dependency in dependencies) {
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
  const _DeviceThemeFromView({
    super.key,
    required this.view,
    required this.child,
  });
  final Widget child;
  final ui.FlutterView view;

  @override
  State<_DeviceThemeFromView> createState() => _DeviceThemeFromViewState();
}

class _DeviceThemeFromViewState extends State<_DeviceThemeFromView>
    with WidgetsBindingObserver {
  DeviceThemeData? _parentData;
  DeviceThemeData? _data;

  bool wasHidden = false;

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case ui.AppLifecycleState.inactive:
        break;
      case ui.AppLifecycleState.paused:
        break;
      case ui.AppLifecycleState.detached:
        break;
      case ui.AppLifecycleState.resumed:
        if (wasHidden) {
          _resetOrientation();
        }
        wasHidden = false;
        break;
      case ui.AppLifecycleState.hidden:
        wasHidden = true;
        break;
    }
  }

  Future<void> _resetOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    await SystemChrome.restoreSystemUIOverlays();
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
    final DeviceThemeData effectiveData = _data!;
    SizerUtils.dpr = widget.view.devicePixelRatio;
    SizerUtils.deviceSize = widget.view.physicalSize / SizerUtils.dpr;

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

extension IsDarkExtension on ui.Brightness {
  bool get isDark => this == ui.Brightness.dark;
  bool get isLight => this == ui.Brightness.light;
}

extension IsThemeDarkExtension on ThemeMode {
  bool get isDark => this == ThemeMode.dark;
  bool get isSystem => this == ThemeMode.system;
}
