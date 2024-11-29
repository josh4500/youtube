import 'package:flutter/widgets.dart';

abstract class EditorNotification extends Notification {}

class OpenTimelineNotification extends EditorNotification {}

class CloseTimelineNotification extends EditorNotification {}

class CreateTextArtifactNotification extends EditorNotification {}
