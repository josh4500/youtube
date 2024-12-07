import 'package:flutter/material.dart';

abstract class CaptureNotification extends Notification {}

class HideControlsNotification extends CaptureNotification {}

class ShowControlsNotification extends CaptureNotification {}

class ShowControlsMessageNotification extends CaptureNotification {
  ShowControlsMessageNotification({required this.message});

  final String message;
}

class StartCountdownNotification extends CaptureNotification {
  StartCountdownNotification({required this.countdown});

  final int countdown;
}

class StopCountdownNotification extends CaptureNotification {}

class InitCameraNotification extends CaptureNotification {}

class DisposeCameraNotification extends CaptureNotification {}

class CompleteNotification extends CaptureNotification {}

class UpdateStopTimerNotification extends CaptureNotification {
  UpdateStopTimerNotification({this.duration});

  final Duration? duration;
}
