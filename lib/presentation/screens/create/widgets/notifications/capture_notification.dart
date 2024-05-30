import 'package:flutter/material.dart';

abstract class CaptureNotification extends Notification {}

class HideCaptureControlsNotification extends CaptureNotification {}

class ShowCaptureControlsNotification extends CaptureNotification {}

class ShowControlsMessageNotification extends CaptureNotification {
  ShowControlsMessageNotification({required this.message});

  final String message;
}
