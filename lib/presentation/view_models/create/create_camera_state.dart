import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateCameraState {
  CreateCameraState({
    required this.hasPermissions,
    this.requested = false,
    this.permissionsDenied = false,
    this.cameras = const <CameraDescription>[],
  });

  final bool requested;
  final bool hasPermissions;
  final bool permissionsDenied;
  final List<CameraDescription> cameras;

  CreateCameraState copyWith({
    bool? requested,
    bool? hasPermissions,
    bool? permissionsDenied,
    List<CameraDescription>? cameras,
  }) {
    return CreateCameraState(
      requested: requested ?? this.requested,
      hasPermissions: hasPermissions ?? this.hasPermissions,
      permissionsDenied: permissionsDenied ?? this.permissionsDenied,
      cameras: cameras ?? this.cameras,
    );
  }

  static Future<CreateCameraState> requestCamera() async {
    CreateCameraState state = CreateCameraState(
      hasPermissions: false,
    );
    final result = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    final hasPermission = result.values.fold<bool>(
      true,
      (value, element) => value && element.isGranted,
    );
    final permissionsDenied = result.values.fold<bool>(
      false,
      (value, element) => value || element.isDenied,
    );

    state = state.copyWith(
      hasPermissions: hasPermission,
      requested: true,
      permissionsDenied: permissionsDenied,
    );

    if (hasPermission) {
      final cameras = await availableCameras();
      state = state.copyWith(cameras: cameras);
    }

    return state;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateCameraState &&
          runtimeType == other.runtimeType &&
          requested == other.requested &&
          hasPermissions == other.hasPermissions &&
          permissionsDenied == other.permissionsDenied &&
          cameras == other.cameras;

  @override
  int get hashCode =>
      requested.hashCode ^
      hasPermissions.hashCode ^
      permissionsDenied.hashCode ^
      cameras.hashCode;
}
